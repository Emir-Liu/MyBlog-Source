---
title: GPT模型的使用
date: 2020-09-24 15:59:03
tags:
- gpt
---
GPT使用有下面的几个方式:
1.直接使用
https://ner.algomo.com/
这是直接调用GPT-3模型的API，里面的原理待定。

2.对自己所需要的小数据进行预训练
https://github.com/Emir-Liu/GPT2-Chinese
GPT2中文训练，使用了BERT的Tokenizer???。主要使用

3.对模型进行微调之后使用
通过微调预训练的GPT-2模型，来生成特定主题的文本。
http://nlp.seas.harvard.edu/2018/04/03/attention.html
其中，直接使用了transformers模块中的函数，直接加载预训练模块，然后训练？？，就结束了，其中训练的过程就是一个黑箱。

上面就是GPT模型的一些使用的方法。
但是，对于初学者来说，更重要的事情是了解黑箱之中是什么原理，以及如何实现。
之前已经了解了GPT模型的原理，下面是学习其实现。

首先BERT和GPT模型都是基于Transformer模型，所以，我简单实现Transformer模型。

在之前已经了解了Transformer模型的原理，那么，其中，有下面多个优化。

例如:
1.参数初始化方式
nn.init.xavier_uniform:参数初始化方式
https://blog.csdn.net/luoxuexiong/article/details/95772045

https://prateekvjoshi.com/2016/03/29/understanding-xavier-initialization-in-deep-neural-networks/

2.Batch Normalization批量归一化
https://zhuanlan.zhihu.com/p/47812375

Normalization 有很多种，但是它们都有一个共同的目的，那就是把输入转化成均值为 0 方差为 1 的数据。我们在把数据送入激活函数之前进行 normalization（归一化），因为我们不希望输入数据落在激活函数的饱和区。

BN:
在每一层的每一批数据上进行归一化。我们可能会对输入数据进行归一化，但是经过该网络层的作用后，我们的数据已经不再是归一化的了。随着这种情况的发展，数据的偏差越来越大，我的反向传播需要考虑到这些大的偏差，这就迫使我们只能使用较小的学习率来防止梯度消失或者梯度爆炸。

BN 的具体做法就是对每一小批数据，在批这个方向上做归一化。

2.学习速率优化
https://blog.csdn.net/luoxuexiong/article/details/90412213

论文：
ADAM: A METHOD FOR STOCHASTIC OPTIMIZATION

Adam是Momentum 和 RMSProp算法的结合

3.过拟合的检验方式


