---
title: "dnsmasq TFTP directory /tftpd inaccessible: Permission denied"
date: 2015-03-25 17:24:47
tags: 
- Linux
categories:
- Linux
---

调试pxe的时候碰到了如下问题"dnsmasq TFTP directory /tftpd inaccessible: Permission denied"，记录下解决步骤:

### 背景
在fedora21 server版本中配置dnsmasq作为tftp服务器，修改配置文件/etc/dnsmasq.conf，增加如下选项：

```
enable-tftp
tftp-root=/tftpd
```

在根目录下创建文件夹tftpd，修改属主为nobody:nobody，然后启动dnsmasq服务器，总是不能启动起来，错误信息如下：

```
Mar 25 16:54:35 localhost dnsmasq[1787]: TFTP directory /tftpd inaccessible: Permission denied
Mar 25 16:54:35 localhost dnsmasq[1787]: FAILED to start up
Mar 25 16:54:35 localhost systemd: dnsmasq.service: main process exited, code=exited, status=3/NOTIMPLEMENTED
Mar 25 16:54:35 localhost systemd: Unit dnsmasq.service entered failed state.
Mar 25 16:54:35 localhost systemd: dnsmasq.service failed.
```

### 解决

刚开始以为是tftpd文件夹的权限问题，就将它设置为777，重启仍然报错，最后思考了下会不会是SELinux所致，默认fedora安装完成后SELINUX的状态为enforcing，关闭SELINUX，重启OK，还真是这个原因！！！建议默认情况下关闭SELinux，方法有两种：

 -  暂时关闭

```
	setenforce 0
```

 - 永久关闭

```
	vim /etc/selinux/config修改enforcing为disable，重启服务器
```

dnsmasq启动OK的输出：

```
Mar 25 17:09:12 localhost dnsmasq[2131]: started, version 2.72 cachesize 150
Mar 25 17:09:12 localhost dnsmasq[2131]: compile time options: IPv6 GNU-getopt DBus no-i18n IDN DHCP DHCPv6 no-Lua TFTP no-conntrack ipset auth DNSSEC loop-detect
Mar 25 17:09:12 localhost dnsmasq-dhcp[2131]: DHCP, IP range 192.168.0.50 -- 192.168.0.150, lease time 12h
Mar 25 17:09:12 localhost dnsmasq-tftp[2131]: TFTP root is /tftpd
Mar 25 17:09:12 localhost dnsmasq[2131]: reading /etc/resolv.conf
Mar 25 17:09:12 localhost dnsmasq[2131]: read /etc/hosts - 2 addresses
```