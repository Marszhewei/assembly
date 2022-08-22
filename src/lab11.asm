; > 96 <123

assume cs:codesg, ds:datasg

datasg segment
        db "azBeginner's All-purpose Symbolic Instruction Code.", 0
datasg ends



codesg segment
start:
        mov ax, datasg
        mov ds, ax

        mov ch, 0
        mov bx, 0

flag:   mov cl, ds:[bx]
        cmp byte ptr ds:[bx], 123
        jnb next1
next1:  cmp byte ptr ds:[bx], 96
        jna next2

        sub cl, 20h
        mov ds:[bx], cl
next2:  inc bx
        jcxz return
        jmp flag
        
return: mov ax, 4c00h
        int 21h
codesg ends
end start