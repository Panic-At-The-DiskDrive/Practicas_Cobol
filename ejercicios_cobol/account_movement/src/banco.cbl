       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANCO.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. GNU-COBOL.
       OBJECT-COMPUTER. GNU-COBOL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-OPCION              PIC 9 VALUE 0.

       01  WS-FIN                 PIC X VALUE 'N'.
           88  FIN-PROGRAMA       VALUE 'S'.

       PROCEDURE DIVISION.

       0000-INICIO.

           PERFORM UNTIL FIN-PROGRAMA

               DISPLAY " "
               DISPLAY "===================================="
               DISPLAY "          BANCO SIMPLE COBOL"
               DISPLAY "===================================="
               DISPLAY "1. Crear cuenta"
               DISPLAY "2. Consultar cuenta"
               DISPLAY "3. Depositar dinero"
               DISPLAY "4. Retirar dinero"
               DISPLAY "5. Transferir dinero"
               DISPLAY "6. Listar cuentas"
               DISPLAY "0. Salir"
               DISPLAY "===================================="
               DISPLAY "Seleccione una opcion: "
               ACCEPT WS-OPCION

               EVALUATE WS-OPCION

                   WHEN 1
                       CALL "CUENTAS" USING "CREAR"

                   WHEN 2
                       CALL "CUENTAS" USING "CONSULTAR"

                   WHEN 3
                       CALL "MOVIMIENTOS" USING "DEPOSITO"

                   WHEN 4
                       CALL "MOVIMIENTOS" USING "RETIRO"

                   WHEN 5
                       CALL "MOVIMIENTOS" USING "TRANSFERENCIA"

                   WHEN 6
                       CALL "CUENTAS" USING "LISTAR"

                   WHEN 0
                       MOVE 'S' TO WS-FIN

                   WHEN OTHER
                       DISPLAY "Opcion invalida."

               END-EVALUATE

           END-PERFORM.

           DISPLAY " "
           DISPLAY "Programa finalizado."
           STOP RUN.