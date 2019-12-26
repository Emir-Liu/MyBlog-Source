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
```bash
.
├── CORE
│   ├── arm_common_tables.h
│   ├── arm_math.h
│   ├── core_cm3.h
│   ├── core_cmFunc.h
│   ├── core_cmInstr.h
│   ├── stm32f10x.h
│   └── system_stm32f10x.h
├── HARDWARE
│   ├── led.c
│   └── led.h
├── makefile
├── stm32_f103ze_gcc.ld
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
├── SYSTEM
│   ├── delay.c
│   ├── delay.h
│   ├── sys.c
│   └── sys.h
└── USER
    ├── CoIDE_startup.c
    ├── main.c
    ├── main.c~
    ├── stm32f10x_conf.h
    ├── stm32f10x.h
    ├── stm32f10x_it.c
    ├── stm32f10x_it.h
    ├── system_stm32f10x.c
    └── system_stm32f10x.h
```
实际工程中的makefile文件是：
```bash

TARGET = test_project

PREFIX	= arm-none-eabi-
CC			= $(PREFIX)gcc
AS			= $(PREFIX)as
LD			= $(PREFIX)ld
OBJCOPY	= $(PREFIX)objcopy

TOP = $(shell pwd)

#include头文件
INC_FLAGS = -I $(TOP)/CORE								\
						-I $(TOP)/HARDWARE						\
						-I $(TOP)/STM32F10x_FWLib/inc	\
						-I $(TOP)/SYSTEM							\
						-I $(TOP)/USER

#GCC选项
# -W -Wall				:开启警报
# -g							:产生调试信息，用于产生.elf调试文件
# mcpu=cortex-m3	:用于设定内核参数
# -D STM32F10X_MD -D USE_STDPERIPH_DRIVER	:宏定义
# -O0							:优化等级有O0,O1,O2等
# -std=gnu11			:设定语言标准GNU11,当然可以换为C98等
CFLAGS = -W -Wall -g mcpu=cortex-m3 -mthumb -D STM32F10X_MD -D USE_STDPERIPH_DRIVER $(INC_FLAGS) -O0 -std=gnu11

#搜索并返回当前路径下的所有.c文件的集合
C_SRC = $(shell find ./ -name '*.c')
#将C_SRC包含的文件的.c后缀代替为.o文件
C_OBJ = $(C_SRC:%.c=%.o)

#.PHONY关键字，代表后面的执行对象，不是文件
.PHONY: all clean update

#all的依赖对象是$(C_OBJ),一个变量是以.c为后缀文件替换为.o为后缀的文件的集合，如果.o文件修改则更新all。
all:$(C_OBJ)
#通过gcc来进行链接，从而产生.elf文件
#-T 代表链接操作
	$(CC) $(C_OBJ) -T stm32_f103ze_gcc.ld -o $(TARGET).elf   -mthumb -mcpu=cortex-m3 -Wl,--start-group -lc -lm -Wl,--end-group -specs=nano.specs -specs=nosys.specs -static -Wl,-cref,-u,Reset_Handler -Wl,-Map=Project.map -Wl,--gc-sections -Wl,--defsym=malloc_getpagesize_P=0x80 
#通过.elf文件，生成.bin和.hex文件
  $(OBJCOPY) $(TARGET).elf  $(TARGET).bin -Obinary 
  $(OBJCOPY) $(TARGET).elf  $(TARGET).hex -Oihex

#.o文件依赖于.o文件
#其中 $@:目标文件 $^:所有依赖文件 $<:第一个依赖文件
$(C_OBJ):%.o:%.c
  $(CC) -c $(CFLAGS) -o $@ $<

#删除所有的中间文件和最后的执行文件
clean:
  rm -f $(shell find ./ -name '*.o')
  rm -f $(shell find ./ -name '*.d')
  rm -f $(shell find ./ -name '*.map')
  rm -f $(shell find ./ -name '*.elf')
  rm -f $(shell find ./ -name '*.bin')
  rm -f $(shell find ./ -name '*.hex')

#openocd进行配置，然后下载程序
# -f			:输入配置文件
# -c			:输入参数
# init		:初始化
# halt		:暂停MCU内核
# flash write_image erase	:烧写文件
# reset		:复位
# exit		:退出
update:
  openocd -f /usr/share/openocd/scripts/interface/stlink-v2.cfg  -f /usr/share/openocd/scripts/target/stm32f1x_stlink.cfg -c init -c halt -c "flash write_image erase $(TOP)/LED_project.hex" -c reset -c shutdown
```
