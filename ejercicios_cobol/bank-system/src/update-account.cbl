       IDENTIFICATION DIVISION.
       PROGRAM-ID. UPDATE-ACCOUNT.

      ******************************************************************
      * UPDATE-ACCOUNT
      * Applies transactions to account balances.
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

       WORKING-STORAGE SECTION.

       COPY COMMON.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           SET ACCOUNT-NOT-FOUND TO TRUE

           MOVE ACCT-BALANCE TO WS-OLD-BALANCE

           EVALUATE TRUE

               WHEN TR-DEPOSIT

                   ADD TR-AMOUNT
                       TO ACCT-BALANCE

                   SET ACCOUNT-FOUND TO TRUE

               WHEN TR-WITHDRAWAL

                   IF ACCT-BALANCE >= TR-AMOUNT

                       SUBTRACT TR-AMOUNT
                           FROM ACCT-BALANCE

                       SET ACCOUNT-FOUND TO TRUE

                   ELSE

                       ADD 1 TO WS-TOTAL-ERRORS

                       CALL "WRITE-LOG"

                   END-IF

               WHEN OTHER

                   ADD 1 TO WS-TOTAL-ERRORS

                   CALL "WRITE-LOG"

           END-EVALUATE

           MOVE ACCT-BALANCE
             TO WS-NEW-BALANCE

           GOBACK.