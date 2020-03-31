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
    
    ;############################ COEFICIENTE 0 ########################################
    mostrarCadena msgCoeficiente0
    ingresarCadena valor
    verificarCoeficienteS coeficiente0
    cmp bx,1d
    je salir

    salir:

    
 
endm


;##############################################################################
;########################## CONTROLAR ESCALAS  ORIGINAL   ###################
;##############################################################################
controlEscalaOriginal macro
    LOCAL escala4,salto,escala3,escala2
    
    cmp [coeficiente4 + 1],0d 
    jg escala4
    cmp [coeficiente3 + 1],0d 
    jg escala3
    cmp [coeficiente2 + 1],0d 
    jg escala2
    mov escala,1d
    mov limiteSuperior,900d
    mov limiteSuperiorN,-900d
    jmp salto
    escala4:
        mov escala,300d
        mov limiteSuperior,13000d
        mov limiteSuperiorN,-13000d
        jmp salto

    escala3:
        mov escala,90d
        mov limiteSuperior,5000d
        mov limiteSuperiorN,-6000d
        jmp salto
    
    escala2:
        mov escala,20d
        mov limiteSuperior,2025d
        mov limiteSuperiorN,-2025d
        jmp salto
    salto:
    
    
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
    LOCAL ciclo,salir,yNegativo,saltoY,xNegativo,saltoX,coorN,saltoCoor,salto,cero
    graficarEjes
    convertirNumero tempI,xInicial
    convertirNumero tempF,xFinal
   
    mov bl,tempI
    ciclo: 
       
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
        mov temporalY,0d
        
        mov bl,temp2
        analizarCoeficiente coeficiente4,4d
        mov bl,temp2
        analizarCoeficiente coeficiente3,3d
        mov bl,temp2
        analizarCoeficiente coeficiente2,2d
        mov bl,temp2
        analizarCoeficiente coeficiente1,1d
        mov bl,temp2
        analizarCoeficiente coeficiente0,0d
        
        mov bx,limiteSuperior

        cmp temporalY,bx 
        jge cero
        
        mov bx,limiteSuperiorN
        cmp temporalY,bx
        jle cero

        mov ax,temporalY
        
        cmp al,0d 
        jl coorN 
        
        escalaY 0d
        pop cx
        
        cmp dl,0d 
        jle salto
        
        jmp saltoCoor

        coorN:
            neg ax 
            escalaY 1d
            pop cx 
            cmp dx,200d 
            jge salto
        
        saltoCoor:
            mov lastValor,dx
            mov ah,0ch
            mov al,9
            int 10h
            jmp salto
        
        cero: 
            pop cx
        salto:
            
            
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
;########################## Analizar Coeficiente ###################
;##############################################################################
analizarCoeficiente macro coeficiente,exponente
    LOCAL yNegativo,saltoY,negar,saltoN,salto
    
    xor ax,ax
    negarNumero 
    xor bh,bh
    xor dx,dx
    potencia exponente,bx
    
    cmp dx,0d 
    je salto 
    
    add lastValor,1d 
    mov dx,lastValor
    
    jmp saltoY
    
    
    salto:
    xor bx,bx
    mov bx,ax

    mov cx,exponente
    mov temp3,0d

    cmp cx,0d
    je saltoN
    cmp cx,2d 
    je saltoN 
    cmp cx,4d 
    je saltoN

    cmp temp2,0
    jl negar 
    jmp saltoN 
    
    negar: 
        mov temp3,1d
    
    saltoN:

    xor ax,ax
    mov al,[coeficiente + 1]

    cmp [coeficiente + 0],1d 
    je yNegativo 
    ejeYPositivo 
    jmp saltoY 
    yNegativo:
        ejeYNegativo

    saltoY:

    
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
    neg al  
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
    mul bx
    
    cmp dx,0d 
    jne salto 
    
    cmp temp3,1d
    je negativo
   
    add temporalY,ax
    jmp salto
    
    negativo:
        
        sub temporalY,ax
        
    salto:
    

endm

;##############################################################################
;########################## GRAFICAR EJE Y + ###################
;##############################################################################
ejeYNegativo macro
    LOCAL negativo,salto
    mul bx
    
    cmp dx,0d 
    jne salto 

    cmp temp3,1d
    je negativo


    sub temporalY,ax

    jmp salto
    
    negativo: 
        add temporalY,ax
        
    salto:
    

endm


;##############################################################################
;########################## ESCALA Y ###################
;##############################################################################
escalaY macro signo
    LOCAL positivo,salto,error
    
    xor dx,dx
    mov cx,escala
    div cx
    xor ah,ah

    mov bx,signo
    cmp bx,0d
    je positivo
    
    mov dx,ax
    add dx,100d

    jmp salto 

    positivo:    
        
        mov dx,100d
        sub dx,ax
        
        

        jmp salto
    
    error:
        xor dx,dx
    
    salto:    
    
    


    

endm
;##############################################################################
;########################## CONVERTIR NUMERO ###################
;##############################################################################
convertirNumero macro numero,limite
    LOCAL negativo,salto
     
    xor ax,ax
    mov al,[limite + 1]
    mov numero,al 
    mov al,numero
    cmp [limite + 0],1d 
    je negativo 
    jmp salto

    negativo:   
        neg al
        xor ah,ah
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
    
    cmp cl,0d
    jg ciclo

    mov ax,1d
    jmp fin     
    ciclo:
        cmp cx,1d 
        jl fin 
        mul valor

        dec cx

        jmp ciclo 

    fin:
        
endm

;##############################################################################
;########################## MOSTRAR FUNCION ORIGINAL ###################
;##############################################################################

mostrarFuncionOTexto macro
    
    mostrarCaracter 'f'
    mostrarCaracter '('
    mostrarCaracter 'x'
    mostrarCaracter ')'
    mostrarCaracter '=' 

    mostrarCaracter 32
    mostrarCaracter 32
    mostrarCaracter 32


    mostrarCoeficiente coeficiente4,'4'
    mostrarCoeficiente coeficiente3,'3'
    mostrarCoeficiente coeficiente2,'2'
    mostrarCoeficiente coeficiente1,'1'
    mostrarCoeficiente coeficiente0,'0'
   
endm


;##############################################################################
;########################## MOSTRAR COEFICIENTE ###################
;##############################################################################

mostrarCoeficiente macro coeficiente,numero
    LOCAL salto
    mostrarSigno [coeficiente + 0] 
    mov dl,[coeficiente + 1]
    xor dh,dh 
    mostrarNumero dl

    mov dl,numero
    cmp dl,48d 
    je salto
    mostrarCaracter 'X' 
    mostrarCaracter numero
    mostrarCaracter 32 
    mostrarCaracter 32
    salto:
endm


;##############################################################################
;########################## MOSTRAR EL SIGNO + / - ###################
;##############################################################################

mostrarSigno macro signo
    LOCAL positivo,salto
    cmp signo,0d
    je positivo 
    mostrarCaracter '-' 
    jmp salto

    positivo:
    mostrarCaracter '+'
    salto:
endm


;##############################################################################
;########################## CALCULAR DERIVADA ###################
;##############################################################################
calcularDerivada macro coeficiente,ncoeficiente,numero
    xor ax,ax
    xor bx,bx 
    xor cx,cx
    mov al,[coeficiente + 1]
    mov bx,numero
    mul bx 

    mov cl,[coeficiente + 0]
    mov [ncoeficiente + 0],cl 
    mov [ncoeficiente + 1],al

endm 

;##############################################################################
;########################## MOSTRAR EN PANTALLA LA DERIVADA ###################
;##############################################################################
mostrarDerivadaTexto macro 
    calcularDerivada coeficiente4,coeficiente3D,4d
    calcularDerivada coeficiente3,coeficiente2D,3d
    calcularDerivada coeficiente2,coeficiente1D,2d
    calcularDerivada coeficiente1,coeficiente0D,1d
    
    mostrarCaracter 'f'
    mostrarCaracter 39d
    mostrarCaracter '('
    mostrarCaracter 'x'
    mostrarCaracter ')'
    mostrarCaracter '=' 

    mostrarCaracter 32
    mostrarCaracter 32
    mostrarCaracter 32


    mostrarCoeficiente coeficiente3D,'3'
    mostrarCoeficiente coeficiente2D,'2'
    mostrarCoeficiente coeficiente1D,'1'
    mostrarCoeficiente coeficiente0D,'0'
        
endm 


;##############################################################################
;########################## MOSTRAR NUMEROS EN DECENA ###################
;##############################################################################

mostrarNumero macro numero
    LOCAL unidad,salto
    xor ax,ax
    xor cx,cx
    mov al,numero
    cmp al,10d 
    jl unidad
    mov cl,10d 
    div cl 

    push ax 
    mov cl,al 
    add cl,48d 
    mostrarCaracter cl 
    pop ax 
    mov cl,ah 
    add cl,48d 
    mostrarCaracter cl 

    
    
    jmp salto
    unidad:
        mov bx,ax
        add bx,48d 
        mostrarCaracter 48d 
        mostrarCaracter bl

    salto:
endm

