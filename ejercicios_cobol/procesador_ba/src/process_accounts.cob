       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROCESS-ACCOUNTS.

       AUTHOR. SIMONETTA, DANIEL.
       DATE-WRITTEN. 2026-03-18.
       DESCRIPTION.
           input file containing bank account data,
           validates records, processes balances, and generates a 
           formatted report

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO '../data/input_accounts.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT OUTPUT-FILE ASSIGN TO '../data/output_report.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD INPUT-FILE.
       01 INPUT-RECORD.
           05 IN-ACCOUNT-ID        PIC X(10).
           05 IN-NAME              PIC X(20).
           05 IN-BALANCE           PIC 9(7)V99.

       FD OUTPUT-FILE.
       01 OUTPUT-RECORD            PIC X(80).

       WORKING-STORAGE SECTION.

       01 WS-EOF                   PIC X VALUE 'N'.
          88 END-OF-FILE           VALUE 'Y'.
          88 NOT-END-OF-FILE       VALUE 'N'.

       01 WS-TOTAL-BALANCE         PIC 9(9)V99 VALUE 0.
       01 WS-VALID-COUNT           PIC 9(5) VALUE 0.
       01 WS-INVALID-COUNT         PIC 9(5) VALUE 0.

       01 WS-FORMATTED-LINE        PIC X(80).

       01 WS-BALANCE-DISPLAY       PIC Z(7)9.99.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           PERFORM INITIALIZE-FILES
           PERFORM PROCESS-FILE UNTIL END-OF-FILE
           PERFORM WRITE-SUMMARY
           PERFORM CLOSE-FILES
           STOP RUN.

       INITIALIZE-FILES.
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE.

       PROCESS-FILE.
           READ INPUT-FILE
               AT END
                   SET END-OF-FILE TO TRUE
               NOT AT END
                   PERFORM VALIDATE-RECORD
           END-READ.

       VALIDATE-RECORD.
           IF IN-ACCOUNT-ID = SPACES OR
              IN-NAME = SPACES
               ADD 1 TO WS-INVALID-COUNT
           ELSE
               PERFORM PROCESS-VALID-RECORD
           END-IF.

       PROCESS-VALID-RECORD.
           ADD 1 TO WS-VALID-COUNT
           ADD IN-BALANCE TO WS-TOTAL-BALANCE

           MOVE IN-BALANCE TO WS-BALANCE-DISPLAY

           STRING
               IN-ACCOUNT-ID DELIMITED BY SIZE
               SPACE
               IN-NAME DELIMITED BY SIZE
               SPACE
               WS-BALANCE-DISPLAY DELIMITED BY SIZE
               INTO WS-FORMATTED-LINE
           END-STRING

           MOVE WS-FORMATTED-LINE TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD.

       WRITE-SUMMARY.
           MOVE SPACES TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD

           MOVE '----- SUMMARY -----' TO OUTPUT-RECORD
           WRITE OUTPUT-RECORD

           STRING
               'VALID RECORDS: '
               WS-VALID-COUNT
               INTO OUTPUT-RECORD
           END-STRING
           WRITE OUTPUT-RECORD

           STRING
               'INVALID RECORDS: '
               WS-INVALID-COUNT
               INTO OUTPUT-RECORD
           END-STRING
           WRITE OUTPUT-RECORD

           MOVE WS-TOTAL-BALANCE TO WS-BALANCE-DISPLAY

           STRING
               'TOTAL BALANCE: '
               WS-BALANCE-DISPLAY
               INTO OUTPUT-RECORD
           END-STRING
           WRITE OUTPUT-RECORD.

       CLOSE-FILES.
           CLOSE INPUT-FILE
                 OUTPUT-FILE.