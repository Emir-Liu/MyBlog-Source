---
title: Ubuntu上opencv教程4之图像处理
date: 2020-03-27 01:29:34
tags:
- ubuntu
- opencv
---

# 0. 简介
这部分包含了以下几个部分：

1.颜色空间的改变
学习如何在不同的色彩空间来更改图像，此外还要学会如何跟踪视频中的彩色物体。
2.图片阈值处理
使用全局阈值和自适应阈值来将图像转换为二进制图像
3.图片的几何转换
学习旋转，平移等。
4.平滑图像
学习模糊图像，使用自定义内核过滤图像等。
5.形态转换
了解例如侵蚀，膨胀，打开或者关闭等形态的变化。
6.图像渐变
7.Canny边缘检测
8.影像金字塔
9.opencv中的轮廓
10.opencv中的直方图
11.opencv中的图像转换
12.模板匹配
13.霍夫线变换
14.霍夫圆变换
15.分水岭算法的图像分割
16.使用GrabCut进行交互前景提取



# 1.颜色空间的改变
这个部分需要学习将图片从一个颜色空间转变为另一个，例如BGR和Gray的变换或者BGR和HSV之间变换等。
除此之外，我们将会建立一个应用来抽取视频中的彩色的物体。
将会使用cv2.cvtColor(),cv2.inRange()等等。

## 1.1 修改颜色空间
opencv中有150多种颜色空间的变换方法。但是，我们仅仅注意最为重要的以及普遍的两种：BGR<->Gray , BGR <-> HSV。

### 1.1.0 颜色空间
备注：HSV是什么？Hue Saturation Value
RGB,YUV和HSV颜色空间模型
颜色通常用三个独立的属性来描述，三个独立变量综合作用，自然就构成一个空间坐标，这就是颜色空间。但被描述的颜色对象本身是客观的，不同颜色空间只是从不同的角度去衡量同一个对象。颜色空间按照基本机构可以分为两大类：基色颜色空间和色、亮分离颜色空间。前者典型的是RGB，后者包括YUV和HSV等等。

### 1.1.1 RGB颜色空间
1、计算机色彩显示器和彩色电视机显示色彩的原理一样，都是采用R、G、B相加混色的原理，通过发射出三种不同强度的电子束，使屏幕内侧覆盖的红、绿、蓝磷光材料发光而产生色彩。这种色彩的表示方法称为RGB色彩空间表示。
2、在RGB颜色空间中，任意色光F都可以用R、G、B三色不同分量的相加混合而成：F=r[R]+r[G]+r[B]
RGB色彩空间还可以用一个三维的立方体来描述。当三基色分量都为0(最弱)时混合为黑色光；当三基色都为k(最大，值由存储空间决定)时混合为白色光。
3、RGB色彩空间根据每个分量在计算机中占用的存储字节数分为如下几种类型：
（1）RGB555
RGB555是一种16位的RGB格式，各分量都用5位表示，剩下的一位不用。
高字节 -> 低字节
XRRRRRGGGGGBBBBB
（2）RGB565
RGB565也是一种16位的RGB格式，但是R占用5位，G占用6位，B占用5位。
（3）RGB24
RGB24是一种24位的RGB格式，各分量占用8位，取值范围为0-255。
（4）RGB32
RGB24是一种32位的RGB格式，各分量占用8位，剩下的8位作Alpha通道或者不用。
4、RGB色彩空间采用物理三基色表示，因而物理意义很清楚，适合彩色显象管工作。然而这一体制并不适应人的视觉特点。因而，产生了其它不同的色彩空间表示法。

### 1.1.2 YUV颜色空间
1、YUV(亦称YCrCb)是被欧洲电视系统所采用的一种颜色编码方法。在现代彩色电视系统中，通常采用三管彩色摄像机或彩色CCD摄影机进行取像，然后把取得的彩色图像信号经分色、分别放大校正后得到RGB，再经过矩阵变换电路得到亮度信号Y和两个色差信号R-Y(即U)、B-Y(即V)，最后发送端将亮度和两个色差总共三个信号分别进行编码，用同一信道发送出去。这种色彩的表示方法就是所谓的YUV色彩空间表示。采用YUV色彩空间的重要性是它的亮度信号Y和色度信号U、V是分离的。如果只有Y信号分量而没有U、V信号分量，那么这样表示的图像就是黑白灰度图像。彩色电视采用YUV空间正是为了用亮度信号Y解决彩色电视机与黑白电视机的兼容问题，使黑白电视机也能接收彩色电视信号。
2、YUV主要用于优化彩色视频信号的传输，使其向后相容老式黑白电视。与RGB视频信号传输相比，它最大的优点在于只需占用极少的频宽（RGB要求三个独立的视频信号同时传输）。其中“Y”表示明亮度（Luminance或Luma），也就是灰阶值；而“U”和“V” 表示的则是色度（Chrominance或Chroma），作用是描述影像色彩及饱和度，用于指定像素的颜色。“亮度”是透过RGB输入信号来建立的，方法是将RGB信号的特定部分叠加到一起。“色度”则定义了颜色的两个方面─色调与饱和度，分别用Cr和Cb来表示。其中，Cr反映了RGB输入信号红色部分与RGB信号亮度值之间的差异。而Cb反映的是RGB输入信号蓝色部分与RGB信号亮度值之同的差异。
3、YUV和RGB互相转换的公式如下（RGB取值范围均为0-255）︰
　Y = 0.299R + 0.587G + 0.114B
　U = -0.147R - 0.289G + 0.436B
　V = 0.615R - 0.515G - 0.100B
　R = Y + 1.14V
　G = Y - 0.39U - 0.58V
　B = Y + 2.03U

### 1.1.3 HSV颜色空间
1、HSV是一种将RGB色彩空间中的点在倒圆锥体中的表示方法。HSV即色相(Hue)、饱和度(Saturation)、明度(Value)，又称HSB(B即Brightness)。色相是色彩的基本属性，就是平常说的颜色的名称，如红色、黄色等。饱和度（S）是指色彩的纯度，越高色彩越纯，低则逐渐变灰，取0-100%的数值。明度（V），取0-max(计算机中HSV取值范围和存储的长度有关)。HSV颜色空间可以用一个圆锥空间模型来描述。圆锥的顶点处，V=0，H和S无定义，代表黑色。圆锥的顶面中心处V=max，S=0，H无定义，代表白色。
2、RGB颜色空间中，三种颜色分量的取值与所生成的颜色之间的联系并不直观。而HSV颜色空间，更类似于人类感觉颜色的方式，封装了关于颜色的信息：“这是什么颜色？深浅如何？明暗如何？”

Hue的范围是[0,179],Saturation的范围是[0,255],value的范围是[0,255]。不同的软件使用不同的规模，如果你用opencv配合其他软件，你需要规范化这些变量。


对于颜色变换，我们通常使用cv2.cvtColor(input_image,flag)函数。
flag决定了变换的类型。

对于BGR->Gray的变换，flag = cv2.COLOR_BGR2GRAY
BGR->HSV变换， flag = cv2.COLOR_BGR2HSV

如果，你希望查找其他的flag，可以用下面的方法：
```bash
import cv2
flags = [i for i in dir(cv2) if i.startswith('COLOR_')]
print(flags)
```
## 1.2 物体跟踪
现在，我们可以将BGR图像转换为HSV图像，我们可以通过这个来提取一个彩色的物体。在HSV中，我们可以更加容易的代表一种颜色，而不是RGB颜色空间。
我们需要提取一个蓝色的物体，下面是实现方式。
提取视频的每一帧
将BGR转换为HSV颜色空间
我们提取HSV图片中的蓝色范围
单独提取蓝色物体，我们可以在图片上做任何想做的事情。
```bash
import cv2
import numpy as np

cap = cv2.VideoCapture(0)

while(1):

    # Take each frame
    _, frame = cap.read()

    # Convert BGR to HSV
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    # define range of blue color in HSV
    lower_blue = np.array([110,50,50])
    upper_blue = np.array([130,255,255])

    # Threshold the HSV image to get only blue colors
    mask = cv2.inRange(hsv, lower_blue, upper_blue)

    # Bitwise-AND mask and original image
    res = cv2.bitwise_and(frame,frame, mask= mask)

    cv2.imshow('frame',frame)
    cv2.imshow('mask',mask)
    cv2.imshow('res',res)
    k = cv2.waitKey(5) & 0xFF
    if k == 27:
        break

cv2.destroyAllWindows()
```
注意，这个里面会有很多噪音，之后我们需要学习如何消除噪音。

这是物体追踪的最简单的方法。如果你学会了轮廓的函数，你可以做很多事情，例如找到物体的中心和追踪物体，只要在摄像头前移动你的手，就可以花图以及其他有趣的东西。

如何找到追踪的HSV数值？
这是非常常见的问题，你可以使用下面的方法,使用BGR来转换为HSV。
注意，opencv是以BGR格式读取数据，我们需要将RGB进行转换。
```bash
>>> green = np.uint8([[[0,255,0 ]]])
>>> hsv_green = cv2.cvtColor(green,cv2.COLOR_BGR2HSV)
>>> print hsv_green
[[[ 60 255 255]]]
```
然后你将[H-10,100,100]和[H+10,255,255]分别作为上下界。
除了这个方法，你还可以通过图片编辑软件GIMP或者在线转换器来找到数值，不要忘记配合HSV的范围。

# 2.图片阈值处理
图片的阈值处理之前我们已经遇到过，我们还需要有自适应阈值处理。

## 2.1 简单阈值
直接看代码：
```bash
import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('gradient.png',0)
ret,thresh1 = cv2.threshold(img,127,255,cv2.THRESH_BINARY)
ret,thresh2 = cv2.threshold(img,127,255,cv2.THRESH_BINARY_INV)
ret,thresh3 = cv2.threshold(img,127,255,cv2.THRESH_TRUNC)
ret,thresh4 = cv2.threshold(img,127,255,cv2.THRESH_TOZERO)
ret,thresh5 = cv2.threshold(img,127,255,cv2.THRESH_TOZERO_INV)

titles = ['Original Image','BINARY','BINARY_INV','TRUNC','TOZERO','TOZERO_INV']
images = [img, thresh1, thresh2, thresh3, thresh4, thresh5]

for i in xrange(6):
    plt.subplot(2,3,i+1),plt.imshow(images[i],'gray')
    plt.title(titles[i])
    plt.xticks([]),plt.yticks([])

plt.show()
```
上面使用了matplotlib绘制函数，可以复习一下。

## 2.2 自适应阈值
上面是我们使用了一个全局变量作为阈值，但是在有些条件下，图片有不同的光照条件，所以，在这种情况下，我们使用自适应的阈值。在这个方法中，我们需要计算图片中某一区域中的阈值。这样，我们在不同的区域中有不同的阈值，从而得到更好的图片结果。

自适应阈值函数中有三个输入变量和一个输出变量：
1.自适应规则：它决定了阈值的计算方法
cv2.ADAPTIVE_THRESH_MEAN_C
阈值设定为附近区域的中间值
cv2.ADAPTIVE_THRESH_GAUSSIAN_C
阈值取决于高斯窗口附近区域值的加权相加。大概是这么翻译的。又见高斯。。。
2.区块大小：决定了附近区域的大小
3.常数：一个从平均值或者加权平均值中减去的常数。

下面是两个阈值的比较
```bash
import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('dave.jpg',0)
img = cv2.medianBlur(img,5)

ret,th1 = cv2.threshold(img,127,255,cv2.THRESH_BINARY)
th2 = cv2.adaptiveThreshold(img,255,cv2.ADAPTIVE_THRESH_MEAN_C,\
            cv2.THRESH_BINARY,11,2)
th3 = cv2.adaptiveThreshold(img,255,cv2.ADAPTIVE_THRESH_GAUSSIAN_C,\
            cv2.THRESH_BINARY,11,2)

titles = ['Original Image', 'Global Thresholding (v = 127)',
            'Adaptive Mean Thresholding', 'Adaptive Gaussian Thresholding']
images = [img, th1, th2, th3]

for i in xrange(4):
    plt.subplot(2,2,i+1),plt.imshow(images[i],'gray')
    plt.title(titles[i])
    plt.xticks([]),plt.yticks([])
plt.show()
```
上面的程序中有一个中值滤波来模糊化图片，能够有效地抑制噪声，从而消除孤立的噪声点。
cv2.medianBlur()

# 3.图片的几何转换
# 4.平滑图像
# 5.形态转换
# 6.图像渐变
# 7.Canny边缘检测
# 8.影像金字塔
# 9.opencv中的轮廓
# 10.opencv中的直方图
# 11.opencv中的图像转换
# 12.模板匹配
# 13.霍夫线变换
# 14.霍夫圆变换
# 15.分水岭算法的图像分割
# 16.使用GrabCut进行交互前景提取
