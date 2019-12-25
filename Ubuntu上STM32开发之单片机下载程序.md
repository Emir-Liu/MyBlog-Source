---
title: Ubuntu上STM32开发之单片机下载程序
date: 2019-12-25 21:55:38
tags:
- ubuntu
- stm32
---
我选用的是STM32F103芯片设计的最小系统板，由于自己在画板子的时候忘记了STlink接口，所以，就很尴尬，只能通过USART串口下载了。

# 1.软件准备
stm32flash:用于串口下载源程序。
安装：
```bash
sudo apt install stm32flash
```
常用指令：
```bash
sudo stm32flash /dev/ttyUSB0 //获取设备信息

sudo stm32flash -w filename -v -g 0 /dev/ttyUSB0 //验证写入，然后写入源程序

stm32flash -r filename /dev/ttyUSB0 //读闪存到文件

stm32flash -g 0 /dev/ttyUSB0 //开始执行

输入时，BOOT0置高，BOOT1置低
```



minicom串口工具。
安装方式：
```bash
sudo apt install minicom
```
配置方式：
```bash
sudo minicom -s //注意在进行串口的操作时候，需要有sudo权限，或者修改串口的权限，修改的方式看下面
```
选择Serial port setup,然后回车，进行配置。
输入a,选择串口设备，也就是输入串口号/dev/ttyUSB0，如何查询串口号，也看下面。修改之后回车。
然后，输入e，修改波特率及配置为 115200 8N1,修改完成后回车。
然后，输入f，配置硬件控制流，选择No。同上，软件控制流也为No。

配置完成后，回车返回上一个界面，选择save setup as dfl将配置保存在默认位置。
然后exit，关闭minicom。

再次输入sudo minicom，就使得配置生效。

问题1：查询串口号：
```bash
dmesg //可以查看安装的驱动信息，里面有串口设备的串口号但是里面的驱动实在是太多了。

ls -l /dev/ttyUSB* //可以查询到串口号，
```

这样，就成功将单片机连接到电脑上了。
