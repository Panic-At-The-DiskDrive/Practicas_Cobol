       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOVIMIENTOS.

      *****************************************************************
      * MODULO DE MOVIMIENTOS BANCARIOS
      * OPERACIONES:
      *   - DEPOSITO
      *   - RETIRO
      *   - TRANSFERENCIA
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

       01  WS-FILE-STATUS            PIC XX.

       01  WS-ACCION                 PIC X(20).

       01  WS-MONTO                  PIC S9(11)V99.

       01  WS-CTA-DESTINO            PIC 9(8).

       01  WS-SALDO-ORIGEN           PIC S9(11)V99.

       01  WS-SALDO-DESTINO          PIC S9(11)V99.

       01  WS-REG-DESTINO.
           COPY CUENTA REPLACING ==REGISTRO-CUENTA==
                               BY ==REG-DESTINO==.

       LINKAGE SECTION.

       01  LK-ACCION                 PIC X(20).

       PROCEDURE DIVISION USING LK-ACCION.

           MOVE LK-ACCION
             TO WS-ACCION

           EVALUATE WS-ACCION

               WHEN "DEPOSITO"
                   PERFORM 1000-DEPOSITO

               WHEN "RETIRO"
                   PERFORM 2000-RETIRO

               WHEN "TRANSFERENCIA"
                   PERFORM 3000-TRANSFERENCIA

               WHEN OTHER
                   DISPLAY MSG-OPCION-INVALIDA

           END-EVALUATE

           GOBACK.

      *****************************************************************
      * DEPOSITO
      *****************************************************************

       1000-DEPOSITO.

           DISPLAY SPACE
           DISPLAY MSG-DEPOSITO

           DISPLAY MSG-INGRESE-CUENTA
           ACCEPT CTA-ID

           READ ARCHIVO-CUENTAS

               INVALID KEY

                   DISPLAY MSG-CUENTA-NO-EXISTE

               NOT INVALID KEY

                   IF CTA-ACTIVA NOT = CTE-CUENTA-ACTIVA

                       DISPLAY MSG-CUENTA-CERRADA-ERR

                   ELSE

                       DISPLAY MSG-INGRESE-MONTO
                       ACCEPT WS-MONTO

                       IF WS-MONTO <= 0

                           DISPLAY MSG-MONTO-INVALIDO

                       ELSE

                           ADD WS-MONTO
                               TO CTA-SALDO

                           ADD 1
                               TO CTA-CANT-DEPOSITOS

                           REWRITE REGISTRO-CUENTA

                           IF WS-FILE-STATUS = FS-OK

                               DISPLAY MSG-DEPOSITO-OK
                               DISPLAY MSG-SALDO-ACTUAL
                               DISPLAY CTA-SALDO

                           ELSE

                               DISPLAY MSG-ERROR-GENERAL

                           END-IF

                       END-IF

                   END-IF

           END-READ.

      *****************************************************************
      * RETIRO
      *****************************************************************

       2000-RETIRO.

           DISPLAY SPACE
           DISPLAY MSG-RETIRO

           DISPLAY MSG-INGRESE-CUENTA
           ACCEPT CTA-ID

           READ ARCHIVO-CUENTAS

               INVALID KEY

                   DISPLAY MSG-CUENTA-NO-EXISTE

               NOT INVALID KEY

                   IF CTA-ACTIVA NOT = CTE-CUENTA-ACTIVA

                       DISPLAY MSG-CUENTA-CERRADA-ERR

                   ELSE

                       DISPLAY MSG-INGRESE-MONTO
                       ACCEPT WS-MONTO

                       IF WS-MONTO <= 0

                           DISPLAY MSG-MONTO-INVALIDO

                       ELSE

                           IF CTA-SALDO < WS-MONTO

                               DISPLAY MSG-SALDO-INSUFICIENTE

                           ELSE

                               SUBTRACT WS-MONTO
                                   FROM CTA-SALDO

                               ADD 1
                                   TO CTA-CANT-RETIROS

                               REWRITE REGISTRO-CUENTA

                               IF WS-FILE-STATUS = FS-OK

                                   DISPLAY MSG-RETIRO-OK
                                   DISPLAY MSG-SALDO-ACTUAL
                                   DISPLAY CTA-SALDO

                               ELSE

                                   DISPLAY MSG-ERROR-GENERAL

                               END-IF

                           END-IF

                       END-IF

                   END-IF

           END-READ.

      *****************************************************************
      * TRANSFERENCIA
      *****************************************************************

       3000-TRANSFERENCIA.

           DISPLAY SPACE
           DISPLAY MSG-TRANSFERENCIA

           DISPLAY MSG-INGRESE-CUENTA
           ACCEPT CTA-ID

           DISPLAY MSG-INGRESE-DESTINO
           ACCEPT WS-CTA-DESTINO

           DISPLAY MSG-INGRESE-MONTO
           ACCEPT WS-MONTO

           IF WS-MONTO <= 0

               DISPLAY MSG-MONTO-INVALIDO
               EXIT PARAGRAPH

           END-IF

           READ ARCHIVO-CUENTAS

               INVALID KEY

                   DISPLAY MSG-CUENTA-NO-EXISTE
                   EXIT PARAGRAPH

           END-READ

           MOVE CTA-SALDO
             TO WS-SALDO-ORIGEN

           IF WS-SALDO-ORIGEN < WS-MONTO

               DISPLAY MSG-SALDO-INSUFICIENTE
               EXIT PARAGRAPH

           END-IF

           MOVE WS-CTA-DESTINO
             TO CTA-ID

           READ ARCHIVO-CUENTAS

               INVALID KEY

                   DISPLAY MSG-CUENTA-NO-EXISTE
                   EXIT PARAGRAPH

           END-READ

           MOVE REGISTRO-CUENTA
             TO REG-DESTINO

      *--- Actualiza destino -----------------------------------------

           ADD WS-MONTO
               TO CTA-SALDO

           ADD 1
               TO CTA-CANT-TRANSFER

           REWRITE REGISTRO-CUENTA

           IF WS-FILE-STATUS NOT = FS-OK

               DISPLAY MSG-ERROR-GENERAL
               EXIT PARAGRAPH

           END-IF

      *--- Actualiza origen ------------------------------------------

           MOVE REG-DESTINO
             TO REGISTRO-CUENTA

           MOVE WS-SALDO-ORIGEN
             TO CTA-SALDO

           SUBTRACT WS-MONTO
               FROM CTA-SALDO

           ADD 1
               TO CTA-CANT-TRANSFER

           REWRITE REGISTRO-CUENTA

           IF WS-FILE-STATUS = FS-OK

               DISPLAY MSG-TRANSFERENCIA-OK

           ELSE

               DISPLAY MSG-ERROR-GENERAL

           END-IF.