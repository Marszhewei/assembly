assume cs:codesg, ds:datasg

datasg segment
        db 'welcome to masm!'
datasg ends

codesg segment
start:  mov ax, datasg
        mov ds, ax
        mov ax, 0B800h
        mov es, ax

        mov cx, 16
        mov bx, 0
        mov si, 0
        mov dx, 0
        mov dh, 0cah
flag1:  mov dl, ds:[si]
        mov es:[bx + 1660], dx
        inc si
        add bx, 2
        loop flag1

        mov ax, 4c00h
        int 21h
codesg ends
end start