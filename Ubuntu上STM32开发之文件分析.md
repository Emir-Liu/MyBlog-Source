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
1. 初始SP //
2. 初始PC = Reset_Handler 复位中断
3. 设置中断向量表的入口和 ISR地址
//ISR就是中断服务处理 Interrupt Service Routines
4. 配置了系统时钟
5. 分支到了C库的main函数，最终调用main函数

复位后，Cortex-M3处理器进入到线程模式，优先级为Privileged,堆栈设置在了main。
//这一句不了解

```bash
/*
.syntax unified说明下面的指令是ARM和THUMB通用格式

*/
   .syntax unified
     .cpu cortex-m3
     .fpu softvfp
     .thumb
//定义全局标签可以对外部链接程序可见， 
 .global g_pfnVectors //该标签指向中断向量表
 .global Default_Handler //该标签指向默认中断，为死循环
 
/*
通常情况下：
BSS(bss segment):Block Started by Symbol  通常指用来存放程序中没有初始化的全局变量的一块内存，属于静态内存分配

DATA(data segment):
通常是指用来存放程序中已经初始化的全局变量的一块内存，属于静态分配。

CODE,TEXT(sode segment):
通常是指用来存放程序执行带没的一块内存，这部分区域的打掉在程序运行之前就已经确定了，通常属于只读，但是某些架构也会允许读写，也就是修改程序。里面可能包含一些常数变量。

上面的三个在GNU中可以默认识别。下面程序中还有相关的介绍。

HEAP:
用于存放进程运行中被动态分配的内存段，大小不固定，可以动态增减，当进程调用malloc等函数分配内存时，新分配的内存会添加到堆上，当调用free等函数释放内存时，就会从堆中剔除。

STACK:
栈，有称之为堆栈，是用户存放程序临时创建的局部变量，也就是函数{}中定义的变量，但是不包括static申明的变量，static申明的变量在数据段中存储。同时，函数被调用时候，参数也会进入发起调用的进程栈中，调用结束之后，函数的返回值，也会存放在栈中，因为先进先出的特点，特别方便用来保存，回复调用现场。可以将它看作一个寄存，交换临时数据的内存区。
*/

/*
label: .word value 将4字节的value放在由连接器分配的label地址上 
*/
 .word   _sidata    //.data部分 初始化的数值 启动地址
 .word   _sdata     //.data部分 在链接脚本定义的 启动地址
 .word   _edata     //.data部分 在链接脚本定义的 结束地址
 .word   _sbss      //.bss部分 在链接脚本定义的 启动地址
 .word   _ebss      //.bss部分 在链接脚本定义的 结束地址
 
/*
.equ <symbol name>, <value>直接对标签赋值类(似于armasm中的EQU)
*/ 
 .equ  BootRAM, 0xF108F85F

/*
这是处理器在复位后首次开始执行时调用的代码，仅执行必要的设置，然后调用应用程序提供的main函数。
*/
/*
 .section <section_name> {,”<flags>”} 
 开始一个新的代码或者数据区域。 
 GNU中区域有
.text, a code section, 
.data, an initialized data section,
.bss, an uninitialized data section. 

These sections have default flags, and the linker understands the default names (similar directive to the armasm directive AREA). 

The following are allowable .section flags for ELF format files:

<Flag> Meaning
 a allowable section
 w writable section
 x executable section

 .text.Reset_Handler这个有点奇怪，有两个不太理解
*/

     .section    .text.Reset_Handler
/*
.weak是弱申明，为了将来可以重映射之类的，和printf重映射类似,将来可以重新定义函数的内容
*/
     .weak   Reset_Handler
     .type   Reset_Handler, %function
 Reset_Handler:  
 
/* Copy the data segment initializers from flash to SRAM */
   movs  r1, #0 //将立即数0赋值给r1寄存器
/*
arm CPU中的b指令和x86 CPU中的jmp指令类似。branch，无条件分支
*/
   b LoopCopyDataInit   //程序转移到LoopCopyDataInit处
 
 CopyDataInit://从FLASH中拷贝地址在sdata和edata之间的代码到SRAM中
     ldr r3, =_sidata//从存储器中将_sidata加载到寄存器r3中
     ldr r3, [r3, r1]//从地址r3+r1处读取一个字（32bit）到r3中  r3为基地址，r1为偏移地址
     str r3, [r0, r1]//把寄存器r3的值存储到存储器中地址为r0+r1地址处
     adds    r1, r1, #4//r1+4
 
 LoopCopyDataInit://循环拷贝数据
/*
LDR (immediate offset)
Load with immediate offset, pre-indexed immediate offset, or post-indexed immediate offset.
*/
     ldr r0, =_sdata//DATA起始地址
     ldr r3, =_edata//r3给出尾地址
/*
adds,如果算术指令的最后有s，就代表n,z,c,v符号位也会立即更新
n == 0 (Negative)结果不是负数
z == 1 (Zero)结果是0
c == 1 (Carry)有进位
v == 0 (Overflow)溢出
*/     
     adds    r2, r0, r1//r2为物理地址，r1为偏移地址，r0为基地址
/*
cmp r1,r2
r1-r2,然后根据运算结果更新标志位
*/    
     cmp r2, r3//r2和r3比较，地址还在data段
/*
Branch if C is Clear当没有借位的时候跳转到下面
*/
     bcc CopyDataInit
     ldr r2, =_sbss
     b   LoopFillZerobss
 /* Zero fill the bss segment. */
 FillZerobss:
     movs    r3, #0
     str r3, [r2], #4
 
 LoopFillZerobss:
     ldr r3, = _ebss
     cmp r2, r3
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
     bx  lr
 .size   Reset_Handler, .-Reset_Handler

```

