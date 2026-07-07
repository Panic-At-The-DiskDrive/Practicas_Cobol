       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.

      ******************************************************************
      * BANK SYSTEM
      * Main Program
      ******************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           COPY FILES.

       DATA DIVISION.

       FILE SECTION.

       FD  MASTER-FILE.
       COPY ACCOUNT.

       FD  TRANS-FILE.
       COPY TRANSACTION.

       FD  REPORT-FILE.
       01  REPORT-RECORD               PIC X(132).

       FD  LOG-FILE.
       01  LOG-RECORD                  PIC X(132).

       WORKING-STORAGE SECTION.

       COPY COMMON.

       01  WS-PROGRAM-NAME             PIC X(30).

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           PERFORM 1000-INITIALIZE

           PERFORM 2000-PROCESS

           PERFORM 3000-FINALIZE

           GOBACK.

      ******************************************************************
      * INITIALIZATION
      ******************************************************************

       1000-INITIALIZE.

           MOVE "BANK SYSTEM" TO WS-PROGRAM-NAME

           OPEN INPUT MASTER-FILE

           IF WS-MASTER-STATUS NOT = "00"
               DISPLAY "ERROR OPENING MASTER FILE"
               GOBACK
           END-IF

           OPEN INPUT TRANS-FILE

           IF WS-TRANS-STATUS NOT = "00"
               DISPLAY "ERROR OPENING TRANSACTION FILE"
               CLOSE MASTER-FILE
               GOBACK
           END-IF

           OPEN OUTPUT REPORT-FILE

           IF WS-REPORT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING REPORT FILE"
               CLOSE MASTER-FILE
               CLOSE TRANS-FILE
               GOBACK
           END-IF

           OPEN OUTPUT LOG-FILE

           IF WS-LOG-STATUS NOT = "00"
               DISPLAY "ERROR OPENING LOG FILE"
               CLOSE MASTER-FILE
               CLOSE TRANS-FILE
               CLOSE REPORT-FILE
               GOBACK
           END-IF.

      ******************************************************************
      * PROCESS
      ******************************************************************

       2000-PROCESS.

           CALL "READ-MASTER"

           CALL "READ-TRANSACTIONS"

           CALL "UPDATE-ACCOUNT"

           CALL "GENERATE-REPORT".

      ******************************************************************
      * FINALIZATION
      ******************************************************************

       3000-FINALIZE.

           CLOSE MASTER-FILE

           CLOSE TRANS-FILE

           CLOSE REPORT-FILE

           CLOSE LOG-FILE

           DISPLAY "-----------------------------------------"
           DISPLAY "BANK SYSTEM PROCESS COMPLETED"
           DISPLAY "-----------------------------------------"
           DISPLAY "TOTAL ACCOUNTS      : " WS-TOTAL-ACCOUNTS
           DISPLAY "TOTAL TRANSACTIONS  : " WS-TOTAL-TRANSACTIONS
           DISPLAY "TOTAL DEPOSITS      : " WS-TOTAL-DEPOSITS
           DISPLAY "TOTAL WITHDRAWALS   : " WS-TOTAL-WITHDRAWALS
           DISPLAY "TOTAL ERRORS        : " WS-TOTAL-ERRORS
           DISPLAY "FINAL BALANCE       : " WS-FINAL-BALANCE
           DISPLAY "-----------------------------------------".