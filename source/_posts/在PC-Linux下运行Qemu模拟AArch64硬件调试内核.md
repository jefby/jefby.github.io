---
title: 在PC-Linux下运行Qemu模拟AArch64硬件调试内核
date: 2015-04-06 13:28:22
tags: 
- aarch64
categories:
- aarch64
---

参考链接：
http://www.bennee.com/~alex/blog/2014/05/09/running-linux-in-qemus-aarch64-system-emulation-mode/

环境说明：
Fedora21 x86_64

ARM公司推出ARM V8架构后，全面进入64位CPU时代，可是目前市场上出现的设备太少或者说性价比不高，但是又想做相关平台下的开发，那么可以考虑下使用qemu模拟器

安装aarch64-qemu：

```
$sudo yum install -y qemu-system-aarch64
```

如果想快速使用模型，可以下载这个镜像：
http://people.linaro.org/~alex.bennee/images/aarch64-linux-3.15rc2-buildroot.img
然后运行命令：

```
$qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -nographic -smp 1 -m 2048 -kernel aarch64-linux-3.15rc2-buildroot.img  --append "console=ttyAMA0"
```

输入root，免密码登陆：
![查看配置](http://img.blog.csdn.net/20150406124814496)
当然还可能需要使用qemu来调试Linux内核，那么需要使用buildroot来构建根文件系统，然后再次配置编译内核，最后启动gdb连接到gdbserver上来进行内核调试和分析：
1.下载和编译buildroot
(1)下载buildroot，2015-02稳定版
http://buildroot.uclibc.org/download.html
(2)配置和编译

```
$tar -xjvf buildroot-2015.02.tar.bz2
$cd buildroot-2015.02
$make menuconfig
```

选用externel cross-compiler，Linaro 14.09，选择安装路径，然后到Linaro官网下载对应的编译器，不要使用yum来安装对应的编译器，因为红帽公司打包的交叉编译器缺少kernel头文件，我把我的配置文件放到了百度网盘，可以参考：
http://pan.baidu.com/s/176ef0
Linaro 14.09交叉编译器的链接地址：
https://releases.linaro.org/14.09/components/toolchain/binaries
下载gcc-linaro-aarch64-linux-gnu-4.9-2014.09_linux.tar.bz2，解压缩到目录/opt/，修改名称并再buildroot中配置路径，然后编译，顺利的话会在目录output/images/生成rootfs.cpio文件，即为根文件系统。
(3)下载并配置编译内核
到kernel.org下载最新版内核，配置initramfs使用buildroot生成的根文件系统，配置架构和交叉工具，编译

```
$ARCH=arm64 make menuconfig
$ARCH=arm64 make -j 8
```

参考配置文件：
http://pan.baidu.com/s/1i35pWwP
成功会在arch/arm64/boot/目录生成Image文件，然后使用以下命令启动：

```
$qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -nographic -smp 1 -m 2048 -kernel /home/jefby/linux-3.19.3/arch/arm64/boot/Image  --append "console=ttyAMA0"
```

(4)调试内核

```
$  qemu-system-aarch64 -s -S -machine virt -cpu cortex-a57 -machine type=virt -nographic -smp 1 -m 2048 -kernel /home/jefby/linux-3.19.3/arch/arm64/boot/Image  --append "console=ttyAMA0"
```

此时内核启动，并使用gdbserver打开了1234端口供gdb客户端连接，本地打开terminal，输入以下命令：

```
$cd linux-3.19.3
$aarch64-linux-gnu-gdb
$file vmlinux
$target remote localhost:1234
$b start_kernel
$c
$n 
```

如图所示：
![这里写图片描述](http://img.blog.csdn.net/20150406132804121)