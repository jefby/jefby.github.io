---
title: AArch64简介
date: 2015-08-29 10:10:44
tags:
- aarch64
categories:
- aarch64
---

# about aarch64

1. Focus on high performance 
2. Exception levels instead of different modes
3. virtualisation support built-in
4. 32 bit fixed length instruction 
5. more registers
6. divide instruction
7. compare & jump instruction
8. support for aarch32

## difference towards aarch32
1. no thumb mode
2. only a handful conditionally executing instruction
3. no more coprocessor
4. beware PC relative addressing doesn't have an offset anymore
5. 31 general purpose registers.1 special purpose
6. no store/load multiple registers(only pairs)

## aarch64 registers

```
registers	special	description
SP/ZR				Stack pointor/Zero register
30			LR		Link register
29			FP		Frame pointer
19~28				stored/restored by callee
18					platforem specific register
17					inter procedure call 1
16					inter procedure call 2
9~15				scratch registers
8					indirect result(pointer to sturct)
0~7					parameters & results
```

### registers can be accessed as 32/64 bit

X0~30 for 64 bit
W0~30 for 32 bit
Also available 
V0~31,SIMD floating point registers


### Modes AArch32 

User		Application
FIQ			Fast Interrupt
IRQ			Interrupt
Supervisor 	Operating System
Abort 		Prefetch abort of instructiion/data
Undefined	After undefined instruction
System		Privileged user mode (for OS functions)
Monitor		On TrustZone Platforms


### Modes on Aarch64

EL0			Unprivileged,applications(with task protection,etc)
EL1			Operating system,kernel,etc
EL2			Hypervisor(for virtualisation)
EL3			Secure monitor(for switching to/from secure state)



> svc,hvc,smc指令切换，对EL1~3有三种不同的中断向量，客户端可以生产virtual exceptions


_CP15 is no more_

> Cache,address and TLB management now have dedicated instructions

> Memory management

> Execpt for EL0,all exception levels have their own memory translation 

> context(EL0 is managed by EL1)

> This means up to 3 stage translation depending on the context

## UEFI&ACPI
http://www.uefi.org/sites/default/files/resources/S4_BldgARMServers_UEFILinuxCon_FINAL_Aug.%2021.pdf