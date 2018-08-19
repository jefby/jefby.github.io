---
title: Linux用户空间和内核空间通信方式比较
date: 2014-09-21 06:46:22
tags: 
- Linux
categories:
- Linux
---

资料整理：

1.       论文，主要比较通信方式
http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=5696027

2.       stackoverflow部分讨论

http://stackoverflow.com/questions/8145943/communication-between-linux-kernel-and-user-space-program

3.       论文，主要讨论netlink

http://1984.lsi.us.es/~pablo/docs/spae.pdf

4.       介绍netlink的一篇博文，写的不错！

http://www.cnblogs.com/iceocean/articles/1594195.html

摘抄自4的博文：

netlink 相对于系统调用，ioctl 以及 /proc 文件系统而言具有以下优点：

1，为了使用 netlink，用户仅需要在 include/linux/netlink.h 中增加一个新类型的 netlink 协议定义即可， 如 #define NETLINK_MYTEST 17 然后，内核和用户态应用就可以立即通过 socket API 使用该 netlink 协议类型进行数据交换。但系统调用需要增加新的系统调用，ioctl 则需要增加设备或文件，那需要不少代码，proc 文件系统则需要在/proc下添加新的文件或目录，那将使本来就混乱的 /proc 更加混乱。

2. netlink是一种异步通信机制，在内核与用户态应用之间传递的消息保存在socket缓存队列中，发送消息只是把消息保存在接收者的socket的接收队列，而不需要等待接收者收到消息，但系统调用与 ioctl 则是同步通信机制，如果传递的数据太长，将影响调度粒度。

3．使用 netlink 的内核部分可以采用模块的方式实现，使用 netlink 的应用部分和内核部分没有编译时依赖，但系统调用就有依赖，而且新的系统调用的实现必须静态地连接到内核中，它无法在模块中实现，使用新系统调用的应用在编译时需要依赖内核。

4．netlink支持多播，内核模块或应用可以把消息多播给一个netlink组，属于该neilink 组的任何内核模块或应用都能接收到该消息，内核事件向用户态的通知机制就使用了这一特性，任何对内核事件感兴趣的应用都能收到该子系统发送的内核事件，在 后面的文章中将介绍这一机制的使用。

5．内核可以使用 netlink 首先发起会话，但系统调用和 ioctl 只能由用户应用发起调用。

6．netlink 使用标准的 socket API，因此很容易使用，但系统调用和 ioctl则需要专门的培训才能使用。



                                                                                                      jefby



