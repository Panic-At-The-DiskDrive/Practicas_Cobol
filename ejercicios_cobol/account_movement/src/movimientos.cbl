       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOVIMIENTOS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT ARCHIVO-CUENTAS
               ASSIGN TO "../data/CUENTAS.DAT"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

           SELECT ARCHIVO-TEMP
               ASSIGN TO "../data/CUENTAS.TMP"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  ARCHIVO-CUENTAS.
       01  REGISTRO-CUENTA.
           05  CUENTA-ID        PIC 9(6).
           05  CUENTA-NOMBRE    PIC X(40).
           05  CUENTA-SALDO     PIC S9(9)V99.
           05  CUENTA-ACTIVA    PIC X.

       FD  ARCHIVO-TEMP.
       01  REGISTRO-TEMP.
           05  TEMP-ID          PIC 9(6).
           05  TEMP-NOMBRE      PIC X(40).
           05  TEMP-SALDO       PIC S9(9)V99.
           05  TEMP-ACTIVA      PIC X.

       WORKING-STORAGE SECTION.

       01  WS-ACCION            PIC X(15).

       01  WS-FILE-STATUS       PIC XX.

       01  WS-CUENTA-ID         PIC 9(6).

       01  WS-CUENTA-ORIGEN     PIC 9(6).

       01  WS-CUENTA-DESTINO    PIC 9(6).

       01  WS-MONTO             PIC S9(9)V99.

       01  WS-ENCONTRADA        PIC X VALUE 'N'.

       01  WS-ENCONTRADA-ORIGEN PIC X VALUE 'N'.

       01  WS-ENCONTRADA-DESTINO PIC X VALUE 'N'.

       01  WS-FIN-ARCHIVO       PIC X VALUE 'N'.

       PROCEDURE DIVISION USING WS-ACCION.

       0000-INICIO.

           EVALUATE WS-ACCION

               WHEN "DEPOSITO"
                   PERFORM 1000-DEPOSITO

               WHEN "RETIRO"
                   PERFORM 2000-RETIRO

               WHEN "TRANSFERENCIA"
                   PERFORM 3000-TRANSFERENCIA

           END-EVALUATE.

           GOBACK.

       1000-DEPOSITO.

           DISPLAY " "
           DISPLAY "=== DEPOSITO ==="

           DISPLAY "Ingrese ID de cuenta:"
           ACCEPT WS-CUENTA-ID

           DISPLAY "Ingrese monto:"
           ACCEPT WS-MONTO

           IF WS-MONTO <= 0

               DISPLAY "El monto debe ser mayor que cero."

           ELSE

               PERFORM 9000-ACTUALIZAR-CUENTA

           END-IF.

       2000-RETIRO.

           DISPLAY " "
           DISPLAY "=== RETIRO ==="

           DISPLAY "Ingrese ID de cuenta:"
           ACCEPT WS-CUENTA-ID

           DISPLAY "Ingrese monto:"
           ACCEPT WS-MONTO

           IF WS-MONTO <= 0

               DISPLAY "El monto debe ser mayor que cero."

           ELSE

               PERFORM 9100-RETIRAR-DINERO

           END-IF.

       3000-TRANSFERENCIA.

           DISPLAY " "
           DISPLAY "=== TRANSFERENCIA ==="

           DISPLAY "Cuenta origen:"
           ACCEPT WS-CUENTA-ORIGEN

           DISPLAY "Cuenta destino:"
           ACCEPT WS-CUENTA-DESTINO

           IF WS-CUENTA-ORIGEN = WS-CUENTA-DESTINO

               DISPLAY "Las cuentas deben ser diferentes."

           ELSE

               DISPLAY "Monto a transferir:"
               ACCEPT WS-MONTO

               IF WS-MONTO <= 0

                   DISPLAY "El monto debe ser mayor que cero."

               ELSE

                   PERFORM 9200-TRANSFERIR

               END-IF

           END-IF.

       9000-ACTUALIZAR-CUENTA.

           MOVE 'N' TO WS-ENCONTRADA
           MOVE 'N' TO WS-FIN-ARCHIVO

           OPEN INPUT ARCHIVO-CUENTAS
           OPEN OUTPUT ARCHIVO-TEMP

           IF WS-FILE-STATUS NOT = "00"

               DISPLAY "Error al abrir archivo."

           ELSE

               PERFORM UNTIL WS-FIN-ARCHIVO = 'S'

                   READ ARCHIVO-CUENTAS

                       AT END
                           MOVE 'S' TO WS-FIN-ARCHIVO

                       NOT AT END

                           IF CUENTA-ID = WS-CUENTA-ID

                               ADD WS-MONTO TO CUENTA-SALDO
                               MOVE 'S' TO WS-ENCONTRADA

                           END-IF

                           MOVE CUENTA-ID TO TEMP-ID
                           MOVE CUENTA-NOMBRE TO TEMP-NOMBRE
                           MOVE CUENTA-SALDO TO TEMP-SALDO
                           MOVE CUENTA-ACTIVA TO TEMP-ACTIVA

                           WRITE REGISTRO-TEMP

                   END-READ

               END-PERFORM

               CLOSE ARCHIVO-CUENTAS
               CLOSE ARCHIVO-TEMP

               IF WS-ENCONTRADA = 'S'

                   CALL "REEMPLAZAR-DATOS"

                   DISPLAY "Deposito realizado."
                   DISPLAY "Nuevo saldo: $"
                       CUENTA-SALDO

               ELSE

                   DISPLAY "Cuenta no encontrada."

               END-IF

           END-IF.

       9100-RETIRAR-DINERO.

           MOVE 'N' TO WS-ENCONTRADA
           MOVE 'N' TO WS-FIN-ARCHIVO

           OPEN INPUT ARCHIVO-CUENTAS
           OPEN OUTPUT ARCHIVO-TEMP

           IF WS-FILE-STATUS NOT = "00"

               DISPLAY "Error al abrir archivo."

           ELSE

               PERFORM UNTIL WS-FIN-ARCHIVO = 'S'

                   READ ARCHIVO-CUENTAS

                       AT END
                           MOVE 'S' TO WS-FIN-ARCHIVO

                       NOT AT END

                           IF CUENTA-ID = WS-CUENTA-ID

                               MOVE 'S' TO WS-ENCONTRADA

                               IF CUENTA-SALDO >= WS-MONTO

                                   SUBTRACT WS-MONTO
                                       FROM CUENTA-SALDO

                               ELSE

                                   DISPLAY
                                       "Saldo insuficiente."

                               END-IF

                           END-IF

                           MOVE CUENTA-ID TO TEMP-ID
                           MOVE CUENTA-NOMBRE TO TEMP-NOMBRE
                           MOVE CUENTA-SALDO TO TEMP-SALDO
                           MOVE CUENTA-ACTIVA TO TEMP-ACTIVA

                           WRITE REGISTRO-TEMP

                   END-READ

               END-PERFORM

               CLOSE ARCHIVO-CUENTAS
               CLOSE ARCHIVO-TEMP

               IF WS-ENCONTRADA = 'S'

                   CALL "REEMPLAZAR-DATOS"

                   DISPLAY "Operacion finalizada."

               ELSE

                   DISPLAY "Cuenta no encontrada."

               END-IF

           END-IF.

       9200-TRANSFERIR.

           MOVE 'N' TO WS-ENCONTRADA-ORIGEN
           MOVE 'N' TO WS-ENCONTRADA-DESTINO
           MOVE 'N' TO WS-FIN-ARCHIVO

           OPEN INPUT ARCHIVO-CUENTAS

           PERFORM UNTIL WS-FIN-ARCHIVO = 'S'

               READ ARCHIVO-CUENTAS

                   AT END
                       MOVE 'S' TO WS-FIN-ARCHIVO

                   NOT AT END

                       IF CUENTA-ID = WS-CUENTA-ORIGEN

                           MOVE 'S' TO WS-ENCONTRADA-ORIGEN

                           IF CUENTA-SALDO < WS-MONTO

                               DISPLAY "Saldo insuficiente."
                               MOVE 'S' TO WS-FIN-ARCHIVO

                           END-IF

                       END-IF

                       IF CUENTA-ID = WS-CUENTA-DESTINO

                           MOVE 'S' TO WS-ENCONTRADA-DESTINO

                       END-IF

               END-READ

           END-PERFORM

           CLOSE ARCHIVO-CUENTAS

           IF WS-ENCONTRADA-ORIGEN = 'N'

               DISPLAY "Cuenta origen no encontrada."

           ELSE

               IF WS-ENCONTRADA-DESTINO = 'N'

                   DISPLAY "Cuenta destino no encontrada."

               ELSE

                   PERFORM 9300-EJECUTAR-TRANSFERENCIA

               END-IF

           END-IF.

       9300-EJECUTAR-TRANSFERENCIA.

           MOVE 'N' TO WS-FIN-ARCHIVO

           OPEN INPUT ARCHIVO-CUENTAS
           OPEN OUTPUT ARCHIVO-TEMP

           PERFORM UNTIL WS-FIN-ARCHIVO = 'S'

               READ ARCHIVO-CUENTAS

                   AT END
                       MOVE 'S' TO WS-FIN-ARCHIVO

                   NOT AT END

                       IF CUENTA-ID = WS-CUENTA-ORIGEN

                           SUBTRACT WS-MONTO
                               FROM CUENTA-SALDO

                       END-IF

                       IF CUENTA-ID = WS-CUENTA-DESTINO

                           ADD WS-MONTO
                               TO CUENTA-SALDO

                       END-IF

                       MOVE CUENTA-ID TO TEMP-ID
                       MOVE CUENTA-NOMBRE TO TEMP-NOMBRE
                       MOVE CUENTA-SALDO TO TEMP-SALDO
                       MOVE CUENTA-ACTIVA TO TEMP-ACTIVA

                       WRITE REGISTRO-TEMP

               END-READ

           END-PERFORM

           CLOSE ARCHIVO-CUENTAS
           CLOSE ARCHIVO-TEMP

           CALL "REEMPLAZAR-DATOS"

           DISPLAY "Transferencia realizada correctamente.".