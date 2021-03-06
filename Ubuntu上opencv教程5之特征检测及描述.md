---
title: Ubuntu上opencv教程5之特征检测及描述
date: 2020-05-16 17:17:03
tags:
- ubuntu
- opencv
---
# 0 简介
特征检测及描述内容：
1. 了解功能
图像的主要特征是什么。这些特征对我们有什么用处。
2. (Harris)哈里斯角检测
拐角是一个很好的特征，我们如何找到它们。
3. Shi-Tomasi拐角检测和良好的跟踪功能
4. SIFT(Scale-Invariant Feature Transform)尺度不变特征变换
当图像比例改变时，Harris角检测不够好。为此出现了SIFT方法。
5. SURF(Speeded-Up Robust Features)加速鲁棒特征
为了提高SIFT运算速度
6. 用于角点检测的快速算法
上面的特征检测分别有优势。但是它们在实时应用例如SLAM中的处理速度不够快。所以引入了运算速度更快的快速算法。
7. BRIEF(Binary Robust Independent Elementary Features)二进制健壮的独立基本特征
SIFT使用了一个包含128个浮点数的特征描述。考虑到大量的特征。它将会花费大量内存和时间来匹配。我们可以表达它来使他更快。但是我们首先依然需要计算。BRIEF会使用更少的内存和更快的匹配来查找二进制特征。
8. ORB(Oriented FAST and Rotated BRIEF)定向快速和旋转BRIEF
首先吐槽一下，这个名字的缩写里面又包含了一个缩写，还好里面的缩写上面刚好有，完整的名字实在是太长了。
SIFT和SURF各有利弊，但是如果你的应用中，每年都为使用他们花钱呢？他们都有专利。为了解决这个问题，opencv提供了一个全新的免费的SIFT和SURF代替品，那就是ORB。
9. 特征匹配
我们了解了大量关于特征检测和描述。现在开始匹配不同的描述，opencv提供了两种技术:Brute-Force和基于FLANN的匹配。
10. 特征匹配和单应性查找对象
现在我们了解了特征匹配，我们通过calib3d模块来在复杂的图片中查找物品。

# 1.了解特征
这部分很简单，和标题一样，了解特征。

就像拼图游戏一样，得到图片中的很多小的图片块，然后将他们正确的结合到一起，组成一个大的完整的实际图片。那该怎么做？

将这个理论投影到计算机程序中，使计算机来玩拼图游戏。将这个话题进行延伸，我们是否可向计算机提供大量的自然图片，然后让计算机将图片组合为一个大的单个图片？继续延伸，将多个图片拼接到一起，那么是否可以提供大量相关结构的图片，然后让计算机创建3D模型？

那么回归到最开始的问题。如何玩拼图游戏？

答案是:寻找独特的特定模式或者特定特征，这些特征可以轻松跟踪和比较。如果我们对其进行定义，很难通过语言来表达，但是我们可以知道它们是什么。即使小孩子也可以指出图片中的某些特征。在游戏中，我们在图像中搜索这些特征，然后找到他们，然后在其他图像中找到相同的特征，将他们对齐。

那么，这个问题更加具体，这些特征是什么。

人类发现这些特征，这一个过程已经在大脑中进行了编程。但是，如果我们深入研究某些图片并且搜索不同的样式，我们会有一些有趣的特点。

首先，如果你所搜寻的特征是一个平坦区域，那么这些特征你很难在图片中找到。可以知道大概的位置，但是很难找到准确的位置。

当特征是物品的边缘，就可以找到一个大概的位置，但是准确的位置依然有些困难。因为沿着边缘，到处是不同的。虽然和平坦区域相比，边缘有更好的功能，但是依然不够准确。

当你搜寻的图片是某些物体的角落，那么就很容易找到他们。因为在拐角处，将这部分图片移动到任意位置，图片都会有所不同。所以，他们有很好的功能。

所以，总结一下，拐点被认为是图片中的良好的特征，在某些情况下，斑点也是一种很好的特征。

那么，我们可以回答上面的问题。
寻找特征就是寻找图像中在其周围的所有区域中(少量移动)时变化最大的区域。

寻找特征被称为特征检测。

那么，假如我们在图像中找到了特征，那么，我们需要在其他图像中找到相同的内容。我们该怎么做？

我们围绕该特征选取一个区域，用自己的话语来解释这个特征，例如，颜色大小等特征，然后在其他图像中搜索相同的区域，来在其他图像中找到他。这些表述称之为功能描述。获得功能描述后，可以在所有的图像中找到相同的功能并且将他们对齐或者缝合等操作。

在这个模式里，我们用opencv中的不同算法来查找功能，进行描述，进行匹配。

# 2. (Harris)哈里斯角检测

## 2.1 理论
首先，我们可以知道角就是图像中各个方向上强度变化很大的区域。
1988年Chris Harris和Mike Stephens在论文组合式拐角和边缘检测器中尝试找到这些拐角。也就是哈里斯拐角检测器。然后形成了一个数学形式。
https://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_feature2d/py_features_harris/py_features_harris.html
上面是部分证明过程。

## 2.2 opencv中哈里斯角检测
Opencv中有cv2.cornerHarris()函数，里面有变量:
img 
输入图片，灰度图而且为float32类型。
blockSize
角检测附近区域的大小
ksize
使用的Sobel导数的孔径参数
k
方程中的哈里斯检测器自由参数
```bash
 import cv2 
 import numpy as np
 
 filename = 'chessboard.png'
 img = cv2.imread(filename)
 gray= cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
 
 gray= np.float32(gray)
 dst = cv2.cornerHarris(gray,2,3,0.04)
 
 dst = cv2.dilate(dst,None)
 
 img[dst>0.01*dst.max()] = [0,0,255]
 
 cv2.imshow('dst',img)
 
 if cv2.waitKey(0) & 0xff == 27: 
     cv2.destroyAllWindows()
```

## 2.3 亚像素精度的拐角
什么是亚像素，就是将两个像素之间进行细分，将每个像素划分为更小的单元。
有时候，你需要获取最大精度的角。opencv提供了一个函数cv2.cornerSubPix()函数来重新获取亚精度的拐角。首先，我们需要获取Harris拐角，然后，我们将这些拐角的中心传递到函数中，来重新获取它们。在这个函数中，我们需要定义精度来确定什么时候停止。
```bash
import cv2
import numpy as np

filename = 'chessboard2.jpg'
img = cv2.imread(filename)
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

# find Harris corners
gray = np.float32(gray)
dst = cv2.cornerHarris(gray,2,3,0.04)
dst = cv2.dilate(dst,None)
ret, dst = cv2.threshold(dst,0.01*dst.max(),255,0)
dst = np.uint8(dst)

# find centroids
ret, labels, stats, centroids = cv2.connectedComponentsWithStats(dst)

# define the criteria to stop and refine the corners
criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 100, 0.001)
corners = cv2.cornerSubPix(gray,np.float32(centroids),(5,5),(-1,-1),criteria)

# Now draw them
res = np.hstack((centroids,corners))
res = np.int0(res)
img[res[:,1],res[:,0]]=[0,0,255]
img[res[:,3],res[:,2]] = [0,255,0]

cv2.imwrite('subpixel5.png',img)
```
这一部分有些不太了解，待定。

# 3. Shi-Tomasi拐角检测和良好的跟踪功能
这一部分我们需要重新学习一种拐角检测方式:Shi-Tomasi拐角检测

## 3.1 理论
这部分待定，主要是将Harris拐角检测的公式进行了简化，看看就行。

## 3.2 代码
```bash
import cv2
from matplotlib import pyplot as plt
#读取图片，然后转换为灰度图
img = cv2.imread('simple.jpg')
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)

#通过goodFeaturesToTrack函数通过Shi-Tomasi获取25个最有效的拐角
corners = cv2.goodFeaturesToTrack(gray,25,0.01,10)
corners = np.int0(corners)

for i in corners:
    x,y = i.ravel()
    cv2.circle(img,(x,y),3,255,-1)

plt.imshow(img),plt.show()
```

# 4. SIFT(Scale-Invariant Feature Transform)尺度不变特征变换
# 5. SURF(Speeded-Up Robust Features)加速鲁棒特征
# 6. 用于角点检测的快速算法
# 7. BRIEF(Binary Robust Independent Elementary Features)二进制健壮的独立基本特征
# 8. ORB(Oriented FAST and Rotated BRIEF)定向快速和旋转BRIEF
# 9. 特征匹配
# 10. 特征匹配和单应性查找对象

