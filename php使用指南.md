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

注释PHP代码
```bash
#this is a comment
//this is the second coment
/*
this is a comment with multiline
*/
```

php对空格不敏感

php区分大小写

可以在命令提示符号中运行PHP脚本

变量：
所有变量前面有$
不必在分配之前分配变量
变量没有内部类型，事先不知道是数字或者字符串

有8种数据类型
1.整数
2.双精度
3.布尔值
4.NULL
5.字符串
6.数组
7.对象
8.资源 特殊变量，保存外部资源

布尔值true的确定：
1.数字精确的等于0为false
2.字符串为空或者字符串‘0’为false
3.NULL类型
4.数组不包含其他值，
5.不要将双精度作为布尔值

字符串：
''字符串按照字面来处理
""用变量来替代变量
\转移字符
\n
\r
\t
\$
\"
\\

$变量替换

变量范围
1.局部变量
2.功能参数
3.全局变量
4.静态变量

变量命名
1.字母或者下划线开头
2.数字字母或者下划线组成，

常量：
定义一个常数
```bash
define("CON",50);
```

常量和变量之间的区别：
1.不用在常量之前写$
2.不能够直接通过简单的赋值来定义，要通过define
3.在任意位置定义和访问常量，无需考虑作用域
4.一旦设置了无法修改

PHP为脚本提供了大量预订义常量

决策：
```bash
if(condition)
	...
else
	...

if(condition)
	...
elseif(condition)
	...
else
	...

switch(expression)
{
	case label1:
		...
		break;
	.
	.
	.

	default:
		...
}
```

循环：
```bash
for(initialization;condition;increment)
{

}

while(condition)
{

}

do
{

}
while(condition);

//遍历数组
foreach(array as value)
{

}

break或者continue
```

网络概念：
HTML页面中任何表单元素都会自动被PHP脚本所用。

```bash
<?php
   if( $_POST["name"] || $_POST["age"] ) {
      if (preg_match("/[^A-Za-z'-]/",$_POST['name'] )) {
         die ("invalid name and name should be alpha");
      }
      
      echo "Welcome ". $_POST['name']. "<br />";
      echo "You are ". $_POST['age']. " years old.";
      
      exit();
   }
?>
<html>
   <body>
   
      <form action = "<?php $_PHP_SELF ?>" method = "POST">
         Name: <input type = "text" name = "name" />
         Age: <input type = "text" name = "age" />
         <input type = "submit" />
      </form>
      
   </body>
</html>
```

有两种方式从浏览器客户端发送数据到网页服务器。
1.get方法
	1.1get方法产生一个长字符串，
	1.2仅发送最多1024个字符
	1.3敏感信息不要通过get发送
	1.4不能将二进制数据例如图像和文档发送到服务器
	1.5发送的数据可以通过query_string环境变量访问
	1.6提供了$_get关联数组，访问所有已经发送 的信息

2.post方法
	2.1post方法对数据大小没有限制
	2.2可以发送ASCII以及二进制数据
	2.3POST数据通过HTTP标头传递
	2.4提供$_POST关联数组，访问信息

$_REQUEST变量
包含$_GET，$_POST,$_COOKIE的内容


