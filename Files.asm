;##############################################################################
;########################## CREA UN ARCHIVO  ###################
;##############################################################################
crearArchivo macro nombre
    mov ah,3ch 
    mov cx,00000000b
    lea dx, [nombre]
    int 21h
    mov filehandle,ax    
endm

;##############################################################################
;########################## GUARDA UNA CADENA EN UN ARCHIVO ###################
;##############################################################################
escribirCadenaArchivo macro tamanio,cadena
    mov ah,40h
    mov bx,filehandle
    mov cx,tamanio
    mov dx, offset cadena 
    int 21h

    mov ah,40h
endm 

;##############################################################################
;########################## GUARDA LA FUNCION ORIGINAL EN UN ARCHIVO ###################
;##############################################################################
reporteOriginal macro
    crearArchivo subReporte
    escribirCadenaArchivo SIZEOF stringfx,stringfx
    guardarCoeficiente coeficiente4,4d
    guardarCoeficiente coeficiente3,3d
    guardarCoeficiente coeficiente2,2d
    guardarCoeficiente coeficiente1,1d 
    guardarCoeficiente coeficiente0,0d
    cerrarArchivo
endm


;##############################################################################
;########################## GUARDA LA FUNCION DERIVADA EN UN ARCHIVO ###################
;##############################################################################
reporteDerivada macro
    crearArchivo subReporte
    escribirCadenaArchivo SIZEOF stringfpx,stringfpx
    guardarCoeficiente coeficiente3D,3d
    guardarCoeficiente coeficiente2D,2d
    guardarCoeficiente coeficiente1D,1d 
    guardarCoeficiente coeficiente0D,0d
    cerrarArchivo
endm

;##############################################################################
;########################## ESCRIBE UN COEFICIENTE CON SU SIGNO ###################
;##############################################################################

guardarCoeficiente macro coeficiente,numero
    LOCAL positivo,salto,salto2
    cmp [coeficiente + 0],0d
    je positivo 
    mov stringCa,"-"
    jmp salto

    positivo:
        mov stringCa,"+"
    salto:

    escribirCadenaArchivo 1,stringCa
    escribirNumero [coeficiente + 1]
    
    mov cl,numero
    cmp cl,0d 
    je salto2 

    mov stringCa,"x"
    escribirCadenaArchivo 1,stringCa
    mov cl,numero 
    mov stringCa,cl 
    add stringCa,48d 
    escribirCadenaArchivo 1,stringCa
    mov stringCa," "
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo 1,stringCa
    salto2:
    
endm


;##############################################################################
;########################## CIERRA UN ARCHIVO EN USO ###################
;##############################################################################
cerrarArchivo macro
   mov ah,3Eh
   mov bx,filehandle
   int 21h
endm


;##############################################################################
;########################## GUARDAR UN NUMERO EN UN ARCHIVO ###################
;##############################################################################

escribirNumero macro numero
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
    mov stringCa,cl  
    add stringCa,48d
    
    escribirCadenaArchivo 1,stringCa
    pop ax 
    mov cl,ah 
    mov stringCa,cl  
    add stringCa,48d 
    escribirCadenaArchivo 1,stringCa

    
    
    jmp salto
    unidad:
        mov bx,ax
        push bx
        mov stringCa,"0"
        escribirCadenaArchivo 1,stringCa
        pop bx
        mov stringCa,bl
        add stringCa,48d 
        
        escribirCadenaArchivo 1,stringCa

    salto:
endm