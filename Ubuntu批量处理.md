---
title: Ubuntu批量处理
date: 2019-09-16 07:51:40
tags: 批处理
---
# 1.内容
shell
makefile
c/c++
# 2.shell

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
