---
title: Pre-train模型
date: 2020-09-30 19:30:56
tags:
---
# 0.概述
资料来源:李宏毅教授教程Deep Learning of Human Language Process

# 1.Pre-Train Model

为什么需要Pre-Train Model
![](why_pre_train.png)


Pre-Train Model的具体流程如下图所示。
![](pre_train_model.png)

由许多层组成，有如下的几种架构方法:
1.LSTM
2.Self-attention layers
流行的model
3.Tree-based model
在公式表示中有很好的表现

Pre-Train发展:
ELMO
Predict Next Token(Bidirectional):
![](ELMO.png)

BERT(类似与CBOW)
Masking Input:
![](BERT_MASKING.png)

补充:
![](CBOW.png)

bert看所有的sequence,而CBOW有固定的窗口

Mask Input:
首先，Original BERT Input
probability
pro [MASK] ##lity

然后，Whole Word Masking(WWM)
probability
[MASK]

最后，Phrase-level和Entity-level(Enhanced Representation through Knowledge Integration,ERNIE)


小的BERT模型有:
ALBERT 每一层的参数都相同，小一些，但是效果没怎么变

Network Compression https://youtu.be/dPp8rCAnU_A
其中:
Network Pruning
Knowledge Distillation
Parameter Quantization
Architecture Design

BERT模型压缩:
http://mitchgordon.me/machine/learning/2019/11/18/all-the-ways-to-compress-BERT.html
all the ways to compress BERT

减少self-attention的运算量(n^2,其中n为sequence的长度):
Reformer
Longformer

有了Pre-Train Model之后，如何Fine-Tune？如图所示。
![](fine-tune1.png)

# 2.优化

## 2.1 Adaptor
当我们进行Fine-Tune任务的时候，通常是如下图所示。
![](adaptor1.png)

增加adaptor模块
![](adaptor2.png)

![](adaptor3.png)

将效果进行对比
![](adaptor比较.png)

# 3.GPT-3
参考论文:language model are few-shot learners
其中，few-shot是什么意思呢？

首先，GPT-3的few-shot和其他模型的few-shot不同,如上图所示。
在其他模型中，few-shot learning是指用少量的训练资料去Fine Tune它。
在GPT-3中没有Fine Tune的内容，直接将问题的简介、样例(有的没有)和问题作为模型的输入，然后输出问题的答案。

如下图所示:
![](GPT-3_3_learning.png)

这种学习被称为In-context learning,图中有三种类型。

精度随着变量变化的趋势。
![](GPT-3_ACCURACY.png)

精度随着样本的变化趋势
![](number_samples_accu.png)

在数学计算上的精度:
![](cal_gpt3.png)

# 4.GPT和BERT对比
首先，BERT是使用了MASK Input模型来获取上下文的资料，而GPT是根据前面的token来进行预训练。

所以GPT在autoregressive生成句子中有劣势，但是，在non-regressive中可能会有好的效果。
