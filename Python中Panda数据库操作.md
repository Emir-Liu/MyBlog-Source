---
title: Python中Panda数据库操作
date: 2020-06-17 17:45:16
tags:
- python
- pandas
---
最近我需要处理大量数据，然后，我想通过panda来实现。

安装很简单,感觉比MySQL小多了。
```bash
pip install pandas
```

然后我们来读取数据，读取数据
```bash
#panda1.py
import pandas as pd

io_out = r'C:\Users\ABC\Desktop\personal\python\panda\list\托外加工单.xlsx'
io_dev = r'C:\Users\ABC\Desktop\personal\python\panda\list\送货清单.xlsx'
io_pur = r'C:\Users\ABC\Desktop\personal\python\panda\list\采购单.xlsx'
io_wee = r'C:\Users\ABC\Desktop\personal\python\panda\list\周计划.xlsx'


out_data = pd.read_excel(io_out,sheet_name = 0,header = 1,index_col = 0)
dev_data = pd.read_excel(io_dev,sheet_name = 0,header = 1,index_col = 1)
pur_data = pd.read_excel(io_pur,sheet_name = 0,header = 1,index_col = 0)
wee_data = pd.read_excel(io_wee,sheet_name = 0,header = 1,index_col = 0)

print('托外加工单')
print(out_data.head())
print('送货清单')
print(dev_data.head())
print('采购单')
print(pur_data.head())


#print('周计划')
#print(wee_data.head())

```
这里需要注意一下，其中用了pandas.read_excel()函数，在使用的时候会提示需要xlrd模块，这里面有一些参数：
1、io，Excel的存储路径
2、sheet_name，要读取的工作表名称（从0开始排序）
3、header， 用哪一行作列名（从0开始排序）
4、names， 自定义最终的列名
5、index_col， 用作索引的列
6、usecols，需要读取哪些列
7、squeeze，当数据仅包含一列
8、converters ，强制规定列数据类型
9、skiprows，跳过特定行
10、nrows ，需要读取的行数
11、skipfooter ， 跳过末尾n行

建议通过命令行来输入，比较方便交互，但是为了方便表达，我写成了文件。

关于pandas中文件的格式，有2种格式：
1.Series
一列数据，
2.DateFrame
由多个列数据组合成的数据帧格式。

那么如何写数据到Excel表格呢：
```bash
import pandas as pd

df = pd.DataFrame({'Hello':['1','2','3'],
                   'The':['1','2','3'],
                   'World':['1','2','3']})

writer = pd.ExcelWriter('Hl.xlsx',engine='xlsxwriter')

df.to_excel(writer,sheet_name='tmp')

writer.save()
```

data.loc['index_name']
通过上面的获取索引中的信息，例如：
```bash
data.loc[:,['产品名','母件特征','制造数量','预交日','日期']]
```

通过位置来获取信息：
```bash
data.iloc[3:5,0:2]
```

判断表中的数据是否在另一个表中存在的方法：
```bash

from pandas import Series,DataFrame
data = {'language':['Java','PHP','Python'],'year':[1995,1995,1991]}
frame = DataFrame(data)
frame['IDE'] = Series(['Intellij','Notepad','IPython'])

'IPython' in frame['IDE']
#输出False

3 in frame['IDE']
#输出True

#猜测 'IPython' in frame['IDE'] <=> 'IPython' in frame['IDE'].index
#所以理所当然会输出False
#注：并不意味着frame['IDE'] == frame['IDE'].index，只是说两句代码在in中效果差不多

#正确判断方法
'IPython' in frame['IDE'].values
#输出True

```

布尔索引
通过一个简单的列的数值来挑选数据
```bash
In [39]: df[df['A'] > 0]
Out[39]:
                   A         B         C         D
2013-01-01  0.469112 -0.282863 -1.509059 -1.135632
2013-01-02  1.212112 -0.173215  0.119209 -1.044236
2013-01-04  0.721555 -0.706771 -1.039575  0.271860

In [40]: df[df > 0]
Out[40]:
                   A         B         C         D
2013-01-01  0.469112       NaN       NaN       NaN
2013-01-02  1.212112       NaN  0.119209       NaN
2013-01-03       NaN       NaN       NaN  1.071804
2013-01-04  0.721555       NaN       NaN  0.271860
2013-01-05       NaN  0.567020  0.276232       NaN
2013-01-06       NaN  0.113648       NaN  0.524988
```

使用isin()方法来过滤
```bash
In [41]: df2 = df.copy()

In [42]: df2['E'] = ['one', 'one', 'two', 'three', 'four', 'three']

In [43]: df2
Out[43]:
                   A         B         C         D      E
2013-01-01  0.469112 -0.282863 -1.509059 -1.135632    one
2013-01-02  1.212112 -0.173215  0.119209 -1.044236    one
2013-01-03 -0.861849 -2.104569 -0.494929  1.071804    two
2013-01-04  0.721555 -0.706771 -1.039575  0.271860  three
2013-01-05 -0.424972  0.567020  0.276232 -1.087401   four
2013-01-06 -0.673690  0.113648 -1.478427  0.524988  three

In [44]: df2[df2['E'].isin(['two', 'four'])]
Out[44]:
                   A         B         C         D     E
2013-01-03 -0.861849 -2.104569 -0.494929  1.071804   two
2013-01-05 -0.424972  0.567020  0.276232 -1.087401  four

```

设置新列将会自动按照索引顺序添加
```bash
In [45]: s1 = pd.Series([1, 2, 3, 4, 5, 6], index=pd.date_range('20130102', periods=6))

In [46]: s1
Out[46]:
2013-01-02    1
2013-01-03    2
2013-01-04    3
2013-01-05    4
2013-01-06    5
2013-01-07    6
Freq: D, dtype: int64

In [47]: df['F'] = s1
```

通过标签设置数值
```bash
In [48]: df.at[dates[0], 'A'] = 0
```
通过位置设置数值
```bash
In [49]: df.iat[0, 1] = 0
```
通过NumPy数组来设置数值
```bash
In [50]: df.loc[:, 'D'] = np.array([5] * len(df))
```

有趣的操作
```bash
In [52]: df2 = df.copy()

In [53]: df2[df2 > 0] = -df2

In [54]: df2
Out[54]:
                   A         B         C  D    F
2013-01-01  0.000000  0.000000 -1.509059 -5  NaN
2013-01-02 -1.212112 -0.173215 -0.119209 -5 -1.0
2013-01-03 -0.861849 -2.104569 -0.494929 -5 -2.0
2013-01-04 -0.721555 -0.706771 -1.039575 -5 -3.0
2013-01-05 -0.424972 -0.567020 -0.276232 -5 -4.0
2013-01-06 -0.673690 -0.113648 -1.478427 -5 -5.0

```

缺失的数据
pandas使用np.nan来代表缺失的数据，默认情况下，它不包含在计算中。
重新索引允许你修改/增加/删除指定的索引，这将返回数据的一个副本。
```bash
In [55]: df1 = df.reindex(index=dates[0:4], columns=list(df.columns) + ['E'])

In [56]: df1.loc[dates[0]:dates[1], 'E'] = 1

In [57]: df1
Out[57]:
                   A         B         C  D    F    E
2013-01-01  0.000000  0.000000 -1.509059  5  NaN  1.0
2013-01-02  1.212112 -0.173215  0.119209  5  1.0  1.0
2013-01-03 -0.861849 -2.104569 -0.494929  5  2.0  NaN
2013-01-04  0.721555 -0.706771 -1.039575  5  3.0  NaN
```

