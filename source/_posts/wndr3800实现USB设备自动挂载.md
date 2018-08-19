---
title: "wndr3800 实现USB设备自动挂载"
date: 2014-05-23 13:03:53
tags: 
- Linux
- OpenWrt
categories:
- Linux
---

WNDR3800路由器有USB2.0接口，但是插上USB存储设备后，并没有像在Linux下那样，在/dev目录下有诸如sda,sdb等设备名，所以也不能提供设备访问。那么需要重新编译内核以支持设备的自动探测和对NTFS，EXT4分区的支持。具体步骤如下：

进入trunk目录下，运行make menuconfig配置内核：
[![PhJUKO.md.png](https://s1.ax1x.com/2018/08/19/PhJUKO.md.png)](https://imgchr.com/i/PhJUKO)


* 配置BASE System => block mount选项，选中
* 配置Kernel Modules => Block Devices => kmod-scsi-generic
* 配置对文件系统的支持,NTFS（windows下常用）和EXT4（Linux下用）

  Kernel Modules => File System => kmod-fs-ext4
  NTFS支持，需要安装软件包ntfs-3g  
  配置 Utilities=> Filesystem =>ntfs-3g

* 保存退出，重新编译内核，并烧写系统到路由器中，使用ssh连接到路由器上，再次插入U盘，可以看到内核提示信息，然后使用mount命令挂载：

* 测试对NTFS分区的支持
  同样插入一个格式为NTFS分区的U盘或者移动硬盘
[![PhJdqe.md.png](https://s1.ax1x.com/2018/08/19/PhJdqe.md.png)](https://imgchr.com/i/PhJdqe)
