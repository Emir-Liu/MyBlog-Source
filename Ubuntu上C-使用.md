---
title: 'Ubuntu上C#使用'
date: 2019-10-15 18:21:46
tags:
- ubuntu
- c#
- mono
---

# 0 安装
```bash
sudo apt install mono-complete
sudo apt install monodevelop
```
好吧，我承认自己没有办法安装monodevelop出现了各种问题，但是，有其他方法，IDE我重新选择了Rider，破解简单，而且下载方便。



# 1 快速入门
```bash
vim hello.cs

//hello.cs
using System;

//namespace declaration 
//namespace is a collection of classes
namespace HelloWorldApplication {

//class declaration
//class generally contain multiple methods,data
   class HelloWorld {

//Main method is the entry point for all c# programs
      static void Main(string[] args) {
         /* my first program in C# */
         Console.WriteLine("Hello World");
         Console.ReadKey();
      }
   }
}

//编译
mcs hello.cs

//执行
mono hello.exe
```
