;##############################################################################
;########################## PEDIR LOS COEFICIENTES      ###################
;##############################################################################
almacenarCoeficientes macro
    LOCAL salir
    mostrarCadena msgCoeficiente4
    ingresarCadena valor
    verificarCoeficienteS coeficiente4
    
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