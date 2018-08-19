---
title: PC创建并使用aarch64虚拟机
date: 2018-08-19 14:32:42
tags:
- aarch64
categories:
- aarch64
---

**如果不想从头自己做虚拟机，可使用这个镜像
链接: https://pan.baidu.com/s/1aQikk7nZWlvXn2EZIn_M3w 密码: 2123
使用方法：
参考第4步，直接启动就可以，用户名和密码都是jefby**

----------

大部分人电脑都是x86_64，但有时候我们需要开发运行在arm64设备的程序，这时候arm64虚拟机就非常有用了，如下是详细步骤

#### 1. qemu-system-arm

直接用apt安装 `sudo apt install -y qemu-system-arm`
或者是从源码安装
```	
wget https://download.qemu.org/qemu-2.12.1.tar.bz2
tar -xjvf qemu-2.12.1.tar.bz2
cd qemu-2.12.1/
./configure –-target-list=aarch64-softmmu
make -j16
sudo make install
```
源码安装需要注意，创建/etc/qemu-ifup文件，内容如下：
```	
#!/bin/sh 
/sbin/ifconfig $1 192.168.0.1
```
完成后增加执行权限
`chmod +x /etc/qemu-ifup`
	
#### 2. 下载ubuntuarm64.iso
http://cdimage.ubuntu.com/releases/16.04/release/
	
创建40G大小的镜像，格式为qcow2，相比raw有个优势，比如同样创建40G的镜像，qcow2格式的size是真正使用的size而不是40G
[![Pfv3h8.md.png](https://s1.ax1x.com/2018/08/19/Pfv3h8.md.png)](https://imgchr.com/i/Pfv3h8)
```
qemu-img create -f qcow2  ubuntu16.04-arm64.qcow2 40G
```
	
#### 3. 创建虚拟机ubuntu16.04-arm64.qcow2并安装ubuntu16.04.5系统

```
qemu-system-aarch64 -m 2048-cpu cortex-a57 -smp 2 -M virt -bios QEMU_EFI.fd -nographic -drive if=none,file=ubuntu-16.04.5-server-arm64.iso,id=cdrom,media=cdrom -device virtio-scsi-device -device scsi-cd,drive=cdrom -drive if=none,file=ubuntu16.04-arm64.qcow2,id=hd0 -device virtio-blk-device,drive=hd0
```
![PfvM7t.png](https://s1.ax1x.com/2018/08/19/PfvM7t.png)
**注意选择OpenSSH Server**
理论上如果顺利的话会自动出现登录界面，进入后如下
[![PfvlAP.md.png](https://s1.ax1x.com/2018/08/19/PfvlAP.md.png)](https://imgchr.com/i/PfvlAP)

####	4. 关机后重新启动命令
	
```
qemu-system-aarch64 -m 2048 -cpu cortex-a57 -smp 2 -M virt -bios QEMU_EFI.fd -nographic -device virtio-scsi-device -drive if=none,file=ubuntu16.04-arm64.qcow2,id=hd0 -device virtio-blk-device,drive=hd0  -netdev type=tap,id=net0 -device virtio-net-device,netdev=net0
```

####	5. 关于UEFI启动后第一项无法自动进入ubuntu解决方法

进入UEFI 界面，在uefi shell中输入exit后在Boot Maintenance Manager进入Boot Options，选择Add Boot Option 依次选择boot/efi/ubuntu/grubaa64.efi，并设置boot order，将添加的boot option放在第一个
[![PfvcjJ.md.png](https://s1.ax1x.com/2018/08/19/PfvcjJ.md.png)](https://imgchr.com/i/PfvcjJ)
[![Pfv2u9.md.png](https://s1.ax1x.com/2018/08/19/Pfv2u9.md.png)](https://imgchr.com/i/Pfv2u9)
####	6. 设置网络
	
Host :
	
```
sudo ifconfig tun0 192.168.0.1
```
Virtual machine:

```
sudo ifconfig eth0 up
sudo ifconfig eth0 192.168.0.2
```
	
#### 7. 登录
在主机端ssh user-name@192.168.0.2输入密码即可登录





#### 参考文章
https://blog.csdn.net/chenxiangneu/article/details/78955462

