       IDENTIFICATION DIVISION.
       PROGRAM-ID. READ-MASTER.

      ******************************************************************
      * READ-MASTER
      * Reads all account records from the master file.
      ******************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           COPY FILES.

       DATA DIVISION.

       FILE SECTION.

       FD  MASTER-FILE.
       COPY ACCOUNT.

       WORKING-STORAGE SECTION.

       COPY COMMON.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           PERFORM UNTIL MASTER-EOF

               READ MASTER-FILE
                   AT END
                       SET MASTER-EOF TO TRUE

                   NOT AT END
                       PERFORM 1000-PROCESS-ACCOUNT

               END-READ

           END-PERFORM

           GOBACK.

      ******************************************************************
      * PROCESS ACCOUNT
      ******************************************************************

       1000-PROCESS-ACCOUNT.

           ADD 1
               TO WS-TOTAL-ACCOUNTS

           ADD ACCT-BALANCE
               TO WS-FINAL-BALANCE.