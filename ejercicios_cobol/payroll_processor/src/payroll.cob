       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYROLL.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMP-FILE ASSIGN TO '../data/input_employees.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT REPORT-FILE ASSIGN TO '../data/payroll_report.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD EMP-FILE.
       01 EMP-RECORD.
           05 EMP-ID           PIC X(5).
           05 EMP-NAME         PIC X(20).
           05 EMP-HOURS        PIC 9(3).
           05 EMP-RATE         PIC 9(3)V99.

       FD REPORT-FILE.
       01 REPORT-REC          PIC X(100).

       WORKING-STORAGE SECTION.

       01 WS-EOF              PIC X VALUE 'N'.
          88 END-OF-FILE      VALUE 'Y'.

       01 WS-GROSS            PIC 9(7)V99.
       01 WS-TAX              PIC 9(7)V99.
       01 WS-NET              PIC 9(7)V99.

       01 WS-TOTAL-GROSS      PIC 9(9)V99 VALUE 0.
       01 WS-TOTAL-TAX        PIC 9(9)V99 VALUE 0.
       01 WS-TOTAL-NET        PIC 9(9)V99 VALUE 0.

       01 WS-DISPLAY-AMT      PIC Z(7)9.99.

       01 WS-VALID-COUNT      PIC 9(5) VALUE 0.
       01 WS-INVALID-COUNT    PIC 9(5) VALUE 0.

       PROCEDURE DIVISION.

       MAIN.
           PERFORM OPEN-FILES
           PERFORM UNTIL END-OF-FILE
               PERFORM READ-EMPLOYEE
               IF NOT END-OF-FILE
                   PERFORM VALIDATE-EMPLOYEE
               END-IF
           END-PERFORM
           PERFORM WRITE-SUMMARY
           PERFORM CLOSE-FILES
           STOP RUN.

       OPEN-FILES.
           OPEN INPUT EMP-FILE
           OPEN OUTPUT REPORT-FILE.

       READ-EMPLOYEE.
           READ EMP-FILE
               AT END
                   SET END-OF-FILE TO TRUE
           END-READ.

       VALIDATE-EMPLOYEE.
           IF EMP-ID = SPACES OR EMP-NAME = SPACES
               ADD 1 TO WS-INVALID-COUNT
           ELSE
               PERFORM CALCULATE-PAY
               PERFORM WRITE-DETAIL
               ADD 1 TO WS-VALID-COUNT
           END-IF.

       CALCULATE-PAY.
           MULTIPLY EMP-HOURS BY EMP-RATE GIVING WS-GROSS
           COMPUTE WS-TAX = WS-GROSS * 0.10
           SUBTRACT WS-TAX FROM WS-GROSS GIVING WS-NET

           ADD WS-GROSS TO WS-TOTAL-GROSS
           ADD WS-TAX TO WS-TOTAL-TAX
           ADD WS-NET TO WS-TOTAL-NET.

       WRITE-DETAIL.
           MOVE WS-GROSS TO WS-DISPLAY-AMT
           STRING
               EMP-ID SPACE EMP-NAME SPACE WS-DISPLAY-AMT
               INTO REPORT-REC
           END-STRING
           WRITE REPORT-REC.

       WRITE-SUMMARY.
           MOVE SPACES TO REPORT-REC
           WRITE REPORT-REC

           STRING 'TOTAL GROSS: ' WS-TOTAL-GROSS
               INTO REPORT-REC
           END-STRING
           WRITE REPORT-REC

           STRING 'TOTAL TAX: ' WS-TOTAL-TAX
               INTO REPORT-REC
           END-STRING
           WRITE REPORT-REC

           STRING 'TOTAL NET: ' WS-TOTAL-NET
               INTO REPORT-REC
           END-STRING
           WRITE REPORT-REC

           STRING 'VALID: ' WS-VALID-COUNT
               INTO REPORT-REC
           END-STRING
           WRITE REPORT-REC

           STRING 'INVALID: ' WS-INVALID-COUNT
               INTO REPORT-REC
           END-STRING
           WRITE REPORT-REC.

       CLOSE-FILES.
           CLOSE EMP-FILE REPORT-FILE.