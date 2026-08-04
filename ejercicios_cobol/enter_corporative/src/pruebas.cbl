       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRUEBAS.

      *****************************************************************
      * PROGRAMA:
      * PRUEBAS
      *
      * DESCRIPCION:
      * Programa principal de pruebas del sistema bancario.
      * Ejecuta los modulos:
      *   - CUENTAS
      *   - MOVIMIENTOS
      *****************************************************************

       ENVIRONMENT DIVISION.


       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY CONSTANTES.
       COPY MENSAJES.


       01 WS-OPCION              PIC 9.

       01 WS-FIN                 PIC X VALUE "N".

           88 FIN-PROGRAMA       VALUE "S".


       01 WS-ACCION-CUENTAS      PIC X(20).

       01 WS-ACCION-MOVIMIENTO   PIC X(20).


       PROCEDURE DIVISION.


       0000-INICIO.


           PERFORM 1000-MENU


           STOP RUN.



      *****************************************************************
      * MENU PRINCIPAL
      *****************************************************************

       1000-MENU.


           PERFORM UNTIL FIN-PROGRAMA


               DISPLAY SPACE

               DISPLAY MSG-TITULO-PRINCIPAL
               DISPLAY MSG-NOMBRE-SISTEMA
               DISPLAY MSG-SEPARADOR

               DISPLAY MSG-MENU-01
               DISPLAY MSG-MENU-02
               DISPLAY MSG-MENU-03
               DISPLAY MSG-MENU-04
               DISPLAY MSG-MENU-05
               DISPLAY MSG-MENU-06
               DISPLAY MSG-MENU-07
               DISPLAY MSG-MENU-00


               DISPLAY MSG-INGRESE-OPCION

               ACCEPT WS-OPCION



               EVALUATE WS-OPCION


                   WHEN 1

                       MOVE "ALTA"
                         TO WS-ACCION-CUENTAS

                       CALL "CUENTAS"
                           USING WS-ACCION-CUENTAS



                   WHEN 2

                       MOVE "CONSULTA"
                         TO WS-ACCION-CUENTAS

                       CALL "CUENTAS"
                           USING WS-ACCION-CUENTAS



                   WHEN 3

                       MOVE "DEPOSITO"
                         TO WS-ACCION-MOVIMIENTO

                       CALL "MOVIMIENTOS"
                           USING WS-ACCION-MOVIMIENTO



                   WHEN 4

                       MOVE "RETIRO"
                         TO WS-ACCION-MOVIMIENTO

                       CALL "MOVIMIENTOS"
                           USING WS-ACCION-MOVIMIENTO



                   WHEN 5

                       MOVE "TRANSFERENCIA"
                         TO WS-ACCION-MOVIMIENTO

                       CALL "MOVIMIENTOS"
                           USING WS-ACCION-MOVIMIENTO



                   WHEN 6

                       MOVE "LISTADO"
                         TO WS-ACCION-CUENTAS

                       CALL "CUENTAS"
                           USING WS-ACCION-CUENTAS



                   WHEN 7

                       MOVE "CIERRE"
                         TO WS-ACCION-CUENTAS

                       CALL "CUENTAS"
                           USING WS-ACCION-CUENTAS



                   WHEN 0

                       MOVE "S"
                         TO WS-FIN



                   WHEN OTHER

                       DISPLAY MSG-OPCION-INVALIDA


               END-EVALUATE


           END-PERFORM.



      *****************************************************************
      * FINAL
      *****************************************************************

       9000-FINALIZAR.


           DISPLAY SPACE

           DISPLAY MSG-DESPEDIDA.