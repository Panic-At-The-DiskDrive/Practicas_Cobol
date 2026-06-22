       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       AUTHOR. Simonetta, Daniel.
       DATE-WRITTEN. 22/06/2026.
       DATE-COMPILED. 22/06/2026.
       INSTALLATION. Proyecto.
       SECURITY. Ninguna.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 WS-OPCION               PIC 9 VALUE 0.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           PERFORM INICIAR-SISTEMA

           PERFORM UNTIL WS-OPCION = 6

               CALL "MENU"
                   USING WS-OPCION

               EVALUATE WS-OPCION

                   WHEN 1
                       CALL "ALTA_CLIENTE"

                   WHEN 2
                       CALL "BAJA_CLIENTE"

                   WHEN 3
                       CALL "MODIFICAR_CLIENTE"

                   WHEN 4
                       CALL "BUSCAR_CLIENTE"

                   WHEN 5
                       CALL "LISTAR_CLIENTES"

                   WHEN 6
                       DISPLAY "FINALIZANDO SISTEMA..."

                   WHEN OTHER
                       DISPLAY "OPCION INVALIDA."

               END-EVALUATE

           END-PERFORM

           STOP RUN.

       INICIAR-SISTEMA.

           DISPLAY "=========================================="
           DISPLAY "     SISTEMA DE GESTION DE CLIENTES"
           DISPLAY "=========================================="

           CALL "CONEXION"

           .