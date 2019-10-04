---
title: Ubuntu上配置Apache服务器
date: 2019-09-03 21:40:40
tags: Apache
---
# 如何在Ubuntu安装Apache Web 服务器
## 1.安装apache2包:
```bash
sudo apt install apache2
```
## 2.配置防火墙:
```bash
sudo ufw app list
sudo ufw allow 'Apache'
sudo ufw status
```
LInux原始的防火墙工具iptables由于过于繁琐，所以ubuntu系统默认提供了一个基于iptable之上的防火墙工具ufw。
### 1.安装
```bash
sudo apt install ufw
```

### 2.启动
```bash
sudo ufw enable
sudo ufw default deny
```
开启防火墙，并在系统启动时自动开启。
关闭所有外部对本机的访问，但本机能够正常访问外部。
### 3.开启/禁用:
```bash
sudo ufw allow/deny [service]
```
### 4.查看防火墙状态
```bash
sudo ufw status
```
## 3.检查你的Web服务器
```bash
sudo systemctl status apache2
```
Systemctl是一个systemd工具，主要负责控制systemd系统和服务管理器。

Systemd是一个系统管理守护进程、工具和库的集合，用于取代System V初始进程。Systemd的功能是用于集中管理和配置类UNIX系统。

在Linux生态系统中，Systemd被部署到了大多数的标准Linux发行版中，只有为数不多的几个发行版尚未部署。Systemd通常是所有其它守护进程的父进程，但并非总是如此。

## 4.访问默认的Apache登陆页面以确认是否通过IP地址正常运行
## 5.关闭，启动，重启Apache
```bash
apache2ctl start	启动
apache2ctl restart	重启
apache2ctl stop 	关闭
```
## 6.Apache2配置文件
/etc/apache2/apache2.conf
## 7.如何检测本地的网站
ping ip然后检查端口，我都不知道自己在说些什么。
Tips:作为小白还需要一些东西来记录一下，关于内网和外网。
简单来说，网络是网状结构的，然后外网是与因特网相通的网络，而内网也就是局域网，类似于几台电脑相互连接，来共享资源数据等。
那么对于这两个网络都有其IP地址，也就分别是：
公有IP：它由因特网信息中心管理，是世界唯一的，通过它能够直接上网。
私有IP：它是内部使用的，不能够直接上网（在局域网中）。
家里路由器分出来的IP都是私有IP，那么就是利用了端口映射，NAT。将外网主机IP地址的一个端口映射到内网中的一台机器，然后提供服务，用户访问这个IP时，服务器就会自动将请求映射到局域网内部的机器上。好复杂我也没听懂自己再说什么。
以路由器为例，有两个端口：
WAN：接外部IP
LAN：接内部IP
