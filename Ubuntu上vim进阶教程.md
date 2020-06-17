---
title: Ubuntu上vim进阶教程
date: 2020-01-02 14:21:18
tags:
- vim
- ubuntu
---
# 0 为什么写这篇教程
最近迷上了makefile，然后，自己使用的是vim编辑器，但是在组织工程的时候发现一个问题，不知道自己该如何来通过vim来控制自己的工程。

之前的vim的操作是一些基础部分，不足以实现。所以这个是一个补充。

我希望通过这个来更好的控制vim编辑器，至少当我在被子里写程序的时候，不会要找鼠标之类的。

希望将vim能够当作IDE来使用。

# 1 vim配置文件
```bash
vim --version
``` 
输入上面的命令之后，可以看到
```bash
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
      user exrc file: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
  fall-back for $VIM: "/usr/share/vim"

```
.vimrc就是控制vim行为的配置文件，通过编辑这个文件可以修改vim的各个方面，包括外观，操作方式，快捷键，插件来使它适合自己。

当然，没有进行配置的vim的确丑。

我有一个仓库，里面就是关于vim的配置。

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
