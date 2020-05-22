---
title: Ubuntu上人工智能学习0
date: 2020-05-21 13:17:37
tags:
- ubuntu
- ai
---
# 0.简介
导师是人工智能方向的，刚忙完一些事情，打算开始做点基础知识的准备，主要是从practicalAI项目学习，一些地方自己顺便做一个补充。

# 1.Notebooks
Jupyter_Notebooks是一款开源的网络应用，我们可以将其用于创建和共享代码与文档。

其提供了一个环境，你无需离开这个环境，就可以在其中编写你的代码、运行代码、查看输出、可视化数据并查看结果。因此，这是一款可执行端到端的数据科学工作流程的便捷工具，其中包括数据清理、统计建模、构建和训练机器学习模型、可视化数据等等。

当你还处于原型开发阶段时，Jupyter_Notebooks的作用更是引人注目。这是因为你的代码是按独立单元的形式编写的，而且这些单元是独立执行的。这让用户可以测试一个项目中的特定代码块，而无需从项目开始处执行代码。很多其它IDE环境（比如RStudio）也有其它几种方式能做到这一点，但我个人觉得Jupyter的单个单元结构是最好的。

正如你将在本文中看到的那样，这些笔记本非常灵活，能为数据科学家提供强大的交互能力和工具。它们甚至允许你运行Python之外的其它语言，比如R、SQL等。因为它们比单纯的IDE平台更具交互性，所以它们被广泛用于以更具教学性的方式展示代码。

这个感觉不是太重要，暂时掠过，看不出有什么特别的作用。

# 2.Python
编程语言，额，之前接触过，用的时候再说。

# 3.NumPy
Python中的一个模块，用于数组的快速计算，在opencv中经常用到。

# 4.Pandas
Python中的数据库，来看一看。
学习使用Python Pandas库进行数据分析。
## 4.1下载数据
从公共链接中下载titanic数据集。
```bash
import urllib.request
#一个收集了多个涉及URL的模块，具体的内容在下面补充
url = "https://raw.githubusercontent.com/GokuMohandas/practicalAI/master/data/titanic.csv"
#这个部分无法正常访问。这是github上的部分文件的存储部分，应该可以直接访问，下载资源的。简而言之，就是被域名污染了。解决方法，下面补充。
response = urllib.request.urlopen(url)
html = response.read()
with open('titanic.csv', 'wb') as f:
    f.write(html)
```
从python3的手册可以看出，urllib.request是用于打开URL的可扩展库。
注意，这里和Python2相比有不同，2中直接是urllib。需要区分。
而且不要把两个手册弄混。

其实，这部分主要是熟悉Python，可以直接用一个可以访问的网站实验一下，我的仓库中有整个项目，可以将整个项目下载，之后继续。
域名去污：
1.查询真实IP
通过IPAddress.com首页,输入raw.githubusercontent.com查询到真实IP地址。

2.修改hosts
CentOS及macOS直接在终端输入

sudo vi /etc/hosts
用以下的格式来写就可以了
```bash
199.232.4.133 raw.githubusercontent.com
```

```bash
!ls -l
# 检查数据是否已经下载成功
# 我有必要说一下，这个指令非常的有趣，显示内容很详细。
```

## 4.2 加载数据
有了数据之后，我们将数据加载到Pandas数据帧中。补充，Pandas是一个很好的Python数据分析库。
```bash
import pandas as pd

#从CSV中读取到Pandas DataFrame
df = pd.read_csv("titanic.csv",header=0)
#输出前5项数据
df.head()
```
上面的程序建议通过ipython来观察输出。

## 4.3 探索
pandas有很多的功能，但是，有一个问题，我总是把Python2和Python3混在一起，感觉他们之间有区别但是没有完全理解。

绘制直方图：
```bash
 import pandas as pd
 import matplotlib.pyplot as plt 
 df = pd.read_csv("titanic.csv",header=0)
 
 print(df.head())
 
 print(df.describe())
 
 df["age"].plot.hist()
 
 plt.show()
```
话说，自己经常使用Python3，却还是混起来了。之后，关于这个的我会补充。下面是线性回归，逻辑回归之类的问题。
