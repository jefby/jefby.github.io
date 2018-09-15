---
title: Arndale Octa配置OpenCL环境
date: 2018-09-15 20:48:33
tags:
- Linux
- ARM
- Arndale Octa
categories:
- Arndale Octa
---


最近想要使用OpenCL来加速sift算法，刚好手头有开发板arndale octa，算是物尽其用吧。。。

>Linaro14.04 for arndale octa内核默认没有mali驱动，我们需要修改内核并重新编译，如下是具体步骤

### 1、编译支持mali驱动的内核r4p0

```
git clone https://git.linaro.org/gwg/linaro-lsk.git 
git checkout lsk-v3.14-lt-mali-r4p0-beta2
```

如下是自动化脚本, build.sh

```bash
# build on Arndale OCTA board
# Working linaro image for sd card can be found at: http://releases.linaro.org/14.04/ubuntu/arndale-octa

set -x
set -e
# Initial config
# 生成kernel配置
./scripts/kconfig/merge_config.sh linaro/configs/linaro-base.conf linaro/configs/distribution.conf linaro/configs/arndale_octa.conf linaro/configs/lt-arndale_octa.conf linaro/configs/mali-arndale-octa.conf

# build，编译内核
MINOR_VERSION=4
make zreladdr-y=0x20008000 LOCALVERSION=  KERNELVERSION=3.14.0-${MINOR_VERSION}-linaro-arndale-octa -j4 zImage modules dtbs
sudo make LOCALVERSION=  KERNELVERSION=3.14.0-${MINOR_VERSION}-linaro-arndale-octa modules_install

# Mount boot partition, prepare for installkernel
sudo mount /dev/mmcblk1p2 /media/boot
sudo rm -r /boot/*

# Install kernel
kernelversion=`cat ./include/config/kernel.release`
sudo installkernel $kernelversion ./arch/arm/boot/zImage ./System.map /boot

# Install device tree binary
sudo cp arch/arm/boot/dts/exynos5420-arndale-octa.dtb /media/boot/board.dtb

# Reboot
sudo sync
sudo umount /media/boot
#sudo reboot
echo "finished"

```

顺利的话，会输出"finished"，重启

```bash
reboot 
```

查看是否生效，如果正常会类似如下：

![iV34eJ.png](https://s1.ax1x.com/2018/09/15/iV34eJ.png)

### 2. 下载user-space驱动

Arndale octa使用的是Exynos 5420，GPU为6核心的Mali-T628，官方下载链接如下：

[https://developer.arm.com/products/software/mali-drivers/user-space](https://developer.arm.com/products/software/mali-drivers/user-space)

找到malit62xr4p002rel0linux1fbdevtar.gz，解压缩后拷贝到/usr/lib目录，直接下载地址:

[https://developer.arm.com/-/media/Files/downloads/mali-drivers/user-space/archive/arndale-octa/malit62xr4p002rel0linux1fbdevtar.gz?revision=c1026f2b-1b1f-430a-be17-6e1949c79463
](https://developer.arm.com/-/media/Files/downloads/mali-drivers/user-space/archive/arndale-octa/malit62xr4p002rel0linux1fbdevtar.gz?revision=c1026f2b-1b1f-430a-be17-6e1949c79463)



### 3. 客户端创建配置mali.icd

创建文件/etc/OpenCL/vendors/mali.icd
内容如下：

`/usr/lib/libmali.so`


### 4. 下载OpenCL-Mali-SDK测试

下载OpenCL-Mali-SDK-1.1，官方已经不再提供了，在github上有之前的备份：

```bash
git clone https://github.com/jefby/Mali_OpenCL_SDK
git checkout 1.1.0
sudo -s
cd samples/hello_world_opencl
make
./hello_world_opencl
```

结果如下：

![iV8iSf.png](https://s1.ax1x.com/2018/09/15/iV8iSf.png)








