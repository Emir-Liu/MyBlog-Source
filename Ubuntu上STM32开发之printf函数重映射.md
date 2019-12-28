---
title: Ubuntu上STM32开发之printf函数重映射
date: 2019-12-28 19:22:40
tags:
- ubuntu
- stm32
---

在之前的博客中，我在尝试使用标准输出函数printf的时候，发现没有显示。

以为自己什么时候出问题了，甚至以为自己没有成功编译下载程序。

但是，我在Windows系统下面，编译了包含printf函数的hex文件，然后，在Ubuntu环境下下载，查看串口。发现没有问题。

我才发现，是因为自己没有重定义printf的底层函数的问题。

首先发代码：
```bash
#include "stm32f10x_conf.h"
 
void uart_init(u32 bound){
  GPIO_InitTypeDef GPIO_InitStructure;
  USART_InitTypeDef USART_InitStructure;
  NVIC_InitTypeDef NVIC_InitStructure;

  RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1|RCC_APB2Periph_GPIOA, ENABLE); 

  //USART1_TX   GPIOA.9

  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9; //PA.9
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP; 
  GPIO_Init(GPIOA, &GPIO_InitStructure);

  //USART1_RX   GPIOA.10
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;//PA10
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
  GPIO_Init(GPIOA, &GPIO_InitStructure);
  //Usart1 NVIC 
   NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority=2 ;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 2;    
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;     
  NVIC_Init(&NVIC_InitStructure); 

  USART_InitStructure.USART_BaudRate = bound;
  USART_InitStructure.USART_WordLength = USART_WordLength_8b;
  USART_InitStructure.USART_StopBits = USART_StopBits_1;
  USART_InitStructure.USART_Parity = USART_Parity_No;
  USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
  USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx; 
  USART_Init(USART1, &USART_InitStructure); 
  USART_ITConfig(USART1, USART_IT_RXNE, ENABLE);
  USART_Cmd(USART1, ENABLE);                    
}
 
int _write (int fd, char *pBuffer, int size)
    {
        int i=0;
        for (i = 0; i < size; i++)
        {
            while (!(USART1->SR & USART_SR_TXE))
            {
            }
            USART_SendData(USART1, pBuffer[i]);
        }
        return size;
    }
 
int main(void)
{
	uart_init(9600);
    int i=0;
 
  while(1)
  {
       for(i=0;i<1000000;i++);
       printf("hello!\r\n");
 
  }
}

```

这里，我写了一个_write函数，因为在gcc_arm_none_eabi编译器中，printf函数是通过_write函数来实现的，我们需要将printf的输出流重映射到串口上，就需要修改这些底层的实现。

还有，在Windows环境下Keil软件中的arm编译器则采取不同的底层实现方式，所以，在不同编译器的情况下，需要重新修改函数。补充一下，在Keil的C库中，printf和scanf是通过fputc和fgetc来操作的。


还有，听说在用GNU的printf需要在最后添加\n或者使用fflush(stdout)函数。来刷新输出流。否则printf不会输出任何数据，而且会被后来的正确发送的printf数据覆盖。这是由于printf的数据流在扫描到 \n以前会被保存在缓存中，直到 \n出现或是fflush(stdout)强制刷新才会输出数据，如果我们在printf数据的末尾不加入\n或fflush(stdout)，这个printf数据就不会被发送出去，而且在新的printf语句也会重写printf的缓存内容，使得新的printf语句不会附带之前的内容一起输出，从而造成上一条错误的printf内容不显示且丢失。
