---
title: GraphSAGE
date: 2020-08-02 17:06:45
tags:
---
GCN是一种在图中结合拓扑结构和顶点属性信息学习顶点的embedding表示的方法。然而GCN要求在一个确定的图中去学习顶点的embedding，无法直接泛化到在训练过程没有出现过的顶点，即属于一种直推式(transductive)的学习。

本文介绍的GraphSAGE则是一种能够利用顶点的属性信息高效产生未知顶点embedding的一种归纳式(inductive)学习的框架。

其核心思想是通过学习一个对邻居顶点进行聚合表示的函数来产生目标顶点的embedding向量。

![](图示1.png)

GraphSAGE 是Graph SAmple and aggreGatE的缩写，其运行流程如上图所示，可以分为三个步骤

1. 对图中每个顶点邻居顶点进行采样

2. 根据聚合函数聚合邻居顶点蕴含的信息

3. 得到图中各顶点的向量表示供下游任务使用
