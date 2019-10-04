---
title: Git使用指南
date: 2019-08-19 13:08:25
tags: git
---
# 目录

# Git创建本地项目，并推送到远程Git仓库
# 1.建立本地项目
```bash
git init
```
它可以创建一个全新的空仓库，或者将已经存在的项目纳入版本管理。同时，系统自动创建唯一的分支master，自动创建.git目录（默认是隐藏状态），这个默认隐藏的目录.git就是版本库（Repository），而当前目录下，除.git以外都是工作区，也就是我们修改文件的地方。版本库中内容很多，并且都很重要，有两个是我们实际操作中经常要遇到的，那就是暂存区（也可以称之为stage或者index）和分支，HEAD是一个指针，指向当前所在的分支（master）。
将文件最终提交到版本库基本流程如下：
（1）.git add命令将工作区未跟踪和修改文件提交到暂存区。
（2）.git commit命令将暂存区内容提交到当前版本。暂存区就如同一个临时性仓库，可以将来自工作区的新文件或者修改文件暂时存放起来，然后统一提交到分支。


1.在远端建立库
进入GitHub,登陆后，创建新的库，保存库的.ssh地址
2.在本地建立库
	1.在工程文件夹，或新的目标文件夹下,输入
```bash
git init
```

```bash
git statues	//查看本地库的状态
```

```bash
git add file-name	//将文件添加到暂存区
git add .		//将所有已改或新建的文件添加到暂存区
git rm --cached file-name//将文件从暂存区移除
git rm -r file-name		//将文件从本地的版本库中删除
git commit -m "xxx"//将暂存区的文件添加到本地仓库 -m代表提交信息
git commit -am "xxx"//将add和commit合二为一
```

```bash
git log	//查看提交日志
```

```bash
git remote add origin ....git//加入远端仓库
git push -u origin branck-name//将本地仓库发送到远端仓库的master分支
```

# 分支
```bash
git branch branch-name	//建立一个新的分支
git branch							
//查看当前的本地分支，可以通过颜色确认当前所在的分支
git branch -a
//看到本地和远程分支
git checkout branch-name//切换到分支
git checkout -b branch-name	
//git branch branch-name和git checkout branch-name的合并
```

# 2.Submodule
```bash
git submodule add submodule_url 
//添加子项目
//出现.gitmodules文件，配置文件

git submodule init
//初始化本地.gitmodules文件
git submodule update
//同步远端submodule源码

```
