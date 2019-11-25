---
title: php使用指南
date: 2019-11-10 14:47:17
tags:
- php
- web
---
PHP允许Web开发人员可以创建动态内容与数据库交互。PHP基本上用于开发基于Web的软件应用程序。
PHP并不是在浏览器上运行，PHP是在服务器的环境中运行，你在浏览器中访问服务器上的php路径，得到的是PHP在服务器上运行之后输出的结果。

想要在浏览器上访问本地的PHP文件，则：
首先需要在本地搭建一个php的运行环境，WAMP、phpstudy、xampp都可以，安装一个。然后把php文件扔进www文件夹中，浏览器输入访问路径：http://localhost/你的文件，就可运行PHP文件显示结果了。

但是，通常我们直接在服务器上配置。
1.安装apache，开启服务，见相关博客
2.安装php
```bash
sudo apt install php7.2
```
3.编写网页检测程序/var/www/html/index.php
```bash
<?php phpinfo( ); ?>
```

HELLO WORLD
```bash
<html>
   
   <head>
      <title>Hello World</title>
   </head>
   
   <body>
      <?php echo "Hello, World!";?>
   </body>

</html>
```
如果检查以上示例的HTML输出，您会注意到从服务器发送到Web浏览器的文件中没有PHP代码。网页中存在的所有PHP均已处理并从页面中删除；从Web服务器返回给客户端的唯一内容是纯HTML输出。
所有PHP代码都必须包含在PHP解析器可识别的三个特殊标记ATE之一中。
```bash
<?php PHP code goes here ?>

<?    PHP code goes here ?>

<script language = "php"> PHP code goes here </script>
```

为了开发和运行PHP网页，需要在计算机系统上安装三个重要组件。

Web服务器 
相关资料查看博客关于Apache。

数据库 
相关资料查看博客关于MySQL数据库。

PHP解析器 
-为了处理PHP脚本指令，必须安装解析器以生成可以发送到Web浏览器的HTML输出。本教程将指导您如何在计算机上安装PHP解析器。
在继续之前，重要的是要确保您的计算机上具有正确的环境设置，以便使用PHP开发Web.
