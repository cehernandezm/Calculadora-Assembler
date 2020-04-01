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
;########################## ABRIR UN ARCHIVO  ###################
;##############################################################################

abrirArchivo macro nombre
    LOCAL openError,salida
    mov ah,3Dh
    xor al,al
    lea dx,[fileAdress] 
    int 21h
    jc openError
      
    mov filehandle,ax 
    mov bx,1d 
    jmp salida 

    openError:
        mostrarCadena msgOpenError 
        mov bx,0d

    salida:

endm

;##############################################################################
;########################## LEER UN ARCHIVO  ###################
;##############################################################################
leerArchivo  macro
    
    mov ah,3fh
    mov bx,filehandle
    mov cx,4000
    lea dx,buffer
    int 21h
    mov fileSize,ax
    mov bx,fileSize
    mov [buffer + bx],"$"
    mostrarCadena buffer
    xor bx,bx 

    
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
;########################## GUARDA LA FUNCION INTEGRAl EN UN ARCHIVO ###################
;##############################################################################
reporteIntegral macro
    crearArchivo subReporte
    escribirCadenaArchivo SIZEOF stringFXX,stringFXX
    guardarCoeficienteIntegral coeficiente5I,5d
    guardarCoeficienteIntegral coeficiente4I,4d
    guardarCoeficienteIntegral coeficiente3I,3d
    guardarCoeficienteIntegral coeficiente2I,2d
    guardarCoeficienteIntegral coeficiente1I,1d
    
    cerrarArchivo
endm

;##############################################################################
;########################## REPORTE GENERAL ###################
;##############################################################################
crearReporteG macro
    escribirCadenaArchivo SIZEOF encabezadoF,encabezadoF
    escribirCadenaArchivo SIZEOF FechaS,FechaS
    obtenerFecha
    mov stringCa,10
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo SIZEOF HoraSS,HoraSS
    obtenerHora 
    mov stringCa,10
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo 1,stringCa

    escribirCadenaArchivo SIZEOF funcionOS,funcionOS
    escribirCadenaArchivo SIZEOF stringfx,stringfx
    guardarCoeficiente coeficiente4,4d
    guardarCoeficiente coeficiente3,3d
    guardarCoeficiente coeficiente2,2d
    guardarCoeficiente coeficiente1,1d 
    guardarCoeficiente coeficiente0,0d
    mov stringCa,10
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo SIZEOF funcionDS,funcionDS
    escribirCadenaArchivo SIZEOF stringfpx,stringfpx
    guardarCoeficiente coeficiente3D,3d
    guardarCoeficiente coeficiente2D,2d
    guardarCoeficiente coeficiente1D,1d 
    guardarCoeficiente coeficiente0D,0d
    mov stringCa,10
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo 1,stringCa
    escribirCadenaArchivo SIZEOF funcionIS,funcionIS
    escribirCadenaArchivo SIZEOF stringFXX,stringFXX
    guardarCoeficienteIntegral coeficiente5I,5d
    guardarCoeficienteIntegral coeficiente4I,4d
    guardarCoeficienteIntegral coeficiente3I,3d
    guardarCoeficienteIntegral coeficiente2I,2d
    guardarCoeficienteIntegral coeficiente1I,1d

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
;########################## ESCRIBE UN COEFICIENTE CON SU SIGNO (INTEGRAL) ###################
;##############################################################################

guardarCoeficienteIntegral macro coeficiente,numero
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
    mov stringCa,"/"
    escribirCadenaArchivo 1,stringCa
    escribirNumero [coeficiente + 2]


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

;##############################################################################
;########################## OBTENER FECHA###################
;##############################################################################

obtenerFecha macro
   LOCAL decena,mes,anio,decena2
   mov ah,2ah
   int 21h

   mov year,cx
   mov day,dl
   mov month,dh

   cmp day,10d
   jge decena

   add day,48d
   escribirCadenaArchivo 1,day
   jmp mes

   decena:
      mov al,day
      mostrarDecenas day

   mes:
      escribirCadenaArchivo 1,diagonal

      cmp month,10d
      jge decena2 

      add month,48d
      escribirCadenaArchivo 1,month

      jmp anio

      decena2:
         mov al,month
         mostrarDecenas month

   anio:
      escribirCadenaArchivo 1,diagonal
      mov bx,offset year
      mov ax,[bx]
      mov cl,10
      div cl
      mov year1,ah

      mov ah, 0
      mov cl, 10
      div cl
      mov year2,ah

      mov ah, 0
      mov cl, 10
      div cl
      mov year3,ah

      mov ah, 0
      mov cl, 10
      div cl
      mov year4,ah

      add year1,48d
      add year2,48d
      add year3,48d
      add year4,48d
      escribirCadenaArchivo 1,year4
      escribirCadenaArchivo 1,year3
      escribirCadenaArchivo 1,year2
      escribirCadenaArchivo 1,year1
endm

obtenerHora macro 
   LOCAL decenas,minutosE,decenas2,segundosE,decenas3,salida
   mov ah, 2Ch
   int 21h

   mov  horas,ch
   mov minutos,cl
   mov segundos,dh

   cmp horas,10d
   jge decenas
   add horas,48d
   escribirCadenaArchivo 1,horas
   
   jmp minutosE


   decenas:
      mov al,horas
      mostrarDecenas horas

   minutosE:
      mov stringCa,":"
      escribirCadenaArchivo 1,stringCa

      cmp minutos,10d
      jge decenas2
      add minutos,48d
      escribirCadenaArchivo 1,minutos
      jmp segundosE
      
      decenas2:
         mov al,minutos
         mostrarDecenas minutos



   segundosE:
      mov stringCa,":"
      escribirCadenaArchivo 1,stringCa

      cmp segundos,10d 
      jge decenas3

      add segundos,48d
      escribirCadenaArchivo 1,segundos
      jmp salida



      decenas3:
         mov al,segundos
         mostrarDecenas segundos


      salida:
    
endm


;##############################################################################
;########################## MUESTRA DECENAS Y LAS GUARDA EN UN ARCHIVO ###################
;##############################################################################
mostrarDecenas macro numero
   xor ah,ah 
   mov cl,10d 
   div cl 
   mov day,al
   add day,48d
   mov day2,ah
   add day2,48d
   escribirCadenaArchivo 1,day
   escribirCadenaArchivo 1,day2
endm