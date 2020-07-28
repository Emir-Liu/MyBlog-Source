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
