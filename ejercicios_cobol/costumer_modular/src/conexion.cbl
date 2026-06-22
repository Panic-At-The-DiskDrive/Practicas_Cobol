       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONEXION.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY SQLCA.

       01 WS-USUARIO              PIC X(30) VALUE "admin".
       01 WS-CONTRASENA           PIC X(30) VALUE "1234".
       01 WS-BASE-DATOS           PIC X(30) VALUE "CLIENTESDB".

       PROCEDURE DIVISION.

       INICIO.

           DISPLAY " "
           DISPLAY "========== CONEXION A LA BASE DE DATOS =========="

           EXEC SQL
               CONNECT :WS-USUARIO
               IDENTIFIED BY :WS-CONTRASENA
               USING :WS-BASE-DATOS
           END-EXEC

           EVALUATE SQLCODE

               WHEN 0
                   DISPLAY "CONEXION ESTABLECIDA CORRECTAMENTE."

               WHEN OTHER
                   DISPLAY "ERROR AL CONECTAR CON LA BASE DE DATOS."
                   DISPLAY "SQLCODE: " SQLCODE
                   STOP RUN

           END-EVALUATE

           GOBACK.