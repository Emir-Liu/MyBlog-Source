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
