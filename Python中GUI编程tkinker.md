---
title: Python中GUI编程tkinker
date: 2020-06-16 21:41:50
tags:
- python
- tkinker
---
Python的GUI编程 tkinter

环境：
Python3

https://www.tutorialspoint.com/python/python_gui_programming.htm
Python提供了多个图形开发界面的库，其中最主要的是：

tkinter
Python内嵌的一个GUI，可以在大多数Unix平台上使用，也可以在Windows和Mac系统中运行

wxPython
开源软件

Jython
可以和Java无缝集成，除了一些标准模块，Jython 使用 Java 的模块。Jython 几乎拥有标准的Python 中不依赖于 C 语言的全部模块。

通过tkinter来创造界面程序非常方便，只要下面的步骤：
1.导入tkinter模块
2.创造图形界面主窗口
3.增加一个或者多个小部件
4.进入主要事件循环，对用户引起的事件采取反馈

tkinter部件包含：
1.按钮
2.画布
3.复选按钮
4.输入
5.框架
6.标签(finished)
7.列表框
8.菜单按钮
9.菜单
10.信息
11.单选按钮
12.比例
13.滚动条
14.文本
15.顶层
16.旋转框
17.窗格视窗
18.标签框
19.tk消息框

标准属性
1.外形尺寸
2.颜色
3.字体
4.锚点
5.浮雕样式
6.位图
7.光标

几何管理器
1.pack()方法 这个几何管理器在将小部件放在父部件之前先将它们按块的方式组织起来(finished)
2.grid()方法  这个几何管理器在父部件中按照表状结构组织小部件
3.place()方法  这个几何管理器将小部件放置在父部件的特定位置中

下面的内容将会涉及上面的内容，但是，我们不会一个一个看下来，学习就先做一些有趣的东西吧。

GUI计算器，这是入门的项目来熟悉tkinter，项目很简单，但是可以有很多写法：

首先，来一个窗口
```bash
#test0.py
from tkinter import *

window = Tk()
window.title("helloGUI")
window.geometry('1068x681+10+10')
window.mainloop()

```
上面就是简单的导入模块，然后建立窗口，设置标题，窗口尺寸，进入事件循环。

开始第一步，按钮和标签。
通过标签来显示内容和反馈，按钮作为输入。
标签：
这个部件可以使用一个框来显示文字或者图片。上面的标签可以在任何时候修改。
语法：
```bash
w = Label(master,option=value,...)
```
变量：
master：表示父窗口
options:下面是这个部件常用的选项列表。这些选项可以用逗号分隔的键值来表示。

1.anchor 如果窗口小部件的空间超过了文本所需的空间，则此选项控制文本的位置。默认值为anchor = CENTER，它将文本在可用空间中居中。
2.bg  正常背景色显示在标签和指示器后面。
3.bitmap  将此选项设置为等于bitmap或图像对象，标签将显示该图形。
4.bd  指标周围边框的大小。默认值为2像素。
5.cursor  如果将此选项设置为光标名称（arrow，dot等），则当光标位于复选按钮上方时，鼠标光标将变为该样式。
6.font  如果要在此标签中显示文本（使用text或textvariable选项，则font选项指定将以哪种字体显示文本。)
7.fg  如果要在此标签中显示文本或位图，则此选项指定文本的颜色。如果要显示位图，则此颜色将显示在位图中1的位置。
8.height  新框架的垂直尺寸。
9.image  要在标签窗口小部件中显示静态图像，请将此选项设置为图像对象。
10.justify  指定多行文本彼此之间如何对齐：LEFT表示向左对齐，CENTER表示居中（默认），RIGHT表示右对齐。
11.padx  小部件内的文本左右添加了额外的空间。默认值为1。
12.pady  在小部件中的文本上方和下方添加了额外的空间。默认值为1。
13.relief  指定标签周围装饰性边框的外观。默认值为FLAT；其他值。
14.text  要在标签窗口小部件中显示一行或多行文本，请将此选项设置为包含文本的字符串。内部换行符（“ \ n”）将强制换行。
15.textvariable  要将标签窗口小部件中显示的文本从属于StringVar类的控制变量，请将此选项设置为该变量。
16.underline  通过将此选项设置为n，可以在文本的第n个字母下方显示下划线（_），从0开始计数。默认值为underline = -1，表示没有下划线。
17.width  标签的宽度，以字符为单位（不是像素！）。如果未设置此选项，则标签将调整大小以适合其内容。
18.wraplength  通过将此选项设置为所需的数字，可以限制每行中的字符数。默认值为0，表示仅在换行符处才断开行。

但是，有一个小小的问题，你在尝试上面的函数之后，标签并没有显示。我们还需要一个函数widget.pack()。

这是几何管理器的一种方法，将小部件放置在父部件上，如果没有这个函数，小部件也就不会显示了。

这里有一个需要注意的地方，那么就是textvariable中提到的StringVar变量。
在之前了解到，string字符串是不可变量，但是这里的StringVar是变量。
这里就要提到Varible类了，有些控件，例如Entry、Radiobutton等，可以通过传入特定的参数和程序变量绑定，这些参数包括：
variable、textvariable、onvalue、offvalue、value。

这种绑定时双向的，如果该变量发生改变，那么与该变量绑定的空间也会随之更新。但是一般的Python变量不能够传递给这些参数中。

定义：
x = StringVar()
x = IntVar()
x = DoubleVar()
x = BooleanVar()

获取，使用get()方法
设置，使用set()方法

我们来讨论一下几何管理器的pack()函数。
语法：
```bash
widget.pack(pack_options)
```
下面是一些可选项：
1.expand 当设置为true，小部件将会扩展，从而填充小部件父部件中没有使用的任何空间。
2.fill 决定小部件是否填充打包文件分配给它的任何额外空间，还是保持自己的最小尺寸：NONE(默认)、Y(垂直填充)、BOTH(水平和垂直填充)
3.side 确定小部件在父部件的那一侧包装：TOP(默认)、BOTTOM、LEFT、RIGHT。

输出和基础的几何管理完成了，那么我们来到输出环节，开始学习按钮这一部分：

按钮是在Python应用程序中添加按钮，这些按钮可以显示文字或者图片来传达这些按钮的目的。你可以将一个函数或者方法附在按钮上，当你点击按钮的时候，调用。

语法：
```bash
w = Button(master,option=value,...)
```
和之前的标签一样：
master 代表父窗口
option 可选的部件选项，常用的如下,我感觉这些选项其实和前面的有些类似，随便看看：
1.activebackground  按钮位于光标下方时的背景色。
2.activeforeground  按钮位于光标下方时的前景色。
3.bd  边框宽度（以像素为单位）。默认值为2。
4.bg  正常背景色。
5.command  单击按钮时要调用的函数或方法。
6.fg  普通前景（文本）颜色。
7.font  用于按钮标签的文本字体。
8.height  按钮的高度，以文本行（用于文本按钮）或像素（用于图像）表示。
9.highlightcolor  当窗口小部件具有焦点时，焦点的颜色突出显示。
10.image  要在按钮上显示的图像（而不是文本）。
11.justify  如何显示多行文本：LEFT左对齐每行；CENTER将它们居中；或RIGHT右对齐。
12.padx  文本左侧和右侧的其他填充。
13.pady  文本上方和下方的其他填充。
14.relief  指定边框的类型。其中一些值为SUNKEN，RAISED，GROOVE和RIDGE。
15.state  将此选项设置为DISABLED可使按钮变灰并使它无响应。鼠标悬停在按钮上时，其值为ACTIVE。默认值为NORMAL。
16.underline  默认值为-1，表示该按钮上的文本的任何字符都不会带有下划线。如果为非负数，则相应的文本字符将带有下划线。
17.width  按钮的宽度，以字母（如果显示文本）或像素（如果显示图像）为单位。
18.wraplength  如果将此值设置为正数，则文本行将被包装以适合此长度。

方法：
1.flash()  使按钮在活动颜色和正常颜色之间闪烁几次。使按钮保持原来的状态。如果该按钮被禁用，忽视这个函数。
2.invoke()  调用按钮的回调，并返回该函数返回的内容。如果按钮被禁用或没有回调，则无效。

那么试一试：
```bash
#test1.py
from tkinter import *
import tkinter.messagebox as msg

window = Tk()
window.title("helloGUI")
window.geometry('1068x681+10+10')
#建立窗口，设置标题，窗口初始大小

label_text = StringVar()
label_text.set('Hello the GUI')
#label = Label(window,text='Hello the GUI')
label = Label(window,textvariable = label_text)
#建立标签label

def click_button():
    #label.config(text = 'Yes')
    label_text.set('Yes')
    msg.showinfo('Hello Button','Hello')

button = Button(window,text='click it',command = click_button)

label.pack()
button.pack()
#几何控制，控制部件的位置

window.mainloop()
#进入主事件循环

```

上面有两种修改text的方法，一种是用textvariable来修改，另一种是用config()来修改
然后，我还是用了messagebox函数来输出，这个将会在之后进行补充。

我们已经初步使用了按钮和标签，那么我们就可以建立一个计算器了。
```bash
#test2.py
from tkinter import *
import tkinter.messagebox as msg

window = Tk()
window.title("Calculator")
window.geometry('1068x681+10+10')
#建立窗口，设置标题，窗口初始大小

label_text = StringVar()
label_text.set('Hello The Calculator')
in_put = ''
str_num = '0'
pre_num = 0
number = 0
pre_ope= 0
label = Label(window,textvariable = label_text)
#建立标签label

def deal(dat):
    global in_put,str_num
    in_put += dat
    label_text.set(in_put)
    if dat.isdigit():
        str_num += dat
    else:
        global number,pre_num,pre_ope
        number = int(str_num)
        msg.showinfo('str_num',str_num)
        msg.showinfo('number',str(number))
        msg.showinfo('pre_num',str(pre_num))
        str_num = '0'
        if dat == '=':
            in_put = ''
            if pre_ope == 1:
                number += pre_num
                pre_number = number
            msg.showinfo('Answer',number)
        elif dat == '+':
            pre_num = number
            number = 0
            pre_ope = 1
#建立数据处理函数

def click_1():
    tmp='1'
    deal(tmp)
def click_add():
    tmp='+'
    deal(tmp)
def click_equ():
    tmp='='
    deal(tmp)
#建立按键函数

button_1 = Button(window,text='1',command = click_1)
button_add = Button(window,text='+',command = click_add)
button_equ = Button(window,text='=',command = click_equ)
#建立按钮

label.pack()
button_1.pack()
button_add.pack()
button_equ.pack()
#几何控制，控制部件的位置

window.mainloop()
#进入主事件循环

```
上面的程序中，只有1和+和=三个按钮，但是已经可以进行运算过程。过程中通过showinfo来显示中间变量。

但是，如果要完成一个完整的计算器就太复杂了。




