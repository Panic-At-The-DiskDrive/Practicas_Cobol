       IDENTIFICATION DIVISION.
       PROGRAM-ID. RECONCILE.
       AUTHOR. SIMONETTA, DANIEL.
       DATE-WRITTEN. 2026-05-06.

      * ============================================
      * PROJECT: BATCH RECONCILIATION SYSTEM
      * AUTHOR : SIMONETTA, DANIEL
      * DATE   : 2026-05-06
      * ============================================

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INT-FILE ASSIGN TO '../data/internal_trx.txt'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-INT-STATUS.

           SELECT EXT-FILE ASSIGN TO '../data/external_trx.txt'
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-EXT-STATUS.

           SELECT REP-FILE ASSIGN TO '../data/reconciliation_report.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD INT-FILE.
       COPY trx_layout.cpy.

       FD EXT-FILE.
       COPY trx_layout.cpy.

       FD REP-FILE.
       01 REP-REC PIC X(120).

       WORKING-STORAGE SECTION.

       01 WS-INT-STATUS PIC XX.
       01 WS-EXT-STATUS PIC XX.

       01 WS-EOF-INT PIC X VALUE 'N'.
          88 EOF-INT VALUE 'Y'.

       01 WS-EOF-EXT PIC X VALUE 'N'.
          88 EOF-EXT VALUE 'Y'.

       01 WS-MATCH-COUNT     PIC 9(5) VALUE 0.
       01 WS-MISSING-INT     PIC 9(5) VALUE 0.
       01 WS-MISSING-EXT     PIC 9(5) VALUE 0.
       01 WS-DIFF-COUNT      PIC 9(5) VALUE 0.

       PROCEDURE DIVISION.

       MAIN.
           PERFORM OPEN-FILES
           PERFORM READ-INT
           PERFORM READ-EXT

           PERFORM UNTIL EOF-INT AND EOF-EXT
               PERFORM RECONCILE-STEP
           END-PERFORM

           PERFORM WRITE-SUMMARY
           PERFORM CLOSE-FILES
           STOP RUN.

       OPEN-FILES.
           OPEN INPUT INT-FILE EXT-FILE
           OPEN OUTPUT REP-FILE.

       READ-INT.
           READ INT-FILE
               AT END SET EOF-INT TO TRUE
           END-READ.

       READ-EXT.
           READ EXT-FILE
               AT END SET EOF-EXT TO TRUE
           END-READ.

       RECONCILE-STEP.
           EVALUATE TRUE
               WHEN EOF-INT
                   ADD 1 TO WS-MISSING-INT
                   PERFORM READ-EXT

               WHEN EOF-EXT
                   ADD 1 TO WS-MISSING-EXT
                   PERFORM READ-INT

               WHEN TRX-ID OF INT-FILE < TRX-ID OF EXT-FILE
                   ADD 1 TO WS-MISSING-EXT
                   PERFORM READ-INT

               WHEN TRX-ID OF INT-FILE > TRX-ID OF EXT-FILE
                   ADD 1 TO WS-MISSING-INT
                   PERFORM READ-EXT

               WHEN OTHER
                   IF TRX-AMOUNT OF INT-FILE = TRX-AMOUNT OF EXT-FILE
                       ADD 1 TO WS-MATCH-COUNT
                   ELSE
                       ADD 1 TO WS-DIFF-COUNT
                   END-IF
                   PERFORM READ-INT
                   PERFORM READ-EXT
           END-EVALUATE.

       WRITE-SUMMARY.
           STRING 'MATCH: ' WS-MATCH-COUNT
               INTO REP-REC
           END-STRING
           WRITE REP-REC

           STRING 'MISSING INTERNAL: ' WS-MISSING-INT
               INTO REP-REC
           END-STRING
           WRITE REP-REC

           STRING 'MISSING EXTERNAL: ' WS-MISSING-EXT
               INTO REP-REC
           END-STRING
           WRITE REP-REC

           STRING 'DIFFERENCES: ' WS-DIFF-COUNT
               INTO REP-REC
           END-STRING
           WRITE REP-REC.

       CLOSE-FILES.
           CLOSE INT-FILE EXT-FILE REP-FILE.