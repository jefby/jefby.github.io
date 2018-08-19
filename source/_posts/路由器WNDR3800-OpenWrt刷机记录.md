---
title: "路由器wndr3800 OpenWrt刷写记录"
date: 2014-05-21 07:29:00
tags: 
- Linux
- OpenWrt
categories:
- Linux
---
对OpenWrt慕名已久，最近有一个想法：实现一个简单的透明翻墙路由器，将校园网共享出来，然后在路由器上运行翻墙代理，实现手机等无线设备的零配置翻墙。网上搜了很多资料，最终决定购买网件的WNDR3800，这台路由器当时配置还可以，但现在看来有点弱，不过相信大品牌的做工和质量。主要的参数如下：

>CPU : AR7161,680MHZ
RAM: 128M DDR
FLASH: 16M

支持双频段：2.4G+5GHZ

首先是内存大，运行大程序应该无压力，另外是出厂FLASH就是16M，比国内某些路由厂商做的地道多了，可以放置更多的应用程序，同时openwrt系统也支持，适合新手使用。当然，如果老鸟的话可能真的是有点看不上。目前360，小米等鼓吹的AC频段，但似乎很少有设备能支持吧？大部分都是802.11n.

在淘宝上选了一家价格和评分都不错的店家买了，入手价是269，再加上我用的顺丰快递（+10），总共下来是279，感觉还可以！等熟悉了openwrt后再买一些比较高端的货玩玩哈！^_^。刚开始还想要店家一些技术问题，发现店家似乎也不是很了解，就只好自己先上网搜搜了，幸好对Linux内核和驱动还算有点了解，下载源码，可以使用git或者svn版本控制管理工具，本文使用trunk版本，git的命令如下：

```
$git clone git://git.openwrt.org/openwrt.git
```

barrier breaker版本命令如下：

```
$git clone git://git.openwrt.org/14.07/openwrt.git
```

SVN的命令如下：

```
$svn co svn://svn.openwrt.org/openwrt/trunk/
```

barrier breaker版本命令如下：

```
$git clone svn://svn.openwrt.org/openwrt/branches/barrier_breaker
```

============================2014/12/3update========================


然后make menuconfig，选择了CPU和路由器WNDR3800，如果需要界面的话进入到LuCI配置下，选择bootstrap风格（个人比较喜欢，很清新），然后选上develop configure模式（不用每次都从零编译），最后保存并退出。配置界面如下图所示：
![PhJarD.png](https://s1.ax1x.com/2018/08/19/PhJarD.png)

接着编译，运行命令：

`make -j8 V=s`

-j8表示启动多少个job（主要参考电脑配置，我电脑是4核的，就设置为8，一般是两倍），顺利的话应该会生成一个bin文件夹，在子目录ar71xx/中会看到openwrt-xxxx-wndr3800.squash.img文件，使用网线连接路由器和电脑，进入管理界面中，刷机，完成后重启，再次打开就是OpenWrt的系统啦！！如下图所示：
[![PhJ0VH.md.png](https://s1.ax1x.com/2018/08/19/PhJ0VH.md.png)](https://imgchr.com/i/PhJ0VH)



     