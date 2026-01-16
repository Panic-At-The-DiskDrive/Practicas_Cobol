       IDENTIFICATION DIVISION.
       PROGRAM-ID. GESTION-USUARIOS.

       AUTHOR. DANIELLE.
       DATE-WRITTEN. 2026-01-16.
       DESCRIPTION.
           Programa de gestion basica de usuarios utilizando
           archivo secuencial en COBOL.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USUARIOS-FILE ASSIGN TO "usuarios.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  USUARIOS-FILE.
       01  USUARIO-REGISTRO.
           05  USR-ID        PIC 9(5).
           05  USR-NOMBRE    PIC X(30).
           05  USR-EMAIL     PIC X(40).
           05  USR-ESTADO    PIC X(10).

       WORKING-STORAGE SECTION.

       01  WS-OPCION           PIC 9 VALUE 0.
       01  WS-EOF              PIC X VALUE "N".
       01  WS-BUSCAR-ID        PIC 9(5).
       01  WS-ENCONTRADO       PIC X VALUE "N".

       01  WS-NUEVO-USUARIO.
           05  WS-ID           PIC 9(5).
           05  WS-NOMBRE       PIC X(30).
           05  WS-EMAIL        PIC X(40).
           05  WS-ESTADO       PIC X(10).

       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           PERFORM UNTIL WS-OPCION = 4
               PERFORM MOSTRAR-MENU
               ACCEPT WS-OPCION
               EVALUATE WS-OPCION
                   WHEN 1
                       PERFORM ALTA-USUARIO
                   WHEN 2
                       PERFORM LISTAR-USUARIOS
                   WHEN 3
                       PERFORM BUSCAR-USUARIO
                   WHEN 4
                       DISPLAY "SALIENDO DEL SISTEMA..."
                   WHEN OTHER
                       DISPLAY "OPCION INVALIDA"
               END-EVALUATE
           END-PERFORM
           STOP RUN.

       MOSTRAR-MENU.
           DISPLAY "-----------------------------"
           DISPLAY " GESTION DE USUARIOS - COBOL "
           DISPLAY "-----------------------------"
           DISPLAY "1 - Alta de usuario"
           DISPLAY "2 - Listar usuarios"
           DISPLAY "3 - Buscar usuario por ID"
           DISPLAY "4 - Salir"
           DISPLAY "Seleccione una opcion: ".

       ALTA-USUARIO.
           OPEN EXTEND USUARIOS-FILE
           DISPLAY "Ingrese ID: "
           ACCEPT WS-ID
           DISPLAY "Ingrese nombre: "
           ACCEPT WS-NOMBRE
           DISPLAY "Ingrese email: "
           ACCEPT WS-EMAIL
           MOVE "ACTIVO" TO WS-ESTADO

           MOVE WS-ID     TO USR-ID
           MOVE WS-NOMBRE TO USR-NOMBRE
           MOVE WS-EMAIL  TO USR-EMAIL
           MOVE WS-ESTADO TO USR-ESTADO

           WRITE USUARIO-REGISTRO
           CLOSE USUARIOS-FILE
           DISPLAY "USUARIO CARGADO CORRECTAMENTE".

       LISTAR-USUARIOS.
           OPEN INPUT USUARIOS-FILE
           MOVE "N" TO WS-EOF
           PERFORM UNTIL WS-EOF = "S"
               READ USUARIOS-FILE
                   AT END
                       MOVE "S" TO WS-EOF
                   NOT AT END
                       DISPLAY "-----------------------------"
                       DISPLAY "ID: " USR-ID
                       DISPLAY "NOMBRE: " USR-NOMBRE
                       DISPLAY "EMAIL: " USR-EMAIL
                       DISPLAY "ESTADO: " USR-ESTADO
               END-READ
           END-PERFORM
           CLOSE USUARIOS-FILE.

       BUSCAR-USUARIO.
           DISPLAY "Ingrese ID a buscar: "
           ACCEPT WS-BUSCAR-ID
           OPEN INPUT USUARIOS-FILE
           MOVE "N" TO WS-EOF
           MOVE "N" TO WS-ENCONTRADO

           PERFORM UNTIL WS-EOF = "S"
               READ USUARIOS-FILE
                   AT END
                       MOVE "S" TO WS-EOF
                   NOT AT END
                       IF USR-ID = WS-BUSCAR-ID
                           DISPLAY "-----------------------------"
                           DISPLAY "USUARIO ENCONTRADO"
                           DISPLAY "NOMBRE: " USR-NOMBRE
                           DISPLAY "EMAIL: " USR-EMAIL
                           DISPLAY "ESTADO: " USR-ESTADO
                           MOVE "S" TO WS-ENCONTRADO
                           MOVE "S" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM

           IF WS-ENCONTRADO = "N"
               DISPLAY "USUARIO NO ENCONTRADO"
           END-IF

           CLOSE USUARIOS-FILE.
