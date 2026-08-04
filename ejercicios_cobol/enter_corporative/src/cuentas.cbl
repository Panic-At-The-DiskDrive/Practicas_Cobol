       IDENTIFICATION DIVISION.
       PROGRAM-ID. CUENTAS.

      *****************************************************************
      * MODULO DE GESTION DE CUENTAS
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

       01 WS-FILE-STATUS         PIC XX.

       01 WS-ACCION              PIC X(20).

       LINKAGE SECTION.

       01 LK-ACCION              PIC X(20).

       PROCEDURE DIVISION USING LK-ACCION.

           MOVE LK-ACCION
             TO WS-ACCION

           EVALUATE WS-ACCION

               WHEN "ALTA"
                   PERFORM 1000-ALTA-CUENTA

               WHEN "CONSULTA"
                   PERFORM 2000-CONSULTA

               WHEN "LISTADO"
                   PERFORM 3000-LISTADO

               WHEN "CIERRE"
                   PERFORM 4000-CIERRE

               WHEN OTHER
                   DISPLAY MSG-OPCION-INVALIDA

           END-EVALUATE

           GOBACK.

      *****************************************************************
      * ALTA
      *****************************************************************

       1000-ALTA-CUENTA.

           DISPLAY SPACE
           DISPLAY MSG-ALTA-CUENTA

           DISPLAY MSG-INGRESE-SUCURSAL
           ACCEPT CTA-SUCURSAL

           DISPLAY MSG-INGRESE-CUENTA
           ACCEPT CTA-ID

           READ ARCHIVO-CUENTAS
                INVALID KEY
                    CONTINUE
                NOT INVALID KEY
                    DISPLAY MSG-CUENTA-EXISTE
                    EXIT PARAGRAPH
           END-READ

           DISPLAY MSG-INGRESE-NOMBRE
           ACCEPT CTA-NOMBRE

           DISPLAY MSG-INGRESE-APELLIDO
           ACCEPT CTA-APELLIDO

           DISPLAY MSG-INGRESE-DOCUMENTO
           ACCEPT CTA-NRO-DOC

           MOVE "DNI"
             TO CTA-TIPO-DOC

           MOVE CTE-CAJA-AHORRO
             TO CTA-TIPO

           MOVE CTE-PESOS
             TO CTA-MONEDA

           MOVE SALDO-INICIAL
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

               DISPLAY MSG-CUENTA-CREADA

           ELSE

               DISPLAY MSG-ERROR-GENERAL

           END-IF.

      *****************************************************************
      * CONSULTA
      *****************************************************************

       2000-CONSULTA.

           DISPLAY SPACE
           DISPLAY MSG-CONSULTA

           DISPLAY MSG-INGRESE-CUENTA
           ACCEPT CTA-ID

           READ ARCHIVO-CUENTAS

               INVALID KEY

                   DISPLAY MSG-CUENTA-NO-EXISTE

               NOT INVALID KEY

                   DISPLAY "------------------------------"
                   DISPLAY MSG-TITULAR
                   DISPLAY CTA-APELLIDO SPACE CTA-NOMBRE

                   DISPLAY MSG-SALDO-ACTUAL
                   DISPLAY CTA-SALDO

                   DISPLAY MSG-TIPO-CUENTA
                   DISPLAY CTA-TIPO

                   DISPLAY MSG-MONEDA
                   DISPLAY CTA-MONEDA

                   DISPLAY MSG-ESTADO
                   DISPLAY CTA-ACTIVA

           END-READ.

      *****************************************************************
      * LISTADO
      *****************************************************************

       3000-LISTADO.

           MOVE LOW-VALUES
             TO CTA-ID

           START ARCHIVO-CUENTAS
               KEY IS NOT LESS THAN CTA-ID

               INVALID KEY
                   DISPLAY MSG-CUENTA-NO-EXISTE

               NOT INVALID KEY

                   PERFORM UNTIL WS-FILE-STATUS = FS-FIN-ARCHIVO

                       READ ARCHIVO-CUENTAS NEXT RECORD

                           AT END
                               EXIT PERFORM

                           NOT AT END

                               DISPLAY
                               "--------------------------------"

                               DISPLAY CTA-SUCURSAL
                                       "-"
                                       CTA-ID

                               DISPLAY CTA-APELLIDO
                                       ", "
                                       CTA-NOMBRE

                               DISPLAY CTA-SALDO

                       END-READ

                   END-PERFORM

           END-START.

      *****************************************************************
      * CIERRE DE CUENTA
      *****************************************************************

       4000-CIERRE.

           DISPLAY SPACE
           DISPLAY MSG-CIERRE

           DISPLAY MSG-INGRESE-CUENTA
           ACCEPT CTA-ID

           READ ARCHIVO-CUENTAS

               INVALID KEY

                   DISPLAY MSG-CUENTA-NO-EXISTE

               NOT INVALID KEY

                   MOVE CTE-CUENTA-CERRADA
                     TO CTA-ACTIVA

                   REWRITE REGISTRO-CUENTA

                   IF WS-FILE-STATUS = FS-OK

                       DISPLAY MSG-CUENTA-CERRADA

                   ELSE

                       DISPLAY MSG-ERROR-GENERAL

                   END-IF

           END-READ.