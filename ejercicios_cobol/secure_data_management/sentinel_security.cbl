       IDENTIFICATION DIVISION.
       PROGRAM-ID. SENTINEL-SECURITY.
       AUTHOR. "Daniel Simonetta".
       DATE-WRITTEN. 20261019.
       DATE-COMPILED. 20261019.
       INSTALLATION. "SECURE DATA MANAGEMENT".
       SECURITY. "ACCESS CONTROL AND AUDIT".

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-CONSTANTS.
           05 WS-MAX-USERS             PIC 9(3) VALUE 100.
           05 WS-MAX-RECORDS           PIC 9(5) VALUE 10000.
           05 WS-MAX-LOGIN-ATTEMPTS    PIC 9(2) VALUE 3.
           05 WS-SESSION-TIMEOUT       PIC 9(4) VALUE 300.
           05 WS-MAX-INPUT-LENGTH      PIC 9(3) VALUE 100.
           05 WS-PASSWORD-MIN-LENGTH  PIC 9(2) VALUE 12.

       01  WS-CONTROL.
           05 WS-MAIN-OPTION           PIC 9.
           05 WS-ADMIN-OPTION          PIC 9.
           05 WS-RUNNING               PIC X VALUE "Y".
           05 WS-AUTHENTICATED         PIC X VALUE "N".
           05 WS-SESSION-ROLE           PIC X(10).
           05 WS-SESSION-USER           PIC X(20).
           05 WS-LOGIN-ATTEMPTS         PIC 9(2) VALUE 0.
           05 WS-ACCESS-DENIED          PIC X VALUE "N".
           05 WS-INPUT-VALID            PIC X VALUE "N".
           05 WS-OPERATION-VALID        PIC X VALUE "N".
           05 WS-RECORD-FOUND           PIC X VALUE "N".
           05 WS-EOF                    PIC X VALUE "N".
           05 WS-ERROR                  PIC X VALUE "N".
           05 WS-EXIT-CONFIRMED         PIC X VALUE "N".

       01  WS-CLOCK.
           05 WS-CURRENT-DATE           PIC 9(8).
           05 WS-CURRENT-TIME           PIC 9(6).
           05 WS-DATE-AND-TIME           PIC X(21).

       01  WS-AUTHENTICATION.
           05 WS-USERNAME                PIC X(20).
           05 WS-PASSWORD                PIC X(100).
           05 WS-EXPECTED-USERNAME       PIC X(20).
           05 WS-EXPECTED-PASSWORD       PIC X(100).
           05 WS-PASSWORD-LENGTH         PIC 9(3).
           05 WS-PASSWORD-VALID          PIC X VALUE "N".
           05 WS-USER-STATUS             PIC X VALUE "A".
           05 WS-FAILED-LOGINS           PIC 9(3) VALUE 0.
           05 WS-LOCKED-USER              PIC X VALUE "N".

       01  WS-DATA-RECORD.
           05 WS-RECORD-ID               PIC 9(10).
           05 WS-RECORD-OWNER            PIC X(20).
           05 WS-RECORD-CLASSIFICATION   PIC X(10).
           05 WS-RECORD-TITLE            PIC X(60).
           05 WS-RECORD-CONTENT          PIC X(100).
           05 WS-RECORD-STATUS            PIC X.
           05 WS-RECORD-CREATED           PIC 9(8).
           05 WS-RECORD-MODIFIED          PIC 9(8).

       01  WS-RECORD-COUNTERS.
           05 WS-NEXT-RECORD-ID          PIC 9(10) VALUE 1.
           05 WS-TOTAL-RECORDS            PIC 9(5) VALUE 0.
           05 WS-ACTIVE-RECORDS           PIC 9(5) VALUE 0.
           05 WS-DELETED-RECORDS          PIC 9(5) VALUE 0.
           05 WS-RECORD-INDEX             PIC 9(5) VALUE 0.

       01  WS-AUDIT.
           05 WS-AUDIT-EVENT              PIC X(30).
           05 WS-AUDIT-DETAIL             PIC X(100).
           05 WS-AUDIT-RESULT             PIC X(12).
           05 WS-AUDIT-SEQUENCE           PIC 9(10) VALUE 0.
           05 WS-AUDIT-ENTRY              PIC X(250).

       01  WS-INPUT-BUFFER.
           05 WS-INPUT                    PIC X(120).
           05 WS-INPUT-LENGTH             PIC 9(3).
           05 WS-CHARACTER                PIC X.
           05 WS-INDEX                    PIC 9(3).
           05 WS-SECOND-INDEX             PIC 9(3).
           05 WS-INVALID-CHARACTER        PIC X VALUE "N".

       01  WS-CRYPTOGRAPHIC-CONTROLS.
           05 WS-SALT                     PIC X(32).
           05 WS-PASSWORD-DIGEST          PIC X(128).
           05 WS-DIGEST-VERIFIED          PIC X VALUE "N".
           05 WS-CRYPTO-AVAILABLE         PIC X VALUE "N".
           05 WS-SECURE-SESSION           PIC X VALUE "N".

       01  WS-STATISTICS.
           05 WS-LOGIN-SUCCESSFUL         PIC 9(8) VALUE 0.
           05 WS-LOGIN-FAILED             PIC 9(8) VALUE 0.
           05 WS-ACCESS-ATTEMPTS          PIC 9(8) VALUE 0.
           05 WS-SECURITY-INCIDENTS       PIC 9(8) VALUE 0.
           05 WS-OPERATIONS-SUCCESSFUL    PIC 9(8) VALUE 0.
           05 WS-OPERATIONS-FAILED        PIC 9(8) VALUE 0.

       01  WS-MESSAGES.
           05 WS-MESSAGE                 PIC X(100).
           05 WS-ERROR-CODE              PIC X(10).

       01  WS-REPORT.
           05 WS-REPORT-LINE              PIC X(120).
           05 WS-REPORT-COUNT              PIC 9(8) VALUE 0.

       PROCEDURE DIVISION.

       MAIN-PROGRAM.

           PERFORM INITIALIZE-SYSTEM
           PERFORM AUTHENTICATE-USER

           IF WS-AUTHENTICATED = "Y"
               PERFORM MAIN-MENU
           END-IF

           PERFORM TERMINATE-SESSION
           STOP RUN.

       INITIALIZE-SYSTEM.

           MOVE FUNCTION CURRENT-DATE TO WS-DATE-AND-TIME
           MOVE WS-DATE-AND-TIME(1:8) TO WS-CURRENT-DATE
           MOVE WS-DATE-AND-TIME(9:6) TO WS-CURRENT-TIME

           MOVE 0 TO WS-LOGIN-ATTEMPTS
           MOVE "N" TO WS-AUTHENTICATED
           MOVE "N" TO WS-ACCESS-DENIED
           MOVE "SYSTEM-START" TO WS-AUDIT-EVENT
           MOVE "Application initialized" TO WS-AUDIT-DETAIL
           MOVE "SUCCESS" TO WS-AUDIT-RESULT

           PERFORM WRITE-AUDIT.

       AUTHENTICATE-USER.

           DISPLAY SPACE
           DISPLAY "========================================"
           DISPLAY "          SENTINEL SECURITY             "
           DISPLAY "       SECURE DATA MANAGEMENT           "
           DISPLAY "========================================"

           PERFORM UNTIL WS-AUTHENTICATED = "Y"
               OR WS-LOGIN-ATTEMPTS >= WS-MAX-LOGIN-ATTEMPTS

               DISPLAY SPACE
               DISPLAY "Username: " WITH NO ADVANCING
               ACCEPT WS-USERNAME

               DISPLAY "Password: " WITH NO ADVANCING
               ACCEPT WS-PASSWORD

               ADD 1 TO WS-LOGIN-ATTEMPTS
               ADD 1 TO WS-ACCESS-ATTEMPTS

               PERFORM VALIDATE-CREDENTIALS

               IF WS-AUTHENTICATED = "Y"
                   ADD 1 TO WS-LOGIN-SUCCESSFUL
                   MOVE "LOGIN-SUCCESS" TO WS-AUDIT-EVENT
                   MOVE "Authenticated session established"
                       TO WS-AUDIT-DETAIL
                   MOVE "SUCCESS" TO WS-AUDIT-RESULT
               ELSE
                   ADD 1 TO WS-LOGIN-FAILED
                   MOVE "LOGIN-FAILED" TO WS-AUDIT-EVENT
                   MOVE "Invalid authentication attempt"
                       TO WS-AUDIT-DETAIL
                   MOVE "DENIED" TO WS-AUDIT-RESULT
                   DISPLAY "Authentication failed."
               END-IF

               PERFORM WRITE-AUDIT

           END-PERFORM

           IF WS-AUTHENTICATED NOT = "Y"
               MOVE "Y" TO WS-ACCESS-DENIED
               ADD 1 TO WS-SECURITY-INCIDENTS
               MOVE "LOGIN-LOCKOUT" TO WS-AUDIT-EVENT
               MOVE "Authentication attempt limit reached"
                   TO WS-AUDIT-DETAIL
               MOVE "DENIED" TO WS-AUDIT-RESULT
               PERFORM WRITE-AUDIT
               DISPLAY "Access denied."
           END-IF.

       VALIDATE-CREDENTIALS.

           MOVE "N" TO WS-AUTHENTICATED

           IF WS-USERNAME = SPACES
               EXIT PARAGRAPH
           END-IF

           IF WS-PASSWORD = SPACES
               EXIT PARAGRAPH
           END-IF

           IF WS-USERNAME = "ADMIN"
               IF WS-PASSWORD = "ChangeMeNow!2026"
                   MOVE "Y" TO WS-AUTHENTICATED
                   MOVE "ADMIN" TO WS-SESSION-ROLE
                   MOVE WS-USERNAME TO WS-SESSION-USER
               END-IF
           END-IF

           IF WS-USERNAME = "AUDITOR"
               IF WS-PASSWORD = "AuditOnly!2026"
                   MOVE "Y" TO WS-AUTHENTICATED
                   MOVE "AUDITOR" TO WS-SESSION-ROLE
                   MOVE WS-USERNAME TO WS-SESSION-USER
               END-IF
           END-IF.

       MAIN-MENU.

           PERFORM UNTIL WS-RUNNING = "N"

               DISPLAY SPACE
               DISPLAY "========================================"
               DISPLAY "             MAIN MENU                  "
               DISPLAY "========================================"
               DISPLAY "Authenticated user: " WS-SESSION-USER
               DISPLAY "Role: " WS-SESSION-ROLE
               DISPLAY "1. Create protected record"
               DISPLAY "2. Read protected record"
               DISPLAY "3. Modify protected record"
               DISPLAY "4. Soft-delete protected record"
               DISPLAY "5. Security dashboard"
               DISPLAY "6. Logout"
               DISPLAY "Select option: " WITH NO ADVANCING

               ACCEPT WS-INPUT
               PERFORM VALIDATE-NUMERIC-INPUT

               IF WS-INPUT-VALID = "N"
                   DISPLAY "Invalid option."
               ELSE
                   EVALUATE FUNCTION NUMVAL(WS-INPUT)
                       WHEN 1
                           PERFORM CREATE-RECORD
                       WHEN 2
                           PERFORM READ-RECORD
                       WHEN 3
                           PERFORM MODIFY-RECORD
                       WHEN 4
                           PERFORM DELETE-RECORD
                       WHEN 5
                           PERFORM SECURITY-DASHBOARD
                       WHEN 6
                           MOVE "N" TO WS-RUNNING
                       WHEN OTHER
                           DISPLAY "Invalid option."
                   END-EVALUATE
               END-IF

           END-PERFORM.

       CREATE-RECORD.

           IF WS-SESSION-ROLE NOT = "ADMIN"
               PERFORM DENY-OPERATION
               EXIT PARAGRAPH
           END-IF

           IF WS-TOTAL-RECORDS >= WS-MAX-RECORDS
               DISPLAY "Record capacity reached."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Record title: " WITH NO ADVANCING
           ACCEPT WS-RECORD-TITLE

           IF WS-RECORD-TITLE = SPACES
               DISPLAY "Title cannot be empty."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Classification (PUBLIC/PRIVATE): "
               WITH NO ADVANCING
           ACCEPT WS-RECORD-CLASSIFICATION

           IF WS-RECORD-CLASSIFICATION NOT = "PUBLIC"
               AND WS-RECORD-CLASSIFICATION NOT = "PRIVATE"
               DISPLAY "Invalid classification."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Record content: " WITH NO ADVANCING
           ACCEPT WS-RECORD-CONTENT

           IF WS-RECORD-CONTENT = SPACES
               DISPLAY "Content cannot be empty."
               EXIT PARAGRAPH
           END-IF

           ADD 1 TO WS-NEXT-RECORD-ID
           ADD 1 TO WS-TOTAL-RECORDS
           ADD 1 TO WS-ACTIVE-RECORDS

           MOVE WS-NEXT-RECORD-ID TO WS-RECORD-ID
           MOVE WS-SESSION-USER TO WS-RECORD-OWNER
           MOVE "A" TO WS-RECORD-STATUS
           MOVE WS-CURRENT-DATE TO WS-RECORD-CREATED
           MOVE WS-CURRENT-DATE TO WS-RECORD-MODIFIED

           MOVE "RECORD-CREATE" TO WS-AUDIT-EVENT
           MOVE "Protected record created" TO WS-AUDIT-DETAIL
           MOVE "SUCCESS" TO WS-AUDIT-RESULT

           PERFORM WRITE-AUDIT
           ADD 1 TO WS-OPERATIONS-SUCCESSFUL

           DISPLAY "Record created."
           DISPLAY "Record ID: " WS-RECORD-ID.

       READ-RECORD.

           DISPLAY "Record ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT
           PERFORM VALIDATE-NUMERIC-INPUT

           IF WS-INPUT-VALID = "N"
               DISPLAY "Invalid record ID."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-RECORD-ID

           IF WS-RECORD-ID > WS-NEXT-RECORD-ID
               DISPLAY "Record not found."
               EXIT PARAGRAPH
           END-IF

           IF WS-RECORD-STATUS NOT = "A"
               DISPLAY "Record unavailable."
               EXIT PARAGRAPH
           END-IF

           IF WS-RECORD-CLASSIFICATION = "PRIVATE"
               IF WS-SESSION-ROLE NOT = "ADMIN"
                   IF WS-RECORD-OWNER NOT = WS-SESSION-USER
                       PERFORM DENY-OPERATION
                       EXIT PARAGRAPH
                   END-IF
               END-IF
           END-IF

           DISPLAY "Record ID: " WS-RECORD-ID
           DISPLAY "Owner: " WS-RECORD-OWNER
           DISPLAY "Classification: " WS-RECORD-CLASSIFICATION
           DISPLAY "Title: " WS-RECORD-TITLE
           DISPLAY "Content: " WS-RECORD-CONTENT
           DISPLAY "Created: " WS-RECORD-CREATED
           DISPLAY "Modified: " WS-RECORD-MODIFIED

           MOVE "RECORD-READ" TO WS-AUDIT-EVENT
           MOVE "Protected record accessed" TO WS-AUDIT-DETAIL
           MOVE "SUCCESS" TO WS-AUDIT-RESULT
           PERFORM WRITE-AUDIT.

       MODIFY-RECORD.

           IF WS-SESSION-ROLE NOT = "ADMIN"
               PERFORM DENY-OPERATION
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Record ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT
           PERFORM VALIDATE-NUMERIC-INPUT

           IF WS-INPUT-VALID = "N"
               DISPLAY "Invalid record ID."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-RECORD-ID

           IF WS-RECORD-ID > WS-NEXT-RECORD-ID
               DISPLAY "Record not found."
               EXIT PARAGRAPH
           END-IF

           IF WS-RECORD-STATUS NOT = "A"
               DISPLAY "Record unavailable."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "New title: " WITH NO ADVANCING
           ACCEPT WS-RECORD-TITLE

           IF WS-RECORD-TITLE = SPACES
               DISPLAY "Title cannot be empty."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "New content: " WITH NO ADVANCING
           ACCEPT WS-RECORD-CONTENT

           IF WS-RECORD-CONTENT = SPACES
               DISPLAY "Content cannot be empty."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-CURRENT-DATE TO WS-RECORD-MODIFIED

           MOVE "RECORD-MODIFY" TO WS-AUDIT-EVENT
           MOVE "Protected record modified" TO WS-AUDIT-DETAIL
           MOVE "SUCCESS" TO WS-AUDIT-RESULT
           PERFORM WRITE-AUDIT

           ADD 1 TO WS-OPERATIONS-SUCCESSFUL
           DISPLAY "Record updated.".

       DELETE-RECORD.

           IF WS-SESSION-ROLE NOT = "ADMIN"
               PERFORM DENY-OPERATION
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Record ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT
           PERFORM VALIDATE-NUMERIC-INPUT

           IF WS-INPUT-VALID = "N"
               DISPLAY "Invalid record ID."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-RECORD-ID

           IF WS-RECORD-ID > WS-NEXT-RECORD-ID
               DISPLAY "Record not found."
               EXIT PARAGRAPH
           END-IF

           IF WS-RECORD-STATUS NOT = "A"
               DISPLAY "Record unavailable."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Confirm deletion (Y/N): "
               WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT NOT = "Y"
               DISPLAY "Deletion cancelled."
               EXIT PARAGRAPH
           END-IF

           MOVE "D" TO WS-RECORD-STATUS
           SUBTRACT 1 FROM WS-ACTIVE-RECORDS
           ADD 1 TO WS-DELETED-RECORDS

           MOVE "RECORD-DELETE" TO WS-AUDIT-EVENT
           MOVE "Protected record soft-deleted"
               TO WS-AUDIT-DETAIL
           MOVE "SUCCESS" TO WS-AUDIT-RESULT
           PERFORM WRITE-AUDIT

           ADD 1 TO WS-OPERATIONS-SUCCESSFUL
           DISPLAY "Record deleted.".

       SECURITY-DASHBOARD.

           IF WS-SESSION-ROLE NOT = "ADMIN"
               AND WS-SESSION-ROLE NOT = "AUDITOR"
               PERFORM DENY-OPERATION
               EXIT PARAGRAPH
           END-IF

           DISPLAY SPACE
           DISPLAY "========================================"
           DISPLAY "          SECURITY DASHBOARD            "
           DISPLAY "========================================"
           DISPLAY "Successful logins: " WS-LOGIN-SUCCESSFUL
           DISPLAY "Failed logins: " WS-LOGIN-FAILED
           DISPLAY "Access attempts: " WS-ACCESS-ATTEMPTS
           DISPLAY "Security incidents: " WS-SECURITY-INCIDENTS
           DISPLAY "Successful operations: "
               WS-OPERATIONS-SUCCESSFUL
           DISPLAY "Failed operations: " WS-OPERATIONS-FAILED
           DISPLAY "Active records: " WS-ACTIVE-RECORDS
           DISPLAY "Deleted records: " WS-DELETED-RECORDS
           DISPLAY "Total records: " WS-TOTAL-RECORDS.

       DENY-OPERATION.

           MOVE "ACCESS-DENIED" TO WS-AUDIT-EVENT
           MOVE "Unauthorized operation rejected"
               TO WS-AUDIT-DETAIL
           MOVE "DENIED" TO WS-AUDIT-RESULT
           PERFORM WRITE-AUDIT

           ADD 1 TO WS-SECURITY-INCIDENTS
           ADD 1 TO WS-OPERATIONS-FAILED

           DISPLAY "Access denied.".

       VALIDATE-NUMERIC-INPUT.

           MOVE "N" TO WS-INPUT-VALID

           IF WS-INPUT = SPACES
               EXIT PARAGRAPH
           END-IF

           IF FUNCTION TEST-NUMVAL(FUNCTION TRIM(WS-INPUT)) = 0
               MOVE "Y" TO WS-INPUT-VALID
           END-IF.

       WRITE-AUDIT.

           ADD 1 TO WS-AUDIT-SEQUENCE

           DISPLAY "AUDIT | "
               WS-CURRENT-DATE " "
               WS-CURRENT-TIME " | "
               WS-AUDIT-SEQUENCE " | "
               WS-SESSION-USER " | "
               WS-AUDIT-EVENT " | "
               WS-AUDIT-RESULT.

       TERMINATE-SESSION.

           MOVE "SESSION-END" TO WS-AUDIT-EVENT
           MOVE "Application session terminated"
               TO WS-AUDIT-DETAIL
           MOVE "SUCCESS" TO WS-AUDIT-RESULT
           PERFORM WRITE-AUDIT

           MOVE "N" TO WS-AUTHENTICATED
           MOVE SPACES TO WS-PASSWORD
           MOVE SPACES TO WS-EXPECTED-PASSWORD
           MOVE SPACES TO WS-SESSION-USER

           DISPLAY "Session terminated.".

       END PROGRAM SENTINEL-SECURITY.