       IDENTIFICATION DIVISION.
       PROGRAM-ID. GENERATE-REPORT.

      ******************************************************************
      * GENERATE-REPORT
      * Writes the processing report.
      ******************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           COPY FILES.

       DATA DIVISION.

       FILE SECTION.

       FD  REPORT-FILE.
       01  REPORT-RECORD               PIC X(132).

       WORKING-STORAGE SECTION.

       COPY COMMON.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           PERFORM 1000-WRITE-HEADER

           PERFORM 2000-WRITE-DETAIL

           PERFORM 3000-WRITE-SUMMARY

           GOBACK.

      ******************************************************************
      * WRITE HEADER
      ******************************************************************

       1000-WRITE-HEADER.

           MOVE ALL "-" TO REPORT-RECORD
           WRITE REPORT-RECORD

           MOVE SPACES TO REPORT-RECORD
           STRING
               "BANK SYSTEM REPORT"
               DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING
           WRITE REPORT-RECORD

           MOVE ALL "-" TO REPORT-RECORD
           WRITE REPORT-RECORD.

      ******************************************************************
      * WRITE DETAIL
      ******************************************************************

       2000-WRITE-DETAIL.

           MOVE SPACES TO REPORT-RECORD

           STRING
               "ACCOUNT : "
               DELIMITED BY SIZE
               ACCT-ID
               DELIMITED BY SIZE
               "  BALANCE : "
               DELIMITED BY SIZE
               ACCT-BALANCE
               DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING

           WRITE REPORT-RECORD.

      ******************************************************************
      * WRITE SUMMARY
      ******************************************************************

       3000-WRITE-SUMMARY.

           MOVE ALL "-" TO REPORT-RECORD
           WRITE REPORT-RECORD

           MOVE SPACES TO REPORT-RECORD
           STRING
               "TOTAL ACCOUNTS      : "
               DELIMITED BY SIZE
               WS-TOTAL-ACCOUNTS
               DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING
           WRITE REPORT-RECORD

           MOVE SPACES TO REPORT-RECORD
           STRING
               "TOTAL TRANSACTIONS  : "
               DELIMITED BY SIZE
               WS-TOTAL-TRANSACTIONS
               DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING
           WRITE REPORT-RECORD

           MOVE SPACES TO REPORT-RECORD
           STRING
               "TOTAL DEPOSITS      : "
               DELIMITED BY SIZE
               WS-TOTAL-DEPOSITS
               DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING
           WRITE REPORT-RECORD

           MOVE SPACES TO REPORT-RECORD
           STRING
               "TOTAL WITHDRAWALS   : "
               DELIMITED BY SIZE
               WS-TOTAL-WITHDRAWALS
               DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING
           WRITE REPORT-RECORD

           MOVE SPACES TO REPORT-RECORD
           STRING
               "TOTAL ERRORS        : "
               DELIMITED BY SIZE
               WS-TOTAL-ERRORS
               DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING
           WRITE REPORT-RECORD

           MOVE SPACES TO REPORT-RECORD
           STRING
               "FINAL BALANCE       : "
               DELIMITED BY SIZE
               WS-FINAL-BALANCE
               DELIMITED BY SIZE
               INTO REPORT-RECORD
           END-STRING
           WRITE REPORT-RECORD

           MOVE ALL "-" TO REPORT-RECORD
           WRITE REPORT-RECORD.