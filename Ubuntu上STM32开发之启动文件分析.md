---
title: Ubuntu上STM32开发之文件分析
date: 2020-01-03 11:11:25
tags:
- ubuntu
- stm32
---
# 0 简介
在建立stm32f1的工程之后，通过makefile来管理所有工程，然后通过gcc-arm-none-eabi工具链编译链接，通过串口stm32flash下载，接着用minicom来进行串口通信之后，终于完成了初步的了解。

那么，这次我主要想了解一下，stm32f1工程中调用的ST官网下载的固件库的文件，里面包含了启动，链接，库函数文件的意义。

至于这个工程，可以找我的仓库。

# 1 启动文件startup_stm32f10x_md.s

这个启动文件是适合gnu编译器的启动文件，记得，之前说过，不同的编译器，需要选择不同的启动文件。
看后缀就知道这个是汇编语言的文件，但是这是ARMCPU中的汇编和之前学过的x86CPU中的汇编不太一样可以参考GNU ARM Assembler Quick Reference文件来查询。

启动文件主要的定义了：
1. 初始SP 
//_estack变量就是SP(stack point),由连接文件定义
2. 初始PC = Reset_Handler 复位中断
3. 设置中断向量表的入口和 ISR地址
//ISR就是中断服务处理 Interrupt Service Routines
4. 配置了系统时钟
5. 分支到了C库的main函数，最终调用main函数

复位后，Cortex-M3处理器进入到线程模式，优先级为Privileged,堆栈设置在了main。
//这一句不了解

```bash
.syntax unified     //说明下面的指令是ARM和THUMB通用格式
.cpu cortex-m3      //定义内核为Cortex-M3
.fpu softvfp        //定义fpu使用
.thumb              //定义汇编代码为Thumb指令集

//定义全局标签可以对外部链接程序可见， 
 .global g_pfnVectors       //该标签指向中断向量表
 .global Default_Handler    //该标签指向默认中断，为死循环
 
/*
通常情况下：
BSS(bss segment):Block Started by Symbol  通常指用来存放程序中没有初始化的全局变量的一块内存，属于静态内存分配

DATA(data segment):
通常是指用来存放程序中已经初始化的全局变量的一块内存，属于静态分配。

TEXT(sode segment):
通常是指用来存放程序执行带没的一块内存，这部分区域的打掉在程序运行之前就已经确定了，通常属于只读，但是某些架构也会允许读写，也就是修改程序。里面可能包含一些常数变量。有的地方写为CODE。

上面的三个在GNU中可以默认识别。下面程序中还有相关的介绍。

HEAP:
用于存放进程运行中被动态分配的内存段，大小不固定，可以动态增减，当进程调用malloc等函数分配内存时，新分配的内存会添加到堆上，当调用free等函数释放内存时，就会从堆中剔除。

STACK:
栈，有称之为堆栈，是用户存放程序临时创建的局部变量，也就是函数{}中定义的变量，但是不包括static申明的变量，static申明的变量在数据段中存储。同时，函数被调用时候，参数也会进入发起调用的进程栈中，调用结束之后，函数的返回值，也会存放在栈中，因为先进先出的特点，特别方便用来保存，回复调用现场。可以将它看作一个寄存，交换临时数据的内存区。
*/

/*label: .word value 将4字节的value放在由连接器分配的label地址上 */
 .word   _sidata    //.data部分 初始化的数值 启动地址
 .word   _sdata     //.data部分 在链接脚本定义的 启动地址
 .word   _edata     //.data部分 在链接脚本定义的 结束地址
 .word   _sbss      //.bss部分 在链接脚本定义的 启动地址
 .word   _ebss      //.bss部分 在链接脚本定义的 结束地址
 
/*.equ <symbol name>, <value>直接对标签赋值类(似于armasm中的EQU)*/ 
 .equ  BootRAM, 0xF108F85F

/*
这是处理器在复位后首次开始执行时调用的代码，仅执行必要的设置，然后调用应用程序提供的main函数。
.section <section_name> {,”<flags>”} 
开始一个新的代码或者数据区域。 之前说过的三个区域有默认的标志，并且三个区域名称是连接器所默认的
下面是一些区域的标志指示
<Flag> Meaning
 a allowable section
 w writable section
 x executable section
*/

     .section    .text.Reset_Handler
/*.weak是弱申明，为了将来可以重映射之类的，和printf重映射类似,将来可以重新定义函数的内容*/
     .weak   Reset_Handler
     .type   Reset_Handler, %function
 Reset_Handler:  //将Reset_Handler复位中断放在程序的开始确定CP
 
/*下面这部分的含义是将flash中的数据段复制到SRAM中 */
   movs  r1, #0 //将立即数0赋值给r1寄存器
/*arm CPU中的b指令和x86 CPU中的jmp指令类似。branch，无条件分支*/
   b LoopCopyDataInit   //程序转移到LoopCopyDataInit处
 
 CopyDataInit:
     ldr r3, =_sidata   //从存储器中将_sidata加载到寄存器r3中
     ldr r3, [r3, r1]   //从地址r3+r1处读取一个字（32bit）到r3中  r3为基地址，r1为偏移地址
     str r3, [r0, r1]   //把寄存器r3的值存储到存储器中地址为r0+r1地址处
     adds    r1, r1, #4 //r1+4
 
 LoopCopyDataInit:      //循环拷贝数据
/*
LDR (immediate offset)
Load with immediate offset, pre-indexed immediate offset, or post-indexed immediate offset.
*/
     ldr r0, =_sdata    //DATA起始地址
     ldr r3, =_edata    //r3给出尾地址
/*
adds,如果算术指令的最后有s，就代表n,z,c,v符号位也会立即更新
n == 0 (Negative)结果不是负数
z == 1 (Zero)结果是0
c == 1 (Carry)有进位
v == 0 (Overflow)溢出
*/     
     adds    r2, r0, r1 //r2=r0+r1
/*cmp r1,r2 ：r1-r2,然后根据运算结果更新标志位*/    
     cmp r2, r3         //r2和r3比较，地址还在data段
/*Branch if C is Clear当没有借位的时候跳转到下面*/
     bcc CopyDataInit
     ldr r2, =_sbss     //从存储器中将_sbss加载到寄存器r2中
     b   LoopFillZerobss//循环置位bss段
 /* Zero fill the bss segment. */
 FillZerobss:
     movs    r3, #0
     str r3, [r2], #4
 
 LoopFillZerobss:
     ldr r3, = _ebss    //从存储器中将_ebss加载到寄存器r3中
     cmp r2, r3         //同上
     bcc FillZerobss
/*
bl 有返回的跳转，
在跳转到子程序之前，将下一条指令的地址拷贝到LR链接寄存器(R14)
由于BL指令保存了下条指令的地址，
所以可以使用MOV PC LR来实现子程序的返回。
*/
 /* Call the clock system intitialization function.*/
     bl  SystemInit
 /* Call static constructors */
     bl __libc_init_array
 /* Call the application's entry point.*/
     bl  main
/*
bc lr类似于
mov pc ,lr
跳转到lr(链接寄存器)也就是返回地址
*/
     bx  lr
 .size   Reset_Handler, .-Reset_Handler

    .section    .text.Default_Handler,"ax",%progbits
 Default_Handler://这就是上面说的默认中断，是一个死循环
 Infinite_Loop:
     b   Infinite_Loop
     .size   Default_Handler, .-Default_Handler
 /******************************************************************************
 *
 * The minimal vector table for a Cortex M3.  Note that the proper constructs
 * must be placed on this to ensure that it ends up at physical address
 * 0x0000.0000.
 *
 ******************************************************************************/
     .section    .isr_vector,"a",%progbits
     .type   g_pfnVectors, %object
     .size   g_pfnVectors, .-g_pfnVectors
g_pfnVectors://这就是上面说的中断向量表
     .word   _estack
     .word   Reset_Handler
     .word   NMI_Handler
     .word   HardFault_Handler
     .word   MemManage_Handler
     .word   BusFault_Handler
     .word   UsageFault_Handler
     .word   0
     .word   0
     .word   0
     .word   0
     .word   SVC_Handler
     .word   DebugMon_Handler
     .word   0
     .word   PendSV_Handler
     .word   SysTick_Handler
     .word   WWDG_IRQHandler
     .word   PVD_IRQHandler
     .word   TAMPER_IRQHandler
     .word   RTC_IRQHandler
     .word   FLASH_IRQHandler
     .word   RCC_IRQHandler
     .word   EXTI0_IRQHandler
     .word   EXTI1_IRQHandler
     .word   EXTI2_IRQHandler
     .word   EXTI3_IRQHandler
     .word   EXTI4_IRQHandler
     .word   DMA1_Channel1_IRQHandler
     .word   DMA1_Channel2_IRQHandler
     .word   DMA1_Channel3_IRQHandler
     .word   DMA1_Channel4_IRQHandler
     .word   DMA1_Channel5_IRQHandler
     .word   DMA1_Channel6_IRQHandler
     .word   DMA1_Channel7_IRQHandler
     .word   ADC1_2_IRQHandler
     .word   USB_HP_CAN1_TX_IRQHandler
     .word   USB_LP_CAN1_RX0_IRQHandler
     .word   CAN1_RX1_IRQHandler
     .word   CAN1_SCE_IRQHandler
     .word   EXTI9_5_IRQHandler
     .word   TIM1_BRK_IRQHandler
     .word   TIM1_UP_IRQHandler
     .word   TIM1_TRG_COM_IRQHandler
     .word   TIM1_CC_IRQHandler
     .word   TIM2_IRQHandler
     .word   TIM3_IRQHandler
     .word   TIM4_IRQHandler
     .word   I2C1_EV_IRQHandler
     .word   I2C1_ER_IRQHandler
     .word   I2C2_EV_IRQHandler
     .word   I2C2_ER_IRQHandler
     .word   SPI1_IRQHandler
     .word   SPI2_IRQHandler
     .word   USART1_IRQHandler
     .word   USART2_IRQHandler
     .word   USART3_IRQHandler
     .word   EXTI15_10_IRQHandler
     .word   RTCAlarm_IRQHandler
     .word   USBWakeUp_IRQHandler
   .word 0
     .word   0
     .word   0
     .word   0
     .word   0
     .word   0
     .word   0
     .word   BootRAM       //0x108. This is for boot in RAM mode 
   /*
   下面的都是对中断函数进行弱申明
   在工程中会在stm32f10x_it文件中重新申明
   */
   .weak NMI_Handler
     .thumb_set NMI_Handler,Default_Handler
 
   .weak HardFault_Handler
     .thumb_set HardFault_Handler,Default_Handler
 
   .weak MemManage_Handler
     .thumb_set MemManage_Handler,Default_Handler
 
   .weak BusFault_Handler
     .thumb_set BusFault_Handler,Default_Handler
 
     .weak   UsageFault_Handler
     .thumb_set UsageFault_Handler,Default_Handler
 
     .weak   SVC_Handler
     .thumb_set SVC_Handler,Default_Handler
 
     .weak   DebugMon_Handler
     .thumb_set DebugMon_Handler,Default_Handler
 
     .weak   PendSV_Handler
     .thumb_set PendSV_Handler,Default_Handler
 
     .weak   SysTick_Handler
     .thumb_set SysTick_Handler,Default_Handler
 
     .weak   WWDG_IRQHandler
     .thumb_set WWDG_IRQHandler,Default_Handler
 
     .weak   TAMPER_IRQHandler
     .thumb_set TAMPER_IRQHandler,Default_Handler
 
     .weak   RTC_IRQHandler
     .thumb_set RTC_IRQHandler,Default_Handler
 
     .weak   FLASH_IRQHandler
     .thumb_set FLASH_IRQHandler,Default_Handler
 
     .weak   RCC_IRQHandler
     .thumb_set RCC_IRQHandler,Default_Handler
 
     .weak   EXTI0_IRQHandler
     .thumb_set EXTI0_IRQHandler,Default_Handler
 
     .weak   EXTI1_IRQHandler
     .thumb_set EXTI1_IRQHandler,Default_Handler
 
     .weak   EXTI2_IRQHandler
     .thumb_set EXTI2_IRQHandler,Default_Handler
 
     .weak   EXTI3_IRQHandler
     .thumb_set EXTI3_IRQHandler,Default_Handler
 
     .weak   EXTI4_IRQHandler
     .thumb_set EXTI4_IRQHandler,Default_Handler
 
     .weak   DMA1_Channel1_IRQHandler
     .thumb_set DMA1_Channel1_IRQHandler,Default_Handler
 
     .weak   DMA1_Channel2_IRQHandler
     .thumb_set DMA1_Channel2_IRQHandler,Default_Handler
    .weak   DMA1_Channel3_IRQHandler
     .thumb_set DMA1_Channel3_IRQHandler,Default_Handler
 
     .weak   DMA1_Channel4_IRQHandler
     .thumb_set DMA1_Channel4_IRQHandler,Default_Handler
 
     .weak   DMA1_Channel5_IRQHandler
     .thumb_set DMA1_Channel5_IRQHandler,Default_Handler
 
     .weak   DMA1_Channel6_IRQHandler
     .thumb_set DMA1_Channel6_IRQHandler,Default_Handler
 
     .weak   DMA1_Channel7_IRQHandler
     .thumb_set DMA1_Channel7_IRQHandler,Default_Handler
 
     .weak   ADC1_2_IRQHandler
     .thumb_set ADC1_2_IRQHandler,Default_Handler
 
     .weak   USB_HP_CAN1_TX_IRQHandler
     .thumb_set USB_HP_CAN1_TX_IRQHandler,Default_Handler
 
     .weak   USB_LP_CAN1_RX0_IRQHandler
     .thumb_set USB_LP_CAN1_RX0_IRQHandler,Default_Handler
 
     .weak   CAN1_RX1_IRQHandler
     .thumb_set CAN1_RX1_IRQHandler,Default_Handler
 
     .weak   CAN1_SCE_IRQHandler
     .thumb_set CAN1_SCE_IRQHandler,Default_Handler
     .weak   EXTI9_5_IRQHandler
     .thumb_set EXTI9_5_IRQHandler,Default_Handler
 
     .weak   TIM1_BRK_IRQHandler
     .thumb_set TIM1_BRK_IRQHandler,Default_Handler
 
     .weak   TIM1_UP_IRQHandler
     .thumb_set TIM1_UP_IRQHandler,Default_Handler
 
     .weak   TIM1_TRG_COM_IRQHandler
     .thumb_set TIM1_TRG_COM_IRQHandler,Default_Handler
 
     .weak   TIM1_CC_IRQHandler
     .thumb_set TIM1_CC_IRQHandler,Default_Handler
 
     .weak   TIM2_IRQHandler
     .thumb_set TIM2_IRQHandler,Default_Handler
 
     .weak   TIM3_IRQHandler
     .thumb_set TIM3_IRQHandler,Default_Handler
 
     .weak   TIM4_IRQHandler
     .thumb_set TIM4_IRQHandler,Default_Handler
 
     .weak   I2C1_EV_IRQHandler
     .thumb_set I2C1_EV_IRQHandler,Default_Handler
 
     .weak   I2C1_ER_IRQHandler
     .thumb_set I2C1_ER_IRQHandler,Default_Handler
     .weak   SPI1_IRQHandler
     .thumb_set SPI1_IRQHandler,Default_Handler
 
     .weak   SPI2_IRQHandler
     .thumb_set SPI2_IRQHandler,Default_Handler
 
     .weak   USART1_IRQHandler
     .thumb_set USART1_IRQHandler,Default_Handler
 
     .weak   USART2_IRQHandler
     .thumb_set USART2_IRQHandler,Default_Handler
 
     .weak   USART3_IRQHandler
     .thumb_set USART3_IRQHandler,Default_Handler
 
     .weak   EXTI15_10_IRQHandler
     .thumb_set EXTI15_10_IRQHandler,Default_Handler
 
     .weak   RTCAlarm_IRQHandler
     .thumb_set RTCAlarm_IRQHandler,Default_Handler
 
     .weak   USBWakeUp_IRQHandler
     .thumb_set USBWakeUp_IRQHandler,Default_Handler

```
好了上面写的很复杂，主要是有一些必要的知识点补充，可以看原本没有注释的文件，就能够看懂这个启动文件的内容了。

下面是启动流程：
首先，STM32上电通过BOOT0和BOOT1两个引脚连接高低电平来确定启动初始地址在哪里，STM32启动位置有三种：

1.Main Flash memory 
是STM32内置的Flash，一般我们使用JTAG或者SWD模式下载程序时，就是下载到这个里面，重启后也直接从这启动程序。

2.System memory 
从系统存储器启动，这种模式启动的程序功能是由厂家设置的。一般来说，这种启动方式用的比较少。

3.Embedded Memory 
内置SRAM，既然是SRAM，自然也就没有程序存储的能力了，这个模式一般用于程序调试。

