---
title: Ubuntu上opencv教程3之核心操作
date: 2020-02-15 13:33:48
tags:
- ubuntu
- opencv
---
# 0.简介
1.对图片的基本操作
读取和修改像素数值，选取部分图片区域
2.对图片的算数操作
3.计算改进技术
提高运算效率
4.数学运算工具
opencv中的数学工具例如PCA，SVD等

# 1.图片的基本操作
## 1.1 获取和修改像素值
```bash
import cv2
import numpy as np

img = cv2.imread('pic.jpg')

px = img[100,100]
print(px)

blue = img[100,100,0]
print(blue)

img[100,100] = [255,255,255]
print(img[100,100])
```
返回
```bash
[157 166 200]
157
[255 255 255]
```
注意：
numpy是一个快速数组计算的库，所以简单的获取和修改单个像素的值都是缓慢的，不建议如此使用。

上面的方法通常用来选择数组的一个区域，例如前5行和后3列。
对于单个像素的获取，通常用array.item()和array.itemset()，但是它总是返回一个数值，所以如果你想要获取所有BGR的值，就需要分别获取。
```bash
#获取 RED 值
img.item(10,10,2)

#修改 RED 值
img.itemset((10,10,2),100)
img.item(10,10,2)
```

## 1.2 获取图片的属性
图片属性包括：行，列，通道，图片数据的类型，像素的数目等等。
```bash
print(img.shape)
#获取图片的行，列，通道

print(img.size)
#获取图片中的像素数目

print(img.dtype)
#获取图片的数据类型
```
图片的数据类型是非常重要的，因为很多的时候错误原因就是不合适的数据类型。

## 1.3 选取图片的区域 ROI(Region Of Image)
有时候，需要选取某些区域的图像，例如，对于眼睛的检测，需要首先执行面部检测，然后再面部内搜索眼睛，这种方法提高了准确性和性能。

所以，ROI是包含了numpy数组
```bash
>>> ball = img[280:340, 330:390]
>>> img[273:333, 100:160] = ball
```

## 1.4 分割和融合图片的通道
B，G，R是彩色图片的通道，对于这个的操作有
```bash
b,g,r = cv2.split(img)
img = cv2.merge((b,g,r))

b = img[:,:,0]
img[:,:,2] = 0
```
注意cv2.split()是一个时间花费昂贵的运算，只有必要的时候才会使用，一般情况下，numpy数组是更加有效的，并且尽可能用。

## 1.5 为图片制作边框(Padding)
Padding,内边框，填充，
如果你想在图片的周围制造边框，可以使用cv2.copyMakeBorder()函数，但是对复杂的运算有更多的应用，无内边框等，这个函数有下列的变量：
```bash
src 
#输入图片
top,bottom,left,right
#在相对应的方向的边界的宽度，单位是像素数目。
borderType 
/*
标志位用来确定添加哪种边界,有下列的类型
cv2.BORDER_CONSTANT 添加一个固定颜色的边界，下个变量应该是颜色
cv2.BORDER_REFLECT  边界将会镜像边界的元素，
例如：fedcba|abcdefgh|hgfedcb
cv2.BORDER_REFLECT_101
cv2.BORDER_DEFAULT  上面两个都是一样的，和上面的相似，但是有不同
例如： gfedcb|abcdefgh|gfedcba
cv2.BORDER_REPLICATE最后的元素代替边界
例如：aaaaaa|abcdefgh|hhhhhhh
cv2.BORDER_WRAP     就像：cdefgh|abcdefgh|abcdefg
*/
value
#如果边界类型是固定颜色的边界，那么需要变量来表示边界的颜色
```

这样，下面是例程：
```bash
import cv2
import numpy as np
from matplotlib import pyplot as plt

BLUE = [255,0,0]

img1 = cv2.imread('opencv_logo.png')

replicate = cv2.copyMakeBorder(img1,10,10,10,10,cv2.BORDER_REPLICATE)
reflect = cv2.copyMakeBorder(img1,10,10,10,10,cv2.BORDER_REFLECT)
reflect101 = cv2.copyMakeBorder(img1,10,10,10,10,cv2.BORDER_REFLECT_101)
wrap = cv2.copyMakeBorder(img1,10,10,10,10,cv2.BORDER_WRAP)
constant= cv2.copyMakeBorder(img1,10,10,10,10,cv2.BORDER_CONSTANT,value=BLUE)

plt.subplot(231),plt.imshow(img1,'gray'),plt.title('ORIGINAL')
plt.subplot(232),plt.imshow(replicate,'gray'),plt.title('REPLICATE')
plt.subplot(233),plt.imshow(reflect,'gray'),plt.title('REFLECT')
plt.subplot(234),plt.imshow(reflect101,'gray'),plt.title('REFLECT_101')
plt.subplot(235),plt.imshow(wrap,'gray'),plt.title('WRAP')
plt.subplot(236),plt.imshow(constant,'gray'),plt.title('CONSTANT')

plt.show()
```
上面有matplotlib，类似于matlab的绘制函数

# 2.图片的算数操作
## 2.1 图片加法
通过opencv的函数cv2.add()将两个图片相加，或者通过数组res=img1+img2。所有的图片必须有相同的类型和深度，或者第二个图片可以是一个灰度值。

但是这两个方法有区别：
opencv加法是饱和运算
numpy是取余运算
例如：
```bash
>>> x = np.uint8([250])
>>> y = np.uint8([10])
>>> print cv2.add(x,y) # 250+10 = 260 => 255
[[255]]
>>> print x+y          # 250+10 = 260 % 256 = 4
[4]
```
当你添加两个图片时候，opencv函数将会提供更好的结果，最好使用opencv函数。

## 2.2 图像混合
也是图片加法，但是不同的权重给图片，有混合和透明度的感觉。
```bash
g(x) = (1 - a)f0(x) + af1(x)
```
将a从0到1,可以将一个图片转换为另一个图片，可以用cv2.addWeighted()来进行图片的混合。
cv2.addWeighted(img1,a,img2,b,c)

out = a * img1 + b * img2 + c
```bash
img1 = cv2.imread('img.png')
img2 = cv2.imread('logo.jpg')

dst = cv2.addWeighted(img1,0.7,img2,0.3,0)

cv2.imshow('dst',dst)
cv2.waitKey(0)
cv2.destroyAllWindows()
```

## 2.3 位运算操作
and,or,not或者xor位运算，这些在抽取图片的不矩形部分中，非常有用。
将一个logo放在一个图片上，如果将两个图片直接相加，它将会修改颜色。如果将两个图片进行图像混合，就会有透明度。如果是一个矩形区域就可以直接用之前的ROI图片区域方法。可以通过位操作
```bash
# 加载两个图片
img1 = cv2.imread('img.jpg')
img2 = cv2.imread('logo.png')

# 将logo放在左上角，所以可以选取图片区域
rows,cols,channels = img2.shape
roi = img1[0:rows, 0:cols ]
# 将logo转变为灰度创立了一个logo的掩体，然后建立一个相反的掩体
img2gray = cv2.cvtColor(img2,cv2.COLOR_BGR2GRAY)
ret, mask = cv2.threshold(img2gray, 10, 255, cv2.THRESH_BINARY)
mask_inv = cv2.bitwise_not(mask)

# 将logo相反的掩膜来提取图片中logo部分以外的数据
img1_bg = cv2.bitwise_and(roi,roi,mask = mask_inv)

# 用logo的掩膜来提取图片中logo的数据
img2_fg = cv2.bitwise_and(img2,img2,mask = mask)

# 将获取的数据进行相加，就可以获取修改之后的图片数据
dst = cv2.add(img1_bg,img2_fg)
img1[0:rows, 0:cols ] = dst

cv2.imshow('res',img1)
cv2.waitKey(0)
cv2.destroyAllWindows()
```
其中有图片阈值函数，cv2.threshold()函数，当像素的数值大于某个阈值，像素点会被分配为一个数值，其他的分配另外的数值。第一个变量是图片，应该是灰度图。第二个变量是阈值，第三个变量是最大值，代表了如果像素值高于或者低于阈值的时候，所需要的数值，第四个变量是阈值函数的类型，分别有：
```bash
cv2.THRESH_BINARY   //像素值大于阈值，就修改为最大值，其他的为0
cv2.THRESH_BINARY_INV//像素值大于阈值为0,否则是最大值
cv2.THRESH_TRUNC    //像素值大于阈值则为阈值，否则是原本的数值
cv2.THRESH_TOZERO   //像素值大于阈值则不变，否则为0
cv2.THRESH_TOZERO_INV//像素值大于阈值为0,否则不变
```
备注：
BINARY模式，阈值的最大值是255,也就是白色，特别注意在opencv中，0代表黑色。
TOZERO模式，将部分数值变为0
INV模式，就是相反

之后是cv2.bitwise_and()函数，这里面有一个掩膜，例如
out = cv2.bitwise_and(img1,img2,mask = mask_defined)
首先，img1和img2有相同的大小，而且
out[i] = img1[i] & img2[i] if mask[i] != 0

# 3.改进运算效率的技术
在图片的运算中，我们每秒需要处理大量的运算，所以，代码不仅仅需要得到正确的解法，而且具有很高的效率，这一部分包含下面的内容：
测量代码运行的效率
提高代码效率的一些小诀窍
需要使用下面的一部分函数：cv2.getTickCount,cv2.getTickFrequency。
除了opencv，python中有time模块，可以用来测量执行的时间，以及profile模块来得到代码的详细内容，例如，代码中每个功能所需要的时间，函数被调用了多少次等。但是，如果你使用IPython，这些特性都很好的被包含在内。

## 3.1 使用opencv来测量性能
cv2.getTickCount函数用来返回一个相关事件（例如，机器启动的时刻）之后直到这个函数被调用之间的时钟周期数，所以，你可以在函数前后调用这个函数来计算得到这个函数的执行需要多少个时钟周期。

cv2.getTickFrequency函数返回了时钟周期频率，或者可以说每秒的时钟周期数目，所以可以通过下面的代码获取执行时间
```bash
e1 = cv2.getTickCount()
# your code execution
e2 = cv2.getTickCount()
time = (e2 - e1)/ cv2.getTickFrequency()
```
你可以直接使用time模块中的time.time()函数，取两个函数返回值的差大概。没有用过。

## 3.2  opencv中默认的优化
opencv中的许多函数都通过SSE2,AVX等进行了优化，它还包含了没有优化的代码。所以如果我们的系统支持这些特性，我们应该使用他们，几乎大多数现代处理器都支持他们。在编译的时候这些就默认使用了。所以，当默认使用的时候，opencv运行优化过的代码，否则运行没有优化过的代码。你可以使用cv2.useOptimized()函数来检查它是否已经启用，也可以使用cv2.setUseOptimized()来开启或者关闭优化。
样例
```bash
# check if optimization is enabled
In [5]: cv2.useOptimized()
Out[5]: True

In [6]: %timeit res = cv2.medianBlur(img,49)
10 loops, best of 3: 34.9 ms per loop

# Disable it
In [7]: cv2.setUseOptimized(False)

In [8]: cv2.useOptimized()
Out[8]: False

In [9]: %timeit res = cv2.medianBlur(img,49)
10 loops, best of 3: 64.1 ms per loop
```

## 3.3 IPython中的检测性能
首先，IPython是什么：
它只是python中的一个模块，可以通过pip来安装。
然后，它有什么用处：
是python的交互式shell,比默认的python shell好用的多，支持自动缩进，bash shell命令，也内置了很多有用的函数以及功能，可以高效使用python,也是利用python来进行科学计算和交互可视化的平台。

主要功能：
1.运行ipython控制台
2.使用ipython作为系统shell
3.使用历史输入(history)
4.Tab补全
5.使用%run命令运行脚本
6.使用%timeit命令快速测量时间
7.使用%pdb命令快速debug
8.使用pylab进行交互计算
9.使用IPython Notebook

但是，我居然还没用过。。。我直接找一些资料先补充。以后用到再说。
样例
```bash
In [10]: x = 5

In [11]: %timeit y=x**2
10000000 loops, best of 3: 73 ns per loop

In [12]: %timeit y=x*x
10000000 loops, best of 3: 58.3 ns per loop

In [15]: z = np.uint8([5])

In [17]: %timeit y=z*z
1000000 loops, best of 3: 1.25 us per loop

In [19]: %timeit y=np.square(z)
1000000 loops, best of 3: 1.16 us per loop
```
说实话，看到上面的样例，感觉有点像Linux中的time函数，我偶尔发现的。
再次提醒，python的数值计算远快于numpy数值计算。所以仅包含一两个元素的运算，我们尽量使用python的数值运算，当数组的大小更大的时候使用numpy。
```bash
In [35]: %timeit z = cv2.countNonZero(img)
100000 loops, best of 3: 15.8 us per loop

In [36]: %timeit z = np.count_nonzero(img)
1000 loops, best of 3: 370 us per loop
```
所以opencv函数比numpy函数快25倍，说实话，这是怎么算出来的？370/15.8,恩就这样。

## 3.4 更多IPython的指令
还有其他命令来测量性能，分析性能，行分析，存储空间测量等。

## 3.5 优化性能的技巧
注意，首先简单实现算法，之后分析，找到瓶颈对其优化。
1.尽量不要在python中使用循环，尤其是多重循环
2.numpy和opencv已经对向量运算进行了优化，因此尽量使用向量
3.利用缓存？
4.除非必要，不要复制数组，而是尝试使用视图。？？
如果这样依旧无法解决问题，那么使用Cython库。

# 4.opencv中的数学运算工具
这里面很复杂，包含SVD和PCA。
SVD Singular Value Decomposition奇异指分解 数值降维
PCA Principal Component Analysis主成分分析 降维算法
这两个方法我会专门进行补充。。待定

