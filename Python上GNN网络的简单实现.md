---
title: Python上GNN网络的简单实现
date: 2020-07-06 17:29:49
tags:
- python
- gnn
---
# 0.简介
通过python实现原始GNN，数据为自己随机设定的，用于验证原始GNN的模型。

# 1.具体操作
实现代码中包含下面的部分：
1.1 数据输入
1.2 数据图显示
1.3 模型构建
1.4 模型训练和评估
1.5 画出loss和acc曲线

## 1.1 数据输入
导入必须的模块，然后输入数据
无向图有多个点，每个点由线连接，然后每个点都有3个label{0,1,2}

```bash
import os
import json
import scipy
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt

import torch
import torch.nn as nn
import torch.optim as optim
from torch.autograd import Variable

# (node, label)集
N = [("n{}".format(i), 0) for i in range(1,7)] + \
    [("n{}".format(i), 1) for i in range(7,13)] + \
    [("n{}".format(i), 2) for i in range(13,19)]
# 边集
E = [("n1","n2"), ("n1","n3"), ("n1","n5"),
     ("n2","n4"),
     ("n3","n6"), ("n3","n9"),
     ("n4","n5"), ("n4","n6"), ("n4","n8"),
     ("n5","n14"),
     ("n7","n8"), ("n7","n9"), ("n7","n11"),
     ("n8","n10"), ("n8","n11"), ("n8", "n12"),
     ("n9","n10"), ("n9","n14"),
     ("n10","n12"),
     ("n11","n18"),
     ("n13","n15"), ("n13","n16"), ("n13","n18"),
     ("n14","n16"), ("n14","n18"),
     ("n15","n16"), ("n15","n18"),
     ("n17","n18")]
```

## 1.2 数据图显示
```bash
# 构建Graph
G = nx.Graph()
G.add_nodes_from(list(map(lambda x: x[0], N)))
G.add_edges_from(E)
# 设置Graph显示属性，包括颜色，形状，大小
ncolor = ['r'] * 6 + ['b'] * 6 + ['g'] * 6
nsize = [700] * 6 + [700] * 6 + [700] * 6
# 显示Graph
plt.figure(1)
nx.draw(G, with_labels=True, font_weight='bold', 
        node_color=ncolor, node_size=nsize)
# plt.savefig("./images/graph.png")
```
## 1.3 模型构建
首先，从训练函数开始
```bash
train_loss, train_acc, test_acc = train(node_list=list(map(lambda x:x[0], N)),
                                        edge_list=E,
                                        label_list=list(map(lambda x:x[1], N)),
                                        T=5)
```
下面是训练的具体内容，在这里，我们需要先补充一下关于torch中的
```bash
# 开始训练模型
def train(node_list, edge_list, label_list, T, ndict_path="./node_dict.json"):
    # 生成node-index字典
    if os.path.exists(ndict_path):
        with open(ndict_path, "r") as fp:
            node_dict = json.load(fp)
    else:
        node_dict = dict([(node, ind) for ind, node in enumerate(node_list)])
        node_dict = {"stoi" : node_dict,
                     "itos" : node_list}
        with open(ndict_path, "w") as fp:
            json.dump(node_dict, fp)

    # 现在需要生成两个向量
    # 第一个向量类似于
    #   [0, 0, 0, 1, 1, ..., 18, 18]
    # 其中的值表示节点的索引，连续相同索引的个数为该节点的度
    # 第二个向量类似于
    #   [1, 2, 4, 1, 4, ..., 11, 13]
    # 与第一个向量一一对应，表示第一个向量节点的邻居节点

    # 首先统计得到节点的度
    Degree = dict()
    for n1, n2 in edge_list:
        # 边的第一个节点的邻接节点为第二个节点
        if n1 in Degree:
            Degree[n1].add(n2)
        else:
            Degree[n1] = {n2}
        # 边的第二个节点的邻接节点为第一个节点
        if n2 in Degree:
            Degree[n2].add(n1)
        else:
            Degree[n2] = {n1}
    
    # 然后生成两个向量
    node_inds = []
    node_neis = []
    for n in node_list:
        node_inds += [node_dict["stoi"][n]] * len(Degree[n])
        node_neis += list(map(lambda x: node_dict["stoi"][x],list(Degree[n])))
    # 生成度向量
    dg_list = list(map(lambda x: len(Degree[node_dict["itos"][x]]), node_inds))
    # 准备训练集和测试集
    train_node_list = [0,1,2,6,7,8,12,13,14]
    train_node_label = [0,0,0,1,1,1,2,2,2]
    test_node_list = [3,4,5,9,10,11,15,16,17]
    test_node_label = [0,0,0,1,1,1,2,2,2]
    
    # 开始训练
    model = OriLinearGNN(node_num=len(node_list),
                         feat_dim=2,
                         stat_dim=2,
                         T=T)
    optimizer = torch.optim.Adam(model.parameters(), lr=0.01, weight_decay=0.01)
    criterion = nn.CrossEntropyLoss(size_average=True)
    
    min_loss = float('inf')
    train_loss_list = []
    train_acc_list = []
    test_acc_list = []
    node_inds_tensor = Variable(torch.Tensor(node_inds).long())
    node_neis_tensor = Variable(torch.Tensor(node_neis).long())
    train_label = Variable(torch.Tensor(train_node_label).long())
    for ep in range(500):
        # 运行模型得到结果
        res = model(node_inds_tensor, node_neis_tensor, dg_list) # (V, 3)
        train_res = torch.index_select(res, 0, torch.Tensor(train_node_list).long())
        test_res = torch.index_select(res, 0, torch.Tensor(test_node_list).long())
        loss = criterion(input=train_res,
                         target=train_label)
        loss_val = loss.item()
        train_acc = CalAccuracy(train_res.cpu().detach().numpy(), np.array(train_node_label))
        test_acc = CalAccuracy(test_res.cpu().detach().numpy(), np.array(test_node_label))
        # 更新梯度
        optimizer.zero_grad()
        loss.backward(retain_graph=True)
        optimizer.step()
        # 保存loss和acc
        train_loss_list.append(loss_val)
        test_acc_list.append(test_acc)
        train_acc_list.append(train_acc)
        
        if loss_val < min_loss:
            min_loss = loss_val
        print("==> [Epoch {}] : loss {:.4f}, min_loss {:.4f}, train_acc {:.3f}, test_acc {:.3f}".format(ep, loss_val, min_loss, train_acc, test_acc))
    return train_loss_list, train_acc_list, test_acc_list
```

```bash
# 实现GNN模型
class OriLinearGNN(nn.Module):
    def __init__(self, node_num, feat_dim, stat_dim, T):
    #在python3中super().xxx可以代替super(class,self).xx
        super(OriLinearGNN, self).__init__()
        self.embed_dim = feat_dim
        self.stat_dim = stat_dim
        self.T = T
        # torch.nn.Embedding
        # torch.nn.Embedding(num_embeddings, embedding_dim, padding_idx=None, max_norm=None, norm_type=2.0, 
        # scale_grad_by_freq=False,   sparse=False, _weight=None)
        # 一个简单的查找表，用于存储固定字典和大小的嵌入
        # 该模块通常用于存储单元嵌入并使用索引检索它们，模块的输入是索引列表，输出是相应的词嵌入。 
        # num_embeddings            :嵌入字典的大小
        # embedding_dim             :每个嵌入向量的大小
        # padding_idx=None          
        # max_norm=None
        # norm_type=2.0
        # scale_grad_by_freq=False
        # sparse=False
        # _weight=None
        # 初始化节点的embedding，即节点特征向量 (V, ln)
        self.node_features = nn.Embedding(node_num, feat_dim)
        # 初始化节点的状态向量 (V, s)
        self.node_states = torch.zeros((node_num, stat_dim))
        # 输出层
        self.linear = nn.Linear(feat_dim+stat_dim, 3)
        self.softmax = nn.Softmax()
        # 实现Fw
        self.Hw = Hw(feat_dim, stat_dim)
        # 实现H的分组求和
        self.Aggr = AggrSum(node_num)
        
    # Input : 
    #    X_Node : (N, )
    #    X_Neis : (N, )
    #    H      : (N, s)
    #    dg_list: (N, )
    def forward(self, X_Node, X_Neis, dg_list):
        node_embeds = self.node_features(X_Node)  # (N, ln)
        neis_embeds = self.node_features(X_Neis)  # (N, ln)
        X = torch.cat((node_embeds, neis_embeds), 1)  # (N, 2 * ln)
        # 循环T次计算
        for t in range(self.T):
            # (V, s) -> (N, s)
            H = torch.index_select(self.node_states, 0, X_Node)
            # (N, s) -> (N, s)
            H = self.Hw(X, H, dg_list)
            # (N, s) -> (V, s)
            self.node_states = self.Aggr(H, X_Node)
#             print(H[1])
        out = self.linear(torch.cat((self.node_features.weight, self.node_states), 1))
        out = self.softmax(out)
        return out  # (V, 3)

```
## 1.4 模型训练和评估
## 1.5 画出loss和acc曲线

