       IDENTIFICATION DIVISION.
       PROGRAM-ID. WRITE-LOG.

      ******************************************************************
      * WRITE-LOG
      * Writes processing errors to the log file.
      ******************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.
           COPY FILES.

       DATA DIVISION.

       FILE SECTION.

       FD  LOG-FILE.
       01  LOG-RECORD                  PIC X(132).

       WORKING-STORAGE SECTION.

       COPY COMMON.

       01  WS-LOG-MESSAGE              PIC X(132).

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           MOVE SPACES TO WS-LOG-MESSAGE

           EVALUATE TRUE

               WHEN ACCOUNT-NOT-FOUND

                   STRING
                       "ERROR: ACCOUNT NOT FOUND. ACCOUNT: "
                       DELIMITED BY SIZE
                       TR-ACCOUNT-ID
                       DELIMITED BY SIZE
                       INTO WS-LOG-MESSAGE
                   END-STRING

               WHEN TR-INVALID

                   STRING
                       "ERROR: INVALID TRANSACTION TYPE. ACCOUNT: "
                       DELIMITED BY SIZE
                       TR-ACCOUNT-ID
                       DELIMITED BY SIZE
                       INTO WS-LOG-MESSAGE
                   END-STRING

               WHEN OTHER

                   STRING
                       "ERROR: INSUFFICIENT FUNDS. ACCOUNT: "
                       DELIMITED BY SIZE
                       TR-ACCOUNT-ID
                       DELIMITED BY SIZE
                       INTO WS-LOG-MESSAGE
                   END-STRING

           END-EVALUATE

           MOVE WS-LOG-MESSAGE
             TO LOG-RECORD

           WRITE LOG-RECORD

           GOBACK.