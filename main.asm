;main.asm
global _start; o ponto de entrada é sempre global
global theta ;variavel global para armazenar o angulo lido
global velocidade_inicial ;variavel global para armazenar a velocidade inicial lida

segment stack stack
    resb 256
stack_top:

extern read_V0 ;declaração de função externa
extern read_theta ;declaração de função externa


segment dados
    sen DW 0, 17, 35, 52, 70, 87, 105, 122, 139, 156, 174, 191, 208, 225, 242, 259, 276, 292, 309, 326, 342, 358, 375, 391, 407, 423, 438, 454, 469, 485, 500, 515, 530, 545, 559, 574, 588, 602, 616, 629, 643, 656, 669, 682, 695, 707, 719, 731, 743, 755, 766, 777, 788, 799, 809, 819, 829, 839, 848, 857, 866, 875, 883, 891, 899, 906, 914, 921, 927, 934, 940, 946, 951, 956, 961, 966, 970, 974, 978, 982, 985, 988, 990, 993, 995, 996, 998, 999, 999, 1000

    global theta, velocidade_inicial
    Vy DW 0 ;variavel para armazenar a componente y da velocidade inicial
    theta DW 0 ;variavel para armazenar o angulo lido
    velocidade_inicial DW 0 ;variavel para armazenar a velocidade inicial lida


section code
..start:
    mov ax,dados
    mov ds,ax

    call read_theta
    mov ax, word[sen]

    call read_V0
    call V_y


V_y:
    ;v0y=velocidade_inicial*seno(theta)

    mov bx, word[velocidade_inicial]
    mul bx ;ax = ax * velocidade_inicial

    ;dividir por 1000 para ajustar a escala
    mov bx, 1000
    xor dx, dx ;limpa dx antes da divisão
    div bx ;ax = ax / 1000
    mul word[velocidade_inicial]
    mov word[Vy], ax
    ;o resultado final (v0y) está em ax
    ;Aqui você pode armazenar ou usar o valor de v0y conforme necessário

    ret 