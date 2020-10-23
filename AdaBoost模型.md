---
title: AdaBoost模型
date: 2020-10-23 19:56:51
tags:
- adaboost
---

# 概述
资料来源:
https://blog.paperspace.com/adaboost-optimizer/#:~:text=AdaBoost%20is%20an%20ensemble%20learning,turn%20them%20into%20strong%20ones.

Ensemble Learning:
集成学习(或者是组合学习)，将多个基础的算法相结合，构造成一个优化的预测模型。

为什么需要集成学习:
1.减少变量
2.减少偏置
3.提高预测性能

集成学习被分为了两个类型:
1. 顺序学习，通过依次生成不同的模型，之前模型的错误被后来的模型学习，利用模型之间的依赖性，使得错误标记有更大的权重。

例如:AdaBoost

2.并行学习，并行产生基本的模型，这通过平均错误来利用了模型的独立性。

例如:Random Forest 随机森林

集成方法中的Boosting
例如人类从错误中学习，并且尝试将来不再犯同样的错误，Boost算法尝试从多个弱分类器的错误中建立一个更强的学习预测模型。
你一开始从训练数据中建立一个模型，
然后你从上一个模型中建立第二个模型通过尝试从减少上一个模型的误差。
模型被顺序增加，每一个都修改它的前面一个模型，知道训练数据被完美的预测或者增加了最大数量的模型。

Boosting基本上是试图减少模型无法识别数据中的相关趋势的时候所引起的偏差。这是通过评估预测数据和实际数据的差值所实现的。

Boost算法的类别:
1.AdaBoost(Adaptive Boosting)
2.Gradient Tree Boosting
3.XGBoost

我们主要注意AdaBoost中的细节，这个是Boost算法中最流行的算法。



