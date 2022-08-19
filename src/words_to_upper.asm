assume cs:codesg, ds:datasg, ss:stacksg

datasg segment
        db 'ibm             '
        db 'dec             '
        db 'dos             '
        db 'vax             '
datasg ends

stacksg segment stack
        dw 0, 0, 0, 0, 0, 0, 0, 0
stacksg ends 

codesg segment
start:  mov ax, datasg
        mov ds, ax
        mov ax, stacksg
        mov ss, ax
        mov sp, 10h

        mov cx, 4h
        mov bx, 0h
outer:  push cx
        mov cx, 3h
        mov si, 0h
inner:  mov al, ds:[bx + si]
        sub al, 20h
        mov ds:[bx + si], al
        inc si
        loop inner

        add bx, 10h
        pop cx
        loop outer

        mov ax, 4c00h
        int 21h
codesg ends
end start