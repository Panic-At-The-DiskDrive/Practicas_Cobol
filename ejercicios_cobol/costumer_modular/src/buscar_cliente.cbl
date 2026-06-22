       IDENTIFICATION DIVISION.
       PROGRAM-ID. BUSCAR_CLIENTE.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY CLIENTE.
       COPY SQLCA.

       PROCEDURE DIVISION.

       INICIO.

           DISPLAY " "
           DISPLAY "====== BUSCAR CLIENTE ======"

           DISPLAY "INGRESE EL ID DEL CLIENTE:"
           ACCEPT WS-ID

           EXEC SQL
               SELECT
                   NOMBRE,
                   APELLIDO,
                   EMAIL
               INTO
                   :WS-NOMBRE,
                   :WS-APELLIDO,
                   :WS-EMAIL
               FROM CLIENTES
               WHERE ID = :WS-ID
           END-EXEC

           EVALUATE SQLCODE

               WHEN 0
                   DISPLAY " "
                   DISPLAY "CLIENTE ENCONTRADO"
                   DISPLAY "------------------------------"
                   DISPLAY "ID        : " WS-ID
                   DISPLAY "NOMBRE    : " WS-NOMBRE
                   DISPLAY "APELLIDO  : " WS-APELLIDO
                   DISPLAY "EMAIL     : " WS-EMAIL

               WHEN 100
                   DISPLAY "NO EXISTE UN CLIENTE CON ESE ID."

               WHEN OTHER
                   DISPLAY "ERROR AL BUSCAR EL CLIENTE."
                   DISPLAY "SQLCODE: " SQLCODE

           END-EVALUATE

           GOBACK.