---
title: "arm linux内核源码中关于何时开启MMU的思考"
date: 2014-08-25 06:00:53
tags: 
- aarch64
categories:
- aarch64
---


今天再次阅读arm linux内核源码，看MMU启动部分发现了一个问题，就是在常规的__enable_mmu和__turn_mmu_on部分我没有找到真正使能MMU标志的代码，但是它到底是什么时候将MMU的最低位置1的呢？？怀着这个疑问我在google上搜索了好多，但是对于这个问题的解答都是模凌两可，说的特别含糊，千篇一律，不能让人信服。


__enable_mmu代码如下：


```
__enable_mmu:

#if defined(CONFIG_ALIGNMENT_TRAP) && __LINUX_ARM_ARCH__ < 6

orr r0, r0, #CR_A

#else

bic r0, r0, #CR_A

#endif

#ifdef CONFIG_CPU_DCACHE_DISABLE

bic r0, r0, #CR_C

#endif

#ifdef CONFIG_CPU_BPREDICT_DISABLE

bic r0, r0, #CR_Z

#endif

#ifdef CONFIG_CPU_ICACHE_DISABLE

bic r0, r0, #CR_I

#endif

#ifndef CONFIG_ARM_LPAE

mov r5, #(domain_val(DOMAIN_USER, DOMAIN_MANAGER) | \

domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) | \

domain_val(DOMAIN_TABLE, DOMAIN_MANAGER) | \

domain_val(DOMAIN_IO, DOMAIN_CLIENT))

mcr p15, 0, r5, c3, c0, 0 @ load domain access register

mcr p15, 0, r4, c2, c0, 0 @ load page table pointer

#endif

b __turn_mmu_on

ENDPROC(__enable_mmu)

```


__turn_mmu_on源码如下：



```
ENTRY(__turn_mmu_on)

mov r0, r0

instr_sync

mcr p15, 0, r0, c1, c0, 0 @ write control reg(启用MMU)

mrc p15, 0, r3, c0, c0, 0 @ read id reg

instr_sync

mov r3, r3

mov r3, r13 @r3中转入最后要跳入的虚拟地址

mov pc, r3 @跳转到__mmap_switched

__turn_mmu_on_end:
```


在__turn_mmu_on中将r0的值写入协处理CP15的C1寄存器中，但是r0的bit0什么时候被置位了呢？？__enable_mmu没有置位，那就肯定是在__enable_mmu之前，搜索代码找到了答案：


::arch/arm/mm/proc-v6.S


其实在__v6_setup中设置的，有一段代码如下：

```
adr r5,v6_crval @将v6_crval的实际运行地址加载到r5处
ldmia r5,{r5,r6}@将r5地址处的两个字内容保存到r5和r6处，根据v6_crval定义可知，值为clear和mmuset，mmmuset的最后一个比特值为1，也就是CR_M=1
orr r0,r0,r6 @在此处将设置r0的bit0为1。随后在__turn_mmu_on中将MMU的值写入CP15的C1寄存器，真正使能MMU。
```


v6_crval的定义如下：


```

.type v6_crval, #object

v6_crval: crval clear=0x01e0fb7f, mmuset=0x00c0387d, ucset=0x00c0187c
```


其中crval是定义的宏，根据配置CONFIG_MMU不同存放不同的值.


```

.macro crval, clear, mmuset, ucset

#ifdef CONFIG_MMU

 .word \clear
 .word \mmuset

#else

 .word \clear
 .word \ucset

#endif                                                                                                         .endm  
```

至此就非常清楚了，在__v6_setup中设置了r0的bit0，然后调用__enable_mmu和__turn_mmu_on真正开启MMU。

