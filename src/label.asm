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