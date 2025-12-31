       IDENTIFICATION DIVISION.
       PROGRAM-ID. LoginSimple.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 USUARIO-INGRESADO     PIC X(20).
       77 PASSWORD-INGRESADO    PIC X(20).
       77 USUARIO-REAL          PIC X(20) VALUE "simonetta".
       77 PASSWORD-REAL         PIC X(20) VALUE "1234".
       77 AUTENTICADO           PIC X VALUE "N".

       PROCEDURE DIVISION.
       INICIO.
           DISPLAY "===== LOGIN COBOL =====".
           
           DISPLAY "Usuario: ".
           ACCEPT USUARIO-INGRESADO.

           DISPLAY "Password: ".
           ACCEPT PASSWORD-INGRESADO.

           IF USUARIO-INGRESADO = USUARIO-REAL
              AND PASSWORD-INGRESADO = PASSWORD-REAL
                 MOVE "S" TO AUTENTICADO
           END-IF.

           IF AUTENTICADO = "S"
              DISPLAY "Login correcto. Bienvenido!"
           ELSE
              DISPLAY "Login incorrecto."
           END-IF.

           STOP RUN.
