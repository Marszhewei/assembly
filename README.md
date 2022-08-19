# 基础知识

## cpu 内存 by 地址线，数据线，控制线

1.  **地址总线**
    
    地址总线带宽表示寻址能力
    exp: 一个cpu有10根地址总线，则可传输10位二进制数据（2^10)

2.  **数据总线**

    exp: 16根数据总线可以一次传送两个字节（大小为2^16）

    如果传送的数据大于总线宽度，则分多次传送，小于等于总线宽度可一次传送

    exp: 89D8H在总线宽度为16的cpu中，第一次传送D8,第二次传送89

3.  **控制总线**

    exp: 对内存的读写命令

## 内存地址空间

这里涉及到虚拟化

-   所有的物理存储器都被看作是一个由若干存储单元组成的逻辑存储器，每个物理存储器在这个逻辑存储器中占有一个地址段，即一段地址空间

    exp: 地址0～7FFFH的32KB空间为主随机存储器的地址空间

    ​		地址8000H～9FFFH的8KB空间为显存地址空间

    ​		……

# 寄存器

## 字在寄存器中的存储

-   ==字节(byte)==：一个字节由8个bit组成，可以存放在8位寄存器中
-   ==字(word)==：一个字由两个字节组成，这两个字节分别称为这个字的高位字节和低位字节，一个字可以存放在一个16位的寄存器中，AX可分为AH，AL
  > 这里针对的是16位cpu

## 几条汇编命令

- 几个通用寄存器
  `AX BX CX DX`
```assembly
mov ax, 18	# 将18送入寄存器AX
mov ah, 78	# 将78送入寄存器AH
add ax, 8	# 将寄存器AX中的数值加8
mov ax, bx	# 将寄存器BX中的数值送入寄存器AX
add ax, bx 	# 将AX和BX中的数值相加，存在AX中
```

tip 1： 指令或一个寄存器的名称时不区分大小写

tip 2： 操作后数据如果超过寄存器所能存放的最大数据，数据会截取低位存放在寄存器中

tip 3： 操作对象要是相同的位数

## 关于多少位CPU的一些概念（以16位为例）

-   运算器最多可以处理16位的数据
-   寄存器的最大宽度为16位
-   寄存器和运算器之间的通路为16位

## 8086CPU给出物理地址的方法

-   CPU中的相关部件提供两个16位的地址，一个称为==段地址==，一个称为==偏移地址==（物理地址=段地址×16+偏移地址）

-   段地址和偏移地址通过两个16位地址合成一个称为**地址加法器**的部件

-   地址加法器将两个16地址合成一个20位的物理地址

-   地址加法器通过内部总线将20位物理地址送入输入输出控制电路

-   输入输出控制电路将20位物理地址送上地址总线

-   20位物理地址被地址总线送到存储器

    CPU可以用不同的段地址和偏移地址形成同一个物理地址

## CS&IP

-   段寄存器，8086有4个段寄存器：CS、DS、SS、ES

-   CS和IP是8086中最关键的两个寄存器：CS为代码段寄存器，IP为指令指针寄存器

-   任意时刻CS内容为M，IP内容为N，CPU将从内存M×16+N单元开始，读取一条指令并执行

-   读取一条指令后，IP的值自动增加，以使CPU可以读取下一条指令

    8086CPU的工作过程可以简述如下：

    1.  从CS:IP指向的内存单元读取指令，读取的指令进入指令缓冲器
    2.  IP=IP+所读取的指令的长度，从而指向下一条指令
    3.  执行指令，转到步骤1,重复这个过程

## 修改CS、IP

-   jmp指令：jmp 段地址：偏移地址

    exp：jmp 2AE3：3，执行后，CS=2AE3H，IP=0003H，CPU将从2AE33H处读取指令

    若只想修改IP的内容，可用形如“jmp 某一合法寄存器”的指令完成

    exp：jmp ax  <—>  mov IP, ax（mov并非真的有此条命令）

## 代码段

-   若想让CPU自动执行代码段，需要将CS、IP设置为代码段的段地址

# 寄存器（内存访问）

## DS和[address]

-   exp：DS存放待访问数据的段地址

    ```assembly
    mov bx, 1000H
    mov ds, bx
    mov al, [0]
    # 将一个内存单元中的内容送入一个寄存器中，格式：mov 寄存器名，内存单元地址
    # [0]中的0表示内存单元的偏移地址，内存单元的段地址为DS中的数据
    ```

    上面三条指令将10000H（1000：0）中的数据读到al中

    为啥不能直接将1000H存到DS中呢？

    因为DS是段寄存器，不支持将数据直接送入寄存器的操作

## mov、add、sub指令

```assembly
# mov
mov 寄存器， 数据
mov 寄存器， 寄存器
mov 寄存器， 内存单元
mov 寄存器， 段寄存器
mov 内存单元， 寄存器
mov 内存单元， 段寄存器
mov 段寄存器， 寄存器
mov 段寄存器， 内存单元
#add & sub
add 寄存器， 数据
add 寄存器， 寄存器
add 寄存器， 内存单元
add 内存单元， 寄存器
sub与add类似
```

## 数据段

-   在编程时可以根据需要将一组内存单元定义为一个段

-   exp

    ```assembly
    # 字节型数据
    mov ax, 123BH
    mov ds, ax		; 将123BH送入ds中，作为数据段的段地址
    mov al, 0		; 用al存放累加结果
    add al, [0]		; 将数据段第一个单元（偏移地址为0）中的数值加到al中
    add al, [1]		; 将数据段第二个单元（偏移地址为1）中的数值加到al中
    add al, [2]		; 将数据段第三个单元（偏移地址为2）中的数值加到al中
    # 字型数据
    mov ax, 123BH
    mov ds, ax		; 将123BH送入ds中，作为数据段的段地址
    mov ax, 0		; 用al存放累加结果
    add ax, [0]		; 将数据段第一个字（偏移地址为0）中的数值加到al中
    add ax, [2]		; 将数据段第二个字（偏移地址为2）中的数值加到al中
    add ax, [4]		; 将数据段第三个字（偏移地址为4）中的数值加到al中
    ```

## CPU提供的栈机制

-   push和pop

    ```assembly
    push ax		; 表示将寄存器ax中的数据送入栈中
    pop ax		; 表示从栈顶取出数据送入ax
    ```

-   SS & SP，段寄存器SS存放栈顶的段地址，寄存器SP存放栈顶的偏移地址，push和pop指令执行时，CPU从SS和SP中得到栈顶的地址

    ```assembly
    push ax 的执行由以下两步完成
    SP=SP-2，SS：SP指向当前栈顶前面的单元，以当前栈顶前面的单元为新的栈顶
    将ax中的内容送入到SS：SP指向的内存单元处，SS：SP此时指向新栈顶
    ```

    ```assembly
    pop ax 的执行与 push ax刚好相反
    将SS：SP指向的内存单元处的数据送入ax中
    SP=SP+2,SS：SP指向当前栈顶下面的单元，以当前栈顶下面的单元为新的栈顶
    ```

-   栈满栈空标志

    exp：

    ```assembly
    # 以10010H～1001F作为栈空间
    栈空标志： SS = 1000H, SP = 0020H
    栈满标志： SS = 1000H, SP = 0010H                            
    ```

-   push& pop

    ```assembly
    # push指令
    push 寄存器		
    push 段寄存器	    
    push 内存单元		
    # pop指令
    pop 寄存器			
    pop 段寄存器		
    pop 内存空间		
    ```

# 源程序

## 汇编指令和伪指令

-   伪指令（由编译器处理）

    ```assembly
    assume cs:name	# 假设，它假设某一段寄存器的某一个用segment...ends定义的段相关联
    				# 此处将代码段name和CPU的段寄存器CS联系起来
    name segment	# 段的开始
    				# name将被编译，连接程序处理为一个段地址
    :
    name ends		# 段的结束
    end				# 整个程序结束的标志
    ```

-   汇编指令（由CPU执行）

## 源程序案例

-   汇编程序从写出到执行的全部过程

    编程  ~  name.asm  ~  编译  ~  name.obj  ~  连接  ~  name.exe  ~  加载  ~  内存中的程序  ~  运行

    edit								masm						link						command

```assembly
assume cs:abc	; abc被用作代码段，可以将abc与cs连接起来
abc segment		; 定义了一个段，名称为abc
	mov ax, 2
	add ax, ax
	add ax, ax
	
	mov ax, 4c00H	; 程序返回
	int 21H
abc ends

end
```

# [BX]和loop指令

## 一些概念

-   [bx]与[0]类似，只是[bx]表示偏移地址存在bx中

-   loop，和循环有关

-   idata表示常量，exp：mov ax, idata 就代表 mov ax, 1 ; mov ax, 2 等

-   段前缀，ds： ，cs： ， ss：等在汇编语言中称为段前缀

-   （）表示一个寄存器（段寄存器）或内存单元中的内容，exp：（al）表示al中的内容，（20000H）表示20000H单元的内容

    （X）所表示的数据有两种类型，（al）为字节型，（ax）为字型

## LOOP指令

-   通过loop简化程序求2^12

    ```assembly
    assume cs:code
    code segment
        mov ax, 2
        mov cx, 11
    s:	add ax, ax
    	loop s
    	mov ax, 4c00H
    	int 21H
    code ends
    end
    ```

-   实现ffff:0~ffff:b中的8位数据，累加到16位寄存器dx中

    ````assembly
    assume cs:code
    code segment
    	mov ax, 0ffffH
    	mov ds, ax	
    	mov bx, 0	; 初始化ds:bx指向ffff:0
    	mov dx, 0	; 初始化累加寄存器（dx）=0
    	mov cx, 12	; 循环计数器
    	
    s:	mov al, [bx]	; ax为中间变量
    	mov ah, 0
    	add dx, ax
    	inc bx			; add bx, 1
    	loop s
    	
    	mov ax, 4c00H
    	int 21H
    code ends
    end
    ````

## 段前缀的使用

-   将内存ffff:0 ~ ffff:b单元中的数据复制到0:200 ~ 0:20b单元中

    ```assembly
    assume cs:code
    code segment
    	mov bx, 0		; 偏移地址
    	mov cx, 12		; 计数器
    s: 	mov ax, 0ffffh	
    	mov ds, ax		; (ds)=ffffh
    	mov dl, [bx]	; 将ffff:bx中的数据送入dl
    	mov ax, 0020h
    	mov ds, ax		; (ds)=0020h
    	mov [bx], dl	; 将dl中的数据送入0020:bx
    	inc bx
    	loop s
    	
    	mov ax, 4c00h
    	int 21h
    code ends
    end
    ```

-   在每次循环的过程中，都要设置两次ds（ffff:X和0020:X相距大于64KB，在不同的64KB段里）效率不高，可以通过设置两个段寄存器

    ```assembly
    assume cs:code
    code segment
    	mov ax, 0ffffh
    	mov ds, ax
    	mov ax, 0020h
    	mov es, ax
    	
    	mov bx, 0		; 偏移地址
    	mov cx, 12		; 计数器
    s: 	mov ax, 0ffffh	
    	mov dl, ds:[bx]	; 将ffff:bx中的数据送入dl
    	mov es:[bx], dl	; 将dl中的数据送入0020:bx
    	inc bx
    	loop s
    	
    	mov ax, 4c00h
    	int 21h
    code ends
    end
    ```

# 包含多个段的程序

## 在代码段中使用数据

-   计算给定八个数据的和，结果存在ax寄存器中

    ```assembly
    assume cs:code
    code segment
    	dw 0123h, 0456h, 0789h, 0abch, 0defh, 0fedf, 0cbah, 0987h
    	# dw: define word，使用dw定义了8个字型数据（大小16字节）
        start:  mov bx, 0	; 偏移地址
        # 通过start: end start指明程序入口（即第一条要执行的命令）
                mov ax, 0	
    
                mov cx, 8	; 计数器
        s:		add ax, cs:[bx]
                add bx, 2
                loop s
    
                mov ax, 4c00h
                int 21h
    code ends
    end start
    ```

-   框架

    ```assembly
    assume cs:code
    code segment
    		数据
        start:  
        	代码
    code ends
    end start
    ```


## 在代码段中使用栈

-   利用栈将程序中定义的数据逆序存放

    ```assembly
    assume cs:codesg
    codeseg segment
    	dw 0123h, 0456h, 0789h, 0abch, 0defh, 0fedf, 0cbah, 0987h
    	# cs:00 ~ cs:0F作为数据空间
    	dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    	# cs:10 ~ cs:2F作为栈空间
    	
    	start: 	mov ax, cs
    			mov ss, ax
    			mov sp, 30h		; 将栈顶设置为ss:sp指向cs:30
    			
    			mov bx, 0		; 偏移地址
    			mov cx, 8		; 计数器
    	s:		push cs:[bx] 	; 入栈
    			add bx, 2
    			loop s
    			
    			mov bx, 0
    			mov cx, 8
    	s0:		pop cs:[bx]		; 出栈
    			add bx, 2
    			loop s0
    			
    			mov ax, 4c00h
    			int 21h
    codesg ends
    end start
    ```

-   

##

# 灵活的定位内存地址的方法

# 数据处理的两个基本问题

# 转移指令的原理

# CALL和RET指令

# 标志寄存器

# 内中断

# int指令

# 端口

# 外中断

# 直接定址表

# 使用BIOS进行键盘输入和磁盘读写

