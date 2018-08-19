---
title: 使用Qemu调试内核(host=aarch64)
date: 2016-03-26 20:50:42
tags: 
- aarch64
categories:
- aarch64
---

在前一篇文章http://blog.csdn.net/jefbai/article/details/44901447
已经介绍过主机为x86_64的情况下如何进行内核调试，但是如果主机换做AArch64呢？？方法类似～

1、编译qemu-system-aarch64

>git clone https://github.com/qemu/qemu
>./configure && make -j8 

随后将该目录添加到PATH变量并source ~/.bashrc

2、 下载并编译内核

>git clone https://git.fedorahosted.org/git/kernel-arm64.git
>make -j8 Image 

3、安装gdb和gcc-c++
4、调试内核（本机，也可以通过网络）
qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine       ↪ type=virt -nographic -smp 1 -m 2048 -kernel arch/arm64/boot/   ↪ Image  --append "console=ttyAMA0" -s -S
-s表示加入 gdb debug的功能，-S是让kernel停在第一行指令，不要往下跑。（可以写成脚本）
cd kernel-arm64
gdb ./vmlinux
target remote localhost:1234

![run first scene](http://img.blog.csdn.net/20160326204802361)
5、此时可以使用gdb进行内核调试了
例如
>b start_kernel
>c

![kernel](http://img.blog.csdn.net/20160326205007112)

