# 基础知识

## cpu 内存 by 地址线，数据线，控制线

1.  **地址总线**

    地址总线代表了寻址能力

    exp: 一个cpu有10根地址总线，则可传输10位二进制数据（2^10)

2.  **数据总线**

    exp: 16根数据总线可以一次传送两个字节（大小为2^16）

    如果传送的数据大于总线宽度，则分多次传送，小于等于总线宽度可一次传送

    exp: 89D8H在总线宽度为16的cpu中，第一次传送D8,第二次传送89

3.  **控制总线**

    exp: 对内存的读写命令

## 内存地址空间

-   所有的物理存储器都被看作是一个由若干存储单元组成的逻辑存储器，每个物理存储器在这个逻辑存储器中占有一个地址段，即一段地址空间

    exp: 地址0～7FFFH的32KB空间为主随机存储器的地址空间

    ​		地址8000H～9FFFH的8KB空间为显存地址空间

    ​		……

    >   这里有内存虚拟化的概念



# 寄存器

## 字在寄存器中的存储

-   ==字节(byte)==：一个字节由8个bit组成，可以存放在8位寄存器中

-   ==字(word)==：一个字由两个字节组成，这两个字节分别称为这个字的高位字节和低位字节，一个字可以存放在一个16位的寄存器中，AX可分为AH，AL

    >   针对十六位cpu，一个word为两个byte

## 几条汇编命令

-   几个通用寄存器（一般用来存放一般数据）：`AX、 BX、 CX、 DX`

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

    >   8086通过两个16地址来合成一个20位物理地址（通过地址加法器）

-   地址加法器通过内部总线将20位物理地址送入输入输出控制电路

-   输入输出控制电路将20位物理地址送上地址总线（20位的地址总线）

-   20位物理地址被地址总线送到存储器

    CPU可以用不同的段地址和偏移地址形成同一个物理地址

## CS&IP

-   段寄存器，8086有4个段寄存器：`CS、 DS、 SS、 ES`

-   CS和IP是8086中最关键的两个寄存器：CS为代码段寄存器，IP为指令指针寄存器

    >   他们指定了CPU当前要读取指令的地址

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

## DosBox中debug的一些常用用法

```shell
debug
-r				# 查看寄存器的值
-r CS			# 修改寄存器的值
-d 										# CS:IP -> CS:IP+0070
-d segment:start_offset   end_offset	# 查看内存
-e segment:start_offset  val1 val2 ...	# 修改内存
-a 			# 开始编写指令
-u 			# 查看内存中的指令
-t 			# 从CS:IP处开始执行指令
```



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

    >   这是8086CPU硬件设计的问题

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
    assume cs:name	# 假设，它假设某一段寄存器与某一个用segment...ends定义的段相关联
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
	int 21H			; 在debug时 -p 指令结束程序
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
    	loop s				; debug时如果想要快速跳过loop，可以使用-p 或者直接-g next_command
    	mov ax, 4c00H									; next_command所在的地址
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

## 将数据、代码、栈放入不同的段

```assembly
assume cs:code, ds:data, ss:stack
data segment
        dw 0123H, 0456H, 0789H, 0abcH, 0defH, 0fedH, 0cbaH, 0987H
data ends

stack segment stack
        dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
stack ends

code segment
start:  mov ax, stack
        mov ss, ax
        mov sp, 20h
        mov ax, data
        mov ds, ax

        mov bx, 0h
        mov cx, 8h

flag:   push ds:[bx]
        add bx, 2
        loop flag

        mov bx, 0h
        mov cx, 8h

flag1:  pop ds:[bx]
        add bx, 2
        loop flag1

        mov ax, 4c00h
        int 21h

code ends
end start
```



# 灵活的定位内存地址的方法

## and 和 or

-   and指令：逻辑与指令，按位进行与运算

    ```assembly
    mov al, 01100011B
    and al, 00111011B
    ; al = 00100011B
    ```

-   or指令：逻辑或指令，按位进行或运算

    ```assembly
    mov al, 01100011B
    or al, 00111011B
    ; al = 01111011B
    ```

## 关于ascii码

-   以`‘ ’`方式指明数据以字符形式给出

    ```assembly
    assume cs:code, ds:data
    data segment
            db 'UNIX', 'fork'
            db 'hello', 'hi', 'nihao'
    data ends
    
    code segment     
    start:  mov ax, data
            mov ds, ax
            mov al, 'a'
            mov bl, 'b'
            mov ax, 4c00h
            int 21h
    code ends
    end start
    ```

-   大小写转换

    ```assembly
    assume cs:code, ds:data
    data segment
            db 'abcdefgh'
            db 'IJKLMNOP'
    data ends
    
    code segment
    start:  mov ax, data
            mov ds, ax
    
            mov cx, 8h
            mov bx, 0h
    
    flag:   mov ax, 20h
            sub ds:[bx], ax ; lower case to upper case
            inc bx
            loop flag
    
            mov cx, 8h
            mov bx, 8h
    
    flag1:  mov ax, 20h
            add ds:[bx], ax ; upper case to lower case
            inc bx
            loop flag1
    
            mov ax, 4c00h
            int 21h
    code ends
    
    end start
    ```

    >   利用小写字母第六位为1,大写字母第六位为0实现自动将小写字母转大写字母而大写字母不变

    ```assembly
    assume cs:code, ds:data
    
    data segment
            db 'VisualBasic'
    data ends
    
    code segment
    start:  mov ax, data
            mov ds, ax
    
            mov cx, 0Bh
            mov bx, 0h
            
    flag:   mov al, ds:[bx]
            and al, 11011111b   ; if a letter is lower case, convert it to upper
            mov ds:[bx], al
            inc bx
            loop flag
    
            mov ax, 4c00h
            int 21h
    code ends
    end start
    ```

## [bx + idata]

-   几种常用写法

    ```assembly
    mov ax, [bx + idata]
    mov ax, [idata + bx]
    mov ax, idata[bx]
    mov ax, [bx].idata
    ```

## SI 和 DI

>   si与di是与bx功能相近的寄存器，但是si和di不能拆分为两个八位寄存器

-   [bx + si] 和 [bx + di]

    ```assembly
    ; 几种常用写法
    mov ax, [bx + si]
    mov ax, [bx][si]
    ```

-   [bx + si + idata]

    ```assembly
    mov ax, [bx + si + idata]
    mov ax, idata[bx + si]
    mov ax, idata[bx][si]
    mov ax, [bx][si].idata
    mov ax, [bx].idata[si]
    ```

# 数据处理的两个基本问题

## bx di si bp

-   在[…]中可以单独出现或以指定搭配出现

    ```assembly
    mov ax, [bx + si + idata]
    mov ax, [bx + di + idata]
    mov ax, [bp + si + idata]
    mov ax, [bp + di + idata]
    ```

    >   如果没有显式地给出段寄存器，默认为ds

## 指令要处理的数据有多长

-   一般操作中带寄存器可以根据寄存器来指定进行操作的是字还是字节

-   对于没有寄存器显式表明的

    ```assembly
    mov word ptr ds:[0], 1h
    inc byte ptr ds:[0]
    ```

## div 指令

1.   被除数为16位，除数为8位

     >   被除数存放在AX中

     >   AL储存除法操作的商，AH储存除法操作的余数

2.   被除数为32位，除数为16位

     >   被除数存放在DX、AX中
     >
     >   >   其中DX存放高16位，AX存放低16位
     >
     >   AX储存除法操作的商，DX储存除法操作的余数

## db dw dd dup

-   db dw dd

    ```assembly
    ; 定义数据的伪指令
    db		; byte
    dw		; word
    dd 		; double word
    ```

-   dup

    >   主要用于定义重复的数据

    ```assembly
    db 3 dup (0)		; db 0,0,0
    db 3 dup (0, 1, 2)	; db 0,1,2,0,1,2,0,1,2
    
    db 200 dup (0)		; 定义了200字节的栈
    ```

# 转移指令的原理

## offset

>   取得标号的偏移地址

```assembly
assume cs:code
code segment
start:	mov ax, offset start	; mov ax, 0
s:		mov ax, offset s		; mov ax, 3
code ends
end start
```

## jmp 指令

```assembly
nop		; 代表空指令(1 byte)
```

### 标签

-   段内短转移

    ```assembly
    jmp short label		; 其对应机器码不包含label的偏移地址，而是包含相对label偏移地址的相对位移
    (IP) = (IP) + 8位
    ```

-   段内近转移

    ```assembly
    jmp near ptr label
    (IP) = (IP) + 16位
    ```

-   段间转移

    ```assembly
    jmp far ptr label	; 对应机器码包含label处的段地址和偏移地址
    (CS)=label处的段地址	(IP)=label处的偏移地址
    ```

### 寄存器

-   转移地址在寄存器中的jmp指令

    ```assembly
    jmp reg
    (IP) = (reg)
    ```

### 内存

-   段内转移

    ```assembly
    jmp word ptr 内存单元地址(段内)
    (IP) = (ds:[bx])
    ```

-   段间转移

    ```assembly
    jmp dword ptr 内存单元地址(段间)
    (CS) = (内存单元地址+2) -> 高地址
    (IP) = (内存单元地址)   -> 低地址
    ```

## 有条件转移指令

>   所有的有条件转移指令都是短转移，对应机器码中包含转移的位移，不包含目的地址

-   jcxz

    ```assembly
    ; 当cx等于0时，转移到标号处执行(相当于普通的短转移)
    ; 当cx不等于0时，程序继续向下执行
    ```

## 循环指令

>   所有的循环指令都是短转移，机器码对应的是位移而不是地址

-   loop

    ```assembly
    loop label		; 当cx不为0时跳转到label处
    ```

# CALL和RET指令

## ret 和 retf

>   ret 指令用栈中的数据，修改IP的内容，从而实现近转移
>
>   retf 指令用栈中的数据，修改CS和IP的内容，从而实现远转移

-   ret

    ```assembly
    (IP) = ((SS)*16 + (SP))
    (SP) = (SP) + 2					; pop IP
    ```

-   retf

    ```assembly
    (IP) = ((SS)*16 + (SP))
    (SP) = (SP) + 2
    (CS) = ((SS)*16 + (SP))
    (SP) = (SP) + 2					; pop IP, pop CS
    ```

## call 指令

>   将当前的IP或CS和IP压入栈中
>
>   转移

-   依据位移进行转移的call指令

    ```assembly
    call label		; 将当前的IP压栈后，转到标号处执行指令
    ; push IP
    ; jmp near ptr label
    ```

-   转移的目的地址在指令中的call指令

    ```assembly
    call far ptr label		; 段间转移
    ; push CS
    ; push IP
    ; jmp far ptr
    ```

-   转移地址在寄存器中的call指令

    ```assembly
    call reg		; 16位寄存器
    ; push IP
    ; jmp reg
    ```

-   转移地址在内存中的call指令

    ```assembly
    call word ptr 内存单元地址
    ; push IP
    ; jmp word ptr 内存单元地址
    ```

    ```assembly
    call dword ptr 内存单元地址
    ; push CS
    ; push IP
    ; jmp dword ptr 内存单元地址
    ```

## 子程序框架

```assembly
assume cs:code
code segment
main:	..
		call sub1
		..
		mov ax, 4c00h
		int 21h		
sub1:	..
		call sub2
		..
		ret
sub2:	..
		ret
code ends
end main
```

## mul 指令

>   两个相乘的数位数要一致
>
>   >   如果都为8位，一个默认放在AL中，一个放在8位reg或内存字节单元中
>   >
>   >   如果都为16位，一个默认放在AX中，一个放在16位reg或内存字节单元中
>
>   结果
>
>   >   8位乘法,结果默认放在AX中
>   >
>   >   16位乘法,高位DX,低位AX

# 标志寄存器

>   1.   用来存储相关指令的某些执行结果
>   2.   用来为cpu执行相关指令提供行为依据
>   3.   用来控制cpu的相关工作方式

## ZF PF SF CF OF DF

-   ZF标志

    >   零标志位,记录相关指令执行后是否为0.如果结果为0,zf = 1,如果结果不为0,zf = 0

    ```assembly
    mov ax, 1
    sub ax, 1		; zf = 1
    mov ax, 2
    sub ax, 1		; zf = 0
    ```

    >   影响标志寄存器的指令: add, sub, mul, div, inc, or, and
    >
    >   不影响标志寄存器的指令: mov, push, pop

-   PF标志

    >   奇偶标志位,记录指令执行后所有bit中1的个数是否为偶数,为偶数,pf = 1,为奇数,pf=0

    ```assembly
    mov al, 1
    add al, 10		; 00001011b, pf = 0
    mov al, 1
    or al, 2		; 00000011b, pf = 1
    ```

-   SF标志

    >   符号标志位,指令执行后结果为负,sf = 1,结果为正,sf = 0

    ```assembly
    ; 指令进行有符号运算 sf标志才有意义
    ```

-   CF标志

    >   进位标志位,在进行无符号运算的时候,记录了最高有效位向更高位的进位值,或从更高位的借位值

    ```assembly
    mov al, 98h
    add al, al		; al = 30h, cf = 1	进位
    mov al, 97h
    sub al, 98h		; al = ffh, cf = 1	借位
    sub al, al		; al = 0, cf = 0	借位
    ```

-   OF标志

    >   溢出标志位,记录有符号数运算结果是否发生溢出,发生溢出,of = 1,否则of = 0

    ```assembly
    mov al, 0f0h
    add al, 88h		; cf = 1, of = 1 
    ```

-   DF标志

    >   方向标志位,控制每次操作后si, di的增减

    ```assembly
    ; df = 0, (si di) inc, add &, 2
    ; df = 1, (si di) dec, sub &, 2
    ```

    ```assembly
    movsb		; byte
    ((es)*16+(di)) = ((ds)*16 + si)
    ; df = 0
    inc si, inc di
    ; df = 1
    dec si, dec di
    
    movsw		; word
    ; df = 0
    add di/si, 2
    ; df = 1
    sub di/si, 2
    ```

    ```assembly
    rep movsb		; equals
    s:  movsb
        loop s
    ; rep movsw
    ```

    对DF位的操作指令

    ```assembly
    cld		; df = 0
    std		; df = 1
    ```

## adc sbb cmp

-   adc

    >   带进位加法指令

    ```assembly
    adc op1, op2
    ; op1 = op1 + op2 + CF		数电里面的加法器原理
    ```

-   sbb

    >   带借位减法指令

    ```assembly
    sbb op1, op2
    ; op1 = op1 - op2 - CF
    ```

-   cmp

    >   比较指令,相对于减法指令不保存结果

    ```assembly
    cmp op1, op2
    ; op1 = op1 - op2	仅根据结果对标志寄存器进行设置
    mov ax, 8
    mov bx, 3
    cmp ax, bx		; ax = 8, cf = 0
    ```

## 检测比较结果的条件转移指令

| 指令 |     含义     | 检测相关标志位 |
| :--: | :----------: | :------------: |
|  je  |  等于则转移  |     zf = 1     |
| jne  | 不等于则转移 |     zf = 0     |
|  jb  |  低于则转移  |     cf = 1     |
| jnb  | 不低于则转移 |     cf = 0     |
|  ja  |  高于则转移  | cf = 0, zf = 0 |
| jna  | 不高于则转移 | cf = 1, zf = 1 |

>   equal, below, above

-   pushf popf

    ```assembly
    mov ax, 0				
    push ax
    popf					; PWD: 0000 0000 0000 0000
    mov ax, 0fff0h			
    add ax, 0010h			; PWD: 0000 0000 0100 0101
    pushf
    pop ax
    and al, 11000101B
    and ah, 00001000B
    ```

-   在debug中标志寄存器的表示

    | 标志 | 值为1的标记 | 值为0的标记 |
    | :--: | :---------: | :---------: |
    |  of  |     OV      |     NV      |
    |  sf  |     NG      |     PL      |
    |  zf  |     ZR      |     NZ      |
    |  pf  |     PE      |     PO      |
    |  cf  |     CY      |     NC      |
    |  df  |     DN      |     UP      |

# 内中断

## 中断过程

-   中断向量表

>   8086cpu指定了中断向量表的位置 `0000:0000 0000:03FF`
>   每个中断类型码对应一个中断向量表的表项
>   每一个表项中高地址存放CS,低地址存放IP

-   中断过程
    1.   取得中断类型码
    2.   标志寄存器入栈
    3.   TF,IF = 0
    4.   CS,IP入栈
    5.   设置CS,IP,进入中断处理程序

-   中断处理程序的编写流程
    1.   保存用到的寄存器
    2.   处理中断
    3.   恢复用到的寄存器
    4.   用iret指令返回        `pop IP, pop CS, popf`

# 端口

## 端口读写

>   通过in, out指令来从端口读入数据或向端口写入数据

-   0 ~ 255

    ```assembly
    in al, 20h		; 向20h端口读入一个字节
    out 20h, al		; 向20h端口写入一个字节
    ```

-   256 ~ 65535

    ```assembly
    mov dx, 3f8h
    in al, dx
    out dx, al
    ```

## shl shr

-   shl 逻辑左移指令

    1.   将一个寄存器或内存单元中的数据向左移
    2.   将最后移出的一位写入CF中
    3.   最低位用0补充

    ```assembly
    mov al, 01001000b
    shl al, 1				; al = 10010000b, cf = 0
    ```

-   shr 逻辑右移指令

    1.   将一个寄存器或内存单元中的数据向右移
    2.   将最后移出的一位写入CF中
    3.   最高位用0补充

    ```assembly
    mov al, 10000001b
    shr al, 1				; al = 01000000b, cf = 1
    ```

# 外中断

## 外中断信息

-   可屏蔽中断

    1.   去中断类型码
    2.   标志寄存器入栈,IF=0, TF=0
    3.   CS, IP入栈
    4.   重置CS, IP

    ```assembly
    sti 		; IF = 1
    cli			; IF = 0
    ```

-   不可屏蔽中断

    1.   标志寄存器入栈,IF=0, TF=0
    2.   CS, IP入栈
    3.   重置CS, IP



# 直接定址表

```assembly
assume cs:codesg, ds:datasg

datasg segment
        a   db 1, 2, 3, 4, 5, 6, 7, 8
        b   dw, 0
datasg ends

codesg segment
start:  
            mov si, 0
            mov cx, 8
s:          mov al, a[si]
            mov ah, 0
            add b, ax
            inc si
            loop s

            mov ax, 4c00h
            int 21h
codesg ends
end start
```

