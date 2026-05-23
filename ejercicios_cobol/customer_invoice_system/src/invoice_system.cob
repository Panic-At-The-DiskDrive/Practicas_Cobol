       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVOICE-SYSTEM.
       AUTHOR. SIMONETTA, DANIEL.
       DATE-WRITTEN. 2026-05-21.

      * ============================================
      * CUSTOMER INVOICE SYSTEM
      * ============================================

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT CUSTOMER-FILE ASSIGN TO
               '../data/customer_master.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT TRANSACTION-FILE ASSIGN TO
               '../data/transactions.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT REPORT-FILE ASSIGN TO
               '../data/invoice_report.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD CUSTOMER-FILE.
       COPY customer_layout.cpy.

       FD TRANSACTION-FILE.
       COPY transaction_layout.cpy.

       FD REPORT-FILE.
       01 REPORT-REC PIC X(120).

       WORKING-STORAGE SECTION.

       01 WS-EOF-CUSTOMER      PIC X VALUE 'N'.
          88 EOF-CUSTOMER      VALUE 'Y'.

       01 WS-EOF-TRANSACTION   PIC X VALUE 'N'.
          88 EOF-TRANSACTION   VALUE 'Y'.

       01 WS-CUSTOMER-TOTAL    PIC 9(9)V99 VALUE 0.
       01 WS-GRAND-TOTAL       PIC 9(11)V99 VALUE 0.

       01 WS-DISCOUNT          PIC 9(7)V99 VALUE 0.
       01 WS-FINAL-TOTAL       PIC 9(9)V99 VALUE 0.

       01 WS-AMOUNT-DISPLAY    PIC Z(9)9.99.

       PROCEDURE DIVISION.

       MAIN.
           PERFORM OPEN-FILES

           PERFORM READ-CUSTOMER
           PERFORM READ-TRANSACTION

           PERFORM UNTIL EOF-CUSTOMER
               PERFORM PROCESS-CUSTOMER
               PERFORM READ-CUSTOMER
           END-PERFORM

           PERFORM WRITE-GRAND-TOTAL
           PERFORM CLOSE-FILES

           STOP RUN.

       OPEN-FILES.
           OPEN INPUT CUSTOMER-FILE
           OPEN INPUT TRANSACTION-FILE
           OPEN OUTPUT REPORT-FILE.

       READ-CUSTOMER.
           READ CUSTOMER-FILE
               AT END
                   SET EOF-CUSTOMER TO TRUE
           END-READ.

       READ-TRANSACTION.
           READ TRANSACTION-FILE
               AT END
                   SET EOF-TRANSACTION TO TRUE
           END-READ.

       PROCESS-CUSTOMER.
           MOVE 0 TO WS-CUSTOMER-TOTAL
           MOVE 0 TO WS-DISCOUNT

           PERFORM UNTIL EOF-TRANSACTION
               OR TRX-CUST-ID > CUST-ID

               IF TRX-CUST-ID = CUST-ID
                   ADD TRX-AMOUNT TO WS-CUSTOMER-TOTAL
               END-IF

               PERFORM READ-TRANSACTION
           END-PERFORM

           PERFORM APPLY-DISCOUNT
           PERFORM WRITE-INVOICE.

       APPLY-DISCOUNT.
           IF WS-CUSTOMER-TOTAL > 50000
               COMPUTE WS-DISCOUNT =
                   WS-CUSTOMER-TOTAL * 0.10
           END-IF

           COMPUTE WS-FINAL-TOTAL =
               WS-CUSTOMER-TOTAL - WS-DISCOUNT

           ADD WS-FINAL-TOTAL TO WS-GRAND-TOTAL.

       WRITE-INVOICE.

           MOVE WS-FINAL-TOTAL TO WS-AMOUNT-DISPLAY

           STRING
               'CUSTOMER: '
               CUST-ID
               SPACE
               CUST-NAME
               SPACE
               'TOTAL: '
               WS-AMOUNT-DISPLAY
               INTO REPORT-REC
           END-STRING

           WRITE REPORT-REC.

       WRITE-GRAND-TOTAL.

           MOVE WS-GRAND-TOTAL TO WS-AMOUNT-DISPLAY

           STRING
               'GRAND TOTAL INVOICED: '
               WS-AMOUNT-DISPLAY
               INTO REPORT-REC
           END-STRING

           WRITE REPORT-REC.

       CLOSE-FILES.
           CLOSE CUSTOMER-FILE
                 TRANSACTION-FILE
                 REPORT-FILE.