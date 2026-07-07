       IDENTIFICATION DIVISION.
       PROGRAM-ID. READ-TRANSACTIONS.

      ******************************************************************
      * READ-TRANSACTIONS
      * Reads transaction records and dispatches processing.
      ******************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           COPY FILES.

       DATA DIVISION.

       FILE SECTION.

       FD  TRANS-FILE.
       COPY TRANSACTION.

       WORKING-STORAGE SECTION.

       COPY COMMON.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           PERFORM UNTIL TRANS-EOF

               READ TRANS-FILE
                   AT END
                       SET TRANS-EOF TO TRUE

                   NOT AT END
                       PERFORM 1000-PROCESS-TRANSACTION

               END-READ

           END-PERFORM

           GOBACK.

      ******************************************************************
      * PROCESS TRANSACTION
      ******************************************************************

       1000-PROCESS-TRANSACTION.

           ADD 1 TO WS-TOTAL-TRANSACTIONS

           EVALUATE TRUE

               WHEN TR-DEPOSIT

                   ADD 1 TO WS-TOTAL-DEPOSITS

                   ADD TR-AMOUNT
                       TO WS-DEPOSIT-AMOUNT

               WHEN TR-WITHDRAWAL

                   ADD 1 TO WS-TOTAL-WITHDRAWALS

                   ADD TR-AMOUNT
                       TO WS-WITHDRAW-AMOUNT

               WHEN OTHER

                   ADD 1 TO WS-TOTAL-ERRORS

                   CALL "WRITE-LOG"

           END-EVALUATE.