       IDENTIFICATION DIVISION.
       PROGRAM-ID. MENU.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       LINKAGE SECTION.

       01 LK-OPCION               PIC 9.

       PROCEDURE DIVISION USING LK-OPCION.

       MENU-PRINCIPAL.

           DISPLAY " "
           DISPLAY "=========================================="
           DISPLAY "            MENU PRINCIPAL"
           DISPLAY "=========================================="
           DISPLAY "1 - Alta de cliente"
           DISPLAY "2 - Baja de cliente"
           DISPLAY "3 - Modificar cliente"
           DISPLAY "4 - Buscar cliente"
           DISPLAY "5 - Listar clientes"
           DISPLAY "6 - Salir"
           DISPLAY "=========================================="
           DISPLAY "Ingrese una opcion: "

           ACCEPT LK-OPCION

           GOBACK.