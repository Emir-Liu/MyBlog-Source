---
title: Ubuntu执行脚本
date: 2019-09-16 07:51:40
tags: 
- 执行脚本
- ubuntu
---
# 1.内容
.sh：source/sh/bash
makefile
c/c++
# 2.sh
在Ubuntu中有三种方式运行.sh脚本：
```bash
sh xxx.sh	//通过sh运行
bash xxx.sh //通过bash运行，该文件可以没有执行权限
source FileName//是bash shell的内置命令
/*
在当前bash环境下读取并执行FileName中的命令，即使没有执行权限
注意 该命令通常使用命令 “.”来替代
例：
source bash_profile
. bash_profile
//这两者等效
*/
./xxx.sh //和上面的等价
```
当时用最后一种时，有两个条件：
1。需要在文档中有
```bash
#! /bin/bash	
//或者
#! /bin/sh
```
分别代表用bash和sh运行

如果没有指定用bash或者sh时，Ubuntu会使用bash.

2。权限修改
```bash
chmod a+x xxx.sh
```
建议使用bash因为会避免一些奇怪的错误

执行shell脚本的执行方式的区别：
./*.sh sh ./*.sh bash ./*.sh 重新启动一个子进程

source ./*.sh ../*.sh 执行方式，都是在当前进程中执行脚本。

注意：没有被export导出的变量（非环境变量）是不能够被子shell继承的。

## 2.1输出重定向
命令		说明
command > file	将输出重定向到 file。
command < file	将输入重定向到 file。
command >> file	将输出以追加的方式重定向到 file。
n > file	将文件描述符为 n 的文件重定向到 file。
n >> file	将文件描述符为 n 的文件以追加的方式重定向到 file。
n >& m		将输出文件 m 和 n 合并。
n <& m		将输入文件 m 和 n 合并。
<< tag		将开始标记 tag 和结束标记 tag 之间的内容作为输入。

## 2.2 echo
"" 里面包含转义字符
''里面没有转义字符

# 3.makefile
## 3.1 .PHONY 
	区分大小写，表示后面的target不是真实的文件。
## 3.2 注释
	#
## 3.3 传递参数
```bash
make args=data
//通过命令行传递参数
```
## 3.4 如何加入bash
```bash
SHELL=/bin/bash
```

## 3.5 :=和=
1、“=”
	make会将整个makefile展开后，再决定变量的值。也就是说，变量的值将会是整个makefile中最后被指定的值。看例子：
```bash
            x = foo
            y = $(x) bar
            x = xyz
```
在上例中，y的值将会是 xyz bar ，而不是 foo bar 。
2、“:=”
	“:=”表示变量的值决定于它在makefile中的位置，而不是整个makefile展开后的最终值。
```bash
            x := foo
            y := $(x) bar
            x := xyz
```
在上例中，y的值将会是 foo bar ，而不是 xyz bar 了。


# 4.c/c++

## 4.1C编译过程：
预处理 .c -> .i
汇编    .i -> .s
编译    .s -> .o
链接    .0 -> 可执行文件

## 4.2gcc使用说明
```bash
gcc [选项] [文件名]
/*
https://blog.csdn.net/zhangzhi2ma/article/details/79636297


*/
```

## 4.1读写文件
```bash
FILE *fopen( const char * filename, const char * mode );//打开文件
```
参数：
模式	描述
r	打开一个已有的文本文件，允许读取文件。
w	打开一个文本文件，允许写入文件。如果文件不存在，则会创建一个新文件。在这里，您的程序会从文件的开头写入内容。如果文件存在，则该会被截断为零长度，重新写入。
a	打开一个文本文件，以追加模式写入文件。如果文件不存在，则会创建一个新文件。在这里，您的程序会在已有的文件内容中追加内容。
r+	打开一个文本文件，允许读写文件。
w+	打开一个文本文件，允许读写文件。如果文件已存在，则文件会被截断为零长度，如果文件不存在，则会创建一个新文件。
a+	打开一个文本文件，允许读写文件。如果文件不存在，则会创建一个新文件。读取会从文件的开头开始，写入则只能是追加模式。

如果处理的是二进制文件，则需使用下面的访问模式来取代上面的访问模式：

"rb", "wb", "ab", "rb+", "r+b", "wb+", "w+b", "ab+", "a+b"

```bash
 int fclose( FILE *fp );//关闭文件
int fputc( int c, FILE *fp );//写入文件
int fputs( const char *s, FILE *fp );//写入文件
int fgetc( FILE * fp );//读取文件
char *fgets( char *buf, int n, FILE *fp );//读取文件
```
