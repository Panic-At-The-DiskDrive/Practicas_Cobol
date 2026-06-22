       IDENTIFICATION DIVISION.
       PROGRAM-ID. ALTA_CLIENTE.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY CLIENTE.
       COPY SQLCA.

       PROCEDURE DIVISION.

       INICIO.

           DISPLAY " "
           DISPLAY "========== ALTA DE CLIENTE =========="

           DISPLAY "ID:"
           ACCEPT WS-ID

           DISPLAY "NOMBRE:"
           ACCEPT WS-NOMBRE

           DISPLAY "APELLIDO:"
           ACCEPT WS-APELLIDO

           DISPLAY "EMAIL:"
           ACCEPT WS-EMAIL

           EXEC SQL
               INSERT INTO CLIENTES
               (
                   ID,
                   NOMBRE,
                   APELLIDO,
                   EMAIL
               )
               VALUES
               (
                   :WS-ID,
                   :WS-NOMBRE,
                   :WS-APELLIDO,
                   :WS-EMAIL
               )
           END-EXEC

           IF SQLCODE = 0
               DISPLAY "CLIENTE REGISTRADO CORRECTAMENTE."
           ELSE
               DISPLAY "ERROR AL REGISTRAR CLIENTE."
               DISPLAY "SQLCODE: " SQLCODE
           END-IF

           GOBACK.