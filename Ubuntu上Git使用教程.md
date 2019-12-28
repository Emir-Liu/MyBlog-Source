---
title: Ubuntu上Git使用教程
date: 2019-10-14 11:47:03
tags:
- ubuntu
- git
---

# 1 获取Git仓库

## 1.1 从工作目录中初始化新仓库

### 1.1.1 初始化
```bash
git init
```
初始化后会出现一个.git目录，所有git所需要的数据和资源都在这个目录中。

### 1.1.2 进行版本控制
```bash
git add *.c
git add README
git commit -m 'initial project version'
```
add命令开始跟踪，
commit命令开始提交

## 1.2 从现有的仓库中克隆
将项目的git仓库复制出来
```bash
git clone git://xxx [file-name]
```

# 2 文件管理
## 2.1 文件状态：
未跟踪：
没有上次更新时的快照，也不早当前的暂存区域。
当文件未被跟踪，git不会自动将其纳入跟踪范围，所以不用担心将临时文件归入版本管理。

已跟踪：
代表文件本来就被纳入了版本控制管理的文件，在上次快照中有记录。
已跟踪文件的状态有：未修改，已修改和已放入暂存区。

状态转化：
刚克隆某个仓库，所有文件都是已跟踪文件，状态为未修改。
编辑文件后，文件状态变为已修改。
将已修改的文件放到暂存区。
最后一次性提交暂存区的文件。

状态转化图：
```bash
untracked(未跟踪) |						tracked(已跟踪)
untracked					| unmodified(未修改) | modified(已修改)	| staged(暂存区)
		       	--------------------add file-------------------->     	    	
                                                    --add file->
                                 --edit file->	    --stage file->
		       	<-remove file--				<-----------commit------------
```
检查当前文件状态：
```bash
git status
```

### 2.1.1跟踪新的文件：
```bash
git add README
```
当add未跟踪的文件，文件会变为已经被跟踪，而且进入了暂存状态。

### 2.1.2暂存已修改的文件
```bash
git add xxx
```
当文件已经跟踪，但是没有暂存，会将文件进入暂存状态。

### 2.1.3 忽略某些文件
一些文件不需要纳入文件管理，也不希望总是出现在未跟踪文件列表中。可以创建一个.gitignore文件，列出需要忽略的文件模式。
```bash
# commitments
*.a
!lib.a#除了xxx
/TODO #忽略TODO文件
build/ #忽略build目录下的所有文件
```

格式规范：
1。空行或者#都会被忽略
2。glob模式匹配
3。匹配模式最后/说明忽略目录
4。忽略指定模式以外的文件或者目录，可以加！

glob模式：shell使用的简化的正则表达式
1. * 匹配零个或多个任意字符
2. [abc] 匹配任何一个列在方括号中的字符
如果方括号中使用短划线分隔两个字符，例如[0-9]
3. (?) 只匹配一个任意字符 

### 2.1.4 查看已暂存和未暂存的更新


```bash
git status
git diff
```

### 2.1.5 提交更新
在提交之前，查看文件的状态，是否已经暂存，然后提交。
```bash

git commit -m "xxx"
```

### 2.1.6 跳过暂存区域提交
通过暂存区域可以准备提交的细节，可以跳过暂存区域。
```bash
git commit -a
```
git自动把所有已经跟踪过的文件暂存起来一起提交，跳过了add步骤。

### 2.1.7 移除文件
从git中移除某个文件，需要将其从已跟踪清单中移除，也就是从暂存区移除。
```bash
git rm
```
从跟踪区域中移除，顺便会在工作目录中删除指定的文件。
如果删除之前已经修改过而且已经放到暂存区，必须使用-f。

如果，希望从git仓库即暂存区中移除，但是仍然希望保留在当前的工作目录中，
```bash
git rm --cached xxx
```

### 2.1.8 移动文件
```bash
git mv file_from file_to
```

## 2.2 查看提交历史
```bash
git log
-p -2
//展开显示每次提交的内容差异。-2表示仅显示最近的两次更新

-stat
//显示简要的更改行数统计
```

## 2.3 撤销操作

### 2.3.1 修改最后一次提交
```bash
git commit --amend 
//撤销刚才的提交操作
//使用当前的暂存区提交快照
//如果刚才的提交完没有任何改动，直接运行此命令，可以重新编辑提交说明。
//如果忘记暂存修改，补上暂存操作，然后再修改提交
```

### 2.3.2 取消已经暂存的文件
```bash
git reset HEAD <file>
```
将修改过后提交到暂存区的文件，撤销暂存，返回已修改但未暂存的状态

### 2.3.3 取消对文件的修改
```bash
git checkout -- <file-name>
```
取消修改，回到修改之前的版本

任何已经提交到git的都可以被恢复，

# 3 远程仓库
```bash
git remote [-v]
//-v verbose显示对应的克隆地址
```
列出每个远程库的简短名字。克隆完某个项目后，至少可以看到一个名为origin的远程库，git默认使用这个明治来标识你所克隆的原始仓库。

## 3.1 添加远程仓库
```bash
git remote add [short-name] [url]
//添加一个新的远程仓库，可以指定一个简单的名字，以便将来引用
```

## 3.2 从远程库抓取数据
```bash
git fetch [short-name]
```
fetch只是将远端的数据拉取到本地仓库。并不会自动合并到当前的工作分支。

还可以用git pull自动抓取数据，
然后将远端分支自动合并到本地仓库的当前分支。

## 3.3 推送数据到远程仓库
```bash
git push [remote-name] [branch-name]
```
只有在所克隆的服务器上有写权限，或者同一时刻没有其他人推数据，这条命令才可以完成。
如果在推送数据之前，别人推送了，必须先将更新抓取到本地，合并到自己的项目中，才能够再次推送。

## 3.4 查看远程仓库的信息
```bash
git remote show [remote-name]
```


## 4 打标签
```bash
git tag
//列出已有标签
git tag -l 'v1.4.2.*'
//特定搜索模式搜索标签
git tag -a v1.4 -m "my sersion 1.4"
//添加标签annotated
```

如果拥有私钥可以通过GPG来签署标签
这个有什么用处呢？
```bash
git tag -s v1.5 -m "my signed 1.5 tag"
```

通过git show可以显示GPG签名

后期加标签
```bash
git log --pretty=online
//显示之前的操作

git tag -a v1.2 9fceb02
//在打标签的时候跟上校验
```

分享标签，默认不会将标签传送到远端服务器，必须通过显式命令。

```bash
git push origin [tagname]

git push origin --tags
//将所有本地标签添加上去
```

git 快捷操作命名别名：
```bash
git config --global alias.ci commit
//输入git commit只需要git ci，用于提高效率
```

# 5 分支
任何版本控制系统都支持分支。
意味着从开发的主线上分离开，在不影响主线的同时继续工作。
在其他版本控制中，需要创建一个源代码目录的完整副本。

git可以快速切换分支与合并。

修补仓库中的程序的步骤：
1.返回到原先的分支
2.新建一个新的分支，修复问题
3.回到原先的分支进行合并，然后推送

```bash

git checkout -b new-branch
//新建并切换到new-branch分支
//以上的命令等效于
git branch new-branch
git checkout new-branch

//修改文件之后,提交文件到暂存区
giit commit -a -m'commit new-brach'

//需要修补主分支的问题
//切换到主分支
git checkout master

//创建新的修补分支
git checkout -b fix-branch

//修改文件,之后提交
git commit -a -m 'fix branch'

//修补完成后，回到主分支并且合并，然后发布
git checkout master
git merge fix-branch

//fix-branch合并后可以删掉
git branch -d fix-branch

//返回到new-branch分支，继续进行原有工作，然后提交
git checkout new-branch
//修改文件
git commit -a -m 'finish the new-branch'

//将新分支和修改分支合并
git checkout master
git merge new-branch

//删除new-branch分支
git branch -d new-branch

```
在实际情况下，会遇到冲突的分支合并
如果在不同的分支中都修改了同一个文件的同一个部分，git就无法将两者合并到一起。这时候就会产生冲突。
通过git status显示。可以选择不同分支的一个或者亲自整合到一起。
整合完成之后，运行git add可以标记为解决状态。
运行git mergetool可以调用一个可视化的合并工具解决冲突。
git commit提交文件。

分支的管理：
```bash
git branch
//显示所有分支
git branch --merged
//显示未合并分支
git branch -d [branch-name]
//删除已合并分支
git branch -D [branch-name]
//删除未合并分支
```

远程分支：
远程分支是对远程仓库的分支的索引。是无法移动的本地分支，只有在git进行网络交互的时候才会更新。
远程分支的表示方式：
远程仓库名/分支名
例如：origin/master
origin仓库的master分支

//同步远程服务器上的数据到本地
git fetch origin

submodule:
在某个仓库中有引用submodule时，clone不会下载submodule，我们需要进入工程然后
```bash
git submodule init
git submodule update
//这样就可以下载submodule了
```
