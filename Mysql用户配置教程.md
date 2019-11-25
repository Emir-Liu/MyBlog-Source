---
title: Mysql用户配置教程
date: 2019-11-25 17:16:33
tags:
- mysql
---
# 问题1：忘记root密码之后，如何修改密码

## 1.在/etc/mysql/my.conf中添加
```bash
[mysqld]
skip-grant-tables
```

## 2.重启mysql
```bash
sudo service mysql restart
```

## 3.重新登录
```bash
sudo mysql
```

## 4.修改密码
```bash
select user, plugin from mysql.user
update mysql.user set authentication_string=PASSWORD('你的密码'), plugin='mysql_native_plugin' where user='root';
```

## 5.退出
