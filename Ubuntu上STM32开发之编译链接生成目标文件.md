---
title: Ubuntu上STM32开发之编译链接，生成目标文件
date: 2019-12-25 20:42:36
tags:
- ubuntu
- stm32
---
# 1.软件准备

gcc-arm-none-eabi是Ubuntu上针对ARM Cortex-M和Cortex-R处理器的GNU Arm嵌入式工具链。适用于C，C++和汇编的开源套件。

下载方式apt:
```bash
sudo apt install gcc-arm-none-eabi
```

makefile用于工程的管理的脚本语言，但是结构很特别。
下载方式同上。

工程模板：
我选用的是STM32F103芯片，STM32不同系列的芯片的存储区域与大小不同，会影响到下载的地址不同，不过可以套用这一套模板进行修改，大概吧。
工程模板是包含了硬件库和一些常用的头文件，以及链接时候的参数文件，以及makefile文件。

# 2.进行对程序进行编译连接，生成目标文件（bin/hex文件）
```bash
make //在有makefile目录中
```
完成后会在工程文件下出现对应的文件。

补充：
上面仅仅是依靠现有的工程来进行编译，链接，最后形成目标文件的过程，其中，makefile中有编译链接的具体的过程，为了了解其中的过程，需要详细分析工具链的操作方式。
gcc-arm-none-eabi工具链的使用方法：
arm-none-eabi-gcc:
c语言编译器，可以将.c文件转化为.o文件。
```bash
arm-none-eabi-gcc -c hello.c
```

arm-none-eabi-g++:
c++语言编译器，可以将.cpp文件转化为.o执行文件。

arm-none-eabi-ld:
将所有.o文件进行链接，生成可执行文件，但是听说对c,cpp文件混合生成的.o文件的支持性不好。所以推荐使用arm-none-eabi-gcc代替。
```bash
arm-none-eabi-gcc -o hello hello.o
```

arm-none-eabi-gdb:
调试器，还没有用过。

知道了这些，就可以编写makefile文件了。


