; ; função de entrada para o angulo theta
; segment dados
;     global theta
;     theta dw 0

;     msg_entry db 'Digite o valor do angulo theta (0-90): $'
;     error db 'Valor invalido. Tente novamente.$'


; segment code
;     global read_theta; ponto de entrada global

; read_theta:
;     push bp;salva o base pointer na pilha com o valor antes de entrar no codigo
;     mov bp, sp; passa o valor atual do satackpointer pro base pointer depois de salvar o bp na pilha, inutilizado até o momento
;     push bx
;     push cx
;     push dx
;     push ax

;     mov ah,9
;     mov dx,msg_entry
;     int 21h

;     mov bx, 0
;     ;mov cx, 3 ;limite de 3 digitos para o angulo theta, contando com o enter né

; read_digit:
;     mov ah,1
;     int 21h
;     cmp al,13
;     je verify_value ;?se for enter, verifica o valor lido

;     sub al, '0';?converte o caractere lido para valor numerico
;     mov ah,0;?zera o registrador alto

;     ;BX = BX * 10 + AX(ah=0,al=theta digit)
;     mov dx, ax ;salvar o digito em dx
;     mov ax, bx ;carrega o valor atual de bx em ax
;     mov bx, 10 ;multiplicador
;     mul bx     ;ax = ax * 10
;     mov bx, ax ;atualiza bx com o valor multiplicado
;     add bx, dx ;bx = bx + digito lido

;     jmp read_digit
;     ;loop read_digit;?decrementa cx e repete se cx != 0,mudei 

; verify_value:
;     cmp bx, 90 ;verifica se o valor está entre 0 e 90
;     ja erro

;     mov [theta],bx;coloca na variavel global

;     pop ax
;     pop dx
;     pop cx
;     pop bx
;     ret;limpa a pilha e retota o ip

; error:
;     mov ah,9
;     mov dx,error
;     int 21h
;     jmp read_theta

;     mov ah, 0ch
;     mov al,0
;     int 21h

;     pop ax
;     pop dx
;     pop cx
;     pop bx
    
;     jmp read_theta

; função de entrada para o angulo theta
segment dados
    ;global theta
    extern theta

    msg_entry db 'Digite o valor do angulo theta (0-90): $'
    error_msg db 0Dh, 0Ah, 'Valor invalido. Tente novamente.$'

segment code
    global read_o
    global theta

read_o:
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    push ax

    ; Exibir mensagem
    mov ah, 9
    lea dx, [msg_entry]  ; 
    int 21h

    mov bx, 0

read_digit:
    mov ah, 1
    int 21h
    
    cmp al, 13           ; Enter
    je verify_value
    
    cmp al, '0'          ; Verifica se é dígito válido
    jb read_digit
    cmp al, '9'
    ja read_digit
    
    sub al, '0'          ; Converte caractere para número
    mov ah, 0
    
    ; BX = BX * 10 + AX
    mov dx, ax           ; Salva o dígito
    mov ax, bx           ; AX = BX
    mov cx, 10
    mul cx               ; AX = AX * 10
    mov bx, ax           ; BX = resultado
    add bx, dx           ; BX = BX + dígito
    
    jmp read_digit

verify_value:
    cmp bx, 90
    ja show_error
    
    mov [theta], bx
    
    pop ax
    pop dx
    pop cx
    pop bx
    pop bp
    ret

show_error:
    mov ah, 9
    lea dx, [error_msg]
    int 21h
    
    ; Limpa buffer do teclado
    mov ah, 0Ch
    mov al, 0
    int 21h
    
    pop ax
    pop dx
    pop cx
    pop bx
    pop bp
    
    jmp read_o





