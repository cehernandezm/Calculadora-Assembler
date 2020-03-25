
include Funcion.asm
;##############################################################################
;########################## MOSTRAR UNA CADENA     ###################
;##############################################################################
mostrarCadena macro cadena
    mov ah,09h
    xor al,al
    mov dx, offset cadena
    int 21h 
endm

;##############################################################################
;########################## PEDIR UN CARACTER      ###################
;##############################################################################
ingresarCaracter macro 
   mov ah,1
   int 21h
   mov bl,al
endm

;##############################################################################
;########################## LIMPIAR PANTALLA     ###################
;##############################################################################
clearScreen macro
    mov ax,03h
    int 10h
endm

;##############################################################################
;########################## INGRESAR UNA CADENA    ###################
;##############################################################################
ingresarCadena macro variable
    xor ax,ax
    mov ah,0AH               
    mov dx,offset variable                
    int 21h
endm


.model small
.stack
.data
    cabecera   db "Universidad de San Carlos de Guatemala",10,"Facultad de Ingenieria",10,"Ciencias y Sistemas",10,
      "Arquitectura de computadores y ensambladores 1 A",10,"Primer Semestre 2020",10,"Carlos Eduardo Hernandez Molina",10,"201612118",10,"Quinta Practica",10,"$"
    
    msgMenu db 10,"1. Ingresar Funcion f(x)",10,"2. Funcion Memoria",10,"3. Derivada de F(x)",10,"4. Integral F(x)",10,"5. Graficar Funciones",10,"6. Reporte",10,"7. Reporte Calculadora",10,"8. Salir",10,"$"

    msgDespedida db 10,"Adios :(",10,"$"

    msgCoeficiente4 db 10,"Coeficiente de x4: $"
    msgCoeficiente3 db 10,"Coeficiente de x3: $"
    msgCoeficiente2 db 10,"Coeficiente de x2: $"
    msgCoeficiente1 db 10,"Coeficiente de x1: $"

    msgErrorCoeficiente db 10,"Se ingreso un valor erroneo $"
    ;############################################# FUNCIONES ##################################################################
    flagFuncion db 2 DUP(0)
    valor db 4 DUP("$")
    coeficiente1 db 2 DUP(0)
    coeficiente2 dw 2 DUP(0)
    coeficiente3 dw 2 DUP(0)
    coeficiente4 db 48,48,"$"
.code

inicio:
    mov ax,@data
    mov ds,ax
    mov dx,ax
    
    menu:
        clearScreen
        mostrarCadena cabecera
        mostrarCadena msgMenu

        ingresarCaracter 
        cmp bl,'1'
        je ingresarFuncion 
        cmp bl,'2'
        je funcionMemoria 
        cmp bl,'3'
        je derivada
        cmp bl,'4'
        je integral 
        cmp bl,'5' 
        je graficarFuncion 
        cmp bl,'6'
        je reporte 
        cmp bl,'7'
        je modoCalculadora 
        cmp bl,'8'
        je salir
        
        clearScreen
        jmp menu

        ;####################################################### INGRESAR FUNCION ###########################################
        ;####################################################################################################################
        ingresarFuncion:
            clearScreen
            almacenarCoeficientes

            cmp bx,0d
            je salida 

            errorCoeficiente:
                mostrarCadena msgErrorCoeficiente
                ingresarCaracter
                mov flagFuncion,0d
                jmp menu

            salida:
                mov flagFuncion,1d
                jmp menu

        ;####################################################### FUNCION MEMORIA ###########################################
        ;####################################################################################################################
        funcionMemoria:


        ;####################################################### DERIVADA ###########################################
        ;####################################################################################################################
        derivada:


        ;####################################################### INTEGRAL ###########################################
        ;####################################################################################################################
        integral:


        ;####################################################### GRAFICAR FUNCION ###########################################
        ;####################################################################################################################
        graficarFuncion:

        ;####################################################### REPORTE ###########################################
        ;####################################################################################################################
        reporte:


        ;####################################################### MODO CALCULADORA###########################################
        ;####################################################################################################################
        modoCalculadora:

    salir:
    mostrarCadena msgDespedida
    mov   ax,4c00h       
    int   21h 
end