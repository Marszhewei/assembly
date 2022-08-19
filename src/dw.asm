assume cs:code

code segment

        dw 1, 2, 3, 4, 5, 6, 7, 8
        
start:  mov bx, 0
        mov ax, 0
        
        mov cx, 8

flag:   add ax, cs:[bx]
        add bx, 2
        loop flag

        mov ax, 4c00h
        int 21h

code ends

end start