assume cs:code

code segment

        dw 0123H, 0456H, 0789H, 0abcH, 0defH, 0fedH, 0cbaH, 0987H

        dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        
start:  mov sp, 30h
        mov ax, cs
        mov ss, ax

        mov cx, 8h
        mov bx, 0

flag:   push cs:[bx]
        add bx, 2
        loop flag

        mov bx, 0
        mov cx, 8h
        
flag1:  pop cs:[bx]
        add bx, 2
        loop flag1

        mov ax, 4c00h
        int 21h

code ends
end start