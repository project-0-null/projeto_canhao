; função de entrada para o angulo velocidade_inicial
segment dados
    global velocidade_inicial
    velocidade_inicial dw 0

    msg_entry db 'Digite o valor da velocidade_inicial: $'
    error db 'Valor invalido. Tente novamente.$'


segment code
    global read_V0; ponto de entrada global
    global velocidade_inicial

read_V0:
    push bp;salva o base pointer na pilha com o valor antes de entrar no codigo
    mov bp, sp; passa o valor atual do satackpointer pro base pointer depois de salvar o bp na pilha, inutilizado até o momento
    push bx
    push cx
    push dx
    push ax

    mov ah,9
    mov dx,msg_entry
    int 21h

    mov bx, 0
    ;mov cx, 3 ;limite de 3 digitos para o angulo velocidade_inicial, contando com o enter né

read_digit:
    mov ah,1
    int 21h
    cmp al,13
    je verify_value ;?se for enter, verifica o valor lido

    cmp al, '0'          ; Menor que '0'?
    jb read_digit        ; SIM: ignora e lê próximo caractere
    
    cmp al, '9'          ; Maior que '9'?
    ja read_digit        ; SIM: ignora e lê próximo caractere

    sub al, '0';?converte o caractere lido para valor numerico
    xor ah,ah;?zera o registrador alto

    ;BX = BX * 10 + AX(ah=0,al=velocidade_inicial digit)
    mov dx, ax ;salvar o digito em dx
    mov ax, bx ;carrega o valor atual de bx em ax
    mov bx, 10 ;multiplicador
    mul bx     ;ax = ax * 10
    mov bx, ax ;atualiza bx com o valor multiplicado
    add bx, dx ;bx = bx + digito lido

    jmp read_digit
    ;loop read_digit;?decrementa cx e repete se cx != 0,mudei 

verify_value:
    mov [velocidade_inicial],bx;coloca na variavel global

    pop ax
    pop dx
    pop cx
    pop bx
    pop bp
    ret;limpa a pilha e retota o ip









