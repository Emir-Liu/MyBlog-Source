---
title: Expect操作指南
date: 2019-09-19 13:16:39
tags: Expect
---
Expect是一个用来处理交互的命令。借助Expect，我们可以将交互过程写在一个脚本上，使之自动化完成。可以应用于ssh登陆，ftp登陆。

# 命令:
```bash
send		//用于向进程发送字符串
expect		//从进程接受字符串
spawn		//启动新的进程
interact	//用户交互
$expect_out(buffer)	//存储了所有对expect的输入
#! /usr/bin/expect -f
```

# 语法:
expect最常用的语法是来自tcl语言的模式-动作。这种语法极其灵活，下面我们就各种语法分别说明。

## 单一分支模式语法:
```bash
expect "hi" {send "You said hi"}
```
匹配到hi后，会输出"you said hi"

## 多分支模式语法：
```bash
expect 	"hi" 	{ send "You said hi\n" } 	\
	"hello"	{ send "Hello yourself\n" } 	\
	"bye" 	{ send "That was unexpected\n" }
```
匹配到hi,hello,bye任意一个字符串时，执行相应的输出。等同于如下写法：
```bash
expect {
	"hi" { send "You said hi\n"}
	"hello" { send "Hello yourself\n"}
	"bye" { send "That was unexpected\n"}
}
```


