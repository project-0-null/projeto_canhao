;codigo para calcular a componente (x,y) da posiçao
segment dados
    x_previous DW 80 ;variavel para armazenar a posiçao x anterior
    y_previous DW 80 ;variavel para armazenar a posiçao y anterior
    global position_y;variavel para armazenar a posiçao y
    global position_x;variavel para armazenar a posiçao x
    position_y DW 1 ;variavel para armazenar a posiçao y
    position_x DW 1 ;variavel para armazenar a posiçao x
 

    t DW 0 ;variavel para armazenar o tempo de voo
    
    initial_position_y DW 100; para caso eu queria alteral daonde começa 
    initial_position_x DW 40; para caso eu queria alteral daonde começa

    g DW 490000 ;(g/2) * 10000 para evitar numeros decimais
    divisor_Fg dw 10000 ;divisor para ajustar a gravidade
    divisor_tempo dw 100 ;divisor para ajustar o tempo

    


segment code
    extern theta
    extern Vy
    extern Vx
    extern sen
    extern DESENHA_SEGMENTO
    global SIMULA_TIRO

SIMULA_TIRO:

    push bp;salva o base pointer na pilha com o valor antes de entrar no codigo
    mov bp, sp; passa o valor atual do satackpointer pro base pointer depois de salvar o bp na pilha, inutilizado até o momento
    push bx
    push cx
    push dx
    push ax

    mov word[t],0 ;zera o tempo
    mov ax, word[initial_position_x] ;inicia a posiçao x anterior na posiçao inicial
    mov bx, 2
    mul bx
    add ax,10;offset x(pixels)
    mov word[x_previous], ax

    mov ax, word[initial_position_y] ;inicia a posiçao
    mov bx, 2
    mul bx
    add ax,40;offset y(pixels)
    mov word[y_previous], ax
    xor ax,ax
    xor bx,bx

loop_tempo:
    call CALCULA_POSICAO_XY

    call draw_conversion
    call delay
    inc word[t] ;incrementa o tempo

    MOV ax,[position_y]
    cmp ax,0;<-- ve se ta zero
    JL loop_fim ;se for menor ou igual a zero, termina a simulaçao

    jmp loop_tempo

loop_fim:

    ;finaliza a simulaçao
    ;tem que adicionar a parte de esperar o usuario apertar uma tecla fora desse modulo
    pop ax
    pop dx
    pop cx
    pop bx
    pop bp;restaura o base pointer com o valor salvo na pilha
    ret




;calcula a posiçao x e y baseado no tempo
CALCULA_POSICAO_XY:
    PUSH ax
    PUSH bx
    PUSH cx
    PUSH dx

    MOV cx, [t] ; cx = t (em décimos de segundo, para precisão)

    ; ------------------------------------
    ; A. CÁLCULO DE X(t) = V0x * t
    ; ------------------------------------
    MOV ax, [Vx]           ; ax = V0x (m/s)
    IMUL cx                ; dx:ax = Vx * t
    MOV bx, 40             ; Divisor para ajustar o tempo (t está em décimos)
    IDIV bx                ; ax = (Vx * t) / 10 = X em metros
    add ax, [initial_position_x] ; Adiciona a posição inicial x0
    MOV [position_x], ax   ; Salva X


    ; ------------------------------------
    ; B. CÁLCULO DE Y(t) = (V0y * t) - (g/2 * t^2)
    ; ------------------------------------

    ; B.1: Calcula o termo (V0y * t)
    MOV ax, [Vy]           ; ax = V0y (m/s)
    IMUL cx                ; dx:ax = V0y * t
    MOV bx, 40             ; Divisor do tempo
    IDIV bx                ; ax = (V0y * t) / 10
    MOV si, ax             ; Guarda o resultado em SI: si = V0y*t

    ; B.2: Calcula o termo da gravidade (g/2 * t^2) -> (4.9 * t^2)
    MOV ax, cx             ; ax = t
    IMUL cx                ; dx:ax = t*t
    MOV bx, 49             ; bx = 4.9 * 10
    IMUL bx                ; dx:ax = (t*t) * 49
    MOV bx, 16000          ; Divisor para (t*t/100) e (4.9*10); to dividino muito mais pq agora t corre 4x mais rapido precisamos dividir 4x mais para t ser em segundos que é o usado na formula
    IDIV bx                ; ax = (t*t * 49) / 100 = 4.9 * (t/10)^2

    ; ------------------------------------
    ; C. Subtração Final
    ; ------------------------------------
    SUB si, ax             ; si = (V0y*t) - (termo da gravidade)
    add si, [initial_position_y] ; Adiciona a posição inicial y0
    MOV [position_y], si   ; Salva a posição Y final

    POP dx
    POP cx
    POP bx
    POP ax
    RET

extern cor 
extern plot_xy

draw_conversion:
    push ax
    push bx
    push cx
    push dx

    push si
;------------------------------------------------------------------
    ;converte (metros->pixels)
    ;pixel = metros*0,32
    mov ax,[position_x]
    mov bx, 32;aq tb
    mul bx ;aqui ax = ax * bx
    mov bx,100
    div bx ;aqui ax = ax / bx ;desfazer essa merda dps pq PQP
    mov si,ax ;si = posiçao x em pixels
;------------------------------------------------------------------
    mov ax,[position_y]
    mov bx,32;aq tb
    mul bx ;aqui ax = ax * bx
    mov bx,100
    div bx ;aqui ax = ax / bx desfazer essa merda dps pq PQP
    mov cx,ax ;cx = posiçao y em pixels
;------------------------------------------------------------------
    ;verifica limtes (transforma em vermhlo)
    ;cores: (0)preto (4)vermelho
    mov bl, 15

    mov ax, [position_x]
    cmp ax, 2000;compara limite de tela na horaizontal(x)
    jg set_red

    mov ax, [position_y]
    cmp ax, 1000;compara limite de tela na vertical(y)
    jg set_red

    jmp define_cor
set_red:
    mov bl, 4 ;vermelho
define_cor:
    mov [cor],bl
;------------------------------------------------------------------
;desenha a linha

    push word[x_previous]
    push word[y_previous]
    push si
    push cx

    call DESENHA_SEGMENTO
;------------------------------------------------------------------
    ;atualiza posiçao anterior
    mov ax,si
    mov word[x_previous],ax

    mov ax,cx
    mov word[y_previous],ax

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

delay:
    push cx
    push dx
    push ax
    
    ; Ajuste esse valor para mais rápido/devagar (FFFFh é o máximo para 1 loop)
    mov cx, 0010h
delay_loop1:
    mov dx, 0500h ; Loop interno
delay_loop2:
    dec dx
    jnz delay_loop2
    loop delay_loop1
    
    pop ax
    pop dx
    pop cx
    ret