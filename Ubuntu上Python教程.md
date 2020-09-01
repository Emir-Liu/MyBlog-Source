---
title: Ubuntu上Python教程
date: 2020-02-15 18:42:26
tags:
- ubuntu
- python
---
# Python中常见的括号(),[],{}的区别：
Python中的这三种数据类型有不同的作用，分别代表不同的Python基本内置数据类型。

## 1 () tuple元组数据类型
元组是一种不可变序列，
```bash
>>> tup = (1,2,3)
>>> tup
(1, 2, 3)
>>> ()
()
>>> 55,
(55,)
```

## 2 []列表数据类型
列表是一种可变序列，
```bash
>>> list('Python')
['P', 'y', 't', 'h', 'o', 'n']
>>> list('ABC')
['A', 'B', 'C']
>>> list(['ABC'])
['ABC']
```

## 3 {}字典数据类型
字典是Python中唯一内建的映射类型
```bash
>>> dic = {'jon':'boy','lili':'girl'}
>>> dic
{'jon': 'boy', 'lili': 'girl'}
```

# Python下载第三方模块，下载速度慢，如何换源
'''
mkdir ~/.pip
vim ~/.pip/pip.conf
'''

'''
[global]
index-url = http://pypi.douban.com/simple
[install]
use-mirrors =true
mirrors =http://pypi.douban.com/simple/
trusted-host =pypi.douban.com
'''

# 不变数据类型和可变数据类型

可变数据类型：value值改变，id值不变；
不变数据类型：value值改变，id值也改变。

分辨方式:在改变value值的同时，使用id()函数来查看变量id值是否发生变化。

不变 整型 浮点型 字符串 元组
可变 列表 字典

不变和可变数据类型对运算结果的影响：

不变
```bash
a = 1
b = a
b += 1

print(a)
print(b)
```
Ans
```bash
1
2
```

可变
```bash
a = {'name':'jack'}
b = a
b['age'] = 27

print(a)
print(b)
```
Ans
```bash
{'name':'jack','age':27}
{'name':'jack','age':27}
```
简而言之，对于不可变数据类型，当多个名称包含的内容都是相同的，当改变一个之后，其他的不变，改变的指向另外的地址。
对于可变的数据类型，当多个内容相同，改变一个之后，所有指向的地址不变，但是内容改变了。

# 打包可执行文件
通过pyinstaller将python程序打包为可执行文件。

pyinstaller,distribute分别是打包所需要的通过pip3来安装
```bash
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple distribute

pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pyinstaller
```
注意，有时候会遇到问题，当执行打包好的文件时，
```bash
no module named 'pkg_resources.py2_warn'
//这个可以通过下面的方法来解决
pip uninstall setuptools
pip install setuptools==44.0.0
//这是将setuptools进行降级处理，可能会出现有些功能无法使用的问题
```
还有一个解决方法记录一下：
1.先用pyinstaller -D(F) xxx.py生成一下(不一定能正常运行)
2.(关键)经过第一步之后，目录下有个.spec文件，用记事本打开，里面有个hiddenimports，在这条里面加上pkg_resources.py2_warn
```bash
hiddenimports=['pkg_resources.py2_warm']
```
3.再次用pyinstaller,注意这时候输入的命令是pyinstaller -D(F) xxx.spec
4.经过步骤2就可以解决这个问题，若仍然提示no module named XXXXX ,则再次写入到hiddenimports
5.需要经过几次调试，建议先用-D处理没问题之后再-F。

# Python中关键词

## __name__
__name__是python的一个内置类属性，它存储模块的名称。
python的模块既可以被调用，也可以独立运行。而被调用时__name__存储的是py文件名(模块名称)，独立运行时存储的是"__main__"。
那么它的作用主要就是用来区分，当前模块是独立运行还是被调用。

具体应用
当我们建立一个模块的时候，我们会在该模块最后输出调试信息，进行调试，调试之后，会在其他地方导入这个模块，但是，我们在调用这个模块的时候不希望产生调试信息，所以我们就需要区分这个模块是独立运行还是被调用，被调用的情况下就不输出调试信息。

例如:
```bash
if __name__ == '__main__':
    ...
```
