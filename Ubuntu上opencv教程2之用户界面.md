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

当变量是0,它一直等待按键按下，这也可以被设置为等待特定的按键。

cv2.destroyAllWindows()是关闭我们建立的所有窗口。如果你想关闭特定的窗口，可以使用函数cv2.destroyWindow()，变量为具体的窗口名称。

## 1.3 保存图片
cv2.imwrite()来保存图片
cv2.imwrite('img.png',img)
将图片以PNG方式保存在工作路径下。

## 1.4 小结
将图片以灰度图的形式保存，然后展示，并且当输入s的时候保存，当输入ESC的时候，退出。

```bash
import cv2

img_path = "./pc1.png"

img = cv2.imread(img_path,0)
cv2.imshow("pic",img)

k = cv2.waitKey(0)

if k == 27:
    cv2.destroyAllWindows()
elif k == ord('s')
    cv2.imwrite('backup.png',img)

```
注意，当使用64位机器，你需要将
k = cv2.waitKey(0)
修改为
k = cv2.waitKey(0) & 0xFF

## 1.5 使用Matplotlib
Matplotlib是一个Python的绘制库，包含了大量的绘制函数，可以使用Matplotlib来显示图片，选择图片区域以及保存它。

更多的待定补充

# 2.视频入门

## 2.1 捕获视频和播放视频
捕获视频需要创造VideoCapture对象，变量可以是设备目录或者视频文件的名字，设备目录只是指定摄像头的数字，之后就会一帧一帧地获取视频，最后不要忘记释放捕获。

cap.read()返回一个bool值，如果帧被正确读取，返回1,所以可以通过检测返回值来检查是否视频结束。

有时候，cap也许没有初始化摄像头，会显示错误，可以通过cap.isOpened()来判断是否初始化完成，如果返回1,继续，否则，使用cap.open()函数。

你可以通过cap.get(propld)来获取视频的参数，使用cap.set(propld,value)来设置视频参数的值。
例如，可以通过cap.get(3)和cap.get(4)检查帧的宽度和长度，默认宽长度是640×480。
修改为320×240,需要
```bash
ret = cap.set(3,320)
ret = cap.set(4,240)
```
如果你遇到错误，确保摄像头可以正常工作通过使用其他的摄像头程序，例如cheese。

样例程序：
```bash
import cv2

cap = cv2.VideoCapture(0)
/*
上面的是读取摄像头，如果读取视频文件那么就用下面的方法
cap = cv2.VideoCapture('vtest.avi')
*/
while(True):
    ret,frame = cap.read()
    gray = cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
    cv2.imshow('frame',gray)
    if cv2.waitKey(1) & 0xFF == ord('q')
        break
cap.release()
cv2.destroyAllWindows()
```
注意里面cv2.waitKey()里面的参数，如果参数太小，视频播放就会非常快速，大的话就会播放速度很慢。25微秒是合适的。

确保安装了合适版本的ffmpeg或者gstreamer，有时候版本不对会导致错误。

## 2.2 保存视频

我们捕获一个视频，一帧一帧地播放视频然后保存视频。
保存图片只需要cv2.imwrite()，保存视频就稍微有些复杂。

当我们创建了一个VideoWriter对象，我们应该确定输出文件的名称，然后我们应该确定FourCC代码，这个是什么，待定。然后fps每秒的帧数和帧的大小应该确定，最后是isColor标志，来确定是彩色还是灰度。

FourCC是4字节的代码用来确定视频的解码器，我们可以使用下列的解码器In Fedora: DIVX, XVID, MJPG, X264, WMV1, WMV2. (XVID is more preferable. MJPG results in high size video. X264 gives very small size video)
In Windows: DIVX (More to be tested and added)
In OSX : (I don’t have access to OSX. Can some one fill this?)

上面的待定，自己看


```bash
import

```

