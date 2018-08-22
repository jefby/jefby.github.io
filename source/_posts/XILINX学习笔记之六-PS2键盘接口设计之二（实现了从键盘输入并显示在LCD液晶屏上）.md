---
title: XILINX学习笔记之六---PS2键盘接口设计之二（实现了从键盘输入并显示在LCD液晶屏上）
date: 2012-11-30 13:44:36
tags:
- FPGA
- Xilinx
categories:
- FPGA
---

在熟悉了PS2键盘接口设计之后，我想大家都希望将输入的数据在显示屏中实时的显示出来或者看看我们到底输入的是什么样的东西，基于这个原因，结合Spartan-3E开发板上的资源，我利用了液晶1602将输入的字符显示出来。最终结果是可以从键盘上输入任意ASCII字符，可以通过1602显示出来。

具体实现方法是基于我的上一篇博文PS2键盘设计和修改后的1602液晶接口，顶层文件定义如下图所示：

![PTUWqI.png](https://s1.ax1x.com/2018/08/22/PTUWqI.png)

CapsLock为大写锁定或者Shift输入端，高有效，clk_50m是系统时钟信号，ps2c,ps2d为ps2的时钟和数据端口定义，rst_n为复位输入，低有效，disp_value为输入字符的ASCII值，sf_d为LCD数据端口，lcd_e，lcd_rs,lcd_rs为1602控制信号。

具体包含两个模块：一个是键盘接口模块，一个是显示模块，键盘接口模块主要负责获取按键的ASCII值，显示模块主要负责在LCD上将该ASCII值所代表的字符显示出来，具体定义如下所示：
![PTURsA.png](https://s1.ax1x.com/2018/08/22/PTURsA.png)

ps2keyboard为键盘接口模块，lcd_port为液晶显示模块设计，实现方法是ps2keyboard将按键的ASCII字符传递给data_i（lcd_port模块的数据输入），然后由lcd_port将数据写入到LCD上。如果按键ASCII字符有变化，因为在LCD_PORT中监视了数据data_i，如果变化就会及时更新显示。源码及使用说明如下：
[http://pan.baidu.com/share/link?shareid=134819&uk=438936279](http://pan.baidu.com/share/link?shareid=134819&uk=438936279)

