; 编写子程序
assume cs:codesg, ds:datasg, ss:stacksg


datasg segment
        db 'welcome to masm', 0     ; 16 bytes
        dw 780                      ; 2 bytes
        db 14 dup (0)               ; 14 bytes
datasg ends


stacksg segment stack
        db 20h dup (0)
stacksg ends


codesg segment
start:  
        mov ax, datasg
        mov ds, ax
        mov si, 0

        mov ax, stacksg
        mov ss, ax
        mov sp, 20h
        
        mov dh, 8
        mov dl, 3
        mov cl, 2
        call show_str


        ;mov ax, 4240h
        ;mov dx, 000Fh
        ;mov cx, 0Ah
        ;call divdw

        mov si, 10h
        mov di, 0
        call dtoc

        mov ax, 4c00h
        int 21h


show_str:
        mov ax, 0B800h
        mov es, ax

        mov ax, 0
        mov al, 160
        mul dh
        push ax
        mov ax, 0
        mov al, 2
        mul dl
        pop bx
        add ax, bx

        mov di, ax
        mov bh, cl
        mov ch, 0
flag:   mov bl, ds:[si]
        mov cl, bl
        jcxz ok
        mov es:[di], bx
        inc si
        add di, 2
        jmp short flag
ok:     ret


divdw:  ; 16位 / 16位 ???   X/N = int(H/N)*65536 + [rem(H/N)*65536 + L]/N
        ret
        

dtoc:   
        mov ax, ds:[si]
        mov dx, 0
s:      mov cx, 10
        div cx
        add dl, 30h
        mov es:[1660+di], dl
        mov byte ptr es:[1660+di+1], 2h
        mov cx, ax
        jcxz fs0
        mov dx, 0
        sub di, 2
        jmp s
fs0:    ret
        


codesg ends
end start