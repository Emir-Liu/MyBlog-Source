---
title: GPT-3教程
date: 2020-09-04 09:08:03
tags:
- nlp
- gpt-3
-
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
其中，k是文档窗口的大小，条件概率P是包含变量&Theta;

GPT模型中，多头注意力机制和位置前馈网络产生了一个目标位置的输出分布。


