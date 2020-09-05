---
title: GPT-3教程
date: 2020-09-04 09:08:03
tags:
- nlp
- gpt
---

# 0.概述
GPT-3(Generative Pre-trained Transformer 3)是一种自动回归语言模型(这是什么东西？)。
使用基于Transformer的深度学习神经网络生成类似于人写的文本。其完整版本包含了1750亿个机器学习的参数。
GPT-3在2020年5月推出，在7月进行Beta测试。

相关资料:
论文:
GPT-3
Language Models are Few-Shot Learners 
https://arxiv.org/abs/2005.14165

GPT模型
Improving Language Understanding by Generative Pre-Training
https://s3-us-west-2.amazonaws.com/openai-assets/research-covers/language-unsupervised/language_understanding_paper.pdf

GPT-3使用了和GPT-2相同的模型和架构，也是基于Transformer模型，所以，研究GPT-3模型，就直接看GPT模型。GPT和bert模型都是基于Transformer模型，但是不同的是:
GPT模型是通过多层解码器构建，而BERT是通过多层编码器模块构建的。

GPT模型的训练有两个步骤：
第一个步骤是，无监督预训练，在大型的文本集上学习的高能力语言模型，
第二个步骤是，有监督微调，将模型调整为带有标记数据的区分任务。

无监督预训练:
获取无监督的语料库u={u_1,...,u_n},然后，我们使用标准的语言建模使得下面的概率最大:
![](GPT3预训练公式1.png)
其中，k是文档窗口的大小，条件概率P是包含变量&Theta;的神经网络模型，而这些变量都是通过随机梯度下降训练出的。

我们使用了一个多层的Transformer解码器模型，其中多头注意力机制和位置前馈网络产生了一个目标位置的输出分布。

![](GPT3预训练公式2.png)

其中，U=(u_-k,...,u_-1)是词语token的内容向量，n是层的数目，W_e是词语token的嵌入矩阵，W_p是位置嵌入矩阵。

其中h_0是GPT的输入，然后计算出每一层的输出，得到最后一层的输出h_t,然后送到softmax函数中计算下个单词出现的概率。

其中，矩阵的维度为:
V:词汇表的大小
L:最长句子的长度
dim:词嵌入的唯独
W_p:L×dim矩阵
W_e:V×dim矩阵

有监督微调:
在无监督预训练之后，我们根据有监督的目标任务修改变量。假设有一个有标签的数据集C，每个实例都是包含输入x1,...,xm和标签y。由预训练模型作为输入，来获取最终的transformer block中的h_m,l,然后将其和变量W_y输入到线性输出层,来预测y:
![](GPT3有监督微调公式1.png)

将所有的概率通过公式叠加，使其最大:
![](GPT3有监督微调公式2.png)

将语言建模作为微调的辅助目标，可以:
1.提高模型的范化能力
2.加快收敛
我们可以优化其目标函数:
![](GPT3有监督微调公式3.png)

GPT的模型和应用:
![](GPT模型及应用.png)
其中的应用分别是:
分类问题:
应用方法，增加起始和终止符。

Textual entailment(文本蕴含任务):
自然语言推理的一部分(其中还有机器阅读，问答系统和对话)，内容是给定一个前提文本(premise)，根据这个前提文本去推断假说文本(hypothesis)与前提的关系，一般为蕴含(entailment)和矛盾(contradiction)。
蕴含关系为从前提中可以推理出假说，矛盾关系为前提和假设矛盾。
应用方法，两个句子之间增加分割符

Similarity(相似性):
对于相似性问题，两个比较的句子之间相似性。
应用方法，将两个句子顺序颠倒作为两个输入

问题解答和常识推理:
对于一个文档，一个问题和一系列可能的回答
