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
import urllib
//一个收集了多个涉及URL的模块，具体的内容在下面补充
url = "https://raw.githubusercontent.com/GokuMohandas/practicalAI/master/data/titanic.csv"
//感觉这个部分已经找不到了，有点可惜
response = urllib.request.urlopen(url)
html = response.read()
with open('titanic.csv', 'wb') as f:
    f.write(html)
```

