---
title: Ubuntu上opencv的使用
date: 2019-09-23 20:41:41
tags: 
- opencv
- python
- ubuntu
---

# 1.Ubuntu上使用摄像头
```bash
ls /dev/v*	//	可以看到摄像头，例如/dev/video0,表示成功驱动摄像头
```

# 1.1如何安装应用程序显示摄像头捕捉到的视频
```bash
sudo apt install camorama
sudo apt install cheese	//camorama/cheese分别是两款应用程序
```

# 2.opencv
	OpenCV是一个基于BSD许可（开源）发行的跨平台计算机视觉库，可以运行在Linux、Windows、Android和Mac OS操作系统上。它轻量级而且高效——由一系列 C 函数和少量 C++ 类构成，同时提供了Python、Ruby、MATLAB等语言的接口，实现了图像处理和计算机视觉方面的很多通用算法。
	OpenCV用C++语言编写，它的主要接口也是C++语言，但是依然保留了大量的C语言接口。该库也有大量的Python、Java and MATLAB/OCTAVE（版本2.5）的接口。这些语言的API接口函数可以通过在线文档获得。如今也提供对于C#、Ch、Ruby,GO的支持。

# 2.1安装opencv
```bash
sudo apt install python-opencv
```

# 3.1opencv操作方式
```bash
import cv2
path = "..."
image = cv2.imread(paht)								//输入代操作的图片的路径
gray	= cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)//灰度转换，降低计算强度
cv2.rectangle(image,(x,y),(x+w,y+w),(0,255,0),2)	
//对图片进行编辑，最后一个参数为画笔的大小
cv2.imshow("image-title",image)								//显示图像
cv2.waitKey(0)																
//注意要加上这一句要不然会看不见图片，
//参数为延迟多少毫秒，当为0时，延迟无穷大秒
face_cascade = cv2.CascadeClassifier(...)			
//获取人脸识别的训练数据，来自Github上opencv/data/haarcascades
```

# 4.人脸识别源码
```bash
import cv2 

image_path      = "./pc1.png"
facedata_path   = "./haarcascade_frontalface_default.xml"
face_cascade    = cv2.CascadeClassifier(facedata_path)

image   = cv2.imread(image_path)
gray    = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
cv2.imshow("Picture",image)
cv2.waitKey(0)
faces = face_cascade.detectMultiScale(
        gray,
        scaleFactor = 1.15,
        minNeighbors= 5,
        minSize     = (5,5),
        flags       = cv2.CASCADE_SCALE_IMAGE
        )   

print('hello')
print("find {0} face(s)!",format(len(faces)))

for(x,y,w,h) in faces:
    cv2.circle(image,((x+x+w)/2,(y+y+h)/2),w/2,(0,255,0),2)
cv2.imshow("Find Faces!",image)
cv2.waitKey(0)

```
