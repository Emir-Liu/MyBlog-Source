---
title: Python 爬虫入门
date: 2019-08-19 10:18:49
tags: Python
---
# Ubuntu18 如何安装Python
Ubuntu18 默认安装了Python2和Python3,打开Python默认打开Python2:
```bash
python
```
按住Ctrl+D退出Python命令行，打开Python3,输入：
```bash
Python3
```

# 简单读取网页的源码
以读取这篇博客为例，在Python2下面输入：
```bash
import urllib2
```
(听说：如果导入失败，退出Python环境，输入 apt-cache search urllib2)
```bash
page = urllib2.urlopen("https://emir-liu.github.io")
html = page.read()
print(html)
```
这样，就会显示本篇博客的源码。


