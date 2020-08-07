---
title: anaconda教程
date: 2020-08-07 14:13:50
tags:
---
# 0.简介
Anaconda是开源的包、环境管理器，里面包含大量安装好的工具包.最主要的是能够通过它进行不同版本的python环境的安装和切换。

# 1.Anaconda环境切换及使用：

查看当前的环境
'''bash
conda info -e
python -V
'''

新建环境，选择python版本
'''bash
conda create --name torch0.3 python=3.5
其中 torch0.3是新环境的名字，python=3.5是选择的python版本
#conda create --name python32 --clone python321
#conda remove --name old_name --all 

激活切换环境
conda activate torch0.3

回到之前的环境
conda deactivate

删除一个已有的环境
conda remove --name torch0.3 --all
'''

我需要一个pytorch0.3版本，但是官网上已经没有wins下的该版本，所以直接使用anaconda官网下的链接进行下载
'''bash
conda install -c peterjc123 pytorch
'''

我们建立了新的环境，但是spyder依旧是过去的怎么版。安装新spyder，然后打开spyder
'''bash
conda install spyder
spyder
'''

# FAQ:
## 在Spyder中如何弹出窗口动态显示图片：
Tools–>Preferences–>IPython console–>Graphics–>Graphics backend–> Backend–>设置成Automatic

## 当下载超时的时候该怎么办？
当国内没有镜像的时候直接在Anaconda Cload上搜索
修改.condarc文件，切换国内源

conda config --show-sources

恢复默认源
conda config --remove-key channels

其中只有default源，我们可以通过
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
来添加镜像

显示通道地址
conda config --set show_channel_urls yes

或者直接在windows：C:\users\username\，linux：/home/username/下的.condarc文件中修改
channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/menpo/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  - defaults
ssl_verify: true


