---
title: "在aarch64主机中使用qemu设置网络"
date: 2016-12-07 01:03:53
tags: 
- aarch64
categories:
- aarch64
---

在上一篇文章《在aarch64主机中使用qemu启动虚机》，介绍了如何使用用户网络模式来启动虚拟机，但是这种模式有很多缺点，例如不能和其他虚机通信，不能使用ping测试通信等。所以在这篇中讲述如何使用tap模式来启动虚机。

该模型为私有虚拟局域网模型，只允许在本host机器上访问，不会影响到host机器网络.
![tap网络](https://wiki.libvirt.org/images/d/d4/Host_with_a_virtual_network_switch_in_nat_mode_and_two_guests.png)

#### 1. 安装libvirt daemon

```
yum install -y libvirt-daemon
```

#### 2. 启动libvirtd 

```
service libvirtd start
```

#### 3. 使用新脚本启动镜像



```
#!/bin/sh

if [ $# -ne 1 ];then
  echo "Usage: $0 network-mode[user|tap]"
  echo "e.g.: $0 user"
  echo "      $0 tap"
  exit
fi


if [ $1 == "user" ];then
  # User Networking Mode
  qemu-system-aarch64 -smp 4 -m 8092 -M virt -bios QEMU_EFI.fd -nographic \
       -device virtio-blk-device,drive=image \
       -drive if=none,id=image,file=xenial-server-cloudimg-arm64-uefi1.qcow2,format=qcow2 \
       -device virtio-blk-device,drive=cloud \
       -drive if=none,id=cloud,file=cloud.img,format=raw \
       -netdev user,id=user0,hostfwd=tcp::2222-:22 -device virtio-net-device,netdev=user0 \
       -enable-kvm -cpu host
elif [ $1 == "tap" ];then
  # Tap Networking Mode [Private Virtual Network]
  macaddress=52:54:00:4a:1e:d4
  qemu-system-aarch64 -smp 4 -m 8092 -M virt -bios QEMU_EFI.fd -nographic \
       -device virtio-blk-device,drive=image \
       -drive if=none,id=image,file=xenial-server-cloudimg-arm64-uefi1.qcow2,format=qcow2 \
       -device virtio-blk-device,drive=cloud \
       -drive if=none,id=cloud,file=cloud.img,format=raw \
       -device virtio-net-device,netdev=network0,mac=$macaddress \
       -netdev tap,id=network0,ifname=tap0,script=qemu-ifup.sh,downscript=no  \
       -enable-kvm -cpu host
fi
```

依赖的qemu-ifup.sh


```
#!/bin/sh

set -x

switch=virbr0

if [ -n "$1" ];then
        # tunctl -u `whoami` -t $1 (use ip tuntap instead!)
        ip tuntap add $1 mode tap user `whoami`
        ip link set $1 up
        sleep 0.5s
        # brctl addif $switch $1 (use ip link instead!)
        ip link set $1 master $switch
        exit 0
else
        echo "Error: no interface specified"
        exit 1
fi
```


使用方法：

`./start_vm.sh tap`

#### 4. 查看ip


```
sudo virsh net-dhcp-leases default
```


结果如下图：

[![Ph8QQU.md.png](https://s1.ax1x.com/2018/08/19/Ph8QQU.md.png)](https://imgchr.com/i/Ph8QQU)

然后使用ssh登录即可