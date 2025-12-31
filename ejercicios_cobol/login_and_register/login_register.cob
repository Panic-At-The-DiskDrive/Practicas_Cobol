       IDENTIFICATION DIVISION.
       PROGRAM-ID. RegisterLoginSimple.
       AUTHOR. Simonetta, Daniel.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       77 OPCION                PIC 9.
       77 USUARIO-REGISTRADO    PIC X(20) VALUE SPACES.
       77 PASSWORD-REGISTRADO   PIC X(20) VALUE SPACES.

       77 USUARIO-INGRESADO     PIC X(20).
       77 PASSWORD-INGRESADO    PIC X(20).

       77 EXISTE-USUARIO        PIC X VALUE "N".
       77 AUTENTICADO           PIC X VALUE "N".

       PROCEDURE DIVISION.
       MAIN.
           PERFORM MOSTRAR-MENU
           STOP RUN.

       MOSTRAR-MENU.
           DISPLAY "============================".
           DISPLAY " 1 - Registrar usuario".
           DISPLAY " 2 - Login".
           DISPLAY "============================".
           DISPLAY "Seleccione opcion: ".
           ACCEPT OPCION

           EVALUATE OPCION
               WHEN 1
                   PERFORM REGISTRAR-USUARIO
               WHEN 2
                   PERFORM LOGIN-USUARIO
               WHEN OTHER
                   DISPLAY "Opcion invalida"
           END-EVALUATE.

       REGISTRAR-USUARIO.
           DISPLAY "===== REGISTRO =====".
           DISPLAY "Nuevo usuario: ".
           ACCEPT USUARIO-REGISTRADO

           DISPLAY "Nueva password: ".
           ACCEPT PASSWORD-REGISTRADO

           MOVE "S" TO EXISTE-USUARIO

           DISPLAY "Usuario registrado correctamente.".

       LOGIN-USUARIO.
           IF EXISTE-USUARIO NOT = "S"
               DISPLAY "No hay usuarios registrados."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "===== LOGIN =====".
           DISPLAY "Usuario: ".
           ACCEPT USUARIO-INGRESADO

           DISPLAY "Password: ".
           ACCEPT PASSWORD-INGRESADO

           IF USUARIO-INGRESADO = USUARIO-REGISTRADO
              AND PASSWORD-INGRESADO = PASSWORD-REGISTRADO
                  MOVE "S" TO AUTENTICADO
           ELSE
                  MOVE "N" TO AUTENTICADO
           END-IF

           IF AUTENTICADO = "S"
               DISPLAY "Login correcto. Bienvenido!"
           ELSE
               DISPLAY "Usuario o password incorrectos."
           END-IF.
