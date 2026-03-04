       IDENTIFICATION DIVISION.
       PROGRAM-ID. ANALISIS-VENTAS.

         AUTHOR. SIMONETTA.
       DATE-WRITTEN. 2026-02-23.
       DESCRIPTION.
           Analisis de ventas.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT VENTAS-FILE ASSIGN TO "ventas.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT REPORTE-FILE ASSIGN TO "reporte.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD VENTAS-FILE.
       01 VENTAS-LINEA                PIC X(100).

       FD REPORTE-FILE.
       01 REPORTE-LINEA               PIC X(120).

       WORKING-STORAGE SECTION.

       01 WS-EOF                      PIC X VALUE "N".

       01 WS-ID                       PIC 9(5).
       01 WS-CATEGORIA                PIC X(20).
       01 WS-IMPORTE                  PIC 9(7)V99.

       01 WS-TOTAL-VENTAS             PIC 9(10)V99 VALUE 0.
       01 WS-CANTIDAD                 PIC 9(7) VALUE 0.
       01 WS-PROMEDIO                 PIC 9(10)V99 VALUE 0.
       01 WS-MAX                      PIC 9(7)V99 VALUE 0.
       01 WS-MIN                      PIC 9(7)V99 VALUE 9999999.99.

       01 WS-TOTAL-ELECTRONICS        PIC 9(10)V99 VALUE 0.
       01 WS-TOTAL-CLOTHING           PIC 9(10)V99 VALUE 0.
       01 WS-TOTAL-FOOD               PIC 9(10)V99 VALUE 0.

       01 WS-CANT-ELECTRONICS         PIC 9(7) VALUE 0.
       01 WS-CANT-CLOTHING            PIC 9(7) VALUE 0.
       01 WS-CANT-FOOD                PIC 9(7) VALUE 0.

       PROCEDURE DIVISION.

       MAIN.
           PERFORM INICIALIZAR
           PERFORM PROCESAR-ARCHIVO
           PERFORM CALCULAR-PROMEDIO
           PERFORM GENERAR-REPORTE
           PERFORM FINALIZAR
           STOP RUN.

       INICIALIZAR.
           OPEN INPUT VENTAS-FILE
           OPEN OUTPUT REPORTE-FILE.

       PROCESAR-ARCHIVO.
           PERFORM UNTIL WS-EOF = "S"
               READ VENTAS-FILE
                   AT END
                       MOVE "S" TO WS-EOF
                   NOT AT END
                       PERFORM PROCESAR-LINEA
               END-READ
           END-PERFORM.

       PROCESAR-LINEA.
           UNSTRING VENTAS-LINEA
               DELIMITED BY ","
               INTO WS-ID
                    WS-CATEGORIA
                    WS-IMPORTE
           END-UNSTRING

           ADD WS-IMPORTE TO WS-TOTAL-VENTAS
           ADD 1 TO WS-CANTIDAD

           IF WS-IMPORTE > WS-MAX
               MOVE WS-IMPORTE TO WS-MAX
           END-IF

           IF WS-IMPORTE < WS-MIN
               MOVE WS-IMPORTE TO WS-MIN
           END-IF

           EVALUATE WS-CATEGORIA
               WHEN "Electronics"
                   ADD WS-IMPORTE TO WS-TOTAL-ELECTRONICS
                   ADD 1 TO WS-CANT-ELECTRONICS
               WHEN "Clothing"
                   ADD WS-IMPORTE TO WS-TOTAL-CLOTHING
                   ADD 1 TO WS-CANT-CLOTHING
               WHEN "Food"
                   ADD WS-IMPORTE TO WS-TOTAL-FOOD
                   ADD 1 TO WS-CANT-FOOD
           END-EVALUATE.

       CALCULAR-PROMEDIO.
           IF WS-CANTIDAD > 0
               DIVIDE WS-TOTAL-VENTAS BY WS-CANTIDAD
                   GIVING WS-PROMEDIO
           END-IF.

       GENERAR-REPORTE.

           MOVE "===== REPORTE DE ANALISIS DE VENTAS ====="
               TO REPORTE-LINEA
           WRITE REPORTE-LINEA

           MOVE SPACES TO REPORTE-LINEA
           WRITE REPORTE-LINEA

           STRING "Total de ventas: " WS-TOTAL-VENTAS
               DELIMITED BY SIZE
               INTO REPORTE-LINEA
           END-STRING
           WRITE REPORTE-LINEA

           STRING "Cantidad de ventas: " WS-CANTIDAD
               DELIMITED BY SIZE
               INTO REPORTE-LINEA
           END-STRING
           WRITE REPORTE-LINEA

           STRING "Promedio: " WS-PROMEDIO
               DELIMITED BY SIZE
               INTO REPORTE-LINEA
           END-STRING
           WRITE REPORTE-LINEA

           STRING "Venta maxima: " WS-MAX
               DELIMITED BY SIZE
               INTO REPORTE-LINEA
           END-STRING
           WRITE REPORTE-LINEA

           STRING "Venta minima: " WS-MIN
               DELIMITED BY SIZE
               INTO REPORTE-LINEA
           END-STRING
           WRITE REPORTE-LINEA

           MOVE SPACES TO REPORTE-LINEA
           WRITE REPORTE-LINEA

           MOVE "---- Totales por Categoria ----"
               TO REPORTE-LINEA
           WRITE REPORTE-LINEA

           STRING "Electronics: " WS-TOTAL-ELECTRONICS
               DELIMITED BY SIZE
               INTO REPORTE-LINEA
           END-STRING
           WRITE REPORTE-LINEA

           STRING "Clothing: " WS-TOTAL-CLOTHING
               DELIMITED BY SIZE
               INTO REPORTE-LINEA
           END-STRING
           WRITE REPORTE-LINEA

           STRING "Food: " WS-TOTAL-FOOD
               DELIMITED BY SIZE
               INTO REPORTE-LINEA
           END-STRING
           WRITE REPORTE-LINEA.

       FINALIZAR.
           CLOSE VENTAS-FILE
           CLOSE REPORTE-FILE.