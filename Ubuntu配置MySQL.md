---
title: Ubuntu配置MySQL
date: 2019-09-14 09:52:06
tags: 
- mysql
---
详细教程:http://www.mysqltutorial.org/basic-mysql-tutorial.aspx
# 1.安装MySQL
```bash
sudo apt install mysql-server
sudo apt install mysql-client
sudo apt install libmysqlclient-dev
```
# 2.检测
安装是否成功
```bash
sudo netstat -tap | grep mysql
```
mysql服务是否正常
```bash
systemctl status mysql.service
``

# 3.基本操作

```bash
mysql -u root -p	//登陆数据库
```

## 1.数据库
```bash
show databases;			//列出数据库

CREATE DATABASE [if not exists] DATABASE-NAME	//创建数据库
[character set charset-name]	//指定字符集
[collate collation-name]	//指定排序规则

drop database [if exists] database-name;	//删除数据库
use database-name;		//选择数据库
source /.../path;		//导入数据库
select database();		//获取当前连接的数据库的名称
```
## 2.表
```bash
show tables;

drop table table-name;

create table [if not exists] table-name(
	column-name data-type (extra),
	.
	.
	table-constraints
) engine = storage-engine	//默认使用InnoDB

column-name data-type(length) [not null] [default value] [auto-increment] column-constraint
//约束:check,unique,not null
//auto-increment，每当自动一个新行插入到列表中，每个表最多宝航一个auto-increment列，当被设置为auto-increment，not null约束会添加到列中

insert into table-name(column-name,...)
values	(data1,...),
	(...)
	.
	.

alter table table-name	//在表中添加一列
add
	new-column-name column-definition
	[first | after column-name],	//默认添加到列表的末尾
	.
	.
	.

alter table table-name
	modify column-name column-definition
	[first | after column-name]
```

## 3.数据
查询表内的数据结构
```bash
desc table-name;					//查询表的字段信息（不包含内容）
show columns from table-name;				//同上
```
```bash
select [distinct] column1[as alias],column2/expression/*	
							//必要,distinct显示唯一状态，如果有多列数值，会得到唯一的组合
from table-name						//必要
[inner/left/right] join table2-name on conditions	//下面的可选
where conditions AND/OR/NOT conditions
group by column-1
having group-conditions
order by column1[ASC|DESC],column2[ASC|DESC]		//默认为升序
limit [offset,]row_count	//offset第一行的偏移规定返回，row_count是最大返回的行数，offset第一个是0.
```
其中，where column-name = 'sth'
where与between搭配:where expression between low and high
where与like搭配:where column-name like '%sth'
  其中，%与零或者多个任意字符串匹配，_匹配任何单个字符。_
where与in搭配:where value in (value1,value2,...)
where与is null搭配:where value is null
  其中，null是一个标记，表示一条信息缺失或者未知。
比较运算符
\=
<>或!=
<
\>
<=
/>=
其中，0被视为false,非零视为true。
MySQL首先运算AND，然后运算OR。

其中in通常与子查询一起使用。
特别使用日期，Between与日期 cast('2001-01-01' as date)

like:(模式不区分大小写)
expression LIKE pattern ESCAPE escape-character
当需要匹配的模式包含通配符，可以用ESCAPE来指定转义字符，如果没有明确指定转义字符，反斜杠为缺省转义字符

MySQL存储引擎:
1.MyISAM
2.InnoDB
3.MERGE
4.MEMORY/HEAP
5.ARCHIVE
6.CSV
7.FEDERATED


MySQL数据类型
每种数据可以通过以下的特征来确定：
1.值的类型
2.占用的空间，以及值为固定长度还是可变长度
3.数据类型的值是否可以索引
4.如何比较特定数据类型的值

数字：
TINYINT	非常小的整数
SMALLINT	小的整数
MEDIUMINT	中等整数
INT	标准整数
BIGINT	大整数
DECIMAL	定点数
FLOAT	单精度浮点数
DOUBLE	双精度浮点数
BIT	一位

布尔：
没有内置的布尔数据类型，使用最小的整数类型TINYINT

字符串：
可以保存从纯文本到二进制数据例如图像或者文件的任何内容。
CHAR	固定长度的非二进制字符串
VARCHAR	可变长度的非二进制字符串

TINYTEXT	很小的非二进制字符串
TEXT	小的非二进制字符串
MEDIUMTEXT	中等非二进制字符串
LONGTEXT	大型非二进制字符串


BINARY	定长的二进制字符串
VARBINARY	可变长度的二进制字符串

TINYBLOB	很小的BLOB(二进制大对象)
BLOB	小BLOB
MEDIUMBLOB	中等BLOB
LONGBLOB	大型BLOB

ENUM	枚举，每个列可以分配一个枚举成员
SET	一套，每个列可以分配0或者多个SET成员

时间：
DATE	CCYY-MM-DD
TIME	HH：MM：SS
DATETIME	CCYY-MM-DD HH：MM：SS
TIMESTAMP	CCYY-MM-DD HH：MM：SS
YEAR	CCYY/YY

空间：
没有用到过，待定

JSON数据类型：

