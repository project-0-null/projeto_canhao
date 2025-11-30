;main.asm
; Miguel Catelan Magalhães - 1029202024 
; engenharia eletrica 

segment stack stack
    resb 256
stack_top:

segment dados
    global sen
    sen DW 0, 17, 35, 52, 70, 87, 105, 122, 139, 156, 174, 191, 208, 225, 242, 259, 276, 292, 309, 326, 342, 358, 375, 391, 407, 423, 438, 454, 469, 485, 500, 515, 530, 545, 559, 574, 588, 602, 616, 629, 643, 656, 669, 682, 695, 707, 719, 731, 743, 755, 766, 777, 788, 799, 809, 819, 829, 839, 848, 857, 866, 875, 883, 891, 899, 906, 914, 921, 927, 934, 940, 946, 951, 956, 961, 966, 970, 974, 978, 982, 985, 988, 990, 993, 995, 996, 998, 999, 999, 1000
    global Vy, Vx
    ;global theta, velocidade_inicial
    Vy DW 0 ;variavel para armazenar a componente y da velocidade inicial
    Vx DW 0 ;variavel para armazenar a componente x da velocidade inicial
    ;theta DW 0 ;variavel para armazenar o angulo lido
    ;velocidade_inicial DW 0 ;variavel para armazenar a velocidade inicial lida
    msg_menu db 13,10, '-->MENU<--',13,10,'L-limpa',13,10,'A-angulo',13,10,'V-velocidade inicial',13,10,'T-disparar',13,10,'S-air',13,10,'$'

section code
    extern read_V0 ;declaração de função externa
    extern read_o ;declaração de função externa
    extern theta;declaração de variavel externa
    extern velocidade_inicial;declaração de variavel externa
    extern SIMULA_TIRO ;declaração de função externa
    extern CONFIGURA_GRAFICOS
    extern restaura_graficos

    global ..start

..start:
    mov ax,dados
    mov ds,ax


loop_menu:
    mov ah,9
    mov dx,msg_menu
    int 21h

    mov ah,1
    int 21h
    and al,11011111b ;converte minuscula em maiuscula

    cmp al,'L'
    je op_l ;limpa a tela, adicionar depois o fato de rodar a simualção

    cmp al,'A'
    je op_A

    cmp al,'V'
    je op_V

    cmp al,'T'
    je op_T

    cmp al,'S'
    je op_S



op_l:
    ;limpa a tela
    call CONFIGURA_GRAFICOS
    jmp loop_menu
    ret

op_A:
    call read_o
    mov ax, word[theta]
    ;ajusta o angulo para estar entre 0 e 90
    jmp loop_menu
    ret

op_V:
    call read_V0
    jmp loop_menu
    ret 

op_T:
    ;iniciar a simulação
    ;chamar a função que calcula a posição y e x
    call V_x
    call V_y
    call SIMULA_TIRO
    jmp loop_menu
    ret

op_S:
    call restaura_graficos
    ;sair do programa
    mov ax,4C00h
    int 21h

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

