;##############################################################################
;########################## PEDIR LOS COEFICIENTES      ###################
;##############################################################################
almacenarCoeficientes macro
    LOCAL salir
    ;############################ COEFICIENTE 4 ########################################
    mostrarCadena msgCoeficiente4
    ingresarCadena valor
    verificarCoeficienteS coeficiente4
    cmp bx,1d
    je salir

    ;############################ COEFICIENTE 3 ########################################
    mostrarCadena msgCoeficiente3
    ingresarCadena valor
    verificarCoeficienteS coeficiente3
    cmp bx,1d
    je salir

    ;############################ COEFICIENTE 2 ########################################
    mostrarCadena msgCoeficiente2
    ingresarCadena valor
    verificarCoeficienteS coeficiente2
    cmp bx,1d
    je salir

    ;############################ COEFICIENTE 1 ########################################
    mostrarCadena msgCoeficiente1
    ingresarCadena valor
    verificarCoeficienteS coeficiente1
    cmp bx,1d
    je salir
    

    salir:

    
 
endm


;##############################################################################
;########################## VERIFICAR LOS COEFICIENTES INGRESADOS(SIGNO)     ###################
;##############################################################################
verificarCoeficienteS macro coeficiente
    LOCAL positivo,salir,negativo
    lea SI, valor + 2

    mov dl, [SI + 0]
    cmp dl,'+'
    je positivo
    cmp dl,'-'
    je negativo
    
    mov [coeficiente + 0],0d
    mov bx,0d
    verificarCoeficienteN coeficiente
    jmp salir

    positivo:
        mov [coeficiente + 0],0d
        mov bx,1d
        verificarCoeficienteN coeficiente
        jmp salir
    
    negativo:
        mov [coeficiente + 0],1d
        mov bx,1d
        verificarCoeficienteN coeficiente
        jmp salir 
    

    salir:

endm

;##############################################################################
;########################## VERIFICAR LOS COEFICIENTES INGRESADOS(NUMERO)     ###################
;##############################################################################
verificarCoeficienteN macro coeficiente
    LOCAL salir,fin
    lea SI, valor + 2

    mov dl, [SI + bx]
    cmp dl,'0'
    jl salir
    cmp dl,'9'
    jg salir
    
    sub dl,48d 
    mov [coeficiente + 1],dl
    mov bx,0d
    jmp fin

    salir:
        mov bx,1d
    fin:

endm 


;##############################################################################
;########################## VERIFICAR LOS LIMITES INGRESADOR(SIGNO)     ###################
;##############################################################################
verificarLimiteS macro limite
    LOCAL positivo,salir,negativo
    lea SI, valor + 2

    mov dl, [SI + 0]
    cmp dl,'+'
    je positivo
    cmp dl,'-'
    je negativo
    
    mov [limite + 0],0d
    mov bx,0d
    verificarLimiteN limite
    jmp salir

    positivo:
        mov [limite + 0],0d
        mov bx,1d
        verificarLimiteN limite
        jmp salir
    
    negativo:
        mov [limite + 0],1d
        mov bx,1d
        verificarLimiteN limite
        jmp salir 
    

    salir:
endm


;##############################################################################
;########################## VERIFICAR LOS LIMITES INGRESADOS(NUMERO)     ###################
;##############################################################################
verificarLimiteN macro limite
    LOCAL salir,fin
    lea SI, valor + 2

    mov dl, [SI + bx]
    cmp dl,'0'
    jl salir
    cmp dl,'9'
    jg salir
    
    ;Decena
    sub dl,48d
    mov al,dl 
    xor ah,ah 
    mov cl,10d 
    mul cl 

    inc bx

    ;Unidad

    mov dl, [SI + bx]
    cmp dl,'0'
    jl salir
    cmp dl,'9'
    jg salir

    sub dl,48d 
    add dl,al 

    mov [limite + 1],dl
    mov bx,0d
    jmp fin

    salir:
        mov bx,1d
    fin:

endm 



;##############################################################################
;########################## COMPARA QUE EL LIMITE INFERIOR SEA MENOR AL LIMITE SUPERIOR    ###################
;##############################################################################
compararLimites macro
    LOCAL compararNegativo,fin,error,comparar
    xor bx,bx
    
    cmp [xInicial + 0],1d 
    je compararNegativo 


    cmp [xFinal + 0],1d 
    je error

    mov bl,[xInicial + 1]
    cmp bl,[xFinal + 1]
    jg error

    mov bx,0d
    jmp fin
    compararNegativo:
        cmp [xFinal + 0],1d 
        je comparar 

        mov bx,0d
        jmp fin 
        comparar:
            mov bl,[xInicial + 1]
            cmp bl,[xFinal + 1]
            jl error 

            mov bx,0d 
            jmp fin
    error:
        mov bx,1d

    fin:

endm


;##############################################################################
;########################## GRAFICAR FUNCION ORIGINAL ###################
;##############################################################################


graphOriginal macro
    LOCAL ciclo_1
    mov ax,13h
    int 10h
    mov cx,0000h
  mov dx,0000h

  ciclo_1:
  mov ah,0ch
  mov al,cl
  int 10h
  inc dx
  cmp dx,200
  jne ciclo_1

  mov dx,0000h
  inc cx
  cmp cx,256
  jne ciclo_1

  ; esperar por tecla
  mov ah,10h
  int 16h

   mov ax,3h
  int 10h
endm