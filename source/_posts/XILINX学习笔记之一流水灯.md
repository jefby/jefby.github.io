---
title: "XILINX学习笔记之一---------流水灯(有工程文件VHDL&Verilog_可直接使用）"
date: 2012-10-18 23:52:26
tags: FPGA
categories: FPGA
---

因为笔者是软件出身，专业是计算机，所以硬件方面的基础相比电子、通信等专业出身的来说非常差，很多时候都会用串行的方法来思考问题，而硬件的主要思想却是并行，另外，刚开始对FPGA设计流程不熟悉，对于很多参考书上所说的逻辑设计、行为仿真、综合、后仿真、下载、测试并运行等等这些环节并没有很深的体悟，相信刚开始很多人也如我一般，一直很迷茫，不知道自己该如何下手，其实，要想学好FPGA最迅速的办法就是自己买块开发板或者借块板子，然后，开始编写代码，仿真，下载，查看结果。结果不对，然后分析问题，一个个排除，一遍遍下载调试，最终你一定可以成功的！废话不多说，从最简单的流水灯实验入手，让我们走进FPGA的世界，相信这将是一个纪念性的时刻，想想，真真实实的看到你自己写的代码来控制硬件，不调用任何函数，没有别人的插手，你自己来打造你自己的电子王国。。。

流水灯的思想很简单，需要依次点亮特定位置的LED灯，当然，对于新手来说这可不是一件容易的事情，首先你得学会VHDL或者Verilog语言之中的一种，然后熟悉设计方法，最后编写代码实现。

下面是部分代码展示：

 
```verilog
process(clk_50MHZ,reset)
	begin
		if(reset = '1')then//异步复位
			count <= (others => '0');//将计数器清零
		elsif(clk_50MHZ'event and clk_50MHZ = '1') then//时钟上升沿到来
			if(count = half_50MHZ)then//检测是否计数器到达50MHZ/2-1，若到达，计数器清零
				count <= (others => '0');
			else
				count <= count + 1;
			end if;
		end if;
end process;

//生成1HZ的时钟信号rclk
process(clk_50MHZ,reset)
	begin
		if(reset = '1')then
			rclk <= '0';
		elsif(clk_50MHZ'event and clk_50MHZ = '1') then
			if(count = half_50MHZ)then
				rclk <= not rclk;
			else
				rclk <= rclk;
			end if;
		end if;
end process;
```

首先需要知道在Spartan-3E上主时钟为50MHZ,而这个50MHZ速度是非常快的，如果只是利用50MHZ时钟来直接做为流水灯转换的间隔，那么是不可行的，那么就必须对其进行分频，笔者考虑到通用性，将其分频为1HZ，即一秒钟变化一次，这样，就可以方便观看效果，下面是流水灯的核心代码：

```verilog
process(rclk,reset,en,dir,q)//注意这儿需要将所有的敏感信号都加进来
begin
	if(reset = '1')then
		q <= x"01";
	elsif(rclk'event and rclk = '1') then
		if(en = '1') then
			if(dir = '0') then--左移
				q <= q(6 downto 0) & q(7);
			elsif(dir = '1') then--右移
				q <= q(0) & q(7 downto 1);
			end if;
		end if;
	end if;
end process;
```

当允许时，才进行左移`（q <= q(6 downto 0) & q(7);）`或者右移操作`（q <= q(0) & q(7 downto 1);）`，否则啥也不做，然后综合，下载即可。

到这里，完整的流水灯就OK了！！

附件里面是我自己写的代码，开发板为SPARTAN-3E starter kit board，ISE 13.3 ，语言为VHDL和Verilog。需要的人下载，同时由于笔者水平有限，希望大家多多批评指正。

附件led-flow.rar为VHDL实现，led-flow-v.rar为Verilog语言实现。

[led-flow-v.rar](http://www.eefocus.com/blog/media/download/id-270136)

[led-flow.rar](http://www.eefocus.com/blog/media/download/id-270135)

