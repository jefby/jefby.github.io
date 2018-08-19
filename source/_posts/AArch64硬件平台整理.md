---
title: AArch64硬件平台整理
date: 2018-08-19 21:06:40
tags:
- aarch64
categories:
- aarch64
---
ARM发布ARM v8架构，主要针对高性能企业级市场，由于ARM系列芯片的高度可定制和低功耗特性，众多小伙伴看到了服务器市场的希望，纷纷跟上，积极推进ARM进军传统服务器领域，虽然目前跟Intel相比还是太弱，但我相信肯定会打出一片天地，ARM授权SoC IP核心，企业可以根据具体应用需求来定制芯片，另外可以加入特定的硬件逻辑，例如SSL安全验证等，这些都是Intel所不能比得，就是生态系统目前还未完全建立，需要各个厂商的通力协作。现整理部分AArch64硬件平台，以方便自己和需要的人做参考，有新的设备欢迎提醒哈！

#### 1. versatile-express（FPGA soft-core）
ARM公司推出的示范平台，用于验证

#### 2. Applied Micro Mustang:
8核ArmV8架构，最早的arm64硬件平台，目前已经可以安装Linaro Ubuntu、Fedora、OpenSUSE等系统，软件支持做的比较好，bootloader也替换为UEFI，而非嵌入式常用的uboot。
https://www.apm.com/products/data-center/x-gene-family/x-c1-development-kits/

#### 3. ARM Juno
http://www.arm.com/zh/products/tools/development-boards/versatile-express/juno-arm-development-platform.php

#### 4. Qemu
软件模拟硬件平台，http://www.bennee.com/~alex/blog/2014/05/09/running-linux-in-qemus-aarch64-system-emulation-mode/

#### 5. AMD 64-bit ARM Opteron Developer Kit
AMD的ARM64服务器平台

#### 6. Cavium Project ThunderX:(48核心) && EZchip
战斗机，https://www.youtube.com/watch?v=zmnjZUQPq5U
100个ARM 64核心，详细资料可查看网址http://www.ezchip.com/products/?ezchip=585&spage=686

#### 7. 96Board 
(1)HiKey : 8核心Cortex-A53，华为麒麟6220,
https://www.96boards.org/products/hikey/
(2)DragonBoard410c，4核心Cortex-A53
https://www.96boards.org/products/dragonboard/
(3)听说AMD也会推出一款面向企业级别的参考设计版，但是价格相对低廉些~

#### 8. 华为平台
D-01和D-02，产品不错，技术领先
https://www.youtube.com/watch?v=dLHhnLLw4Fw

#### 9. Nvidia 平台
面向机器识别、人工智能和无人机图形处理运算方面的
http://devblogs.nvidia.com/parallelforall/nvidia-jetson-tx1-supercomputer-on-module-drives-next-wave-of-autonomous-machines/

购买链接：
http://www.nvidia.com/object/jetson-tx1-dev-kit.html
最新版是TX2，有cuda加速，但CPU架构感觉有点老，怎么还是cortex-a57?：
https://developer.nvidia.com/embedded/buy/jetson-tx2