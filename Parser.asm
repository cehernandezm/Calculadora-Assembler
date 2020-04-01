
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


