---
title: Ubuntu上opencv教程2之用户界面
date: 2020-02-11 23:59:37
tags:
- ubuntu
- opencv
- python
---
# 0.简介
这部分分为多个部分：
1.图片入门
2.视频入门
3.绘画功能
4.将鼠标作为画笔
5.跟踪条作为调色板

# 1.图片入门

## 1.1 读取图片
使用cv2.imread()函数来获取图片，图片需要在工作目录或者完整的目录中。

第二个变量是图片读取方式的标识。
1.cv2.IMREAD_COLOR
加载一个彩色的图片，任何的图片的透明度都会被忽视，默认选项。
2.cv2.IMREAD_GRAYSCALE
加载一个灰度图片
3.cv2.IMREAD_UNCHANGED
加载图片包含alpha通道（不知道）

可以直接用1,0,-1来分别表示。

样例：
```bash
import numpy as np
import cv2

#load an color image in grayscale
img = cv2.imread('img.jpg',0)
```

## 1.2 显示图片
使用cv2.imshow()函数在一个窗口中显示图片，窗口自动适应图片的大小。

第一个参数是窗口的名字，是一个字符串。
第二个参数是图片。
你可以创造任意多的窗口，每个窗口有不同的名字。

```bash
cv2.imshow('image',img)
cv2.waitKey(0)
cv2.destroyAllWindows()
```
cv2.waitKey()是一个键盘绑定功能。他的变量是时间，单位是毫秒。
这个函数等待特定的时间，来等待任意键盘事件。如果你按下按键，程序继续执行。
