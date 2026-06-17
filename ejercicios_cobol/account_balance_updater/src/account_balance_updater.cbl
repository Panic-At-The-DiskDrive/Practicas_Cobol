      ******************************************************************
      * Program.....: ACCOUNT_BALANCE_UPDATER
      * Author......: Daniel Simonetta
      * Date........: 2026-06-17
      * Purpose.....: Processes pending transactions and updates
      *              account balances using embedded SQL.
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCOUNT-BALANCE-UPDATER.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

       77  WS-END                 PIC X VALUE 'N'.
           88 END-OF-CURSOR              VALUE 'Y'.

       77  WS-ROWS-PROCESSED      PIC 9(6) VALUE ZERO.
       77  WS-DEPOSITS            PIC 9(6) VALUE ZERO.
       77  WS-WITHDRAWALS         PIC 9(6) VALUE ZERO.

       77  WS-NEW-BALANCE         PIC S9(9)V99 COMP-3.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01 HV-TRANSACTION-ID       PIC S9(9) COMP.
       01 HV-ACCOUNT-ID           PIC S9(9) COMP.
       01 HV-AMOUNT               PIC S9(9)V99 COMP-3.
       01 HV-TYPE                 PIC X.

       EXEC SQL END DECLARE SECTION END-EXEC.

      ******************************************************************
      * Cursor
      ******************************************************************

       EXEC SQL
            DECLARE TRANSACTION_CURSOR CURSOR FOR
            SELECT
                   TRANSACTION_ID,
                   ACCOUNT_ID,
                   AMOUNT,
                   TRANSACTION_TYPE
              FROM TRANSACTION_LOG
             WHERE PROCESSED = 'N'
             ORDER BY TRANSACTION_ID
       END-EXEC.

       PROCEDURE DIVISION.

       MAIN.

           PERFORM CONNECT-DATABASE

           PERFORM OPEN-CURSOR

           PERFORM UNTIL END-OF-CURSOR

               PERFORM FETCH-TRANSACTION

               IF NOT END-OF-CURSOR
                   PERFORM PROCESS-TRANSACTION
               END-IF

           END-PERFORM

           PERFORM CLOSE-CURSOR

           PERFORM FINAL-REPORT

           GOBACK.

              ******************************************************************
      * Connect Database
      ******************************************************************

       CONNECT-DATABASE.

      * Connection is assumed to be established externally.
      * This paragraph is kept for portability.

           EXIT.

      ******************************************************************
      * Open Cursor
      ******************************************************************

       OPEN-CURSOR.

           EXEC SQL
               OPEN TRANSACTION_CURSOR
           END-EXEC

           IF SQLCODE NOT = 0
               DISPLAY "ERROR OPENING CURSOR. SQLCODE = " SQLCODE
               GOBACK
           END-IF.

      ******************************************************************
      * Fetch Next Transaction
      ******************************************************************

       FETCH-TRANSACTION.

           EXEC SQL
               FETCH TRANSACTION_CURSOR
               INTO
                    :HV-TRANSACTION-ID,
                    :HV-ACCOUNT-ID,
                    :HV-AMOUNT,
                    :HV-TYPE
           END-EXEC

           EVALUATE SQLCODE

               WHEN 0
                   CONTINUE

               WHEN 100
                   MOVE 'Y' TO WS-END

               WHEN OTHER
                   DISPLAY "FETCH ERROR. SQLCODE = " SQLCODE
                   PERFORM ROLLBACK-CHANGES
                   GOBACK

           END-EVALUATE.

      ******************************************************************
      * Process Transaction
      ******************************************************************

       PROCESS-TRANSACTION.

           EVALUATE HV-TYPE

               WHEN 'D'
                   PERFORM PROCESS-DEPOSIT
                   ADD 1 TO WS-DEPOSITS

               WHEN 'W'
                   PERFORM PROCESS-WITHDRAWAL
                   ADD 1 TO WS-WITHDRAWALS

               WHEN OTHER
                   DISPLAY "INVALID TRANSACTION TYPE: "
                           HV-TYPE

           END-EVALUATE

           ADD 1 TO WS-ROWS-PROCESSED

           PERFORM MARK-AS-PROCESSED.   

              ******************************************************************
      * Process Deposit
      ******************************************************************

       PROCESS-DEPOSIT.

           EXEC SQL
               UPDATE ACCOUNT
                  SET BALANCE = BALANCE + :HV-AMOUNT
                WHERE ACCOUNT_ID = :HV-ACCOUNT-ID
           END-EXEC

           IF SQLCODE NOT = 0
               DISPLAY "DEPOSIT ERROR. SQLCODE = " SQLCODE
               PERFORM ROLLBACK-CHANGES
               GOBACK
           END-IF.

      ******************************************************************
      * Process Withdrawal
      ******************************************************************

       PROCESS-WITHDRAWAL.

           EXEC SQL
               UPDATE ACCOUNT
                  SET BALANCE = BALANCE - :HV-AMOUNT
                WHERE ACCOUNT_ID = :HV-ACCOUNT-ID
           END-EXEC

           IF SQLCODE NOT = 0
               DISPLAY "WITHDRAWAL ERROR. SQLCODE = " SQLCODE
               PERFORM ROLLBACK-CHANGES
               GOBACK
           END-IF.

      ******************************************************************
      * Mark Transaction as Processed
      ******************************************************************

       MARK-AS-PROCESSED.

           EXEC SQL
               UPDATE TRANSACTION_LOG
                  SET PROCESSED = 'Y'
                WHERE TRANSACTION_ID = :HV-TRANSACTION-ID
           END-EXEC

           IF SQLCODE NOT = 0
               DISPLAY "UPDATE LOG ERROR. SQLCODE = " SQLCODE
               PERFORM ROLLBACK-CHANGES
               GOBACK
           END-IF

           EXEC SQL
               COMMIT
           END-EXEC

           IF SQLCODE NOT = 0
               DISPLAY "COMMIT ERROR. SQLCODE = " SQLCODE
               GOBACK
           END-IF.   

              ******************************************************************
      * Rollback
      ******************************************************************

       ROLLBACK-CHANGES.

           EXEC SQL
               ROLLBACK
           END-EXEC.

      ******************************************************************
      * Close Cursor
      ******************************************************************

       CLOSE-CURSOR.

           EXEC SQL
               CLOSE TRANSACTION_CURSOR
           END-EXEC.

      ******************************************************************
      * Final Report
      ******************************************************************

       FINAL-REPORT.

           DISPLAY " "
           DISPLAY "========================================"
           DISPLAY " ACCOUNT BALANCE UPDATE COMPLETED"
           DISPLAY "========================================"

           DISPLAY "TRANSACTIONS PROCESSED : "
                   WS-ROWS-PROCESSED

           DISPLAY "DEPOSITS               : "
                   WS-DEPOSITS

           DISPLAY "WITHDRAWALS            : "
                   WS-WITHDRAWALS

           DISPLAY "========================================".

       END PROGRAM ACCOUNT-BALANCE-UPDATER.   