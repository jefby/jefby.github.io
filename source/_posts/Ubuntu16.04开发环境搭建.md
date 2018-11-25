---
title: Ubuntu16.04开发环境搭建
date: 2018-11-25 13:10:29
tags: 
- Linux
categories:
- Linux
---


### 1. 安装cuda-driver

[https://blog.csdn.net/qq\_20492405/article/details/79034430](https://blog.csdn.net/qq_20492405/article/details/79034430)

setting 选择软件和更新，附加驱动


![2018-11-22 17-41-15屏幕截图.png | center | 654x468](https://s1.ax1x.com/2018/11/25/FkHHZd.png "")


### 2. 安装cuda-toolkit、cudnn等


#### 2.1 cuda-toolkit 
[https://developer.nvidia.com/cuda-80-ga2-download-archive](https://developer.nvidia.com/cuda-80-ga2-download-archive)，使用deb方式安装，完成后给~/.bashrc增加如下内容：

```bash
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH:$CUDA_HOME/extras/CUPTI/lib64
export PATH=$CUDA_HOME/bin:$PATH
```

编译cuda-example

```bash
cd /usr/local/cuda/samples
sudo make -j16
cd bin/x86_64/linux/release
./deviceQuery
```

如下是结果：


![2018-11-22 17-45-56屏幕截图.png | center | 827x476](https://s1.ax1x.com/2018/11/25/FkbPds.png "")



#### 2.2 cudnn
[https://developer.nvidia.com/cuda-80-ga2-download-archive](https://developer.nvidia.com/cuda-80-ga2-download-archive)
安装cuda8.0-cudnn-7.1.4 deb，默认会安装到/usr/local
检查结果
```bash
# 检查cudnn版本
cat /usr/include/cudnn.h | grep CUDNN_MAJOR -A 2
# 检查cuda-toolkit版本
nvcc --version
```


### 3. 必需软件安装
```bash
# terminal模拟器，相比gnome-terminal支持各种横向切分、纵向切分，使用方便，linux版本的"iTerm"
sudo apt install -y terminator
# Ubuntu默认不开启ssh端口，需要自行安装ssh-server
sudo apt install -y openssh-server
```
安装搜狗输入法后设置方法:
* 设置=>文本输入 只保留fcitx


![2018-11-22 22-57-30屏幕截图.png | center | 827x484](https://s1.ax1x.com/2018/11/25/FkbWwj.png "")

* 在全局搜索框中查找fcitx配置,只保留搜狗输入和英语


![2018-11-22 22-58-36屏幕截图.png | center | 579x516](https://s1.ax1x.com/2018/11/25/FkbRmQ.png "")


### 4. 配置VNC远程访问
参考第一步 [https://www.cnblogs.com/xuliangxing/p/7642650.html](https://www.cnblogs.com/xuliangxing/p/7642650.html)

### 5. Shadowsocks-Qt5

```bash
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install shadowsocks-qt5
```

完成后使用Chrome，安装Proxy SwitchyOmega插件并配置

