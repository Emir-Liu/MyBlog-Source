---
title: BERT模型分析
date: 2020-08-10 10:05:49
tags:
---
# 0.简介
Transformer和Bert之间的关系:
Transformer模型是2017年谷歌发表的论文attention is all you need中提出的seq2seq模型。现在已经取得了大范围的应用和扩展，而BERT就是从transformer中衍生出来的预训练语言模型

BERT使用TensorFlow，2018年提供了BERT的PyTorch版本Transformer

来源:
论文:BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding
模型的整体框架就是一个seq2seq结构
Google AI Language
NLP中的预训练:
词嵌入是NLP深度学习的基础

![](词向量.png)
词嵌入(word2vec,GloVe)是通过共现文本对统计，对文本语料库进行预训练
![](共现文本对统计.png)

上下文表示:
之前的问题:
词嵌入是应用于与上下文无关的方式
![](与上下文无关的词嵌入.png)

解决方法:
在语料库中训练上下文表示。
![](与上下文相关的词嵌入.png)

上下文相关的表示方法:
半监督的序列学习,Google,2015
![](半监督的序列学习.png)

ELMo:深度上下文词嵌入，2017
![](深度上下文词嵌入.png)

通过通用的预训练来提升语言理解OpenAL,2018
![](通过通用预训练来提升语言理解.png)


模型:借鉴于Attention Is All You Need中的Encoder
![](AttentionIsAllYouNeed.png)
完全由注意力机制构成，其分为左右两部分:
左侧:编码器部分
N=6
All Layers output size 512
Embedding
Positional Encoding
![](PositionalEncoding.png)
Notice the Residual connection
Multi-head Attention
LayerNorm(x + Sublayer(x))
Position wise feed forward

右侧:解码器部分
N=6
All Layers output size 512
Embedding
Positional Encoding
Notice the Residual connection
Multi-head Attention
![](Multi-headAttention.png)
LayerNorm(x + Sublayer(x))
Position wise feed forward
Softmax
![](SoftMax.png)

其中，解码器中的Multi-head Attention的原理:
![](Multi-HeadAttention模型.png)
其中点乘注意力模型为:
![](ScaledDotProductAttention.png)
公式:
![](Attention模型.png)
多注意力模型公式:
![](多注意力模型公式.png)
其中，公式中的Q，K，V的定义为:
编码器-解码器注意力层中，序列Q来自之前的解码器层，记忆力关键词K和数值V来自编码器的输出。
这三个变量都来自之前的层(hidden state)

然后是Feed Forward前馈网络Position-wise Feed-Forward network
![](PositionWiseFeedForwardNetwork.png)


Attention Is All You Need解析:https://www.jianshu.com/p/b1030350aadb
Seq2Seq模型的简介:https://www.jianshu.com/p/b2b95f945a98
Seq2Seq模型是输出的长度不确定时采用的模型，这种情况一般是在机器翻译的任务中出现，将一句中文翻译成英文，那么这句英文的长度有可能会比中文短，也有可能会比中文长，所以输出的长度就不确定了。如下图所，输入的中文长度为4，输出的英文长度为2。
![](Seq2Seq模型.webp)
在网络结构中，输入一个中文序列，然后输出它对应的中文翻译，输出的部分的结果预测后面，根据上面的例子，也就是先输出“machine”，将"machine"作为下一次的输入，接着输出"learning",这样就能输出任意长的序列。
机器翻译、人机对话、聊天机器人等等，这些都是应用在当今社会都或多或少的运用到了我们这里所说的Seq2Seq。

Seq2Seq结构
seq2seq属于encoder-decoder结构的一种，这里看看常见的encoder-decoder结构，基本思想就是利用两个RNN，一个RNN作为encoder，另一个RNN作为decoder。encoder负责将输入序列压缩成指定长度的向量，这个向量就可以看成是这个序列的语义，这个过程称为编码，如下图，获取语义向量最简单的方式就是直接将最后一个输入的隐状态作为语义向量C。也可以对最后一个隐含状态做一个变换得到语义向量，还可以将输入序列的所有隐含状态做一个变换得到语义变量。
![](encoder_decoder结构.webp)
而decoder则负责根据语义向量生成指定的序列，这个过程也称为解码，如下图，最简单的方式是将encoder得到的语义变量作为初始状态输入到decoder的RNN中，得到输出序列。可以看到上一时刻的输出会作为当前时刻的输入，而且其中语义向量C只作为初始状态参与运算，后面的运算都与语义向量C无关。
![](encoder_decoder结构1.webp)
decoder处理方式还有一种，就是语义向量参与了序列的所有时刻的运算，上一时刻的输出仍然作为当前时刻的输入，但是语义向量会参与到所有时刻的运算。
![](encoder_decoder结构2.webp)

如何训练Seq2Seq模型:
RNN是可以学习概率分布，然后进行预测，比如我们输入t时刻的数据后，预测t+1时刻的数据，比较常见的是字符预测例子或者时间序列预测。为了得到概率分布，一般会在RNN的输出层使用softmax激活函数，就可以得到每个分类的概率。
Softmax在机器学习和深度学习中有着非常广泛的应用。尤其在处理多分类（C > 2）问题，分类器最后的输出单元需要Softmax 函数进行数值处理。关于Softmax 函数的定义如下所示：
![](softmax.svg)

其中，Vi是分类器前级输出单元的输出。i表示类别索引，总的类别个数为C,表示的是当前元素的指数与所有元素指数和的比值。Softmax 将多分类的输出数值转化为相对概率，更容易理解和比较。我们来看下面这个例子。
一个多分类问题，C = 4。线性分类器模型最后输出层包含了四个输出值，分别是：
![](math输入.svg)
通过Softmax处理之后，数值转化为相对概率:
![](math输出.svg)
很明显，Softmax 的输出表征了不同类别之间的相对概率。我们可以清晰地看出，S1 = 0.8390，对应的概率最大，则更清晰地可以判断预测为第1类的可能性更大。Softmax 将连续数值转化成相对概率，更有利于我们理解。
![](Seq2Seq模型Softmax公式.webp)
对于RNN，对于某个序列，对于时序t，它的词向量输出概率为P(xt|x1,x2,...,xt-1)，则softmax层每个神经元的计算如下。
![](神经元计算公式.svg)
其中ht是隐含状态，它与上一时刻的状态及当前输入有关，即h<sub>t</sub>=f(h<sub>t-1</sub>,x<sub>t</sub>)
那么整个序列的概率就为:
![](序列的概率.svg)
![](RNNDecodeEncode模型.webp)

而对于encoder-decoder模型，设有输入序列x<sub>1</sub>,x<sub>2</sub>，x<sub>3</sub>,...,x<sub>T</sub>,输出序列y<sub>1</sub>，y<sub>2</sub>,y<sub>3</sub>，...,y<sub>T</sub>，输入序列和输出序列的长度可能不同。那么其实就需要根据输入序列去得到输出序列可能输出的词概率，于是有下面的条件概率，￼发生的情况下，￼发生的概率等于￼连乘，如下公式所示。其中v表示￼对应的隐含状态向量，它其实可以等同表示输入序列。



Seq2Seq模型:https://dataxujing.github.io/seq2seqlearn/chapter2/

部分教程:https://towardsml.com/2019/09/17/bert-explained-a-complete-guide-with-theory-and-tutorial/
bert tensorflow版本:https://github.com/google-research/bert
bert pytorch版本:https://github.com/huggingface/transformers
bert pytorch版本说明文档:https://huggingface.co/transformers/quicktour.html
BERT Bidirectional Encoder Representations from Transformers
一种从Transformers模型得来的双向编码表征模型
下面通过理论和实践两部分来解释BERT模型
1.理论：
1.1 为什么需要BERT
1.2 它背后的核心思想是什么
1.3 它是如何工作的
1.4 我们什么时候可以使用它并且对其进行微调

2.实践

# 1.理论
## 1.1 为什么需要BERT
NLP的最大挑战之一是缺乏足够的培训数据。总体而言，有大量文本数据可用，但是如果我们要创建特定于任务的数据集，则需要将该堆拆分为许多不同的类型。而当我们这样做时，我们最终仅得到数千或数十万个人工标记的训练样本。但是，为了表现良好，基于深度学习的NLP模型需要大量数据-在数百万或数十亿的带注释的训练样本上进行训练时，他们看到了重大改进。为了解决上面的数据问题，研究人员开发了多种技术，可在网络上使用大量未注释的文本来训练通用语言表示模型（这被称为预训练）。然后，可以在较小的用于特定任务的数据集上微调这些通用的预训练模型，例如，在处理诸如问题回答和情感分析之类的问题。与从头开始对较小的特定于任务的数据集进行训练相比，此方法可显着提高准确性。BERT是用于NLP预训练的最新的技术。它在深度学习社区引起了轰动，因为它在各种NLP任务（例如问题解答）中都提供了最先进的结果。

关于BERT的最好的部分是可以免费下载和使用-我们可以使用BERT模型从文本数据中提取高质量的语言特征，也可以根据特定任务（例如情感分析）微调这些模型并使用我们自己的数据回答问题，以产生最先进的预测。
## 1.2 它背后的核心思想是什么
语言建模的真正意义是什么？语言模型试图解决哪些问题？基本上，他们的任务是根据上下文“填补空白”。例如，给定

“那个女人去商店买了_____鞋。”
'The woman went to the store and bought a __ of shoes'

语言模型可能会说20%是'cart'，80%是'pair'

在BERT模型出现之前，语言模型会在训练期间从左到右或这将从左到右和从右到左的结合来查看此文本序列。这种单向方法很适合生成句子-我们可以预测下一个单词，将其附加到序列中，然后预测下一个单词的下一个单词，直到获得完整的句子。

现在使用BERT模型，这是一种经过双向训练的语言模型（这也是其关键的技术创新）。这意味着与单向语言模型相比，我们现在可以对语言上下文和流程有更深刻的了解。

BERT并没有预测序列中的下一个单词，而是使用一种称为Masked LM（MLM）的新颖技术：它 随机屏蔽句子中的单词，然后尝试预测它们。掩蔽Mask意味着该模型从两个方向看，并且它使用句子的整个上下文（包括左边和右边的语境）来预测被掩盖的单词。与以前的语言模型不同，它同时考虑了前一个和下一个tokens令牌  。LSTM模型将从左到右和从右到左相结合，并没有同时考虑这两个方向。（不过，说BERT是无方向性的可能更准确。）

额外提出一个问题，为什么这个无方向性的方法这么有效呢？
预训练语言表示分为context-free(和上下文无关)和context-based(基于上下文).
context-based表示可以是单向或者双向。
context-free表示,例如word2vec产生了一个简单的词嵌入(数字向量)表示词汇表中的每一个词语。
例如bank将会有相同的context-free表示在'bank account'和'bank of river'中。

另一方面，基于上下文的模型建立代表每一个词语的表示是基于句子中的其他词语。
例如:I accessed the bank account
在单向网络模型中，词语bank是基于I accessed the bank 而不是 account
但是，在BERT中，bank是使用了其上下文 I accessed the ... account
它从深度神经网络的最底层开始，使其深度双向化。

而且，BERT是基于Transformer model architecture(Transformer模型架构),而不是LSTM，我们很快就会讨论BERT的细节，但是总体而言:
Transformer通过执行少量恒定的步骤来工作。在每个步骤中，它都会应用一种注意力机制来理解句子中所有单词之间的关系，而不管它们各自的位置如何。例如，给定句子'I arrive at the bank after crossing the river'，以确定‘bank’一词是指河岸而不是金融机构，那么Transformer可以学会立即注意单词“ river”，然后一步一步做出决定。

现在，我们了解了BERT的关键思想，让我们深入研究细节。

## 1.3 它是如何工作的
BERT依赖于Transformer（一种学习文本中单词之间的上下文关系的注意力机制）。一个基本的Transformer包括一个读取文本输入的编码器和一个对任务进行预测的解码器。由于BERT的目标是生成语言表示模型，因此只需要编码器部分即可。BERT编码器的输入是一系列令牌，这些令牌首先被转换为矢量，然后在神经网络中进行处理。但是在开始处理之前，BERT需要对输入进行处理并用一些额外的元数据修饰：
令牌嵌入：在第一个句子的开头将[CLS]令牌添加到输入的单词令牌中，并在每个句子的末尾插入[SEP]令牌。
段嵌入：将指示句子A或句子B的标记添加到每个标记。这允许编码器区分句子。
位置嵌入：将位置嵌入添加到每个标记，以指示其在句子中的位置。
![](BERT输入.png)
BERT输入表示：输入嵌入是令牌嵌入、分段嵌入和位置嵌入的总和

本质上，Transformer会堆叠一个将序列映射到序列的层，因此输出也是对应索引的输入和输出令牌之间一对一对应关系的向量序列。而且正如我们之前所了解的，BERT不会尝试预测句子中的下一个单词。培训使用以下两种策略：

### 1.3.1 Masked LM (MLM)
这里的想法很简单：随机掩盖输入中15％的单词（用[MASK]令牌替换），通过基于BERT注意的编码器运行整个序列，然后根据序列中其他未屏蔽单词提供的上下文来预测被掩盖的词语。但是，这种掩盖方法存在一个问题-模型仅在输入中存在[MASK]令牌的时候尝试预测，而我们希望模型在不管输入中有什么令牌的时候，都尝试预测正确的令牌。输入。要解决此问题，15％用于屏蔽的令牌中：

实际上有80％的令牌已替换为令牌[MASK]。
10％的令牌被替换为随机令牌。
10％的令牌保持不变。
在训练BERT损失函数时，仅考虑掩蔽标记的预测，而忽略非掩蔽标记的预测。这导致模型收敛的速度比从左至右或从右至左的模型慢得多。

### 1.3.2 Next Sentence Prediction(NSP)
为了理解两个句子之间的关系，BERT训练过程还使用下一个句子预测。具有这种理解的预训练模型与诸如回答问题之类的任务有关。在训练过程中，该模型接受句子的输入对，并且学习预测第二个句子是否也是原始文本中的下一个句子。

如前所述，BERT使用特殊的[SEP]标记分隔句子。在训练过程中，模型每次输入两个输入语句，从而：

第二句话是第一句话之后的概率是50％。
有50％的概率是整个语料库中的随机句子。

然后要求BERT预测第二个句子是否是随机的，并假设该随机句子将与第一个句子断开：
![](BERT句子预测.png)

为了预测第二句话是否与第一句话相连，基本上整个输入序列都会经过基于Transformer的模型，使用简单的分类层将[CLS]令牌的输出转换为2×1形状的矢量，并使用softmax确认IsNext-Label标签。

结合使用“Marked LM”和“下一句预测”对模型进行训练。这是为了最小化这两种策略的组合损失函数-  “在一起更好”。

### 1.3.4 结构
有4种类型的BERT预训练版本，取决于模型结构的大小
BERT-Base：12层，768个隐藏节点，12个注意点，110M参数
BERT-Large：24层，1024个隐藏节点，16个注意点，340M参数

有趣的事实：BERT-Base在4个云TPU上进行了4天的训练，而BERT-Large在16个TPU上进行了4天的训练！

## 1.4 我们什么时候可以使用它并且对其进行微调
在一般语言理解（例如自然语言推理，情感分析，问题回答，释义检测和语言可接受性）下，BERT在各种任务上的表现都超过了最新技术。

现在，我们如何针对特定任务对其进行微调？BERT可用于多种语言任务。如果要基于自己的数据集微调原始模型，可以通过在核心模型的顶部添加一个单独的层来实现。

例如，假设我们正在创建一个问答应用程序。本质上，问题解答只是一项预测任务-在收到问题作为输入时，应用程序的目标是从某个语料库中识别正确的答案。因此，给定一个问题和一个上下文段落，该模型将从最有可能回答该问题的段落中预测一个开始和结束标记。这意味着使用BERT可以通过学习两个标记答案开头和结尾的额外矢量来训练我们应用程序的模型。
![](BERT回答.png)

就像句子对任务一样，问题将成为输入序列中的第一个句子，第二个句子成为段落。但是，这一次在微调期间学习了两个新参数：起始向量和结束向量。

在微调训练中，大多数超参数保持与BERT训练中相同；本文针对需要调整的超参数给出了具体指导。

请注意，如果要进行微调，我们需要将输入转换为用于预训练核心BERT模型的特定格式，例如，我们需要添加特殊标记以标记开始（[CLS ]）以及句子的分隔/结尾（[SEP]）和用于区分不同句子的句段ID －将数据转换为BERT使用的特征。

# 2.实践
实践环境:ubuntu python torch transformers


