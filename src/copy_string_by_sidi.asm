assume cs:codesg, ds:datasg

datasg segment
        db 'Wlecome to masm!'
        db '................'
datasg ends

codesg segment
start:  mov ax, datasg
        mov ds, ax

        mov cx, 8h  ; 8 words, 16 bytes
        mov si, 0h
        ; mov di, 10h

flag:   ; mov ax, ds:[si]
        ; mov ds:[di], ax
        mov ax, ds:[0h+si]
        mov ds:[10h+si], ax
        add si, 2h
        ; add di, 2h
        loop flag
        
        mov ax, 4c00h
        int 21h
codesg ends
end start