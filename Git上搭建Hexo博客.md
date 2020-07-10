---
title: Git上搭建Hexo博客
date: 2019-08-19 11:20:56
tags: 
- hexo
- git
- ubuntu
---
## 概述
Git上提供免费的空间，可以构建静态网页，从而避免了各种平台上的限制，同时，为了方便管理，使用Hexo一个快速方便的博客框架，可以很容易的搭建博客。
Hexo是一款基于Node.js的静态博客框架，依赖少易于安装使用,Hexo的安装只需要npm来控制。

环境：
Ubuntu18

下面本文的结构
安装Git,Hexo(需要Node.js和npm)
建立Git远程库
配置Hexo
建立本地库

## 安装必要环境
### Git
sudo apt install git
### Hexo（听说下载安装过程中会卡住，选择科学上网即可，或者切换源）
#### 安装Node.js和npm
```bash
sudo apt-get install nodejs
sudo apt-get install npm
```
#### 检查是否安装成功
```bash
nodejs -v
npm -v
```
返回版本号
#### 安装Hexo

```bash
mkdir hexo			//创建目录
cd hexo				//进入目录
sudo npm install -g hexo-cli	//安装Hexo
hexo init			//初始化
```
安装插件
```bash
npm install hexo-generator-index --save
npm install hexo-generator-archive --save
npm install hexo-generator-category --save
npm install hexo-generator-tag --save
npm install hexo-server --save
npm install hexo-deployer-git --save	//注意，这个插件用于将博客上传到git上。
npm install hexo-deployer-heroku --save
npm install hexo-deployer-rsync --save
npm install hexo-deployer-openshift --save
npm install hexo-renderer-marked --save
npm install hexo-renderer-stylus --save
npm install hexo-generator-feed --save
npm install hexo-generator-sitemap --save
npm install hexo-asset-image --save //用于在文章中添加图片
```
测试
```bash
hexo server
```
返回网址http://0.0.0.0:4000，进入可以显示

## Git创建
### 建立github远程仓库
注册Git账号
新建Repositories(注意！用于建立博客的仓库的名字为xxx.github.io，xxx为账户名，每个账户只能有一个)
点击Settings，在GitHub Pages中选择Choose a theme，选择博客的主题，然后GitHub Pages下面会提示Your site is published at http://xxx.github.io/
进入网址中，这就是你的初始博客了。

同时，我们可以生成SSH添加到GitHub，这样我们可以避免在电脑上将文件上传到库的时候需要输入账户名和密码

```bash
git config --global user.name "xnamex"
git config --global user.email "xemailx"
```
xnamex:GitHub用户名
xemailx:GitHub邮箱

```bash
ssh -keygen -t rsa -C "xemailx"
```
生成.ssh文件，id_rsa:私人密钥，id_rsa.pub:公共密钥

### 配置Hexo

进入博客的目录hexo,修改_config.yml文件
```bash
vim _config.yml
```
修改为:
```bash
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repo: git@github.com:Emir-Liu/Emir-Liu.github.io.git
branch: master
```
上面的一段是用于和GitHub相联系。

输入:
```bash
hexo g		//生成静态页面
hexo s		//预览页面
hexo d		//部署到GitHub
```
### 建立本地库

### makefile
```bash
.PHONY: deploy

deploy:
	hexo g
	hexo d
```


下载最新版本的nodejs:
sudo npm install n -g
sudo n stable
node --version

FAQ:
1.npm : Depends: node-gyp (>= 0.10.9) but it is not going to be installed

sudo apt-get install nodejs-dev node-gyp libssl1.0-dev
sudo apt-get install npm

2.npm: Not compatible with your operating system or architecture:
更新npm的版本
```bash
sudo npm install -g npm
```

3.在博客中插入图片
之前一直没有插入图片，导致阅读总觉得缺了点什么，现在补上:
1.安装模块
```bash
npm install https://github.com/CodeFalling/hexo-asset-image --save
```
在hexo文件夹中输入上面的命令。

2.修改全局文件
然后在全局_config.yml中修改
```bash
post_asset_folder:true
```

3.使用
但使用hexo new 来新建文件的时候会出现一个博客文件和文件夹，名字相同，类似于:
```bash
.
├── test
├── test.md
```
插入图片的时候只要有:
```bash
![](test/cat.jepg)
```
