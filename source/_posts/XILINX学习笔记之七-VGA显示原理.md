---
title: XILINX学习笔记之七---VGA显示原理
date: 2012-12-07 22:03:03
tags:
- FPGA
- Xilinx
categories:
- FPGA
---

VGA(Video Graphic Array)，视频图像阵列，是在20世纪80年代末由IBM PC中引入的视频显示标准，现在已经在PC显示器中得到了推广。图1所示为Spartan-3E上的VGA 显示接口。

[![PTagYT.md.png](https://s1.ax1x.com/2018/08/22/PTagYT.md.png)](https://imgchr.com/i/PTagYT)                                                         <center>图1</center>


![PTackV.png](https://s1.ax1x.com/2018/08/22/PTackV.png)
<center>图2</center>


图2所示为DB15接口图，主要有5个信号比较重要，即水平、垂直两大同步信号，3基色信号（红、绿、蓝），spartan-3e中用3bit来表示每一个像素，故显示效果不好。最古老的显示器要属CRT显示器，它的全称为((cathode ray tube)阴极射线管.图3所示为640×480的CRT显示时序图。

[![PTayT0.md.png](https://s1.ax1x.com/2018/08/22/PTayT0.md.png)](https://imgchr.com/i/PTayT0)
<center>图3</center>


如图3所示，VGA控制器生成水平和垂直同步时序信号，并且协调每一像素周期的视频数据传输。像素周期定义了能够显示一个像素信息的时间。vs信号定义了显示器的刷新频率，或者显示设备中的所有信息需要重画的频率。一般刷新频率范围是60HZ~120HZ。

如果需要在显示设备上显示一幅图片，则可以根据图3设置相应的计数器，产生出水平和垂直扫描信号，并将图片信息保存在ROM中，然后从ROM中读入缓冲区，不停的刷新即可。
