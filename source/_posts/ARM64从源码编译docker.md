---
title: 'ARM64从源码编译docker（v1.9.1) '
date: 2015-11-30 20:41:11
tags: 
- aarch64
categories:
- aarch64
---

>在X86_64机器fedora系统下，不要使用官方编译的rpm包，交叉编译bootstrap会出现异常，使用源码编译的go.

### 1.编译X86_64的go binary

```
cd /root
git clone https://github.com/golang/go
git checkout go1.4.2
cd src/
./make.bash //先编译一个go x86_64
mv /root/go /root/go1.4//因为go1.5beta代码固定了go路径
```

### 2.下载go1.5.1，使用go1.4为arm64交叉编译bootstrap，或者直接checkout go1.5.1

```
cd go/src/
GOOS=linux GOARCH=arm64 ./bootstrap.bash
```

### 3. 拷贝go-linux-arm64-bootstrap.tbz到Arm64机器上继续编译其他模块

```
scp go-linux-arm64-bootstrap.tbz xxx //
//下载go1.5.1代码
git checkout go1.5.1
cd go/src
GOROOT=/path/to/go/bootstrap
GOROOT_BOOTSTRAP=$GOROOT ./all.bash
```

### 4. 下载docker源码并编译

```
git clone https://github.com/jefby/docker.git
git checkout jefby-v1.9.1 //找到最新的v1.9.1版本
AUTO_GOPATH=1 ./hack/make.sh dynbinary //编译动态版本
./hack/make.sh binary //静态版本，根据github docker社区的评论，似乎是用Redhat系列不能用静态版本的，因为默认使用了devicemapper，而不是ubuntu使用的aufs
```

### 5. 需要安装glibc-static
在docker v1.9.1版本中，hack/make.sh dynbinary中依然依赖libc.a和libpthread.a库，所以需要安装glibc-static rpm包，提供这两个库~

### 6. 修改hack/make.sh增加set -x
添加调试选项，进行debug，查看到底是什么地方出现错误

### 7.安装必须的一些pkg

```
yum install -y device-mapper-devel
yum install -y btrfs-progs-devel
```

### 8.docker pull 的时候提示错误Server error: Status 0 while fetching image layer
解决方法：
在/etc/hosts后面添加对docker网站的dns解析
```
162.242.195.84 index.docker.io
162.242.195.84 registry-1.docker.io
```