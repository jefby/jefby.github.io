---
title: 在aarch64主机中使用Qemu启动虚拟机
date: 2016-11-25 20:35:19
tags: 
- aarch64
categories:
- aarch64
---


### 1. host 

CentOS Linux release 7.2.1603 (AltArch) aarch64
kernel: 3.19.0-0.79.aa7a.aarch64

**检查内核是否支持kvm**

>$dmesg | grep -i kvm
[    0.364920] kvm [1]: GICH base=0x780c0000, GICV base=0x780e0000, IRQ=122
[    0.365026] kvm [1]: timer IRQ3
[    0.365039] kvm [1]: Hyp mode initialized successfully

### 2. 安装必须的包

```
sudo yum install -y qemu-system-aarch64
```

### 3. 下载uefi.img和QEMU_EFI.fd

```
wget https://releases.linaro.org/components/kernel/uefi-linaro/15.12/release/qemu64/QEMU_EFI.fd
wget https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cloud-images/xenial/20161124/xenial-server-cloudimg-arm64-uefi1.img 
```

### 4. 制作cloud.img


* 创建cloud.txt文件，内容如下，其中ssh-rsa换做你本地的id_rsa.pub

```
#cloud-config
 
users:
  - name: <your_username>
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1y....
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
```

* 创建cloud.img

```
# 根据cloud.txt内容创建镜像cloud.img
$cloud-localds cloud.img cloud.txt
```

### 5. 启动镜像

```
qemu-system-aarch64 -smp 4 -m 8092 -M virt -bios QEMU_EFI.fd -nographic \
       -device virtio-blk-device,drive=image \
       -drive if=none,id=image,file=xenial-server-cloudimg-arm64-uefi1.img \
       -device virtio-blk-device,drive=cloud \
       -drive if=none,id=cloud,file=cloud.img \
       -netdev user,id=user0,hostfwd=tcp::2222-:22 -device virtio-net-device,netdev=user0 \
       -enable-kvm -cpu host
```

### 6. 登录

```
ssh -p 2222 <your_username>@localhost
```

成功后如下所示：

```
[root@APM html]# ssh -p 2222 root@localhost
Welcome to Ubuntu 16.04.1 LTS (GNU/Linux 4.4.0-47-generic aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.


Last login: Fri Nov 25 12:22:42 2016 from 10.0.2.2
root@ubuntu:~# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.1 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.1 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial

```
