       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVENTORY.
       AUTHOR. SIMONETTA, DANIEL.
       DATE-WRITTEN. 2026-05-14.

      * ============================================
      * INVENTORY RESTOCK SYSTEM
      * ============================================

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT PRODUCT-FILE ASSIGN TO '../data/products.txt'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PRODUCT-STATUS.

           SELECT REPORT-FILE ASSIGN TO '../data/restock_report.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD PRODUCT-FILE.
       COPY product_layout.cpy.

       FD REPORT-FILE.
       01 REPORT-REC PIC X(120).

       WORKING-STORAGE SECTION.

       01 WS-PRODUCT-STATUS      PIC XX.

       01 WS-EOF                 PIC X VALUE 'N'.
          88 END-OF-FILE         VALUE 'Y'.

       01 WS-RESTOCK-QTY         PIC 9(5).

       01 WS-LOW-STOCK-COUNT     PIC 9(5) VALUE 0.
       01 WS-NORMAL-STOCK-COUNT  PIC 9(5) VALUE 0.

       PROCEDURE DIVISION.

       MAIN.
           PERFORM OPEN-FILES

           PERFORM UNTIL END-OF-FILE
               PERFORM READ-PRODUCT
               IF NOT END-OF-FILE
                   PERFORM PROCESS-PRODUCT
               END-IF
           END-PERFORM

           PERFORM WRITE-SUMMARY
           PERFORM CLOSE-FILES

           STOP RUN.

       OPEN-FILES.
           OPEN INPUT PRODUCT-FILE
           OPEN OUTPUT REPORT-FILE.

       READ-PRODUCT.
           READ PRODUCT-FILE
               AT END
                   SET END-OF-FILE TO TRUE
           END-READ.

       PROCESS-PRODUCT.
           IF PROD-STOCK < PROD-MIN-STOCK
               PERFORM GENERATE-RESTOCK
           ELSE
               ADD 1 TO WS-NORMAL-STOCK-COUNT
           END-IF.

       GENERATE-RESTOCK.
           COMPUTE WS-RESTOCK-QTY =
               PROD-MAX-STOCK - PROD-STOCK

           ADD 1 TO WS-LOW-STOCK-COUNT

           STRING
               'RESTOCK REQUIRED - '
               PROD-ID
               SPACE
               PROD-NAME
               SPACE
               'ORDER: '
               WS-RESTOCK-QTY
               INTO REPORT-REC
           END-STRING

           WRITE REPORT-REC.

       WRITE-SUMMARY.
           MOVE SPACES TO REPORT-REC
           WRITE REPORT-REC

           STRING
               'LOW STOCK PRODUCTS: '
               WS-LOW-STOCK-COUNT
               INTO REPORT-REC
           END-STRING
           WRITE REPORT-REC

           STRING
               'NORMAL STOCK PRODUCTS: '
               WS-NORMAL-STOCK-COUNT
               INTO REPORT-REC
           END-STRING
           WRITE REPORT-REC.

       CLOSE-FILES.
           CLOSE PRODUCT-FILE
                 REPORT-FILE.