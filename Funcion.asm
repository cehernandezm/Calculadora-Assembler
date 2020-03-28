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
    xor dx,dx
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


;##############################################################################
;########################## GRAFICAR EJES ###################
;##############################################################################
graficarEjes macro
    LOCAL ejeX,ejeY
    mov ax,13h
    int 10h
    mov cx,0000h
    mov dx,0000h
    xor cx,cx
    mov dx,100d
    ejeX:

        mov ah,0ch
        mov al,12
        int 10h
        
        inc cx
        cmp cx,320d
        jle ejeX

    mov cx,160
    xor dx,dx

    ejeY:

        mov ah,0ch
        mov al,12
        int 10h
        
        inc dx
        cmp dx,200d
        jle ejeY

   
endm

;##############################################################################
;########################## GRAFICAR ORIGINAL ###################
;##############################################################################
graphOriginal macro
    LOCAL ciclo,salir,yNegativo,saltoY,xNegativo,saltoX
    graficarEjes
    convertirNumero tempI,xInicial
    convertirNumero tempF,xFinal
    
     mov bl,tempI
    ciclo: 
       
        xor bh,bh
        mov temp2,bl 
        cmp bl,tempF 
        jg salir
        push bx
        

        cmp bl,0d 
        jl xNegativo
        ejeXPositivo bl 
        jmp saltoX

        xNegativo:
            ejeXNegativo bl
        saltoX:

        convertirNumero temp,coeficiente1 
        
        xor ax,ax
        mov al,temp
        xor bx,bx 
        mov bl,temp2 

        cmp temp,0d 
        jl yNegativo 
        jmp saltoY 
        yNegativo:

        saltoY:
            ejeYPositivo 

         
        pop dx
        pop cx
        mov ah,0ch
        mov al,9
        int 10h


            
        pop bx
        inc bx

    jmp ciclo
    salir:
    ; esperar por tecla
    mov ah,10h
    int 16h

    mov ax,3h
    int 10h
endm


;##############################################################################
;########################## GRAFICAR EJE X + ###################
;##############################################################################
ejeXPositivo macro numero
    xor ax,ax
    mov al,numero  
    xor ah,ah
    mov cx,160d 
    mul cx 
    mov cx,99d
    div cx 
    xor ah,ah 
    add ax,160d

    mov cx,ax 
    push cx

endm

;##############################################################################
;########################## GRAFICAR EJE X - ###################
;##############################################################################
ejeXNegativo macro numero
    xor ax,ax
    mov al,numero
    neg ax  
    xor ah,ah
    mov cx,160d 
    mul cx 
    mov cx,99d
    div cx 
    xor ah,ah
    mov bx,ax
    mov ax,160d 
    sub ax,bx

    mov cx,ax 
    push cx

endm

;##############################################################################
;########################## GRAFICAR EJE Y + ###################
;##############################################################################
ejeYPositivo macro
    LOCAL negativo,salto
    push bx
    negarNumero 
    xor bh,bh
    mul bx
    mov dx,ax
    mov ax,100d
    
    pop bx 
    cmp bl,0d 
    jl negativo
    
    sub ax,dx 
    
    jmp salto
    
    negativo: 
        add ax,dx
    salto:
    mov dx,ax 
    push dx





endm


;##############################################################################
;########################## CONVERTIR NUMERO ###################
;##############################################################################
convertirNumero macro numero,limite
    LOCAL negativo,salto 
    xor ax,ax
    mov al,[limite + 1]
    mov numero,al
    cmp [limite + 0],1d 
    je negativo 
    jmp salto

    negativo:   
        mov numero,-1d
        mul numero 
        mov numero,al 
    salto:
endm

;##############################################################################
;########################## NEGAR NUMERO ###################
;##############################################################################
negarNumero macro
    LOCAL negativo,salto
    cmp bl,0d 
    jl negativo 
    jmp salto
        
        
    negativo:
        neg bx

    salto:
endm 
;##############################################################################
;########################## POTENCIA ###################
;##############################################################################
potencia macro cantidad,valor
    LOCAL ciclo,fin 
    xor cx,cx 
    mov cl,cantidad
    mov ax,1d
    
    cmp cx,0d
    jg ciclo

    mov ax,0d
    jmp fin     
    ciclo:
        cmp cx,1d 
        jl fin 
        mul valor

        dec cx

        jmp ciclo 

    fin:
        
endm