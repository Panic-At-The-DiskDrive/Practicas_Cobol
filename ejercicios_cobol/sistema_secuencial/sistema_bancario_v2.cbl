       IDENTIFICATION DIVISION.
       PROGRAM-ID. SISTEMA-BANCARIO-V2.

       AUTHOR. DANIELLE.
       DATE-WRITTEN. 2026-01-16.
       DESCRIPTION.
           Sistema bancario simplificado con manejo de cuentas
           y registro de movimientos.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUENTAS-FILE ASSIGN TO "cuentas.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT MOVIMIENTOS-FILE ASSIGN TO "movimientos.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  CUENTAS-FILE.
       01  CUENTA-REG.
           05  CTA-NRO        PIC 9(10).
           05  CTA-TITULAR    PIC X(30).
           05  CTA-TIPO       PIC X(2).
           05  CTA-SALDO      PIC 9(9)V99.
           05  CTA-ESTADO     PIC X(10).

       FD  MOVIMIENTOS-FILE.
       01  MOV-REG.
           05  MOV-CTA        PIC 9(10).
           05  MOV-FECHA      PIC 9(8).
           05  MOV-TIPO       PIC X(3).
           05  MOV-MONTO      PIC 9(9)V99.
           05  MOV-SALDO      PIC 9(9)V99.

       WORKING-STORAGE SECTION.

       01  WS-OPCION        PIC 9 VALUE 0.
       01  WS-EOF           PIC X VALUE "N".
       01  WS-ENCONTRADO    PIC X VALUE "N".
       01  WS-BUSCAR-CTA    PIC 9(10).
       01  WS-MONTO         PIC 9(9)V99.
       01  WS-FECHA         PIC 9(8).

       PROCEDURE DIVISION.
       MAIN.
           PERFORM UNTIL WS-OPCION = 7
               PERFORM MENU
               ACCEPT WS-OPCION
               EVALUATE WS-OPCION
                   WHEN 1 PERFORM ALTA-CUENTA
                   WHEN 2 PERFORM CONSULTAR-CUENTA
                   WHEN 3 PERFORM DEPOSITAR
                   WHEN 4 PERFORM EXTRAER
                   WHEN 5 PERFORM LISTAR-CUENTAS
                   WHEN 6 PERFORM LISTAR-MOVIMIENTOS
                   WHEN 7 DISPLAY "FIN DEL SISTEMA"
                   WHEN OTHER DISPLAY "OPCION INVALIDA"
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       MENU.
           DISPLAY "----------------------------------"
           DISPLAY " SISTEMA BANCARIO - VERSION 2 "
           DISPLAY "----------------------------------"
           DISPLAY "1 - Alta de cuenta"
           DISPLAY "2 - Consultar cuenta"
           DISPLAY "3 - Depositar"
           DISPLAY "4 - Extraer"
           DISPLAY "5 - Listar cuentas"
           DISPLAY "6 - Ver movimientos"
           DISPLAY "7 - Salir"
           DISPLAY "Seleccione opcion: ".

       ALTA-CUENTA.
           OPEN EXTEND CUENTAS-FILE
           DISPLAY "Numero de cuenta: "
           ACCEPT CTA-NRO
           DISPLAY "Titular: "
           ACCEPT CTA-TITULAR
           DISPLAY "Tipo (CA/CC): "
           ACCEPT CTA-TIPO
           MOVE 0 TO CTA-SALDO
           MOVE "ACTIVA" TO CTA-ESTADO
           WRITE CUENTA-REG
           CLOSE CUENTAS-FILE
           DISPLAY "CUENTA CREADA".

       CONSULTAR-CUENTA.
           DISPLAY "Numero de cuenta: "
           ACCEPT WS-BUSCAR-CTA
           PERFORM BUSCAR-CUENTA
           IF WS-ENCONTRADO = "S"
               DISPLAY "TITULAR: " CTA-TITULAR
               DISPLAY "SALDO: " CTA-SALDO
               DISPLAY "ESTADO: " CTA-ESTADO
           ELSE
               DISPLAY "CUENTA NO EXISTE"
           END-IF.

       BUSCAR-CUENTA.
           OPEN INPUT CUENTAS-FILE
           MOVE "N" TO WS-EOF WS-ENCONTRADO
           PERFORM UNTIL WS-EOF = "S"
               READ CUENTAS-FILE
                   AT END MOVE "S" TO WS-EOF
                   NOT AT END
                       IF CTA-NRO = WS-BUSCAR-CTA
                           MOVE "S" TO WS-ENCONTRADO
                           MOVE "S" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM
           CLOSE CUENTAS-FILE.

       DEPOSITAR.
           DISPLAY "Cuenta: "
           ACCEPT WS-BUSCAR-CTA
           DISPLAY "Monto: "
           ACCEPT WS-MONTO
           PERFORM OPERAR-CUENTA
               USING "DEP".

       EXTRAER.
           DISPLAY "Cuenta: "
           ACCEPT WS-BUSCAR-CTA
           DISPLAY "Monto: "
           ACCEPT WS-MONTO
           PERFORM OPERAR-CUENTA
               USING "EXT".

       OPERAR-CUENTA USING MOV-TIPO.
           OPEN I-O CUENTAS-FILE
           MOVE "N" TO WS-EOF WS-ENCONTRADO
           PERFORM UNTIL WS-EOF = "S"
               READ CUENTAS-FILE
                   AT END MOVE "S" TO WS-EOF
                   NOT AT END
                       IF CTA-NRO = WS-BUSCAR-CTA
                           IF CTA-ESTADO NOT = "ACTIVA"
                               DISPLAY "CUENTA BLOQUEADA"
                           ELSE
                               IF MOV-TIPO = "EXT"
                                   AND CTA-SALDO < WS-MONTO
                                   DISPLAY "SALDO INSUFICIENTE"
                               ELSE
                                   IF MOV-TIPO = "DEP"
                                       ADD WS-MONTO TO CTA-SALDO
                                   ELSE
                                       SUBTRACT WS-MONTO FROM CTA-SALDO
                                   END-IF
                                   REWRITE CUENTA-REG
                                   PERFORM REGISTRAR-MOVIMIENTO
                                   DISPLAY "OPERACION OK"
                               END-IF
                           END-IF
                           MOVE "S" TO WS-ENCONTRADO WS-EOF
                       END-IF
               END-READ
           END-PERFORM
           CLOSE CUENTAS-FILE.

       REGISTRAR-MOVIMIENTO.
           ACCEPT WS-FECHA FROM DATE YYYYMMDD
           OPEN EXTEND MOVIMIENTOS-FILE
           MOVE WS-BUSCAR-CTA TO MOV-CTA
           MOVE WS-FECHA      TO MOV-FECHA
           MOVE WS-MONTO      TO MOV-MONTO
           MOVE CTA-SALDO     TO MOV-SALDO
           WRITE MOV-REG
           CLOSE MOVIMIENTOS-FILE.

       LISTAR-CUENTAS.
           OPEN INPUT CUENTAS-FILE
           MOVE "N" TO WS-EOF
           PERFORM UNTIL WS-EOF = "S"
               READ CUENTAS-FILE
                   AT END MOVE "S" TO WS-EOF
                   NOT AT END
                       DISPLAY CTA-NRO " - " CTA-TITULAR
                       DISPLAY "SALDO: " CTA-SALDO
               END-READ
           END-PERFORM
           CLOSE CUENTAS-FILE.

       LISTAR-MOVIMIENTOS.
           OPEN INPUT MOVIMIENTOS-FILE
           MOVE "N" TO WS-EOF
           PERFORM UNTIL WS-EOF = "S"
               READ MOVIMIENTOS-FILE
                   AT END MOVE "S" TO WS-EOF
                   NOT AT END
                       DISPLAY MOV-CTA " "
                               MOV-FECHA " "
                               MOV-TIPO " "
                               MOV-MONTO " "
                               MOV-SALDO
               END-READ
           END-PERFORM
           CLOSE MOVIMIENTOS-FILE.
