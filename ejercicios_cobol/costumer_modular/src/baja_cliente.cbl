       IDENTIFICATION DIVISION.
       PROGRAM-ID. BAJA_CLIENTE.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       COPY CLIENTE.
       COPY SQLCA.

       PROCEDURE DIVISION.

       INICIO.

           DISPLAY " "
           DISPLAY "========== BAJA DE CLIENTE =========="

           DISPLAY "INGRESE EL ID DEL CLIENTE A ELIMINAR:"
           ACCEPT WS-ID

           EXEC SQL
               DELETE FROM CLIENTES
               WHERE ID = :WS-ID
           END-EXEC

           EVALUATE SQLCODE

               WHEN 0
                   DISPLAY "CLIENTE ELIMINADO CORRECTAMENTE."

               WHEN 100
                   DISPLAY "NO EXISTE UN CLIENTE CON ESE ID."

               WHEN OTHER
                   DISPLAY "ERROR AL ELIMINAR CLIENTE."
                   DISPLAY "SQLCODE: " SQLCODE

           END-EVALUATE

           GOBACK.