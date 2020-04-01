
;##############################################################################
;#################### ELIMINA LOS CARACTERES DE MAS EN LA DIRECCION ###########
;#################################### DEL ARCHIVO #############################
corregirDireccion macro
    LOCAL recursivo,salida,error,fin
    xor bx,bx
    mov SI,offset direccion + 4
    mov cl,10d
    mostrarCaracter cl
    recursivo:
        mov cl,[SI + BX]
        cmp cl,'$'
        je salida
        cmp cl,'#'
        je salida 

        mov [fileAdress + bx],cl
        mostrarCaracter cl

        inc bx
        jmp recursivo


    salida:
    abrirArchivo fileAdress
    cmp bx,0d
    je error 
    mov cl,10d
    mostrarCaracter cl
    mostrarCaracter cl
    leerArchivo
    analisisLexico
    cmp bx,1d 
    je error 
    analisisSintactico
    jmp fin

    error: 
        ingresarCaracter 

    fin: 
        cerrarArchivo
endm



;##############################################################################
;########################## VERIFICA QUE TODOS LOS CARACTERES ###################
;##################################### LOS ACEPTE EL LENGUAJE ###################
analisisLexico macro
    LOCAL salto,recursividad,error,fin,seguir
    xor bx,bx

    recursividad:
        cmp bx,fileSize
        jge salto 

        mov cl,[buffer + bx]
        cmp cl,'-'
        je seguir 
        cmp cl,'+'
        je seguir 
        cmp cl,'/'
        je seguir 
        cmp cl,'*'
        je seguir 
        cmp cl,59d 
        je seguir 
        cmp cl,10d
        je seguir 
        cmp cl,32d 
        je seguir

        cmp cl,'0'
        jl error 

        cmp cl,'9'
        jg error


        seguir:
        inc bx
        jmp recursividad 
    
    error:
        mov bx,1d
        mostrarCadena msgErrorLexico
        mostrarCaracter cl
        jmp fin 
    
    salto:
        mov bx,0d

    fin:

endm 


;##############################################################################
;#################### ANALISIS SINTACTICO DE LOS CARACTERES ###########
analisisSintactico macro
    LOCAL salto,recursividad,error,espacio,signo,seguir
    xor bx,bx
    xor dx,dx
    xor ax,ax
    recursividad:
        cmp bx,fileSize
        jge salto 

        mov cl,[buffer + bx]
        cmp cl,'-'
        je signo 
        cmp cl,'+'
        je signo 
        cmp cl,'/'
        je signo 
        cmp cl,'*'
        je signo

        cmp cl,59d 
        je espacio 
        cmp cl,10d
        je espacio 
        cmp cl,32d 
        je espacio

        cmp ax,2d
        jge error

        inc ax
        mov dx,0d

        jmp seguir

        signo:
            cmp dx,1d 
            je error
            cmp ax,0d
            je error 
            mov dx,1d
            mov ax,0d
            
        espacio:
            cmp ax,1d 
            je error
           

        seguir:
        inc bx
        jmp recursividad 
    
    error:
        
        mostrarCadena msgErrorSintactico
        mostrarCaracter cl
        mov bx,1d
        jmp fin 
    
    salto:
        mov bx,0d

    fin: 
endm

