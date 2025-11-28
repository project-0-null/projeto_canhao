;main.asm
; Miguel Catelan Magalhães - 1029202024 
; engenharia eletrica 

segment stack stack
    resb 256
stack_top:

segment dados
    sen DW 0, 17, 35, 52, 70, 87, 105, 122, 139, 156, 174, 191, 208, 225, 242, 259, 276, 292, 309, 326, 342, 358, 375, 391, 407, 423, 438, 454, 469, 485, 500, 515, 530, 545, 559, 574, 588, 602, 616, 629, 643, 656, 669, 682, 695, 707, 719, 731, 743, 755, 766, 777, 788, 799, 809, 819, 829, 839, 848, 857, 866, 875, 883, 891, 899, 906, 914, 921, 927, 934, 940, 946, 951, 956, 961, 966, 970, 974, 978, 982, 985, 988, 990, 993, 995, 996, 998, 999, 999, 1000

    ;global theta, velocidade_inicial
    Vy DW 0 ;variavel para armazenar a componente y da velocidade inicial
    Vx DW 0 ;variavel para armazenar a componente x da velocidade inicial
    ;theta DW 0 ;variavel para armazenar o angulo lido
    ;velocidade_inicial DW 0 ;variavel para armazenar a velocidade inicial lida


section code
    extern read_V0 ;declaração de função externa
    extern read_o ;declaração de função externa
    extern theta
    extern velocidade_inicial
    global ..start
..start:
    mov ax,dados
    mov ds,ax

    call read_o
    mov ax, word[sen]

    call read_V0
    call V_y


V_y:
    ; v0y = velocidade_inicial * seno(theta)
    mov bx, word[velocidade_inicial]
    mul bx              ; DX:AX = AX(seno) * BX(velocidade)
    mov bx, 1000
    div bx              ; AX = (DX:AX) / 1000
    mov word[Vy], ax
    ret

V_x:
    ; v0x = velocidade_inicial * cosseno(theta)
    mov bx, word[velocidade_inicial]
    mov ax, word[sen + 90*2]   ; cosseno = seno(theta + 90)
    mul bx                     ; DX:AX = AX(cosseno) * BX(velocidade)
    mov bx, 1000
    div bx                     ; AX = (DX:AX) / 1000
    mov word[Vx], ax
    ret
Y:
