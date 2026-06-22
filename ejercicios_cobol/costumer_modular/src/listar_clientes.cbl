       IDENTIFICATION DIVISION.
       PROGRAM-ID. LISTAR_CLIENTES.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY CLIENTE.
       COPY SQLCA.

       01 WS-FIN-CURSOR           PIC X VALUE 'N'.

       PROCEDURE DIVISION.

       INICIO.

           DISPLAY " "
           DISPLAY "========== LISTADO DE CLIENTES =========="
           DISPLAY " "

           EXEC SQL
               DECLARE CLIENTES_CURSOR CURSOR FOR
                   SELECT
                       ID,
                       NOMBRE,
                       APELLIDO,
                       EMAIL
                   FROM CLIENTES
                   ORDER BY ID
           END-EXEC

           EXEC SQL
               OPEN CLIENTES_CURSOR
           END-EXEC

           IF SQLCODE NOT = 0
               DISPLAY "ERROR AL ABRIR EL CURSOR."
               DISPLAY "SQLCODE: " SQLCODE
               GOBACK
           END-IF

           PERFORM UNTIL WS-FIN-CURSOR = 'S'

               EXEC SQL
                   FETCH CLIENTES_CURSOR
                   INTO
                       :WS-ID,
                       :WS-NOMBRE,
                       :WS-APELLIDO,
                       :WS-EMAIL
               END-EXEC

               EVALUATE SQLCODE

                   WHEN 0
                       DISPLAY "----------------------------------------"
                       DISPLAY "ID       : " WS-ID
                       DISPLAY "NOMBRE   : " WS-NOMBRE
                       DISPLAY "APELLIDO : " WS-APELLIDO
                       DISPLAY "EMAIL    : " WS-EMAIL

                   WHEN 100
                       MOVE 'S' TO WS-FIN-CURSOR

                   WHEN OTHER
                       DISPLAY "ERROR DURANTE EL FETCH."
                       DISPLAY "SQLCODE: " SQLCODE
                       MOVE 'S' TO WS-FIN-CURSOR

               END-EVALUATE

           END-PERFORM

           EXEC SQL
               CLOSE CLIENTES_CURSOR
           END-EXEC

           DISPLAY " "
           DISPLAY "========== FIN DEL LISTADO =========="

           GOBACK.