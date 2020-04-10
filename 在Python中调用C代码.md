---
title: 在Python中调用C代码
date: 2020-04-07 15:55:53
tags:
- python
- c/c++
---
# 0.简介
为什么在Python中调用C代码？
1.提升代码运行速度
2.C语言中的传统类库
3.从内存到文件接口的底层资源访问

有哪些方法？
1.-ctypes
2.SWIG
3.Python/C API

# 1.CTypes
使用Python中的ctypes模块是最为简单的。ctypes提供了和C兼容的数据类型和函数来加载dll文件，因此在调用时不需要对源文件做任何修改。
下面是例子:
## 1.1 建立C函数
```bash
#include <stdio.h>
 
int add_int(int, int);
float add_float(float, float);
 
int add_int(int num1, int num2){
    return num1 + num2;
 
}
 
float add_float(float num1, float num2){
    return num1 + num2;
}
```

## 1.2 将C语言编译为.so文件(windows下为dll),生成adder.so文件。
```bash
#For Linux
$  gcc -shared -Wl,-soname,adder -o adder.so -fPIC add.c
 
#For Mac
$ gcc -shared -Wl,-install_name,adder.so -o adder.so -fPIC add.c
```

## 1.3 在Python代码中调用C函数
```bash
from ctypes import *
 
#load the shared object file
adder = CDLL('./adder.so')
 
#Find sum of integers
res_int = adder.add_int(4,5)
print "Sum of 4 and 5 = " + str(res_int)
 
#Find sum of floats
a = c_float(5.5)
b = c_float(4.1)
 
add_float = adder.add_float
add_float.restype = c_float
print "Sum of 5.5 and 4.1 = ", str(add_float(a, b))
```
在这个文件中，C语言是自解释的。

在Python文件中，一开始先导入ctypes模块，然后使用CDLL函数来加载我们创建的库文件。这样我们就可以通过变量adder来使用C类库中的函数了。当adder.add_int()被调用时，内部将发起一个对C函数add_int的调用。ctypes接口允许我们在调用C函数时使用原生Python中默认的字符串型和整型。

而对于其他类似布尔型和浮点型这样的类型，必须要使用正确的ctype类型才可以。如向adder.add_float()函数传参时, 我们要先将Python中的十进制值转化为c_float类型，然后才能传送给C函数。这种方法虽然简单，清晰，但是却很受限。例如，并不能在C中对对象进行操作。

# 2.SWIG(Simplified Wrapper and Interface Generator)
这个方法需要编写额外的接口文件来作为SWIG的入口，一般不使用这个方法，因为比较复杂。但是，当你一个C/C++代码库需要被多种语言调用时，这就很有用了。
例子:
```bash
//example.c
#include <time.h>
double My_variable = 3.0;
 
int fact(int n) {
    if (n <= 1) return 1;
    else return n*fact(n-1);
 
}
 
int my_mod(int x, int y) {
    return (x%y);
 
}
 
char *get_time()
{
    time_t ltime;
    time(&ltime);
    return ctime(&ltime);
}
```

编译:
```bash
unix % swig -python example.i
unix % gcc -c example.c example_wrap.c \
    -I/usr/local/include/python2.1
unix % ld -shared example.o example_wrap.o -o _example.so
```
输出:
```bash
>>> import example
>>> example.fact(5)
120
>>> example.my_mod(7,3)
1
>>> example.get_time()
'Sun Feb 11 23:01:07 1996'
```

# 3.Python/C API
最广泛使用的方法，不仅简单而且可以在C代码中操作Python对象。
这种方法需要以特定的方式来编写C代码以供Python去调用它。所有的Python对象都被表示为一种叫做PyObject的结构体，并且Python.h头文件中提供了各种操作它的函数。例如，如果PyObject表示为PyListType(列表类型)时，那么我们便可以使用PyList_Size()函数来获取该结构的长度，类似Python中的len(list)函数。大部分对Python原生对象的基础函数和操作在Python.h头文件中都能找到。


