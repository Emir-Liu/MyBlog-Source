---
title: Ubuntu上vim进阶教程
date: 2020-01-02 14:21:18
tags:
- vim
- ubuntu
---
# 0 简介
这是对我之前的博客vim操作指南的一个补充，是对于我的配置的一些讲解

我有一个仓库，里面就是关于vim的配置。之前也提到过:https://github.com/Emir-Liu/vimrc

我们看一看user vimrc file，里面有下面的内容：
```bash
 set runtimepath+=~/.vim_runtime
 
 source ~/.vim_runtime/vimrcs/basic.vim
 source ~/.vim_runtime/vimrcs/filetypes.vim
 source ~/.vim_runtime/vimrcs/plugins_config.vim
 source ~/.vim_runtime/vimrcs/extended.vim
 
 try
 source ~/.vim_runtime/my_configs.vim
 catch
 endtry

```
其中，采用了source命令，这是一个很有趣的东西，在当前的bash环境中，读取并且执行文件中的命令。

讲解一下source的来源，是从C Shell而来的，这是什么？是bash的内置命令。通常情况下，通常使用“.”来代替。
