       IDENTIFICATION DIVISION.
       PROGRAM-ID. CUSTOMER-INQUIRY.
       AUTHOR. SIMONETTA, DANIEL.
       DATE-WRITTEN. 2026-06-05.

      * ============================================
      * CUSTOMER INQUIRY SYSTEM
      * COBOL + SQL EXAMPLE
      * ============================================

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT REPORT-FILE
               ASSIGN TO '../reports/active_customers.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD REPORT-FILE.
       01 REPORT-REC PIC X(120).

       WORKING-STORAGE SECTION.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

       01 WS-CUSTOMER-ID       PIC X(5).
       01 WS-CUSTOMER-NAME     PIC X(50).
       01 WS-BALANCE           PIC 9(7)V99.

       01 WS-END-OF-DATA       PIC X VALUE 'N'.
          88 END-OF-DATA VALUE 'Y'.

       EXEC SQL
           DECLARE CUSTOMER_CURSOR CURSOR FOR
           SELECT
               CUSTOMER_ID,
               CUSTOMER_NAME,
               BALANCE
           FROM CUSTOMERS
           WHERE CUSTOMER_STATUS = 'A'
           ORDER BY CUSTOMER_ID
       END-EXEC.

       PROCEDURE DIVISION.

       MAIN-PROCESS.

           OPEN OUTPUT REPORT-FILE

           PERFORM OPEN-CURSOR

           PERFORM UNTIL END-OF-DATA
               PERFORM FETCH-CUSTOMER
           END-PERFORM

           PERFORM CLOSE-CURSOR

           CLOSE REPORT-FILE

           STOP RUN.

       OPEN-CURSOR.

           EXEC SQL
               OPEN CUSTOMER_CURSOR
           END-EXEC.

       FETCH-CUSTOMER.

           EXEC SQL
               FETCH CUSTOMER_CURSOR
               INTO
                   :WS-CUSTOMER-ID,
                   :WS-CUSTOMER-NAME,
                   :WS-BALANCE
           END-EXEC.

           IF SQLCODE = 100
               SET END-OF-DATA TO TRUE
           ELSE
               PERFORM WRITE-CUSTOMER
           END-IF.

       WRITE-CUSTOMER.

           MOVE SPACES TO REPORT-REC

           STRING
               WS-CUSTOMER-ID
               SPACE
               WS-CUSTOMER-NAME
               SPACE
               'BALANCE: '
               INTO REPORT-REC
           END-STRING

           WRITE REPORT-REC.

       CLOSE-CURSOR.

           EXEC SQL
               CLOSE CUSTOMER_CURSOR
           END-EXEC.