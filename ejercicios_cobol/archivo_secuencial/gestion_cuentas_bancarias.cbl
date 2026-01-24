       IDENTIFICATION DIVISION.
       PROGRAM-ID. GESTION-CUENTAS-BANCARIAS.

       AUTHOR. DANIELLE.
       DATE-WRITTEN. 2026-01-16.
       DESCRIPTION.
           Sistema basico de gestion de cuentas bancarias
           utilizando archivo secuencial.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUENTAS-FILE ASSIGN TO "cuentas.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  CUENTAS-FILE.
       01  CUENTA-REGISTRO.
           05  CTA-NUMERO     PIC 9(10).
           05  CTA-TITULAR    PIC X(30).
           05  CTA-TIPO       PIC X(2).
           05  CTA-SALDO      PIC 9(9)V99.
           05  CTA-ESTADO     PIC X(10).

       WORKING-STORAGE SECTION.

       01  WS-OPCION           PIC 9 VALUE 0.
       01  WS-EOF              PIC X VALUE "N".
       01  WS-BUSCAR-NRO       PIC 9(10).
       01  WS-MONTO            PIC 9(9)V99.
       01  WS-ENCONTRADO       PIC X VALUE "N".

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           PERFORM UNTIL WS-OPCION = 6
               PERFORM MOSTRAR-MENU
               ACCEPT WS-OPCION
               EVALUATE WS-OPCION
                   WHEN 1
                       PERFORM ALTA-CUENTA
                   WHEN 2
                       PERFORM CONSULTAR-CUENTA
                   WHEN 3
                       PERFORM DEPOSITAR
                   WHEN 4
                       PERFORM EXTRAER
                   WHEN 5
                       PERFORM LISTAR-CUENTAS
                   WHEN 6
                       DISPLAY "SALIENDO DEL SISTEMA..."
                   WHEN OTHER
                       DISPLAY "OPCION INVALIDA"
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       MOSTRAR-MENU.
           DISPLAY "-----------------------------------"
           DISPLAY " SISTEMA DE CUENTAS BANCARIAS "
           DISPLAY "-----------------------------------"
           DISPLAY "1 - Alta de cuenta"
           DISPLAY "2 - Consultar cuenta"
           DISPLAY "3 - Depositar dinero"
           DISPLAY "4 - Extraer dinero"
           DISPLAY "5 - Listar cuentas"
           DISPLAY "6 - Salir"
           DISPLAY "Seleccione una opcion: ".

       ALTA-CUENTA.
           OPEN EXTEND CUENTAS-FILE
           DISPLAY "Numero de cuenta: "
           ACCEPT CTA-NUMERO
           DISPLAY "Titular: "
           ACCEPT CTA-TITULAR
           DISPLAY "Tipo de cuenta (CA/CC): "
           ACCEPT CTA-TIPO
           MOVE 0 TO CTA-SALDO
           MOVE "ACTIVA" TO CTA-ESTADO
           WRITE CUENTA-REGISTRO
           CLOSE CUENTAS-FILE
           DISPLAY "CUENTA CREADA CORRECTAMENTE".

       CONSULTAR-CUENTA.
           DISPLAY "Ingrese numero de cuenta: "
           ACCEPT WS-BUSCAR-NRO
           OPEN INPUT CUENTAS-FILE
           MOVE "N" TO WS-EOF
           MOVE "N" TO WS-ENCONTRADO

           PERFORM UNTIL WS-EOF = "S"
               READ CUENTAS-FILE
                   AT END
                       MOVE "S" TO WS-EOF
                   NOT AT END
                       IF CTA-NUMERO = WS-BUSCAR-NRO
                           DISPLAY "-----------------------------------"
                           DISPLAY "TITULAR: " CTA-TITULAR
                           DISPLAY "TIPO: " CTA-TIPO
                           DISPLAY "SALDO: " CTA-SALDO
                           DISPLAY "ESTADO: " CTA-ESTADO
                           MOVE "S" TO WS-ENCONTRADO
                           MOVE "S" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM

           IF WS-ENCONTRADO = "N"
               DISPLAY "CUENTA NO ENCONTRADA"
           END-IF

           CLOSE CUENTAS-FILE.

       DEPOSITAR.
           DISPLAY "Numero de cuenta: "
           ACCEPT WS-BUSCAR-NRO
           DISPLAY "Monto a depositar: "
           ACCEPT WS-MONTO

           OPEN I-O CUENTAS-FILE
           MOVE "N" TO WS-EOF
           MOVE "N" TO WS-ENCONTRADO

           PERFORM UNTIL WS-EOF = "S"
               READ CUENTAS-FILE
                   AT END
                       MOVE "S" TO WS-EOF
                   NOT AT END
                       IF CTA-NUMERO = WS-BUSCAR-NRO
                           ADD WS-MONTO TO CTA-SALDO
                           REWRITE CUENTA-REGISTRO
                           DISPLAY "DEPOSITO REALIZADO"
                           MOVE "S" TO WS-ENCONTRADO
                           MOVE "S" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM

           IF WS-ENCONTRADO = "N"
               DISPLAY "CUENTA NO ENCONTRADA"
           END-IF

           CLOSE CUENTAS-FILE.

       EXTRAER.
           DISPLAY "Numero de cuenta: "
           ACCEPT WS-BUSCAR-NRO
           DISPLAY "Monto a extraer: "
           ACCEPT WS-MONTO

           OPEN I-O CUENTAS-FILE
           MOVE "N" TO WS-EOF
           MOVE "N" TO WS-ENCONTRADO

           PERFORM UNTIL WS-EOF = "S"
               READ CUENTAS-FILE
                   AT END
                       MOVE "S" TO WS-EOF
                   NOT AT END
                       IF CTA-NUMERO = WS-BUSCAR-NRO
                           IF CTA-SALDO >= WS-MONTO
                               SUBTRACT WS-MONTO FROM CTA-SALDO
                               REWRITE CUENTA-REGISTRO
                               DISPLAY "EXTRACCION REALIZADA"
                           ELSE
                               DISPLAY "SALDO INSUFICIENTE"
                           END-IF
                           MOVE "S" TO WS-ENCONTRADO
                           MOVE "S" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM

           IF WS-ENCONTRADO = "N"
               DISPLAY "CUENTA NO ENCONTRADA"
           END-IF

           CLOSE CUENTAS-FILE.

       LISTAR-CUENTAS.
           OPEN INPUT CUENTAS-FILE
           MOVE "N" TO WS-EOF

           PERFORM UNTIL WS-EOF = "S"
               READ CUENTAS-FILE
                   AT END
                       MOVE "S" TO WS-EOF
                   NOT AT END
                       DISPLAY "-----------------------------------"
                       DISPLAY "CTA: " CTA-NUMERO
                       DISPLAY "TITULAR: " CTA-TITULAR
                       DISPLAY "SALDO: " CTA-SALDO
                       DISPLAY "ESTADO: " CTA-ESTADO
               END-READ
           END-PERFORM

           CLOSE CUENTAS-FILE.
