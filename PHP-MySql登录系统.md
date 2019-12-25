---
title: 'PHP,MySql登录系统'
date: 2019-11-10 13:57:13
tags:
- php
- mysql
- web
---

# 0.前置相关主题
- php
- mysql

# 1.首先建立配置数据库

首先建立一个webdata数据库，在该数据库中添加users表单，在表单中加入一些栏目。

```bash
+------------+--------------+------+-----+-------------------+----------------+
| Field      | Type         | Null | Key | Default           | Extra          |
+------------+--------------+------+-----+-------------------+----------------+
| id         | int(11)      | NO   | PRI | NULL              | auto_increment |
| username   | varchar(50)  | NO   | UNI | NULL              |                |
| password   | varchar(255) | NO   |     | NULL              |                |
| created_at | datetime     | YES  |     | CURRENT_TIMESTAMP |                |
+------------+--------------+------+-----+-------------------+----------------+

```
那么数据库已经配置完成。

# 2.配置网页
看git仓库。

