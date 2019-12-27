---
title: Ubuntu上STM32开发之工程管理
date: 2019-12-26 19:38:11
tags:
- ubuntu
- stm32
- makefile
---

通过makefile来实现工程的管理。
首先工程的结构是：
CORE:cm的核心文件
HARDWARE:硬件方面的.c和.h文件
STM32F10x_FWLib:STM32F10X的固件库
SYSTEM:常用的功能的.c和.h文件
USER:用户写的main.c等
makefile文件
ld文件

CORE和STM32F10x_FWLib都是来自ST官网的固件库里面。
说到ST官网，大概说一下固件库在STM32系列->Tools&Software->Embedded Software->MCU&MPU Embedded Software->Standard Peripheral Libraries

建立自己的工程文件夹，在里面建立CORE，STM32F10x_FWLib，HARDWARE，SYSTEM，USER文件夹。
首先，将固件库的inc和src文件复制到自己工程的STM32F10x_FWLib文件夹中。
再选择文件到CORE文件夹中，按照下面我的工程进行挑选，在选择的过程中，有多个启动文件，选择TrueSTUDIO文件夹下的启动文件，然后，不同启动文件对应不同的内存，我就选startup_stm32f10x_md.s作为我的启动文件，我的芯片是STM32F103RBT6。然后记得要挑选链接文件.ld，

记住不要忘记stm32f10x_conf.h文件。

然后，如果在编译的时候遇到下面的问题
```bash
/tmp/ccSTjuNC.s: Assembler messages:
/tmp/ccSTjuNC.s:890: Error: registers may not be the same -- `strexb r3,r2,[r3]'
/tmp/ccSTjuNC.s:943: Error: registers may not be the same -- `strexh r3,r2,[r3]'
makefile:32: recipe for target 'CORE/core_cm3.o' failed

```
这是因为GCC更新之后，对于源代码的错误的容忍性降低了，很多旧版本可以忽略的代码错误，在新版本就会被拒绝。
这些问题的最常见原因是在文件core_cm3.c的内联汇编过程中（通常未链接）对strexh和strexb的错误使用，该文件是ARM CMSIS库的一部分，包含在ST外设库中。
您有两种方法可以解决此问题。两种方法均有效，您可以根据自己的情况选择一种：

1.更新所有库（CMSIS，外围设备库等）。这是一种更简洁的方法，并且从长远来看是最好的，但是如果您使用的是旧版本的库，则短期内可能需要大量工作才能适应调用库的代码。（万恶的ST更新库了吗？我不知道，因为我写的时候还没有更新这个问题）

2.编辑core_cm3.c并注释掉函数__STREXH和__STREXB的定义。这些存在问题的函数很少使用，您的应用程序很可能不需要它们。如果确实使用它们，则应更新库（上面的选项1）。

上面来源：http://support.raisonance.com/node/431888

但是，其实我们可以通过修改core_cm3的汇编部分代码来避免这个错误：

在core_cm3.h文件中，我们需要修改__STREXB和 __STREXH

```bash
//原本是这样的
__ASM volatile ("strexh %0, %2, [%1]" : "=r" (result) : "r" (addr), "r"(value) );
//现在是这样的
__ASM volatile ("strexh %0, %2, [%1]" : "=&r" (result) : "r" (addr), "r"(value) );
//就是将=r 修改为了 =&r
```
这样问题就解决了
下面是我的工程模板
```bash
.
├── CORE
│   ├── core_cm3.c
│   ├── core_cm3.h
│   ├── startup_stm32f10x_md.s
│   ├── stm32f10x.h
│   ├── system_stm32f10x.c
│   └── system_stm32f10x.h
├── HARDWARE
│   ├── led.c
│   └── led.h
├── makefile
├── STM32F10x_FWLib
│   ├── inc
│   │   ├── misc.h
│   │   ├── stm32f10x_adc.h
│   │   ├── stm32f10x_bkp.h
│   │   ├── stm32f10x_can.h
│   │   ├── stm32f10x_cec.h
│   │   ├── stm32f10x_crc.h
│   │   ├── stm32f10x_dac.h
│   │   ├── stm32f10x_dbgmcu.h
│   │   ├── stm32f10x_dma.h
│   │   ├── stm32f10x_exti.h
│   │   ├── stm32f10x_flash.h
│   │   ├── stm32f10x_fsmc.h
│   │   ├── stm32f10x_gpio.h
│   │   ├── stm32f10x_i2c.h
│   │   ├── stm32f10x_iwdg.h
│   │   ├── stm32f10x_pwr.h
│   │   ├── stm32f10x_rcc.h
│   │   ├── stm32f10x_rtc.h
│   │   ├── stm32f10x_sdio.h
│   │   ├── stm32f10x_spi.h
│   │   ├── stm32f10x_tim.h
│   │   ├── stm32f10x_usart.h
│   │   └── stm32f10x_wwdg.h
│   └── src
│       ├── misc.c
│       ├── stm32f10x_adc.c
│       ├── stm32f10x_bkp.c
│       ├── stm32f10x_can.c
│       ├── stm32f10x_cec.c
│       ├── stm32f10x_crc.c
│       ├── stm32f10x_dac.c
│       ├── stm32f10x_dbgmcu.c
│       ├── stm32f10x_dma.c
│       ├── stm32f10x_exti.c
│       ├── stm32f10x_flash.c
│       ├── stm32f10x_fsmc.c
│       ├── stm32f10x_gpio.c
│       ├── stm32f10x_i2c.c
│       ├── stm32f10x_iwdg.c
│       ├── stm32f10x_pwr.c
│       ├── stm32f10x_rcc.c
│       ├── stm32f10x_rtc.c
│       ├── stm32f10x_sdio.c
│       ├── stm32f10x_spi.c
│       ├── stm32f10x_tim.c
│       ├── stm32f10x_usart.c
│       └── stm32f10x_wwdg.c
├── stm32_flash.ld
├── SYSTEM
│   ├── delay.c
│   ├── delay.h
│   ├── sys.c
│   └── sys.h
└── USER
    ├── main.c
    └── stm32f10x_conf.h

7 directories, 62 files

```
实际工程中的makefile文件是：
```bash
TARGET = test_project

PREFIX  = arm-none-eabi-
CC      = $(PREFIX)gcc
AS      = $(PREFIX)as
LD      = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy

#读取当前工作目录
TOP=$(shell pwd)

#include头文件
INC_FLAGS= -I $(TOP)/CORE                   \
           -I $(TOP)/HARDWARE               \
           -I $(TOP)/STM32F10x_FWLib/inc    \   
           -I $(TOP)/SYSTEM                 \
           -I $(TOP)/USER

#GCC选项
# -W -Wall        :开启警报
# -g              :产生调试信息，用于产生.elf调试文件
# mcpu=cortex-m3  :用于设定芯片内核参数
# -mthumb         :表明使用的指令集
# -D STM32F10X_MD -D USE_STDPERIPH_DRIVER :宏定义
# -O0             :优化等级有O0,O1,O2等
# -std=gnu11      :设定语言标准GNU11,当然可以换为C98等
CFLAGS =  -W -Wall -g -mcpu=cortex-m3 -mthumb -D STM32F10X_MD -D USE_STDPERIPH_DRIVER $(INC_FLAGS) -O0 -std=gnu11
ASFLAGS = -W -Wall -g -mcpu=cortex-m3 -mthumb

#搜索并返回当前路径下的所有.c文件的集合
#将C_SRC包含的文件的.c后缀代替为.o文件
C_SRC=$(shell find ./ -name '*.c')
C_OBJ=$(C_SRC:%.c=%.o)

ASM_SRC=$(shell find ./ -name '*.s')
ASM_OBJ=$(ASM_SRC:%.s=%.o)

#.PHONY关键字，代表后面的执行对象，不是文件
.PHONY: all clean update

#all的依赖对象是$(C_OBJ)和$(ASM_OBJ),一个变量是以.c或.s为后缀文件替换为.o为后缀>的文件的集合，如果.o文件修改则更新all。
all:$(C_OBJ) $(ASM_OBJ)
  $(CC) $(C_OBJ) $(ASM_OBJ) -T stm32_flash.ld -o $(TARGET).elf   -mthumb -mcpu=cortex-m3 -Wl,--start-group -lc -lm -Wl,--end-group -specs=nano.specs -specs=nosys.specs -static -Wl,-cref,-u,Reset_Handler -Wl,-Map=Project.map -Wl,--gc-sections -Wl,--defsym=malloc_getpagesize_P=0x80 
#通过.elf文件，生成.bin和.hex文件
  $(OBJCOPY) $(TARGET).elf  $(TARGET).bin -Obinary 
  $(OBJCOPY) $(TARGET).elf  $(TARGET).hex -Oihex

#.o文件依赖于.o文件
#其中 $@:目标文件 $^:所有依赖文件 $<:第一个依赖文件
$(C_OBJ):%.o:%.c
  $(CC) -c $(CFLAGS) -o $@ $<

#$(ASM_OBJ):%.o:%.c
# $(AS) -c $(ASFLAGS) -o $@ $<
$(ASM_OBJ): $(ASM_SRC)
  $(AS) -c $(ASFLAGS) -o $@ $<

clean:
  rm -f $(shell find ./ -name '*.o')
  rm -f $(shell find ./ -name '*.d')
  rm -f $(shell find ./ -name '*.map')
  rm -f $(shell find ./ -name '*.elf')
  rm -f $(shell find ./ -name '*.bin')
  rm -f $(shell find ./ -name '*.hex')

update:
  openocd -f /usr/share/openocd/scripts/interface/stlink-v2.cfg  -f /usr/share/openocd/scripts/target/stm32f1x_stlink.cfg -c init -c halt -c "flash write_image erase $(TOP)/LED_project.hex" -c reset -c shutdown

```
