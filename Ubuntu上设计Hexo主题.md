---
title: Ubuntu上设计Hexo主题
date: 2019-10-15 15:19:56
tags:
- Ubuntu
- Hexo
---

# 0 Hexo Theme
用多了hexo的默认主题，打算自己写一个Hexo主题，感觉很方便。
主要在theme文件夹中。
hexo文档格式:
```bash
├── _config.yml       // 总体的配置文件
├── node_modules      // NodeJs 所依赖的包，后期也可以自己添加插件
├── package-lock.json // 支持 hexo 运行的 NodeJs 包
├── package.json      // 自定义的 NodeJs 包
├── scaffolds         // Hexo Markdown 加载时的关键字，如data,title等,它会在启动的时候默认加载
├── source            // md 源文件目录
└── themes            // 主题文件夹
    └── landscape     // 默认主题       
```
我们编写 md 文档放在 『source』文件夹中，在运行『hexo generate』的时候，会根据『source』目录中的 md 文件自动生成一组 『html』格式的静态文件组，会在wiki目录下新建一个 『public』目录，存放在其中。

在『_config.yml』中，可以看到配置的默认主题『theme: landscape』,所对应的是 themes 目录下的 landscape 目录。

将theme:后面的内容修改为自己写的主题：lym.

在『themes』目录下，新建一个自己的主题『lym』，并且新建一些可以支持运行的文件与目录，按照如下目录格式创建，里面可以不写东西，下面写有注释的，就是我新建的文件。

```bash
├── _config.yml                 
├── node_modules                
├── package-lock.json        
├── package.json                
├── scaffolds                        
├── source                            
└── themes                            
    ├── landscape
    └── lym                // 自建的主题目录
        ├── _config.yml     // 主题配置文件
        ├── layout          // 主要构造 html 的模板
        │   ├── index.ejs   // 主页模板
        │   ├── layout.ejs  // 布局模板
        │   └── post.ejs    // md 编译成 html 后的文件模板
        └── source          // 静态资源文件目录
            ├── css         // css 样式目录
            └── js          // JavaScript 脚本目录
```

# 1.EJS标签

EJS(Effective JavaScript)是一套简单的模板语言，帮你利用普通的 JavaScript 代码生成 HTML 页面。

```bash
<% '脚本' 标签，用于流程控制，无输出。
<%_ 删除其前面的空格符
<%= 输出数据到模板（输出是转义 HTML 标签）
<%- 输出非转义的数据到模板
<%# 注释标签，不执行、不输出内容
<%% 输出字符串 '<%'
%> 一般结束标签
-%> 删除紧随其后的换行符
_%> 将结束标签后面的空格符删除
<%- include("index.ejs") %>	引入其他模板
```

```bash
    <% 
        var test = "基本上，就用这两组标签，其他的也用不上。";
    %>
    <%- test %>
```

# 2.Hexo变量
```bash
site								总体变量，几乎都是从这里开始的
site.posts					所有文章
site.posts[0].path	文章路径，带日期的
site.posts[0].slug	文章路径，根据项目文件夹的路径来的
site.posts[0]._id		文章的唯一 id，后面会用于 active 对比
site.posts[0].title	文章的标题
site.posts[0].date	文章的时间
page.date						在直接访问文章路径下，文章的时间
page.title					在直接访问文章路径下，文章的标题
page._id						在直接访问文章路径下，文章的的唯一 id，后面会用于 active 对比
page.content				引入对应文章的正文
config.xxx					总体配置文件的引用 _config.yml
theme.xxx						主题配置文件 theme._config.yml
<%- body %>					同时引入 post.ejs 和 index.ejs
<%- css(path,...)%>	引入 css 文件
<%- js(path,...) %>	引入 js 文件
```
