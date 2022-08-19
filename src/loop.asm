assume cs:code

code segment

        mov ax, 2000h
        mov ds, ax
        mov bx, 1000h
    
        mov cx, 8  ; set number of loops
        mov dl, 0
    
FLAG:   mov ds:[bx], dl
        inc dl
        inc bx
        
        loop FLAG

        mov ax, 4c00h
        int 21h

code ends

end