       IDENTIFICATION DIVISION.
       PROGRAM-ID. INICIALIZAR.

      *****************************************************************
      * PROGRAMA:
      * INICIALIZAR
      *
      * DESCRIPCION:
      * Crea e inicializa el archivo indexado de cuentas bancarias.
      *****************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT ARCHIVO-CUENTAS
               ASSIGN TO "../data/CUENTAS.DAT"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS CTA-ID
               FILE STATUS IS WS-FILE-STATUS.


       DATA DIVISION.

       FILE SECTION.

       FD  ARCHIVO-CUENTAS.

       COPY CUENTA.


       WORKING-STORAGE SECTION.

       COPY CONSTANTES.
       COPY MENSAJES.


       01 WS-FILE-STATUS          PIC XX.

       01 WS-CONTINUAR            PIC X.


       PROCEDURE DIVISION.


       0000-INICIO.

           DISPLAY SPACE

           DISPLAY MSG-TITULO-PRINCIPAL
           DISPLAY MSG-NOMBRE-SISTEMA
           DISPLAY MSG-SEPARADOR

           DISPLAY SPACE
           DISPLAY "INICIALIZANDO BASE DE DATOS..."



           OPEN OUTPUT ARCHIVO-CUENTAS


           IF WS-FILE-STATUS NOT = FS-OK

               DISPLAY MSG-ARCHIVO
               DISPLAY "CODIGO: "
                   WS-FILE-STATUS

               STOP RUN

           END-IF



           PERFORM 1000-CREAR-CUENTA-DEMO


           CLOSE ARCHIVO-CUENTAS



           DISPLAY SPACE
           DISPLAY "Archivo CUENTAS.DAT creado correctamente."

           DISPLAY "Inicializacion finalizada."

           STOP RUN.



      *****************************************************************
      * CREA REGISTRO DE PRUEBA
      *****************************************************************

       1000-CREAR-CUENTA-DEMO.


           MOVE ZERO
             TO REGISTRO-CUENTA


           MOVE 0001
             TO CTA-SUCURSAL


           MOVE 00000001
             TO CTA-ID


           MOVE "JUAN"
             TO CTA-NOMBRE


           MOVE "PEREZ"
             TO CTA-APELLIDO


           MOVE "DNI"
             TO CTA-TIPO-DOC


           MOVE 1234567890
             TO CTA-NRO-DOC


           MOVE CTE-CAJA-AHORRO
             TO CTA-TIPO


           MOVE CTE-PESOS
             TO CTA-MONEDA


           MOVE 50000.00
             TO CTA-SALDO


           MOVE CTE-CUENTA-ACTIVA
             TO CTA-ACTIVA


           MOVE CTE-NO-BLOQUEADA
             TO CTA-BLOQUEADA


           MOVE ZERO
             TO CTA-CANT-DEPOSITOS
                CTA-CANT-RETIROS
                CTA-CANT-TRANSFER


           WRITE REGISTRO-CUENTA


           IF WS-FILE-STATUS = FS-OK

               DISPLAY "Cuenta demo creada."

           ELSE

               DISPLAY "Error creando cuenta demo."
               DISPLAY WS-FILE-STATUS

           END-IF.