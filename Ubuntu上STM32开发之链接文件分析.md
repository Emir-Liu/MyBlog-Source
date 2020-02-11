---
title: Ubuntu上STM32开发之链接文件分析
date: 2020-01-03 18:58:26
tags:
- ubuntu
- stm32
---

# 0 简介
接着上面的启动文件的分析之后，这一篇就是关于链接文件的介绍，链接文件也就是：stm32_flash.ld。连接器需要通过链接文件来形成最后的目标文件。
链接程序脚本是提供给链接程序的脚本，用于指定内存布局并在执行固件时初始化固件所使用的各个内存段。这些脚本至关重要，因为它们指定了闪存和RAM的起始地址以及它们的大小。
```bash
/* Entry Point */
 ENTRY(Reset_Handler)
/*
指定程序的入口点，即程序中要执行的第一条指令。
*/
 /* Highest address of the user mode stack */
 _estack = 0x20005000;    /* end of 20K RAM */
/*
声明一个变量_estack，该值表示堆栈的开始。
*/

/*
HEAP 和 STACK 在前面的启动文件中有解释
*/
 _Min_Heap_Size = 0;      /* required amount of heap  */
 _Min_Stack_Size = 0x100; /* required amount of stack */
 
/*
这一部分需要根据你选择的芯片来确定。
在我之前的关于STM32下载的博客中，通过stm32flash可以看到
Interface serial_posix: 57600 8E1
Version      : 0x22
Option 1     : 0x00
Option 2     : 0x00
Device ID    : 0x0410 (STM32F10xxx Medium-density)
- RAM        : 20KiB  (512b reserved by bootloader)
- Flash      : 128KiB (size first sector: 4x1024)
- Option RAM : 16b
- System RAM : 2KiB
在下载程序的时候可以看到是下载到flash里面，下载地址从0x08000000开始。
ORIGIN 起始地址
LENGTH 大小
*/
 /* Specify the memory areas */
 MEMORY
 {
   FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 128K
   RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 20K
   MEMORY_B1 (rx)  : ORIGIN = 0x60000000, LENGTH = 0K
 }

/* Define output sections */
 SECTIONS
 {
   /* The startup code goes first into FLASH */
   .isr_vector :
   {
     . = ALIGN(4);
     KEEP(*(.isr_vector)) /* Startup code */
     . = ALIGN(4);
   } >FLASH
 
   /* The program code and other data goes into FLASH */
   .text :
   {
     . = ALIGN(4);
     *(.text)           /* .text sections (code) */
     *(.text*)          /* .text* sections (code) */
     *(.rodata)         /* .rodata sections (constants, strings, etc.  ) */
     *(.rodata*)        /* .rodata* sections (constants, strings, etc. ) */
     *(.glue_7)         /* glue arm to thumb code */
     *(.glue_7t)        /* glue thumb to arm code */
 
     KEEP (*(.init))
     KEEP (*(.fini))
 
     . = ALIGN(4);
     _etext = .;        /* define a global symbols at end of code */
   } >FLASH

    .ARM.extab   : { *(.ARM.extab* .gnu.linkonce.armextab.*) } >FLASH
     .ARM : {
     __exidx_start = .;
       *(.ARM.exidx*)
       __exidx_end = .;
     } >FLASH
 
   .ARM.attributes : { *(.ARM.attributes) } > FLASH
 
   .preinit_array     :
   {
     PROVIDE_HIDDEN (__preinit_array_start = .);
     KEEP (*(.preinit_array*))
     PROVIDE_HIDDEN (__preinit_array_end = .);
   } >FLASH
   .init_array :
   {
     PROVIDE_HIDDEN (__init_array_start = .);
     KEEP (*(SORT(.init_array.*)))
     KEEP (*(.init_array*))
     PROVIDE_HIDDEN (__init_array_end = .);
   } >FLASH
   .fini_array :
   {
     PROVIDE_HIDDEN (__fini_array_start = .);
     KEEP (*(.fini_array*))
     KEEP (*(SORT(.fini_array.*)))
     PROVIDE_HIDDEN (__fini_array_end = .);
   } >FLASH

   /* used by the startup to initialize data */
   _sidata = .;
 
   /* Initialized data sections goes into RAM, load LMA copy after     code */
   .data : AT ( _sidata )
   {
     . = ALIGN(4);
     _sdata = .;        /* create a global symbol at data start */
     *(.data)           /* .data sections */
     *(.data*)          /* .data* sections */
 
     . = ALIGN(4);
     _edata = .;        /* define a global symbol at data end */
   } >RAM
 
   /* Uninitialized data section */
   . = ALIGN(4);
   .bss :
   {
     /* This is used by the startup in order to initialize the .bss    secion */
     _sbss = .;         /* define a global symbol at bss start */
     __bss_start__ = _sbss;
     *(.bss)
     *(.bss*)
     *(COMMON)
 
     . = ALIGN(4);
     _ebss = .;         /* define a global symbol at bss end */
     __bss_end__ = _ebss;
   } >RAM

   PROVIDE ( end = _ebss );
   PROVIDE ( _end = _ebss );
 
   /* User_heap_stack section, used to check that there is enough RAM  left */
   ._user_heap_stack :
   {
     . = ALIGN(4);
     . = . + _Min_Heap_Size;
     . = . + _Min_Stack_Size;
     . = ALIGN(4);
   } >RAM
 
   /* MEMORY_bank1 section, code must be located here                  explicitly            */
   /* Example: extern int foo(void) __attribute__ ((section (".        mb1text"))); */
   .memory_b1_text :
   {
     *(.mb1text)        /* .mb1text sections (code) */
     *(.mb1text*)       /* .mb1text* sections (code)  */
     *(.mb1rodata)      /* read-only data (constants) */
     *(.mb1rodata*)
   } >MEMORY_B1
 
   /* Remove information from the standard libraries */
   /DISCARD/ :
   {
     libc.a ( * )
     libm.a ( * )
     libgcc.a ( * )
   }
 }

```

在看完上面的链接文件，以及之前博客关于启动文件的分析，可以了解到。

在文件的一开始，便将程序的入口地址设定为了Reset中断。

进入Reset中断之后，首先将从0x80000（这里有几个0我数不清了，随便打的）开始的flash地址中的data数据复制到RAM中，其中flash中的数据就是我们下载的工程的程序，然后将bss段清零初始化。

重新回顾一下text.data数据段和bss数据段：
TEXT:
通常是指用来存放程序执行带没的一块内存，这部分区域的内容在程序运行之前就已经确定了，通常属于只读，但是某些架构也会允许读写，也就是修改程序。里面可能包含一些常数变量。有的地方写为CODE。

DATA(data segment):
通常是指用来存放程序中已经初始化的全局变量的一块内存，属于静态分配。

BSS(bss segment):Block Started by Symbol  通常指用来存放程序中没有初始化的全局变量的一块内存，属于静态内存分配。

但是，为什么需要进行复制呢？考虑一下flash和RAM的关系。
都是随机存储器，断电数据消失，但Flash有点不一样，它在消失数据之前，添加了一个“性质”，这个性质能上电后再识别，且把这个信号返回到ram中，这样近似的把flash当成了eeprom来使用，就是这样，RAM芯片断电后数据会丢失，Flash芯片断电后数据不会丢失，但是RAM的读取数据速度远远快于Flash芯片。

所以，将flash中的data数据复制到ram中大概可以提高运行速度之类的。我猜的。有必要看一下哪些数据被分配到了data数据段。

接着进行跳转，先是系统初始化，也就是调用系统时钟初始化函数。
然后调用静态构造函数，对静态数据进行初始化的函数，从名字上来看。
接着调用自己编写的工程，从main函数开始。
