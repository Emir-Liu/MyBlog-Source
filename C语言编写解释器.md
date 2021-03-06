---
title: C语言编写解释器
date: 2019-10-03 21:08:07
tags: 
- c/c++
---

相关资料：
基于栈的指令集和基于寄存器的指令集的对比：
https://www.cnblogs.com/wade-luffy/p/6058089.html

用C写了一个解释器，发现Java等高级语言通过虚拟机解释运行程序的过程和汇编语言编译为机器语言有异曲同工之妙。

将代码解释为的字节码，和汇编语言很类似。

# C语言编译原理

## gcc
```bash
gcc [options] [filenames]
```
其中options就是编译器所需要的参数，filenames给出相关的文件名称。

```bash
-E
//只激活预处理，生成.i文件
//预处理：将头文件插入代码中，生成.i文件
-S
//只激活预处理和编译，生成汇编文件.s
//编译：将预处理后的文件转换为为汇编语言，检查代码规范性，是否有语法错误等。检查完毕后，将代码翻译为汇编语言，生成.s文件。
//gcc -S -O3 -fno-asynchronous-unwind-tables main.c这一句里面的参数不明白
-c
//只激活预处理,编译,和汇编,生成.o文件
//汇编：将汇编语言转换为为机器语言，并将指令打包为可重定位目标程序的二进制格式，生成.o文件
无参数
//激活预处理，编译，汇编和连接，生成执行文件
//链接：将调用的函数的目标文件与主程序整合到一起，将文件合并后生成一个可执行的目标文件

gcc -E main.c -o main.i
gcc -S main.i -o main.s
gcc -c main.s -o hello.o
gcc main.o -o main.out

```




