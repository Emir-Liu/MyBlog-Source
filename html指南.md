---
title: html/css指南
date: 2019-09-24 15:29:27
tags: html/css
---
来源：W3school(CSS参考手册)https://www.w3school.com.cn/cssref/index.asp
# 1.HTML
## 1.1class(类)
```bash
.class-name{ ...  ;}	//命名一个class
class = "class-name"	//调用一个class
```
## 1.2id
```bash
#id-name{ ... ;}			//命名一个id
id = "id-name"				//调用一个id
```
## 1.3class与id对比
	在一个html网页页面中可以无数次调用相同的class类；
	而同样的id在页面里只能出现一次
## 1.2注释
```bash
<!-- comment  -->
```

## 1.3如何插入小图标
```bash
<link rel="shortcut icon" sizes="16*16 24*24 48*48 64*64" href="favicon.ico">
```
### 1.3.1图片的引用
1.绝对路径
/../xx.png
2.相对路径
xx.png
3.子路径
images/xx.png
4.父路径
../xx.png

## 1.4导航条
```bash
<nav>//导航栏
<ul>//无序列表,ol为有序列表
<li>Emir Liu</li>//列表中的元素
<li>Blog </li>
<li>Resume</li>
</ul>
</nav>
//或者
<nav>
<ul>
<li> </li>
</ul>
</nav>
```
### 1.4.1超链接
<a hreb="/blog">Blog</a>
<a hreb="/" >Emir Liu</a>

### 1.4.2导航排列方式
display: inline-block
排列在一行

:hover
当鼠标悬浮在某个格式上面的时候，则

cursor: pointer 鼠标变为手指

## 2.属性

### 2.1 position属性
1、static：
	static是所有元素的默认属性，也就是可以理解为正常的文档流
2、relative:
	relative是相对于自己文档的位置来定位的，对旁边的元素没有影响
3、absolute：
	absolute是相对于父标签来进行定位的，如果没有父标签或者父标签是static，那么sorry，刚烈的absolute会相对于文档定位（不同于fixed相对于浏览器定位）
4、fixed；
	牛逼的fixed，是相对于浏览器窗口来定位的。不会因为滚动条滚动，牛了一笔。（但是平常卵用不多，我自己的吐槽）

# 2.CSS
## 2.1如何插入一个CSS样式表
### 2.1.1外部样式表
```bash
<head>
<link rel="stylesheet" type="text/css" href="css-filename.css">
</head>
//在每个页面上通过link连接到样式表
```
### 2.1.2内部样式表
```bash
<head>
<style type="text/css">
	body{ ... ;}
	.class-name{ ... ;}
	#id-name{ ... ;}
</style>
</head>
```
### 2.1.3内联样式(不建议使用)
```bash
<p style="color: sienna; margin-left: 20px">
	This is a paragraph
</p>
```
### 2.1.4多重样式表
	加入某个属性在不同的样式表中被同样的选择器定义，属性值将从范围小的样式表中被继承下来。例如外部样式表和内部样式表中都定义了一个属性，则继承内部样式表。

## 1.基础语法
```bash
selector{property: value}
```
### 2.1类型选择器
```bash
h1{
	color:#36cfff;
}
```
### 2.2通用选择器
* {
	 color:#36cfff;
}
### 2.3后代选择器
```bash
ul em {
   color: #000000; 
}//仅当样式规则位于特定元素内时，才希望将其应用于特定元素。如以下示例所示，样式规则仅在<em>元素位于<ul>标记内时才适用。
```
### 2.4类选择器
```bash
.black {
   color: #000000; 
}文档中class属性设置为black的每个元素，此规则均将其内容呈现为黑色。
h1.black {
   color: #000000; 
}//将class属性设置为black的 <h1>元素呈现为黑色。
```
### 2.5id选择器
```bash
#black {
   color: #000000; 
}文档中id属性设置为black的每个元素，此规则均将其内容呈现为黑色。
```

# FAQ:
## 页面加载过程中显示加载界面，加载完毕隐藏加载界面：https://blog.csdn.net/SL_World/article/details/89109050
