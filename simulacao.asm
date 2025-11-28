;codigo para calcular a componente y da posiçao
segment dados
    global position_y DW 0 ;variavel para armazenar a posiçao y
    global position_x DW 0 ;variavel para armazenar a posiçao x
    tempo DW 0 ;variavel para armazenar o tempo de voo
    initial_position_y DW 0; para caso eu queria alteral daonde começa 
    initial_position_x DW 0; para caso eu queria alteral daonde começa
    x_previous DW 0 ;variavel para armazenar a posiçao x anterior
    y_previous DW 0 ;variavel para armazenar a posiçao y anterior

    g DW 490000 ;(g/2) * 10000 para evitar numeros decimais
    divisor_Fg dw 10000 ;divisor para ajustar a gravidade
    divisor_tempo dw 100 ;divisor para ajustar o tempo

    global SIMULA_TIRO


segment code
    extern theta
    extern Vy
    extern Vx
    extern sen

    push bp;salva o base pointer na pilha com o valor antes de entrar no codigo
    mov bp, sp; passa o valor atual do satackpointer pro base pointer depois de salvar o bp na pilha, inutilizado até o momento
    push bx
    push cx
    push dx
    push ax

    mov word[tempo],0 ;zera o tempo
    mov word[position_y], word[initial_position_y] ;inicia a posiçao y na posiçao inicial
    mov word[position_x], word[initial_position_x] ;inicia a posiçao
    mov word[x_previous], word[initial_position_x] ;inicia a posiçao x anterior na posiçao inicial
    mov word[y_previous], word[initial_position_y] ;inicia a posiçao


loop_tempo:
    MOV ax,[position_y]
    cmp ax,0;<-- ve se ta zero
    JLE loop_fim ;se for menor ou igual a zero, termina a simulaçao

    call calc_position_xy

    call draw_conversion

    inc word[tempo] ;incrementa o tempo

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

    MOV cx, [t] ; cx = t (em centésimos)

    ; ------------------------------------
    ; A. CÁLCULO DE X(t) = V0x * t
    ; X_metros = (Vx * t) / 100 
    ; ------------------------------------
    MOV ax, [Vx]           ; ax = V0x (m/s)
    IMUL cx                ; dx:ax = Vx * t (32 bits)
    MOV bx, [divisor_tempo]  ; bx = 100
    IDIV bx                ; ax = (Vx * t) / 100 = X_metros
    MOV [POSICAO_X], ax    ; Salva X

    ; ------------------------------------
    ; B. CÁLCULO DE Y(t) = V0y * t - 4.9 * t^2
    ; ------------------------------------

    ; B.1: Termo V0y * t (Já calculado acima, mas repetindo para clareza)
    MOV ax, [Vy]           ; ax = V0y (m/s)
    IMUL cx                ; dx:ax = V0y * t (32 bits). salva a parte alta em dx, e a baixa em ax
    MOV bx, [divisor_tempo]  ; bx = 100
    MOV [POSICAO_Y], ax    ; (tempporario), POSICAO_Y = Termo 1 (Quociente)

    ; B.2: Termo Gravidade (4.9 * t^2)
    ; Gravidade_Term = (divisor_Fg * t * t) / (10000 * 100)
    ; Para simplificar, divisor_Fg (490000) já engloba uma parte da escala.

    ; Calcula t * t
    MOV ax, cx             ; ax = t
    IMUL cx                ; dx:ax = t * t (32 bits)

    ; Multiplica por divisor_Fg (490000)
    ; Esta multiplicação 32x16 é complexa e pode estourar, vamos simplificar.
    
    ; Alternativa de Escala (Se t não for muito grande, max 16 bits):
    MOV ax, [divisor_Fg]
    IMUL cx                 ; ax * t (usando cx = t)
    ; Isso não é suficiente. Vamos usar ax como parte alta e bx como parte baixa da multiplicação 32x16.

    ; CÁLCULO GRAV. (Simplificado para 16 bits, assumindo tempo total < 10s)
    MOV ax, cx             ; ax = t
    IMUL cx                ; dx:ax = t*t (32 bits)
    
    ; Divide por um divisor grande (e.g., 10000) antes de multiplicar por 4.9
    MOV bx, 1000           ; Divisor para reduzir t*t
    IDIV bx                ; ax = t*t / 1000

    MOV bx, 49             ; 4.9 * 10
    IMUL bx                ; ax = (t*t/1000) * 49 (Aproximado)
    MOV bx, 10             ; Divide pelo 10 do 4.9*10
    IDIV bx                ; ax = Termo Gravidade em metros
    
    ; ------------------------------------
    ; C. Subtração Final
    ; ------------------------------------
    MOV bx, [POSICAO_Y]    ; bx = Termo 1 (V0y * t)
    SUB bx, ax             ; bx = V0y*t - Gravidade_Term
    
    MOV [POSICAO_Y], bx    ; Salva Y_metros

    POP dx
    POP cx
    POP bx
    POP ax
    RET