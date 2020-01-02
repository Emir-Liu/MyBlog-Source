---
title: Ubuntu上STM32开发之UC/OS-III移植
date: 2019-12-30 19:35:46
tags:
- ubuntu
- stm32
- uc/os
---
# 0准备
makefile 管理工程脚本语言
STM32F1的固件库，之前的博客有提到
UC/OS III文件，从Micrium官网下载符合STM32的版本。

# 1提取必要的文件
UC/OS III文档中，该文件结构的分析：
EvalBoards:
开发板相关的文件，主要配置底层和系统，需要提取部分文件
uC-CPU:CPU相关的文件，但是我打算使用STM32F1的标准固件库，就不用这部分了
uC-LIB:这是Micrium官方的库，刚接触的时候可以不用
uCOS-III:这是关键的部分，主要的移植内容。其中有两个文件夹。
Ports:与系统相关的端口配置文件
Source:OS的全部文件

知道了文档的结构之后，该提取了。
提取uCOS-III文档，和EvalBoards中的app_cfg.h和os_cfg.h。
app_cfg.h:应用配置文件：任务优先级和堆栈大小等。
os_cfg.h：系统配置文件：使能相应的功能函数，裁剪系统
STM32固件库中的必要文件：
  启动文件
  链接文件
  库文件

# 2 配置文件：
  首先的我们需要配置系统节拍器system TIck TImer,SysTIck，也就是俗称的系统滴答，其作用类似于驱动整个系统的心脏。

## 2.1 初始化系统节拍器
  我们使用ST的系统节拍器作为操作系统的系统节拍器，芯片的SysTick是内核Cortex-M3的一部分，所以，在初始化的时候调用CM3中的SysTick_Config函数。

  说明一下，SysTick是专门为系统而设计的Cortex-M3内核的芯片的功能。

  配置过程如下：
```bash
//app_cfg.c
void OSTick_Init(void)
{
  RCC_ClocksTypeDef RCC_ClocksStructure;
  RCC_GetClocksFreq(&RCC_ClocksStructure);  //获取系统时钟频率
  SysTick_Config(RCC_ClocksStructure.HCLK_Frequency/OS_TICKS_PER_SEC);
//初始化并启动SysTick和它的中断
}
```

## 2.2 系统节拍器中断配置
中断函数需要调用系统相关的函数
```bash
void SysTick_Handler(void)
{
  OSIntEnter();
  OSTimeTick();
  OSIntExit();
//系统节拍器调用OS函数
}
```

## 2.3 裁剪系统
  打开或者关闭系统的某些功能，也就是配置os_cfg.h文件。

### 2.3.1最低优先级 os_lowest_prio
  优先级：优先级越小，数值越大。配置优先值数值的最大值。

### 2.3.2系统每秒的滴答数 os_ticks_per_sec
  
### 2.3.3任务堆栈大小 os_task_xxx_stk_size
  
## 2.4 配置os_cpu_a.asm文件
  位于uc/os iii ports下面，主要是系统底层相关的一部分汇编代码，内容是对外部引用（全局变量，函数）声明，以及部分系统相关源代码（汇编）做定义。



# 3 工程结构

第一类 标准外设库
  startup code:启动代码
  STM32F10x_StdPeriph_Dricer:标准外设库驱动
  CMSIS：标准接口

第二类 uC/OS III内核
  uC/OS III Source:内核源代码
  uC/OS III Ports:OS端口底层代码，与处理器，编译平台有关。

第三类 用户应用
  Bsp:应用底层代码（初始化，驱动等）
  App:应用实现代码（配置OS，应用等）



FAQ:
1.SYSTEM\sys\sys.c:33:7: error: expected '(' before 'void' __ASM void MSR_MSP(u32 addr)

我在编译工程的时候遇到的这个问题，说实话这个东西应该是编译器的版本的问题吧，大概，需要将上面的文件修改一些：
```bash
__ASM void MSR_MSP(u32 addr)
{
MSR MSP, r0 //set Main Stack value
BX r14
}

//将上面那种写法修改成下面这种应该就没事了
//为什么？我也不知道。总之先记下了。
void MSR_MSP(u32 addr)
{
__ASM volatile("MSR MSP, r0");
__ASM volatile("BX r14");
}
```
