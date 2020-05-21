---
title: Ubuntu上apt抽风出现的问题及修补
date: 2020-05-21 13:53:33
tags:
- ubuntu
- apt
---
apt抽风了怎么办？
先哭。。
然后资料来源：https://blog.csdn.net/shimadear/article/details/90598646

下面是详细：
apt下载出现下面的错误:
Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)

解决办法：
第一种情况：
进程中存在与apt相关的正在运行的进程：
首先检查是否在运行apt,apt-get相关的进程
```bash
ps aux | grep -i apt
```
如果存在与apt相关的正在运行的进程，kill掉进程；
```bash
sudo kill -9 <process id>
```
或者直接简单粗暴的：

```bash
sudo killall apt apt-get
```
如果进行完上面的步骤还是无法顺利执行apt-get 操作，则属于第二种情况：

第二种情况：
进程列表中已经没有与apt相关的进程在运行，但依然报错，在这种情况下，产生错误的根本原因是lock_file. lock_file用于防止两个或多个进程使用相同的数据。 当运行apt或apt-commands时，它会在几个地方创建lock files。 当前一个apt命令未正确终止时，lock file未被删除，因此它们会阻止任何新的apt / apt-get命令实例，比如正在执行apt-get upgrade，在执行过程中直接ctrl+c取消了该操作，很有可能就会造成这种情况。
要解决此问题，首先要删除lock file。
使用lsof命令获取持有lock file的进程的进程ID,依次运行如下命令：

```bash
lsof /var/lib/dpkg/lock
lsof /var/lib/apt/lists/lock
lsof /var/cache/apt/archives/lock
```
需要注意的是，以上命令执行结果如果无返回，说明没有正在运行的进程；如果返回了相应的进程，需要kill掉。

删除所有的lock file
```bash
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock
```
最后重新配置一下dpkg：

```bash
sudo dpkg --configure -a
```
如果上述命令不出任何错误，就万事大吉了。（我是到这里问题就解决了）

但是有时候，生活总是嫌你不够惨，执行配置命令时可能会出现以下错误：

dpkg: error: dpkg frontend is locked by another process
这需要我们额外进行一些操作：

找出正在锁定lock file的进程：

```
lsof /var/lib/dpkg/lock-frontend
kill掉输出的进程（如果输出为空则忽略）
sudo kill -9 PID
删除lock file并重新配置dpkg:
sudo rm /var/lib/dpkg/lock-frontend
sudo dpkg --configure -a
```

