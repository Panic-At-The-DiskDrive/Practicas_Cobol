       IDENTIFICATION DIVISION.
       PROGRAM-ID. SALES-REPORT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SALES-FILE ASSIGN TO '../data/input_sales.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT REPORT-FILE ASSIGN TO '../data/sales_report.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD SALES-FILE.
       01 SALES-RECORD.
           05 SR-REGION        PIC X(10).
           05 SR-SALESPERSON   PIC X(20).
           05 SR-AMOUNT        PIC 9(7)V99.

       FD REPORT-FILE.
       01 REPORT-RECORD        PIC X(100).

       WORKING-STORAGE SECTION.

       01 WS-EOF               PIC X VALUE 'N'.
          88 END-OF-FILE       VALUE 'Y'.

       01 WS-CURRENT-REGION    PIC X(10) VALUE SPACES.
       01 WS-PREV-REGION       PIC X(10) VALUE SPACES.

       01 WS-REGION-TOTAL      PIC 9(9)V99 VALUE 0.
       01 WS-GRAND-TOTAL       PIC 9(11)V99 VALUE 0.

       01 WS-AMOUNT-DISPLAY    PIC Z(9)9.99.

       PROCEDURE DIVISION.

       MAIN.
           PERFORM OPEN-FILES
           PERFORM READ-RECORD

           IF NOT END-OF-FILE
               MOVE SR-REGION TO WS-PREV-REGION
           END-IF

           PERFORM UNTIL END-OF-FILE
               PERFORM PROCESS-RECORD
               PERFORM READ-RECORD
           END-PERFORM

           PERFORM FINALIZE-REPORT
           PERFORM CLOSE-FILES

           STOP RUN.

       OPEN-FILES.
           OPEN INPUT SALES-FILE
           OPEN OUTPUT REPORT-FILE.

       READ-RECORD.
           READ SALES-FILE
               AT END
                   SET END-OF-FILE TO TRUE
           END-READ.

       PROCESS-RECORD.
           MOVE SR-REGION TO WS-CURRENT-REGION

           IF WS-CURRENT-REGION NOT = WS-PREV-REGION
               PERFORM WRITE-REGION-TOTAL
               MOVE 0 TO WS-REGION-TOTAL
               MOVE WS-CURRENT-REGION TO WS-PREV-REGION
           END-IF

           ADD SR-AMOUNT TO WS-REGION-TOTAL
           ADD SR-AMOUNT TO WS-GRAND-TOTAL

           PERFORM WRITE-DETAIL.

       WRITE-DETAIL.
           MOVE SR-AMOUNT TO WS-AMOUNT-DISPLAY

           STRING
               SR-REGION DELIMITED BY SIZE
               SPACE
               SR-SALESPERSON DELIMITED BY SIZE
               SPACE
               WS-AMOUNT-DISPLAY DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING

           WRITE REPORT-RECORD.

       WRITE-REGION-TOTAL.
           IF WS-PREV-REGION NOT = SPACES
               MOVE WS-REGION-TOTAL TO WS-AMOUNT-DISPLAY

               STRING
                   'TOTAL REGION '
                   WS-PREV-REGION
                   ': '
                   WS-AMOUNT-DISPLAY
                   INTO REPORT-RECORD
               END-STRING

               WRITE REPORT-RECORD

               MOVE SPACES TO REPORT-RECORD
               WRITE REPORT-RECORD
           END-IF.

       FINALIZE-REPORT.
           PERFORM WRITE-REGION-TOTAL

           MOVE WS-GRAND-TOTAL TO WS-AMOUNT-DISPLAY

           STRING
               'GRAND TOTAL: '
               WS-AMOUNT-DISPLAY
               INTO REPORT-RECORD
           END-STRING

           WRITE REPORT-RECORD.

       CLOSE-FILES.
           CLOSE SALES-FILE
                 REPORT-FILE.