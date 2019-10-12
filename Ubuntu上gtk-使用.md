---
title: Ubuntu上gtk+使用
date: 2019-10-12 21:04:59
tags: gtk+
---
# 0简介
GTK(GIMP Toolkit)是一套跨多种平台的图形工具包,按LGPL许可协议发布的。虽然最初是为GIMP写的，但早已发展为一个功能强大、设计灵活的通用图形库。特别是被GNOME选中使得GTK+广为流传，成为Linux下开发图形界面的应用程序的主流开发工具之一，当然GTK+并不要求必须在Linux上，事实上，目前GTK+已经有了成功的windows版本。 [1] 
GTK+虽然是用C语言写的，但是您可以使用你熟悉的语言来使用GTK+，因为GTK+已经被绑定到几乎所有流行的语言上，如：C++, Guile, Perl, Python, TOM, Ada95, Objective C, Free Pascal, Eiffel等。
# 1.gtk+的安装
```bash
sudo apt-get install libgtk2.0-dev
```
