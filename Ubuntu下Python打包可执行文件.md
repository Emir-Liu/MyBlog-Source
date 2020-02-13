---
title: Ubuntu下Python打包可执行文件
date: 2020-02-13 19:57:04
tags:
- ubuntu
- python
---

# 0.简介
在Ubuntu下，通过pyinstaller将python程序打包为可执行文件。

# 1.操作

## 1.1 环境配置
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
