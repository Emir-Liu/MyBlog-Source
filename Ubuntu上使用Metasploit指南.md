---
title: Ubuntu上使用Metasploit指南
date: 2019-09-16 06:27:53
tags: Metasploit
---
# 1.安装
进入官网安装Metasploit，选择开源版本，进入到git找到Metasploit的快速安装方法。
```bash
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall
```
注意，需要安装curl包。

然后，Metasploit默认使用postgres数据库，安装postgres数据库。

当然,也可以使用其他数据库，不过先不管了。

# 2.启动Metasploit
首先启动数据库
```bash
service postgresql start
```
查看数据库服务是否开启
```bash
netstat -tnpl | grep postgres
```
进入msfconsole
```bash
msfconsole
```

# 3.Metasploit操作
## 3.1漏洞扫描
```bash
nmap -v 192.168.1.1/24 --script vuln -Pn -O
```
关于nmap
-v 增加详细程度
--script 脚本
vuln	检测目标机是否有常见漏洞
-Pn 	将所有主机视为在线
-O	启动系统检测

namp脚本:
auth: 负责处理鉴权证书（绕开鉴权）的脚本
broadcast: 在局域网内探查更多服务开启状况，如dhcp/dns/sqlserver等服务
brute: 提供暴力破解方式，针对常见的应用如http/snmp等
default: 使用-sC或-A选项扫描时候默认的脚本，提供基本脚本扫描能力
discovery: 对网络进行更多的信息，如SMB枚举、SNMP查询等
dos: 用于进行拒绝服务攻击
exploit: 利用已知的漏洞入侵系统
external: 利用第三方的数据库或资源，例如进行whois解析
fuzzer: 模糊测试的脚本，发送异常的包到目标机，探测出潜在漏洞 intrusive: 入侵性的脚本，此类脚本可能引发对方的IDS/IPS的记录或屏蔽
malware: 探测目标机是否感染了病毒、开启了后门等信息
safe: 此类与intrusive相反，属于安全性脚本
version: 负责增强服务与版本扫描（Version Detection）功能的脚本
vuln: 负责检查目标机是否有常见的漏洞（Vulnerability），如是否有MS08_067

关于扫描漏洞的结果:
NSE(Nmap Script Engine)是Nmap最强大，最灵活的功能之一。它允许用户编写（和共享）简单脚本，以自动执行各种网络任务。然后，这些脚本将与您期望从Nmap获得的速度和效率并行执行。用户可以依赖分布在Nmap上的不断增长的各种脚本，或者编写自己的脚本来满足自定义需求。

DNS（Domain Name Resolution）域名解析是把域名指向网站空间IP，让人们通过注册的域名可以方便地访问到网站的一种服务。IP地址是网络上标识站点的数字地址，为了方便记忆，采用域名来代替IP地址标识站点地址。域名解析就是域名到IP地址的转换过程。域名的解析工作由DNS服务器完成。把域名解析到一个IP地址，然后在此IP地址的主机上将一个子目录与域名绑定。
互联网中的地址是数字的IP地址，域名解析的作用主要就是为了便于记忆。

SYN扫描:
SYN扫描是恶意黑客不建立完全连接，用来判断通信端口状态的一种手段。这种方法是最老的一种攻击手段，有时用来进行拒绝服务攻击。
SYN扫描也称半开放扫描。在SYN扫描中，恶意客户企图跟服务器在每个可能的端口建立TCP/IP连接。这通过向服务器每个端口发送一个SYN数据包，装作发起一个三方握手来实现。如果服务器从特定端口返回SYN/ACK（同步应答）数据包，则意味着端口是开放的。然后，恶意客户程序发送一个RST数据包。结果，服务器以为存在一个通信错误，以为客户端决定不建立连接。开放的端口因而保持开放，易于受到攻击。如果服务器从特定端口返回一个RST数据包，这表示端口是关闭的，不能攻击。通过向服务器连续发送大量的SYN数据包，黑客能够消耗服务器的资源。由于服务器被恶意客户的请求所淹没，不能或者只能跟很少合法客户建立通信。

SYN Stealth Scan
