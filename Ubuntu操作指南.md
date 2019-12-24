---
title: Ubuntu操作指南
date: 2019-08-19 11:44:30
tags: 
- Ubuntu
---

## 输入法配置谷歌拼音

```bash
1.安装中文字体（已经有了，这一步略过）
2.安装fcitx框架
3.安装google拼音
4.配置输入法
```

```bash
sudo apt install fcitx
sudo apt install fcitx-googlepinyin
```

配置输入法：
1.点击input method
2.选择fcitx

3.进入input method configuration
4.选择加号添加输入法
5.取消勾选仅显示当前语言，在下面搜索google-pinyin
6.重启fcitx或者Ubuntu
7.默认切换输入法ctrl+space或者shift

## 文档处理指令：

cd:进入下级目录
cd ..	返回上级文件
cd /	返回根目录
cd ~	返回用户目录

ls:显示当前路径下的文件
ls -a	显示包括隐藏文件之内的所有文件
/*
ls命令下文件颜色的含义:
白色：普通文件
绿色：可执行文件
红色：压缩文件
蓝色：目录
青色：链接文件，类似于快捷方式
黄色：设备文件，把硬件设备抽象为文件。
	例如：block块可以表示硬盘，char表示键盘
灰色：其他文件
*/
mkdir:新建目录

rm:删除
rm 文件名
rm -r 文件夹名

cp:复制
-i	(interactive)要求确认在复制过程中是否覆盖现有文件
-r	复制给定目录中的所有子目录和文件并保留树结构
-v	(verbose)显示逐个复制的文件

mv:移动和重命名文件
-i	(interactive)要求确认是否覆盖现有文件
-f	(force)覆盖交互，不返回任何提示
-v	(verbose)显示逐个移动文件

cat:打开文档


# 解压，压缩文件：

## 文件格式

tar.gz压缩格式用于unix的操作系统,
zip用于windows的操作系统
在windows系统中用WinRar工具同样可以解压缩tar.gz格式的。

详细：

zip流行于windows系统上的压缩文件（其他系统也可以打开）。zip格式开放而且免费 。zip支持分卷压缩，128/256-bit AES加密算法等功能。zip的含义是速度，其目标就 是为顶替ARC而诞生的“职业”压缩软件。

tar是“tape archive”(磁带存档)的简称，它出现在还没有软盘驱动器、硬盘和光盘驱 动器的计算机早期阶段，随着时间的推移， tar命令逐渐变为一个将很多文件进行存档的工具，目前许多用于Linux操作系统的程序就是打包为tar档案文件的形式。 在Linux里面，tar一般和其他没有文件管理的压缩算法文件结合使用，用tar打包整个文件目录结构成一个文件，再用gz，bzip等压缩算法压缩成一次。也是Linux常见的压缩归档的 处理方法。
## 指令：
```bash
# .tar	仅打包，并非压缩
tar -xvf FileName.tar         # 解包
tar -cvf FileName.tar DirName # 将DirName和其下所有文件（夹）打包

# .gz
gunzip FileName.gz  # 解压1
gzip -d FileName.gz # 解压2
gzip FileName       # 压缩，只能压缩文件

# .tar.gz 和 .tgz
tar -zxvf FileName.tar.gz               # 解压
tar -zcvf FileName.tar.gz DirName       # 将DirName和其下所有文件（夹）压缩
tar -C DesDirName -zxvf FileName.tar.gz # 解压到目标路径

# .zip	占用空间比.tar.gz大
unzip FileName.zip          # 解压
zip FileName.zip DirName    # 将DirName本身压缩
zip -r FileName.zip DirName # 压缩，递归处理，将指定目录下的所有文件和子目录一并压缩

# .rar	mac和linux并没有自带rar，需要去下载
rar x FileName.rar      # 解压
rar a FileName.rar DirName # 压缩
```
tree:显示当前目录下的文件结构（需要安装tree）

## 下载安装文件：
sudo apt [--yes --force-yes] install  文件名	从文件源下载安装文件
sudo apt update		apt源文件目录更新
sudo apt upgrade	文件升级


## 权限：（注意！尽可能不要使用以下权限，除非安装程序之类的操作）
sudo	暂时获取管理员权限，之后要求输入密码，不显示密码
sudo -s 获取root权限
exit	退出root权限

## 建立快捷方式
在/usr/share/applications目录下
```bash
vim pycharm.desktop

[Desktop Entry]
Type=Application
Name=Pycharm
Comment=The Python IDE
Exec=sh /home/eglym/pycharm-community-2019.2.3/bin/pycharm.sh
Icon=/home/eglym/pycharm-community-2019.2.3/bin/pycharm.png

```

# FAQ:
## 用apt下载文件时遇到 /var/lib/dpkg/lock - open (13: 权限不够)问题：
解决方式：
	1.提升权限：
```bash
sudo -s //进入root模式
...
exit	//下载文件后退出root模式

```
	2.强制解锁
```bash
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock
```

## 退出root模式时，显示There are stopped jobs
```bash
jobs	//显示被暂停的工作
```

sudo vim /etc/systemd/resolved.conf
取消DNS注释：


问题：
如何在Ubuntu中使用AppImage文件：
右键，属性，Allow executing file as program
