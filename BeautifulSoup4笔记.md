---
title: BeautifulSoup4笔记
date: 2020-10-02 16:25:52
tags:
- python
- beautifulsoup
---

# 0.概述
参考文档:
https://www.crummy.com/software/BeautifulSoup/bs4/doc.zh/

Beautiful Soup 是一个可以从HTML或XML文件中提取数据的Python库。
```bash
pip install beautifulsoup4
//安装

from bs4 import BeautifulSoup
//加载模块
```

Beautiful Soup将复杂HTML文档转换成一个复杂的树形结构,每个节点都是Python对象,所有对象可以归纳为4种:Tag,NavigableString,BeautifulSoup,Comment.

其中的正则表达式re模块需要参考下面的文档:
https://docs.python.org/zh-cn/3/howto/regex.html#regex-howto
