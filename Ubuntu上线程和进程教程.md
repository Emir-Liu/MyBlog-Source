---
title: Ubuntu上线程和进程教程
date: 2019-10-20 22:12:19
tags:
- ubuntu
- 线程
- 进程 
---

# 0.简介
一个进程可以具有多个异步执行的线程。异步执行使每个线程能够独立处理特定的工作或者服务，因此一个进程中运行的多个线程处理服务，构成了进程的完整的功能。
线程(thread):
线程通常作为调度程序所处理的最小处理单元。
进程(process):

为什么一个进程中需要多个线程，而不是只有一个主线程：

在一个进程中，存在实时输入，并且与每个输入相对应，产生一定的输出。
如果进程不是多线程，那么进程的处理则为同步，将接受输入，进行处理，产生输出。
局限性在于：该进程只有在完成的较早输入的处理后才会接受输入，在处理输入的时间长于预期的情况下，接受其它输入的操作将被搁置。

在socket服务器上，处理输入，处理,输出到socket客户端。
如果，任何输入时，服务器花费的时间超过了预期的时间，同时，另一个输入到达了socket服务器，那么服务器无法接受新的输入连接，卡在了处理旧的输入连接。
因此需要线程来实现异步执行。

进程与线程的差异：
1。进程不共享地址空间，而在统一进程下的线程共享地址空间。
2。进程是彼此独立执行的，进程之间的同步通过内核负责，另一方面，线程的同步必须由进程负责。
3。与进程的切换相比，线程的切换更快
4。两个进程的交互只能够通过标准的进程间通信来实现，而统一进程下执行的线程可以轻松地进行通信，因为共享大多数资源，例如内存，文本等。

用户线程和内核线程

线程可以存在于用户空间和内核空间中。

# 2 采用POSIX线程(pthread)库：
POSIX线程库是用于C / C ++的基于标准的线程API。它允许产生新的并发进程。可以更好的执行文件。

## 2.1 线程基础
线程操作包括创建，终止，同步（连接，阻塞），调度，数据管理和进程交互。

线程不维护已经创建线程的列表，也不知道创建该线程的线程。

进程的所有线程有共同的地址空间

一个进程的线程共享：
	说明
	数据
	文件
	信号和信号处理程序
	当前工作目录
	用户和组ID

每个线程都有唯一的
	线程ID
	寄存器集和堆栈指针
	堆栈局部变量，返回地址
	信号屏蔽
	优先
	返回值：errno
	
## 3.2线程创建和终止
需要头文件pthread.h

```bash
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void *func_print(void *ptr);

int main()
{
	pthread_t thread1,thread2;
	const char *message1 = "thread 1";
	const char *message2 = "thread 2";
	int iret1,iret2;
	iret1 = pthread_create(&thread1,NULL,func_print,(void*)message1);
	if(iret1)
	{
		printf("Error_pthread create return code : %d\n",iret1);
		exit(EXIT_FAILURE);
	}

	iret2 = pthread_create(&thread2,NULL,func_print,(void*)message2);
	
	if(iret2)
	{
		printf("Error_pthread create return code : %d\n",iret2);
		exit(EXIT_FAILURE);
	}
	printf("pthread_create() for thread 1 returns: %d\n",iret1);
	printf("pthread_create() for thread 2 returns: %d\n",iret2);

	pthread_join( thread1, NULL);
	pthread_join( thread2, NULL);
	exit(EXIT_SUCCESS);
}


void *func_print(void *ptr)
{
	char *message;
	message = (char *)ptr;
	printf("%s \n",message);
}
```

现在GNU编译器具有命令行选项"-pthread"，在早期的版本中使用"-lpthread"显式指定了pthread库。
```bash
gcc pthread.c -lpthread
```
该程序的输出结果不同，有以下的一些输出：
```bash
pthread_create() for thread 1 returns: 0
pthread_create() for thread 2 returns: 0
thread 1 
thread 2
```

```bash
thread 1 
pthread_create() for thread 1 returns: 0
pthread_create() for thread 2 returns: 0
thread 2 
```
等各种情况。

对上面的程序中引用的函数进行分析：
创建新的线程
```bash

    int pthread_create(pthread_t * thread, 
                       const pthread_attr_t * attr,
                       void * (*start_routine)(void *), 
                       void *arg);
```
其中：
	thread	返回线程ID。（在bits / pthreadtypes.h中定义的无符号long int）
	attr		如果使用默认线程属性，则设置为NULL。（在bits / pthreadtypes.h中定义的struct pthread_attr_t结构的其他定义成员）属性包括：
	分离状态（可联接吗？默认值：PTHREAD_CREATE_JOINABLE。其他选项：PTHREAD_CREATE_DETACHED）
	调度策略（实时？PTHREAD_INHERIT_SCHED，PTHREAD_EXPLICIT_SCHED，SCHED_OTHER）
	调度参数
		Inheritsched属性（默认值：PTHREAD_EXPLICIT_SCHED从父线程继承：PTHREAD_INHERIT_SCHED）
		作用域（内核线程：PTHREAD_SCOPE_SYSTEM用户线程：PTHREAD_SCOPE_PROCESS请选择一个或另一个，不要同时选择两者。）
	防护尺寸
		堆栈地址（请参见unistd.h和bits / posix_opt.h _POSIX_THREAD_ATTR_STACKADDR）
		堆栈大小（在pthread.h中设置的默认最小PTHREAD_STACK_SIZE），
	void *（* start_routine） -指向要线程化的函数的指针。函数只有一个参数：指向void的指针。
	* arg-指向函数参数的指针。要传递多个参数，请发送指向结构的指针。

等待另一个线程的停止

终止调用线程



## 3.3线程同步
## 3.4线程调度
## 3.5线程陷阱
## 3.6线程调试
## 3.7线程手册



