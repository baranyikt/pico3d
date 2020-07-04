plotxy:                         ; puts pixel into (si,di) of color dl
                                ; assumes: es=video seg
    push di
    push ax
    shl di, 6                   ; mul di, 320
    mov ax, di                  ; ax=di=y * 64
    shl ax, 2                   ; ax=y * 256
    add di, ax                  ; di=y*(64+256)=320
    add di, si                  ; di=y*320+x
    mov [es:di], dl
    pop ax
    pop di
    ret                         ; plotxy: 0x1e-0x00 bytes (30)
                                ; changed dx to ax, al to dl: (same length)

lineDraw:                       ; draws line from (si,di) to (cx,dx)
    mov ax, dx
    sub ax, di                  ; ax = |toy-fromy|
    mov bx, cx
    sub bx, si                  ; bx = |tox-fromx|
    shl ax, 1                   ; ax = 2*deltay
    mov bp, ax
    sub bp, bx                  ; bp = 2*deltay - deltax
    shl bx, 1                   ; bx = 2*deltax
    mov dl, 5

ld2:
    call plotxy
    cmp bp,0
    jle noyinc
    inc di
    sub bp, bx
noyinc:
    add bp, ax
    cmp si, cx
    jbe ld2

    ret                         ; lineDraw: 0x55-0x1e bytes (55) 
                                ; using the unused dx for color instead of ax: 0x51-0x1e bytes (51) 
                                ; swapping bp & ax: 
main:
    mov ax, 0A000h
    mov es, ax
    mov ss, ax
    mov sp, 320*200
    mov ax, 13h
    int 10h                     ; VGA Mode 13h set
    mov dx, 250     ; toy
    mov cx, 510     ; tox
    mov di, 210     ; fromy
    mov si, 330     ; fromx
    call lineDraw

                                ; total so far 81h bytes
                                ; using dl for color & using dx in linedraw 78h bytes