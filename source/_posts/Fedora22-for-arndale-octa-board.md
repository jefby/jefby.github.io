---
title: "Fedora22 image for arndale octa board"
date: 2015-07-19 12:03:00
tags: 
- Linux
- arndale octa
- arm
categories:
- Linux
---

Hello,everynoe.

I have made an image based Fedora 22 for arndale octa board.


Offical arndale octa board just provides the linaro ubuntu linux release , but i'm more familiar RHEL/Fedora/CentOS series,,so i take some time to port the fedora 22 to this board, and it works very good.


The image file is very easy to use,and supposes that you use the linux/mac osx ,you just insert your tf card, open the terminal and input follow commands:


`dd if=Fedora22-arndale-octa-1G.img of=/dev/sdX bs=1M`


when it dones,poll out the tf card and insert it to the board,boot it and it will work ok .Maybe you should upgrade the kernel and dtb files because the new 4.1-rc8 kernel is more efficient and good.please command follow:

```
mount /dev/mmcblk1p2 /media
cp uImage /media/
cp board.dtb /media/
```


Besides:
1. [Fedora22-arndale-octa-1G.img](https://pan.baidu.com/s/1o6215xg) 
2. [uImage](https://pan.baidu.com/s/1jG1U3tW)
3. [board.dtb](https://pan.baidu.com/s/1jGAHWX4)



