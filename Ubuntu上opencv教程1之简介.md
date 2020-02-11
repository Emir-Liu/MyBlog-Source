---
title: Ubuntu上opencv教程1之简介
date: 2020-02-11 22:19:52
tags:
- ubuntu
- opencv
- python
---

# 0.总结
这个部分的内容在于如何在电脑中配置opencv-python，以及介绍。

# 1.介绍
## 1.1 opencv
opencv项目1999年开始，2000年公布。
现在opencv支持很多语言C++，Python,Java等等。可以在很多平台上使用Windows,Linux,OS X,Android,IOS等等。

## 1.2 opencv-python
opencv-python是opencv的python的API接口。它结合了opencv的C++API接口和Python语言。

因为python的简单和可读性，而十分流行。

和其他语言C/C++相比，Python速度较慢，但是，Python可以容易地用C/C++来扩展。这个特性有助于在C/C++中编写计算密集型代码，并且为其创建Python包装器，然后可以将这些包装器来用作Python模块。因此，这个有两个优点：

1.它的后台实际是C++代码，所以我们的代码和原始C/C++代码一样快。

2.Python中代码非常容易

这就是opencv python的工作原理，它就是围绕原始C++实现的Python包装器。

Numpy的支持使任务变得非常容易，Numpy是一个高度优化的数值运算库。提供了一个MATLAB风格的语法。所有OpenCV数组结构都转变为Numpy数组。

opencv python教程
开始之前需要了解python和numpy，因为用opencv python编写优化代码，就必须具备良好的numpy知识。

# 2.ubuntu上opencv使用入门
## 2.1 Ubuntu上使用摄像头
```bash
ls /dev/v*  //  可以看到摄像头，例如/dev/video0,表示成功驱动摄像头    
```

## 2.2如何安装应用程序显示摄像头捕捉到的视频
```bash
sudo apt install camorama
sudo apt install cheese //camorama/cheese分别是两款应用程序
```

## 2.3opencv操作方式
```bash
import cv2
path = "..."
image = cv2.imread(paht)                                //            输入代操作的图片的路径
gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)//                    灰度转换，降低计算强度
cv2.rectangle(image,(x,y),(x+w,y+w),(0,255,0),2)
//对图片进行编辑，最后一个参数为画笔的大小
cv2.imshow("image-title",image)                             //        显示图像
cv2.waitKey(0)                                                            
//注意要加上这一句要不然会看不见图片，
//参数为延迟多少毫秒，当为0时，延迟无穷大秒
face_cascade = cv2.CascadeClassifier(...)
//获取人脸识别的训练数据，来自Github上opencv/data/haarcascades
```
## 2.4人脸识别源码
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



