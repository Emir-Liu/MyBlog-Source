---
title: Ubuntu上shadowsocks配置
date: 2019-09-17 21:39:46
tags: shadowsocks
---
# 1.购买服务器
## 1.1购买网站以及要注意的
服务器IP
服务器账户
服务器密码

## 1.2连接服务器
```bash
ping 服务器ip //检查是否可以连接
ssh 服务器账户@服务器IP//进行连接 连接后会让你输入服务器密码
```
# 2.在服务器上搭建shadowsocks
## 2.1安装shadowsocks
```bash
apt-get update
apt install python-pip
apt install python-setuptools
pip install shadowsocks
vim shadowsocks.json//自己建立目录在目录下建立配置文件
{
        "server":"0.0.0.0",
        "server_port":服务器端口,
        "password":"密码",
        "method":"aes-256-cfb"//加密方式
}

ssserver -c /目录/shadowsock.json -d start
```
# 3.在客户端搭建
## 3.1安装shadowsocks
```bash
apt-get install shadowsocks

vim shadowsocks.json//自己建立目录在目录下建立配置文件
{
        "server": "服务器IP",
        "server_port": 服务器端口,
        "local_address": "127.0.0.1",
        "local_port": "1080",
        "password": "密码",
        "method": "aes-256-cfb",//加密方式
        "timeout": 300,
        "fast_open": true
}
~       
sudo -s//进入root
sslocal -c /目录/shadowsocks.json -d start
exit//退出root

```
