       IDENTIFICATION DIVISION.
       PROGRAM-ID. FACTURACION.

         AUTHOR. SIMONETTA.
       DATE-WRITTEN. 2026-02-23.
       DESCRIPTION.
           Sistema de facturacion.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCH-PRODUCTOS ASSIGN TO "PRODUCTOS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ARCH-VENTAS ASSIGN TO "VENTAS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ARCH-REPORTE ASSIGN TO "REPORTE.TXT"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD ARCH-PRODUCTOS.
       01 REG-PRODUCTO.
           05 PRD-CODIGO        PIC 9(5).
           05 PRD-NOMBRE        PIC X(20).
           05 PRD-PRECIO        PIC 9(7)V99.

       FD ARCH-VENTAS.
       01 REG-VENTA.
           05 VTA-CODIGO        PIC 9(5).
           05 VTA-CANTIDAD      PIC 9(5).

       FD ARCH-REPORTE.
       01 REG-REPORTE           PIC X(120).

       WORKING-STORAGE SECTION.

       77 WS-EOF-PRODUCTOS      PIC X VALUE "N".
       77 WS-EOF-VENTAS         PIC X VALUE "N".
       77 WS-ENCONTRADO         PIC X VALUE "N".

       77 WS-SUBTOTAL           PIC 9(9)V99 VALUE 0.
       77 WS-IVA                PIC 9(9)V99 VALUE 0.
       77 WS-TOTAL              PIC 9(9)V99 VALUE 0.

       77 WS-IVA-PORC           PIC V99 VALUE .21.

       77 WS-TEXTO              PIC X(120).

       PROCEDURE DIVISION.

       MAIN-PROCESS.
           PERFORM ABRIR-ARCHIVOS
           PERFORM LEER-VENTA

           PERFORM UNTIL WS-EOF-VENTAS = "S"
               PERFORM PROCESAR-VENTA
               PERFORM LEER-VENTA
           END-PERFORM

           PERFORM CERRAR-ARCHIVOS
           STOP RUN.

       ABRIR-ARCHIVOS.
           OPEN INPUT ARCH-PRODUCTOS
           OPEN INPUT ARCH-VENTAS
           OPEN OUTPUT ARCH-REPORTE.

       CERRAR-ARCHIVOS.
           CLOSE ARCH-PRODUCTOS
           CLOSE ARCH-VENTAS
           CLOSE ARCH-REPORTE.

       LEER-VENTA.
           READ ARCH-VENTAS
               AT END MOVE "S" TO WS-EOF-VENTAS
           END-READ.

       PROCESAR-VENTA.
           MOVE "N" TO WS-ENCONTRADO
           MOVE 0 TO WS-SUBTOTAL WS-IVA WS-TOTAL

           PERFORM BUSCAR-PRODUCTO

           IF WS-ENCONTRADO = "S"
               COMPUTE WS-SUBTOTAL =
                   PRD-PRECIO * VTA-CANTIDAD

               COMPUTE WS-IVA =
                   WS-SUBTOTAL * WS-IVA-PORC

               COMPUTE WS-TOTAL =
                   WS-SUBTOTAL + WS-IVA

               STRING
                   "COD: " VTA-CODIGO
                   " CANT: " VTA-CANTIDAD
                   " SUBTOTAL: " WS-SUBTOTAL
                   " IVA: " WS-IVA
                   " TOTAL: " WS-TOTAL
                   DELIMITED BY SIZE
                   INTO REG-REPORTE
               END-STRING

           ELSE
               STRING
                   "ERROR - PRODUCTO NO EXISTE: "
                   VTA-CODIGO
                   DELIMITED BY SIZE
                   INTO REG-REPORTE
               END-STRING
           END-IF

           WRITE REG-REPORTE.

       BUSCAR-PRODUCTO.
           CLOSE ARCH-PRODUCTOS
           OPEN INPUT ARCH-PRODUCTOS

           MOVE "N" TO WS-EOF-PRODUCTOS

           PERFORM UNTIL WS-EOF-PRODUCTOS = "S"
               READ ARCH-PRODUCTOS
                   AT END
                       MOVE "S" TO WS-EOF-PRODUCTOS
               END-READ

               IF PRD-CODIGO = VTA-CODIGO
                   MOVE "S" TO WS-ENCONTRADO
                   MOVE "S" TO WS-EOF-PRODUCTOS
               END-IF
           END-PERFORM.