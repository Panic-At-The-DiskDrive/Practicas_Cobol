       IDENTIFICATION DIVISION.
       PROGRAM-ID. MODIFICAR_CLIENTE.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY CLIENTE.
       COPY SQLCA.

       PROCEDURE DIVISION.

       INICIO.

           DISPLAY " "
           DISPLAY "====== MODIFICAR CLIENTE ======"

           DISPLAY "INGRESE EL ID DEL CLIENTE:"
           ACCEPT WS-ID

           DISPLAY "NUEVO EMAIL:"
           ACCEPT WS-EMAIL

           EXEC SQL
               UPDATE CLIENTES
                  SET EMAIL = :WS-EMAIL
                WHERE ID = :WS-ID
           END-EXEC

           EVALUATE SQLCODE

               WHEN 0
                   DISPLAY "EMAIL ACTUALIZADO CORRECTAMENTE."

               WHEN 100
                   DISPLAY "NO EXISTE UN CLIENTE CON ESE ID."

               WHEN OTHER
                   DISPLAY "ERROR AL MODIFICAR EL CLIENTE."
                   DISPLAY "SQLCODE: " SQLCODE

           END-EVALUATE

           GOBACK.