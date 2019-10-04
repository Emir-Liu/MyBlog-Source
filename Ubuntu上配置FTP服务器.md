---
title: Ubuntu上配置FTP服务器
date: 2019-09-05 15:32:48
tags: FTP
---
# 在Ubuntu上配置FTP服务器
## 1.安装VSFTPD服务器
```bash
sudo apt install vsftpd
```
##2.启动,重启服务
```bash
systemctl start vsftpd
systemctl enable vsftpd
systemctl restart vsftpd
```
## 3.配置服务器
## 4.测试FTP服务器,在局域网的其他电脑上。
```bash
ftp ...
```
