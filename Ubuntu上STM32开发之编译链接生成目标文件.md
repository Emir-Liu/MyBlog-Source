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


的最小系统板，由于自己在画板子的时候忘记了STlink接口，所以，就很尴尬，只能通过USART串口下载了。

