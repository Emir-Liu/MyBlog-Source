---
title: Ubuntu上的C语言socket服务器教程
date: 2019-10-20 20:26:26
tags:
- ubuntu
- socket
- c/c++
---

# 0 简介
socket服务器的运行方式：
1.打开socket
2.绑定到一个地址和端口
3.监听传入的连接
4.接受连接
5.读/发送数据

# 1.将socket绑定到端口
根据前面socket客户端可以知道建立socket，绑定将socket与地址和端口组合，需要一个类似于connect的sockaddr_in结构。
```bash
int socket_desc;
struct sockaddr_in server;
	
//Create socket
socket_desc = socket(AF_INET , SOCK_STREAM , 0);
if (socket_desc == -1)
{
	printf("Could not create socket\n");
}
	
//Prepare the sockaddr_in structure
server.sin_family = AF_INET;
server.sin_addr.s_addr = INADDR_ANY;
server.sin_port = htons( 8888 );
	
//Bind
if( bind(socket_desc,(struct sockaddr *)&amp;server , sizeof(server)) &lt; 0)
{
	puts("bind failed\n");
}
puts("bind done\n");
```
绑定完成后，应该用socket连接了，将socket绑定到特定的ip和端口号，确认接受到，传入数据。
不能将两个socket绑定到同一个端口。

# 2 监听连接

将socket切换到listen模式
```bash
listen(socket_desc,3);
```

# 3 接受连接
## 3.1 接受连接不回复
```bash
#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>

int main(int argc , char *argv[])
{
	int socket_desc , new_socket , c;
	struct sockaddr_in server , client;
	
	//Create socket
	socket_desc = socket(AF_INET , SOCK_STREAM , 0);
	if (socket_desc == -1)
	{
		printf("Could not create socket");
	}
	
	//Prepare the sockaddr_in structure
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons( 8888 );
	
	//Bind
	if( bind(socket_desc,(struct sockaddr *)&server , sizeof(server)) < 0)
	{
		puts("bind failed\n");
	}
	puts("bind done\n");
	
	//Listen
	listen(socket_desc , 3);
	
	//Accept and incoming connection
	puts("Waiting for incoming connections...");
	c = sizeof(struct sockaddr_in);
	new_socket = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c);
	if (new_socket<0)
	{
		puts("accept failed\n");
	}
	
	puts("Connection accepted");

	return 0;
}

```

运行该程序，然后通过telnet程序连接本地的8888端口
```bash
telnet localhost 8888
```

获取连接的客户端的IP地址
```bash
char *client_ip = inet_ntoa(client.sin_addr);
int client_port = ntohs(client.sin_port);

```

## 3.2 回复客户端：
```bash

#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>

int main(int argc , char *argv[])
{
  int socket_desc , new_socket , c;
  struct sockaddr_in server , client;
	char *message;

  //Create socket
  socket_desc = socket(AF_INET , SOCK_STREAM , 0);
  if (socket_desc == -1)
  {
    printf("Could not create socket");
  }
  
  //Prepare the sockaddr_in structure
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = INADDR_ANY;
  server.sin_port = htons( 8888 );

	//Bind
	if( bind(socket_desc,(struct sockaddr *)&amp;server , sizeof(server)) < 0)
	{
		puts("bind failed");
		return 1;
	}
	puts("bind done");
	
	//Listen
	listen(socket_desc , 3);
	
	//Accept and incoming connection
	puts("Waiting for incoming connections...");
	c = sizeof(struct sockaddr_in);
	new_socket = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c);
	if (new_socket<0)
	{
		perror("accept failed");
		return 1;
	}
	
	puts("Connection accepted");
	
	//Reply to the client
	message = "Hello Client , I have received your connection. But I have to go now, bye\n";
	write(new_socket , message , strlen(message));
	
	return 0;
}

```
## 3.3 保持服务器
在客户端连接到服务器之后立即关闭，为了保持服务器不间断运行，将accept置于循环之中，可以一直接受传入的连接。将服务器的程序修改为：

```bash
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>

int main(int argc , char *argv[])
{
  int socket_desc , new_socket , c;
  struct sockaddr_in server , client;
  char *message;

  //Create socket
  socket_desc = socket(AF_INET , SOCK_STREAM , 0);
  if (socket_desc == -1)
  {
    printf("Could not create socket");
  }
  //Prepare the sockaddr_in structure
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = INADDR_ANY;
  server.sin_port = htons( 8888 );

  //Bind
  if( bind(socket_desc,(struct sockaddr *)&server , sizeof(server)) < 0)
  {
    puts("bind failed");
    return 1;
  }
  puts("bind done");

  //Listen
  listen(socket_desc , 3);
  //Accept and incoming connection
  puts("Waiting for incoming connections...");
  c = sizeof(struct sockaddr_in);
  while( new_socket = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c) )
	{
  	puts("Connection accepted");

  	//Reply to the client
  	message = "Hello Client , I have received your connection. But I have to go now, bye\n";
  	write(new_socket , message , strlen(message));
		if(new_socket < 0)
		{
			printf("accept failed");
		}
	}
  return 0;
}

```
## 3.4 通过线程来处理多客户端连接

为了处理每个连接，需要单独的处理代码与服务器一起运行。通过线程来实现。
主服务器接受一个连接并且创建一个新的线程来处理该连接的通信，然后服务器返回接受更多的连接。

在Linux,可以使用pthread(posix线程)库完成线程,关于线程的教程在补充中。
```bash
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <pthread.h>
#include <stdlib.h>

void *connect_server(void *);

int main(int argc , char *argv[])
{
  int socket_desc , new_socket , c,*new_sock;
  struct sockaddr_in server , client;
  char *message;

  //Create socket
  socket_desc = socket(AF_INET , SOCK_STREAM , 0);
  if (socket_desc == -1)
  {
    printf("Could not create socket");
  }

  //Prepare the sockaddr_in structure
  server.sin_family = AF_INET;
  server.sin_addr.s_addr = INADDR_ANY;
  server.sin_port = htons( 5555 );

  //Bind
  if(bind(socket_desc,(struct sockaddr *)&server , sizeof(server)) < 0)
  {
    puts("bind failed");
    return 1;
  }
  puts("bind done");

  //Listen
  listen(socket_desc , 3);

  //Accept and incoming connection
  puts("Waiting for incoming connections...");
  c = sizeof(struct sockaddr_in);

  while(new_socket=accept(socket_desc,(struct sockaddr *)&client, (socklen_t*)&c))
  {
    puts("Connection accepted");

    //Reply to the client
    message = "Hello Client , I have received your connection.\n";
    write(new_socket , message , strlen(message));

    pthread_t sniffer_thread;
    new_sock = malloc(1);
    *new_sock = new_socket;

    if(pthread_create(&sniffer_thread,NULL,connect_server,(void*)new_sock) > 0)
    {
      printf("could not create thread");
      return 1;
    }
    puts("handler assignment");
    if(new_socket < 0)
    {
      printf("accept failed");
      return 1;
    }
  }	
  return 0;
}

void *connect_server(void *socket_desc)
{
	int sock = *(int *)socket_desc;
	int read_size;
	char *message,client_message[2000];
	message = "Greetings!I am your connection handler\n";
	write(sock,message,strlen(message));

	message = "It is my duty to communicate with you\n";
	write(sock,message,strlen(message));
	
	while( (read_size = recv(sock,client_message,2000,0) ) > 0 )
	{
		if( strcmp(client_message,"exit") == 0)
		{
			fflush(stdout);
			break;
			
		}
		write(sock,client_message,strlen(client_message));
	}

	if(read_size == 0)
	{
		puts("client disconnect");
		fflush(stdout);
	}
	else if(read_size == -1)
	{
		puts("recv failed");
	}

	return 0;
}
```
