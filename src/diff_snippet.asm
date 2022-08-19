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
