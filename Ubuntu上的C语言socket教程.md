---
title: Ubuntu上的C语言socket教程
date: 2019-10-12 21:35:29
tags: 
- socket
- C/C++
---
# 0.简介
socket时网络中2个主机之间进行任何类型的网络通信的虚拟口，任何网络通信都是通过套接字来进行。
按照功能分为：
socket客户端：连接到远程系统来获取数据的应用程序
socket服务器：使用socket接受传入连接，并提供数据的应用程序。

# 1 建立socket客户端
其中包含以下的内容：
1.创建一个socket
2.连接到远程服务器
3.发送数据
4.接受数据
5.关闭socket
在本部分中，我们编写socket客户端，www.baidu.com作为socket服务器。
更具体的说：
www.baidu.com是http服务器,网络浏览器是http客户端。

# 1.1 创建一个socket
```bash

#include <stdio.h>
#include <sys/socket.h>

int main()
{
	int socket_desc;
	socket_desc = socket(AF_INET,SOCK_STREAM,0);
	
	if(socket_desc == -1)
	{
		printf("could not create socket");
	}
	return 0;
}

```
socket函数创建了一个socket，并且返回了一个socket描述符，可以在其他的函数中别使用，socket函数具体有以下的属性：
```bash
int socket(int domain,int type,int protocol)
int domain: AF_UNIX（本机通信），AF_INET（TCP/IP-IPv4）,AF_INET6（TCP/IP-IPv6）
int type: SOCK_STREAM(TCP),SOCK_DGRAM(UDP),SOCK_RAW
int protocol =0确定套接字需要的协议簇和类型
返回值：成功返回套接字，失败返回-1，错误代码写入“errno”
```

# 1.2将socket连接到服务器
通过socket连接到远程服务器,需要ip地址和端口号进行连接

## 1.2.1 创建sockaddr_in结构
```bash
struct sockaddr_in server;
```
sockaddr_in 结构如下面：
```bash
// IPv4 AF_INET sockets:
struct sockaddr_in {
    short            sin_family;   // e.g. AF_INET, AF_INET6
    unsigned short   sin_port;     // e.g. htons(3490)
    struct in_addr   sin_addr;     // see struct in_addr, below
    char             sin_zero[8];  // zero this if you want to
};

struct in_addr {
    unsigned long s_addr;          // load with inet_pton()
};

struct sockaddr { 
    unsigned short sa_family; //地址族，AF_xxx 
    char sa_data [14]; // 14个字节的协议地址
};
```
函数inet_addr是将ip地址转换为长格式的函数：
```bash
server.sin_addr.s_addr = inet_addr("183.232.231.172");
```
这里时baidu的ip地址。下面有如何找出给定域名的ip地址。

## 1.2.2 连接
“连接”的概念适用于SOCK_STREAM / TCP类型的套接字。连接是指可靠的数据“流”，以便可以有多个这样的流，每个流具有自己的通信。可以将其视为不受其他数据干扰的管道。

其他套接字，例如UDP，ICMP，ARP都没有“连接”的概念。这些是基于非连接的通信。这意味着您一直在发送或接收来自任何人和每个人的数据包。

```bash
#include<stdio.h>
#include<sys/socket.h>
#include<arpa/inet.h>	//inet_addr

int main(int argc , char *argv[])
{
	int socket_desc;
	struct sockaddr_in server;
	
	//Create socket
	socket_desc = socket(AF_INET , SOCK_STREAM , 0);
	if (socket_desc == -1)
	{
		printf("Could not create socket");
	}
		
	server.sin_addr.s_addr = inet_addr("183.232.231.172");
	server.sin_family = AF_INET;
	server.sin_port = htons( 80 );

	//Connect to remote server
	if (connect(socket_desc , (struct sockaddr *)&server , sizeof(server)) < 0)
	{
		puts("connect error");
		return 1;
	}
	
	puts("Connected");
	return 0;
}
```

# 1.3 通过socket发送数据
通过send函数发送数据。
```bash
#include<stdio.h>
#include<string.h>	//strlen
#include<sys/socket.h>
#include<arpa/inet.h>	//inet_addr

int main(int argc , char *argv[])
{
	int socket_desc;
	struct sockaddr_in server;
	char *message;
	
	//Create socket
	socket_desc = socket(AF_INET , SOCK_STREAM , 0);
	if (socket_desc == -1)
	{
		printf("Could not create socket");
	}
		
	server.sin_addr.s_addr = inet_addr("183.232.231.172");
	server.sin_family = AF_INET;
	server.sin_port = htons( 80 );

	//Connect to remote server
	if (connect(socket_desc , (struct sockaddr *)&server , sizeof(server)) < 0)
	{
		puts("connect error");
		return 1;
	}
	
	puts("Connected\n");
	
	//Send some data
	message = "GET / HTTP/1.1\r\n\r\n";
	if( send(socket_desc , message , strlen(message) , 0) < 0)
	{
		puts("Send failed");
		return 1;
	}
	puts("Data Send\n");
	
	return 0;
}
```
备注：也可以通过write来将数据发送到socket

# 1.4 通过socket接受数据
函数recv用于在socket上接受数据,
```bash
#include<stdio.h>
#include<string.h>	//strlen
#include<sys/socket.h>
#include<arpa/inet.h>	//inet_addr

int main(int argc , char *argv[])
{
	int socket_desc;
	struct sockaddr_in server;
	char *message , server_reply[2000];
	
	//Create socket
	socket_desc = socket(AF_INET , SOCK_STREAM , 0);
	if (socket_desc == -1)
	{
		printf("Could not create socket");
	}
		
	server.sin_addr.s_addr = inet_addr("183.232.231.172");
	server.sin_family = AF_INET;
	server.sin_port = htons( 80 );

	//Connect to remote server
	if (connect(socket_desc , (struct sockaddr *)&server , sizeof(server)) < 0)
	{
		puts("connect error");
		return 1;
	}
	
	puts("Connected\n");
	
	//Send some data
	message = "GET / HTTP/1.1\r\n\r\n";
	if( send(socket_desc , message , strlen(message) , 0) < 0)
	{
		puts("Send failed");
		return 1;
	}
	puts("Data Send\n");
	
	//Receive a reply from the server
	if( recv(socket_desc, server_reply , 2000 , 0) < 0)
	{
		puts("recv failed");
	}
	puts("Reply received\n");
	puts(server_reply);
	
	return 0;
}
```
baidu返回了html。

备注：我们也可以通过read读取socket的数据。

# 1.5 关闭socket
用close函数,需要unistd.h头文件

```bash
close(socket_desc);
```

以上，socket客户端已经基本完成。

# 1.6 补充：获取主机的IP地址
连接到到远程主机，需要IP地址。用gethostbyname函数，域名作为参数，返回hostent类型的结构。
```bash
/* 单个主机的数据库描述*/
struct hostent
{
  char *h_name;			/* 主机的正式名称*/
  char **h_aliases;		/* 别名列表*/
  int h_addrtype;		/* 主机地址类型*/
  int h_length;			/* 地址的长度*/
  char **h_addr_list;		/* 服务器的地址列表*/
};
```
在 h_addr_list中有IP地址。通过以下的代码来使用：
```bash
#include <stdio.h> //printf
#include <string.h> //strcpy
#include <sys/socket.h>
#include <netdb.h> //hostent
#include <arpa/inet.h>

int main(int argc , char *argv[])
{
  char *hostname = "www.baidu.com";
  char ip[100];
  struct hostent *he;
  struct in_addr **addr_list;
  int i;

  if ( (he = gethostbyname( hostname ) ) == NULL)
  {
    //gethostbyname failed
    herror("gethostbyname");
    return 1;
  }
  
  //Cast the h_addr_list to in_addr , since h_addr_list also has the ip address in long format only
  addr_list = (struct in_addr **) he->h_addr_list;

  for(i = 0; addr_list[i] != NULL; i++)
  {
    //Return the first one;
    strcpy(ip , inet_ntoa(*addr_list[i]) );
  }

  printf("%s resolved to : %s\n", hostname , ip);
  return 0;
}

```


