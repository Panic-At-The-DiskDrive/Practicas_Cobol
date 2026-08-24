>>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SECUREVAULT.
       AUTHOR. "DANIEL SIMONETTA".
       DATE-WRITTEN. "24/08/2026".
       DATE-COMPILED. "24/08/2026".

      ******************************************************************
      * COBOL SECUREVAULT
      * Single-file local credential and private-record manager.
      *
      * Author: Daniel Simonetta
      * Date  : 24/08/2026
      *
      * This program is designed as a complete educational/local COBOL
      * application. It uses sequential files and requires no database.
      *
      * Security:
      *   - Authentication required for private records.
      *   - Three failed login attempts lock an account.
      *   - Password changes require the current password.
      *   - Password confirmation is required.
      *   - Passwords are never displayed by the program.
      *   - User-owned records are isolated by username.
      *   - File operations are checked with FILE STATUS.
      *   - Sequential-file updates use temporary files and controlled
      *     replacement rather than pretending an in-place DELETE exists.
      *
      * IMPORTANT:
      * The password digest below is a deterministic application digest,
      * not a modern cryptographic password hash such as Argon2id/bcrypt.
      * This program is therefore suitable for learning and local use,
      * not for protecting high-value production credentials.
      *
      * Files created in the executable directory:
      *   SV-USERS.DAT
      *   SV-VAULT.DAT
      *   SV-USERS.TMP
      *   SV-VAULT.TMP
      ******************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. GNUCOBOL.
       OBJECT-COMPUTER. GNUCOBOL.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USER-FILE ASSIGN TO "SV-USERS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-USER-FS.

           SELECT USER-TEMP-FILE ASSIGN TO "SV-USERS.TMP"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-USER-TEMP-FS.

           SELECT VAULT-FILE ASSIGN TO "SV-VAULT.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-VAULT-FS.

           SELECT VAULT-TEMP-FILE ASSIGN TO "SV-VAULT.TMP"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-VAULT-TEMP-FS.

       DATA DIVISION.
       FILE SECTION.

       FD  USER-FILE.
       01  USER-RECORD.
           05 UR-USERNAME          PIC X(30).
           05 UR-PASSWORD-HASH     PIC 9(10).
           05 UR-LOCKED            PIC X.
           05 UR-FAIL-COUNT        PIC 9.

       FD  USER-TEMP-FILE.
       01  USER-TEMP-RECORD.
           05 UTR-USERNAME         PIC X(30).
           05 UTR-PASSWORD-HASH    PIC 9(10).
           05 UTR-LOCKED           PIC X.
           05 UTR-FAIL-COUNT       PIC 9.

       FD  VAULT-FILE.
       01  VAULT-RECORD.
           05 VR-USERNAME          PIC X(30).
           05 VR-ID                PIC 9(5).
           05 VR-TITLE             PIC X(50).
           05 VR-SECRET            PIC X(200).

       FD  VAULT-TEMP-FILE.
       01  VAULT-TEMP-RECORD.
           05 VTR-USERNAME         PIC X(30).
           05 VTR-ID               PIC 9(5).
           05 VTR-TITLE            PIC X(50).
           05 VTR-SECRET           PIC X(200).

       WORKING-STORAGE SECTION.

       01  WS-USER-FS              PIC XX VALUE "00".
       01  WS-USER-TEMP-FS         PIC XX VALUE "00".
       01  WS-VAULT-FS             PIC XX VALUE "00".
       01  WS-VAULT-TEMP-FS        PIC XX VALUE "00".

       01  WS-EOF                  PIC X VALUE "N".
           88  EOF-YES             VALUE "Y".
           88  EOF-NO              VALUE "N".

       01  WS-FOUND                PIC X VALUE "N".
           88  FOUND-YES           VALUE "Y".
           88  FOUND-NO            VALUE "N".

       01  WS-VALID                PIC X VALUE "N".
       01  WS-CONTINUE             PIC X VALUE "Y".

       01  WS-OPTION               PIC X(2).
       01  WS-USERNAME             PIC X(30).
       01  WS-PASSWORD             PIC X(100).
       01  WS-PASSWORD-2           PIC X(100).
       01  WS-OLD-PASSWORD         PIC X(100).
       01  WS-NEW-PASSWORD         PIC X(100).
       01  WS-NEW-PASSWORD-2       PIC X(100).

       01  WS-CURRENT-USER         PIC X(30) VALUE SPACES.
       01  WS-TITLE                PIC X(50).
       01  WS-SECRET               PIC X(200).

       01  WS-HASH                 PIC 9(10) VALUE ZERO.
       01  WS-CHAR-CODE            PIC 9(4) VALUE ZERO.
       01  WS-LENGTH               PIC 9(4) VALUE ZERO.
       01  WS-I                    PIC 9(4) VALUE ZERO.

       01  WS-LOGIN-TRIES          PIC 9 VALUE ZERO.
       01  WS-MAX-TRIES            PIC 9 VALUE 3.

       01  WS-NEXT-ID              PIC 9(5) VALUE 1.
       01  WS-RECORD-ID            PIC 9(5) VALUE ZERO.

       01  WS-NUMERIC-INPUT        PIC X(5).
       01  WS-NUMERIC-VALID        PIC X VALUE "N".

       01  WS-DELETE-CONFIRM       PIC X.
       01  WS-REPLACE-OK           PIC X VALUE "Y".

       01  WS-DATE.
           05 WS-YEAR              PIC 9(4).
           05 WS-MONTH             PIC 9(2).
           05 WS-DAY               PIC 9(2).

       PROCEDURE DIVISION.

       MAIN.
           PERFORM INITIALIZE-DATA
           PERFORM MAIN-MENU
           PERFORM CLEAN-SHUTDOWN
           STOP RUN.

      ******************************************************************
      * INITIALIZATION
      ******************************************************************
       INITIALIZE-DATA.
           MOVE FUNCTION CURRENT-DATE TO WS-DATE

           OPEN INPUT USER-FILE
           IF WS-USER-FS NOT = "00"
               IF WS-USER-FS = "35"
                   OPEN OUTPUT USER-FILE
                   IF WS-USER-FS NOT = "00"
                       DISPLAY "ERROR: Cannot create SV-USERS.DAT."
                       STOP RUN
                   END-IF
                   CLOSE USER-FILE
               ELSE
                   DISPLAY "ERROR: Cannot access SV-USERS.DAT."
                   DISPLAY "FILE STATUS: " WS-USER-FS
                   STOP RUN
               END-IF
           ELSE
               CLOSE USER-FILE
           END-IF

           OPEN INPUT VAULT-FILE
           IF WS-VAULT-FS NOT = "00"
               IF WS-VAULT-FS = "35"
                   OPEN OUTPUT VAULT-FILE
                   IF WS-VAULT-FS NOT = "00"
                       DISPLAY "ERROR: Cannot create SV-VAULT.DAT."
                       STOP RUN
                   END-IF
                   CLOSE VAULT-FILE
               ELSE
                   DISPLAY "ERROR: Cannot access SV-VAULT.DAT."
                   DISPLAY "FILE STATUS: " WS-VAULT-FS
                   STOP RUN
               END-IF
           ELSE
               CLOSE VAULT-FILE
           END-IF.

      ******************************************************************
      * MAIN MENU
      ******************************************************************
       MAIN-MENU.
           MOVE "Y" TO WS-CONTINUE

           PERFORM UNTIL WS-CONTINUE = "N"
               DISPLAY SPACE
               DISPLAY "=============================================="
               DISPLAY "              COBOL SECUREVAULT"
               DISPLAY "=============================================="
               DISPLAY "Local credential and private-record manager"
               DISPLAY "Author : Daniel Simonetta"
               DISPLAY "Date   : 24/08/2026"
               DISPLAY "----------------------------------------------"
               DISPLAY "1 - Create user"
               DISPLAY "2 - Login"
               DISPLAY "3 - Exit"
               DISPLAY "----------------------------------------------"
               DISPLAY "Option: " WITH NO ADVANCING
               ACCEPT WS-OPTION

               EVALUATE WS-OPTION
                   WHEN "1"
                       PERFORM CREATE-USER
                   WHEN "2"
                       PERFORM LOGIN
                   WHEN "3"
                       MOVE "N" TO WS-CONTINUE
                   WHEN OTHER
                       DISPLAY "Invalid option."
               END-EVALUATE
           END-PERFORM.

      ******************************************************************
      * CREATE USER
      ******************************************************************
       CREATE-USER.
           DISPLAY SPACE
           DISPLAY "----------- CREATE USER -----------"

           MOVE SPACES TO WS-USERNAME
           DISPLAY "Username (1-30 chars): " WITH NO ADVANCING
           ACCEPT WS-USERNAME

           PERFORM VALIDATE-USERNAME
           IF WS-VALID = "N"
               DISPLAY "Invalid username."
               EXIT PARAGRAPH
           END-IF

           PERFORM FIND-USER
           IF FOUND-YES
               DISPLAY "That username already exists."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Password (minimum 8 chars): " WITH NO ADVANCING
           ACCEPT WS-PASSWORD

           DISPLAY "Confirm password: " WITH NO ADVANCING
           ACCEPT WS-PASSWORD-2

           IF WS-PASSWORD NOT = WS-PASSWORD-2
               DISPLAY "Passwords do not match."
               EXIT PARAGRAPH
           END-IF

           PERFORM VALIDATE-PASSWORD
           IF WS-VALID = "N"
               DISPLAY "Password rejected."
               DISPLAY
                 "Use at least 8 characters with letters and digits."
               EXIT PARAGRAPH
           END-IF

           PERFORM HASH-PASSWORD

           MOVE WS-USERNAME TO UR-USERNAME
           MOVE WS-HASH TO UR-PASSWORD-HASH
           MOVE "N" TO UR-LOCKED
           MOVE ZERO TO UR-FAIL-COUNT

           OPEN EXTEND USER-FILE
           IF WS-USER-FS NOT = "00"
               DISPLAY "ERROR: Cannot open user database."
               DISPLAY "FILE STATUS: " WS-USER-FS
               EXIT PARAGRAPH
           END-IF

           WRITE USER-RECORD
           IF WS-USER-FS NOT = "00"
               DISPLAY "ERROR: User was not saved."
               DISPLAY "FILE STATUS: " WS-USER-FS
           ELSE
               DISPLAY "User created successfully."
           END-IF

           CLOSE USER-FILE.

      ******************************************************************
      * LOGIN
      ******************************************************************
       LOGIN.
           MOVE ZERO TO WS-LOGIN-TRIES
           MOVE "N" TO WS-FOUND

           DISPLAY SPACE
           DISPLAY "--------------- LOGIN ----------------"

           DISPLAY "Username: " WITH NO ADVANCING
           ACCEPT WS-USERNAME

           PERFORM FIND-USER
           IF FOUND-NO
               DISPLAY "Invalid username or password."
               EXIT PARAGRAPH
           END-IF

           IF UR-LOCKED = "Y"
               DISPLAY "This account is locked."
               EXIT PARAGRAPH
           END-IF

           PERFORM UNTIL WS-LOGIN-TRIES >= WS-MAX-TRIES
               ADD 1 TO WS-LOGIN-TRIES

               DISPLAY "Password: " WITH NO ADVANCING
               ACCEPT WS-PASSWORD

               PERFORM HASH-PASSWORD

               IF WS-HASH = UR-PASSWORD-HASH
                   MOVE ZERO TO UR-FAIL-COUNT
                   PERFORM UPDATE-USER-RECORD
                   MOVE WS-USERNAME TO WS-CURRENT-USER
                   DISPLAY "Login successful."
                   PERFORM USER-MENU
                   EXIT PERFORM
               ELSE
                   DISPLAY "Invalid username or password."

                   IF WS-LOGIN-TRIES >= WS-MAX-TRIES
                       MOVE "Y" TO UR-LOCKED
                       MOVE 3 TO UR-FAIL-COUNT
                       PERFORM UPDATE-USER-RECORD
                       DISPLAY "Too many failed attempts."
                       DISPLAY "The account has been locked."
                   END-IF
               END-IF
           END-PERFORM.

      ******************************************************************
      * USER MENU
      ******************************************************************
       USER-MENU.
           MOVE "Y" TO WS-CONTINUE

           PERFORM UNTIL WS-CONTINUE = "N"
               DISPLAY SPACE
               DISPLAY "=============================================="
               DISPLAY "                USER AREA"
               DISPLAY "=============================================="
               DISPLAY "Authenticated user: " WS-CURRENT-USER
               DISPLAY "1 - Add private record"
               DISPLAY "2 - List private records"
               DISPLAY "3 - View private record"
               DISPLAY "4 - Delete private record"
               DISPLAY "5 - Change password"
               DISPLAY "6 - Logout"
               DISPLAY "----------------------------------------------"
               DISPLAY "Option: " WITH NO ADVANCING
               ACCEPT WS-OPTION

               EVALUATE WS-OPTION
                   WHEN "1"
                       PERFORM ADD-RECORD
                   WHEN "2"
                       PERFORM LIST-RECORDS
                   WHEN "3"
                       PERFORM VIEW-RECORD
                   WHEN "4"
                       PERFORM DELETE-RECORD
                   WHEN "5"
                       PERFORM CHANGE-PASSWORD
                   WHEN "6"
                       MOVE "N" TO WS-CONTINUE
                       MOVE SPACES TO WS-CURRENT-USER
                       MOVE SPACES TO WS-PASSWORD
                       MOVE SPACES TO WS-OLD-PASSWORD
                       MOVE SPACES TO WS-NEW-PASSWORD
                       MOVE SPACES TO WS-NEW-PASSWORD-2
                       DISPLAY "Logged out."
                   WHEN OTHER
                       DISPLAY "Invalid option."
               END-EVALUATE
           END-PERFORM.

      ******************************************************************
      * ADD PRIVATE RECORD
      ******************************************************************
       ADD-RECORD.
           DISPLAY SPACE
           DISPLAY "----------- ADD PRIVATE RECORD -----------"

           PERFORM GET-NEXT-ID
           MOVE WS-NEXT-ID TO WS-RECORD-ID

           DISPLAY "Title (max 50 chars): " WITH NO ADVANCING
           ACCEPT WS-TITLE

           PERFORM VALIDATE-TITLE
           IF WS-VALID = "N"
               DISPLAY "Invalid title."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Private content (max 200 chars): "
               WITH NO ADVANCING
           ACCEPT WS-SECRET

           MOVE WS-CURRENT-USER TO VR-USERNAME
           MOVE WS-RECORD-ID TO VR-ID
           MOVE WS-TITLE TO VR-TITLE
           MOVE WS-SECRET TO VR-SECRET

           OPEN EXTEND VAULT-FILE
           IF WS-VAULT-FS NOT = "00"
               DISPLAY "ERROR: Cannot open vault database."
               DISPLAY "FILE STATUS: " WS-VAULT-FS
               EXIT PARAGRAPH
           END-IF

           WRITE VAULT-RECORD
           IF WS-VAULT-FS = "00"
               DISPLAY "Private record saved with ID "
                   WS-RECORD-ID
           ELSE
               DISPLAY "ERROR: Record was not saved."
               DISPLAY "FILE STATUS: " WS-VAULT-FS
           END-IF

           CLOSE VAULT-FILE.

      ******************************************************************
      * LIST RECORDS
      ******************************************************************
       LIST-RECORDS.
           DISPLAY SPACE
           DISPLAY "----------- PRIVATE RECORDS -----------"

           MOVE "N" TO WS-EOF
           MOVE "N" TO WS-FOUND

           OPEN INPUT VAULT-FILE
           IF WS-VAULT-FS NOT = "00"
               DISPLAY "ERROR: Cannot open vault database."
               DISPLAY "FILE STATUS: " WS-VAULT-FS
               EXIT PARAGRAPH
           END-IF

           PERFORM UNTIL EOF-YES
               READ VAULT-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF VR-USERNAME = WS-CURRENT-USER
                           MOVE "Y" TO WS-FOUND
                           DISPLAY "ID: " VR-ID
                           DISPLAY "Title: " VR-TITLE
                           DISPLAY "--------------------------------------"
                       END-IF
               END-READ
           END-PERFORM

           CLOSE VAULT-FILE

           IF FOUND-NO
               DISPLAY "No private records found."
           END-IF.

      ******************************************************************
      * VIEW RECORD
      ******************************************************************
       VIEW-RECORD.
           DISPLAY SPACE
           DISPLAY "----------- VIEW PRIVATE RECORD -----------"

           PERFORM GET-RECORD-ID
           IF WS-VALID = "N"
               EXIT PARAGRAPH
           END-IF

           MOVE "N" TO WS-EOF
           MOVE "N" TO WS-FOUND

           OPEN INPUT VAULT-FILE
           IF WS-VAULT-FS NOT = "00"
               DISPLAY "ERROR: Cannot open vault database."
               DISPLAY "FILE STATUS: " WS-VAULT-FS
               EXIT PARAGRAPH
           END-IF

           PERFORM UNTIL EOF-YES
               READ VAULT-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF VR-USERNAME = WS-CURRENT-USER
                           AND VR-ID = WS-RECORD-ID
                           MOVE "Y" TO WS-FOUND
                           DISPLAY SPACE
                           DISPLAY "ID: " VR-ID
                           DISPLAY "Title: " VR-TITLE
                           DISPLAY "Content:"
                           DISPLAY VR-SECRET
                       END-IF
               END-READ
           END-PERFORM

           CLOSE VAULT-FILE

           IF FOUND-NO
               DISPLAY "Record not found."
           END-IF.

      ******************************************************************
      * DELETE RECORD
      *
      * A line-sequential file cannot safely remove an arbitrary record
      * in place. We therefore rebuild it into a temporary file.
      ******************************************************************
       DELETE-RECORD.
           DISPLAY SPACE
           DISPLAY "----------- DELETE PRIVATE RECORD -----------"

           PERFORM GET-RECORD-ID
           IF WS-VALID = "N"
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Delete record " WS-RECORD-ID
               "? Type Y to confirm: " WITH NO ADVANCING
           ACCEPT WS-DELETE-CONFIRM

           IF WS-DELETE-CONFIRM NOT = "Y"
               DISPLAY "Deletion cancelled."
               EXIT PARAGRAPH
           END-IF

           MOVE "N" TO WS-EOF
           MOVE "N" TO WS-FOUND

           OPEN INPUT VAULT-FILE
           IF WS-VAULT-FS NOT = "00"
               DISPLAY "ERROR: Cannot read vault database."
               DISPLAY "FILE STATUS: " WS-VAULT-FS
               EXIT PARAGRAPH
           END-IF

           OPEN OUTPUT VAULT-TEMP-FILE
           IF WS-VAULT-TEMP-FS NOT = "00"
               CLOSE VAULT-FILE
               DISPLAY "ERROR: Cannot create temporary vault."
               DISPLAY "FILE STATUS: " WS-VAULT-TEMP-FS
               EXIT PARAGRAPH
           END-IF

           PERFORM UNTIL EOF-YES
               READ VAULT-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF VR-USERNAME = WS-CURRENT-USER
                           AND VR-ID = WS-RECORD-ID
                           MOVE "Y" TO WS-FOUND
                       ELSE
                           MOVE VR-USERNAME TO VTR-USERNAME
                           MOVE VR-ID TO VTR-ID
                           MOVE VR-TITLE TO VTR-TITLE
                           MOVE VR-SECRET TO VTR-SECRET
                           WRITE VAULT-TEMP-RECORD
                       END-IF
               END-READ
           END-PERFORM

           CLOSE VAULT-FILE
           CLOSE VAULT-TEMP-FILE

           IF FOUND-NO
               DISPLAY "Record not found. Nothing was deleted."
               DELETE FILE "SV-VAULT.TMP"
               EXIT PARAGRAPH
           END-IF

           MOVE "Y" TO WS-REPLACE-OK

           OPEN INPUT VAULT-TEMP-FILE
           IF WS-VAULT-TEMP-FS NOT = "00"
               MOVE "N" TO WS-REPLACE-OK
           ELSE
               CLOSE VAULT-TEMP-FILE
           END-IF

           IF WS-REPLACE-OK = "N"
               DISPLAY "ERROR: Temporary vault verification failed."
               EXIT PARAGRAPH
           END-IF

           DELETE FILE "SV-VAULT.DAT"

           OPEN INPUT VAULT-TEMP-FILE
           OPEN OUTPUT VAULT-FILE

           IF WS-VAULT-FS NOT = "00"
               DISPLAY "ERROR: Cannot rebuild vault database."
               CLOSE VAULT-TEMP-FILE
               EXIT PARAGRAPH
           END-IF

           MOVE "N" TO WS-EOF

           PERFORM UNTIL EOF-YES
               READ VAULT-TEMP-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       MOVE VTR-USERNAME TO VR-USERNAME
                       MOVE VTR-ID TO VR-ID
                       MOVE VTR-TITLE TO VR-TITLE
                       MOVE VTR-SECRET TO VR-SECRET
                       WRITE VAULT-RECORD
               END-READ
           END-PERFORM

           CLOSE VAULT-TEMP-FILE
           CLOSE VAULT-FILE

           DELETE FILE "SV-VAULT.TMP"

           DISPLAY "Record deleted successfully.".

      ******************************************************************
      * CHANGE PASSWORD
      ******************************************************************
       CHANGE-PASSWORD.
           DISPLAY SPACE
           DISPLAY "----------- CHANGE PASSWORD -----------"

           DISPLAY "Current password: " WITH NO ADVANCING
           ACCEPT WS-OLD-PASSWORD

           MOVE WS-OLD-PASSWORD TO WS-PASSWORD
           PERFORM HASH-PASSWORD

           IF WS-HASH NOT = UR-PASSWORD-HASH
               DISPLAY "Current password is incorrect."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "New password: " WITH NO ADVANCING
           ACCEPT WS-NEW-PASSWORD

           DISPLAY "Confirm new password: " WITH NO ADVANCING
           ACCEPT WS-NEW-PASSWORD-2

           IF WS-NEW-PASSWORD NOT = WS-NEW-PASSWORD-2
               DISPLAY "Passwords do not match."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-NEW-PASSWORD TO WS-PASSWORD
           PERFORM VALIDATE-PASSWORD

           IF WS-VALID = "N"
               DISPLAY "New password rejected."
               DISPLAY
                 "Use at least 8 characters with letters and digits."
               EXIT PARAGRAPH
           END-IF

           PERFORM HASH-PASSWORD
           MOVE WS-HASH TO UR-PASSWORD-HASH
           MOVE ZERO TO UR-FAIL-COUNT
           MOVE "N" TO UR-LOCKED

           PERFORM UPDATE-USER-RECORD.

      ******************************************************************
      * FIND USER
      ******************************************************************
       FIND-USER.
           MOVE "N" TO WS-FOUND

           OPEN INPUT USER-FILE
           IF WS-USER-FS NOT = "00"
               EXIT PARAGRAPH
           END-IF

           MOVE "N" TO WS-EOF

           PERFORM UNTIL EOF-YES
               READ USER-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF UR-USERNAME = WS-USERNAME
                           MOVE "Y" TO WS-FOUND
                           MOVE "Y" TO WS-EOF
                       END-IF
               END-READ
           END-PERFORM

           CLOSE USER-FILE.

      ******************************************************************
      * UPDATE USER RECORD
      ******************************************************************
       UPDATE-USER-RECORD.
           MOVE "N" TO WS-EOF
           MOVE "Y" TO WS-REPLACE-OK

           OPEN INPUT USER-FILE
           IF WS-USER-FS NOT = "00"
               DISPLAY "ERROR: Cannot read user database."
               DISPLAY "FILE STATUS: " WS-USER-FS
               EXIT PARAGRAPH
           END-IF

           OPEN OUTPUT USER-TEMP-FILE
           IF WS-USER-TEMP-FS NOT = "00"
               CLOSE USER-FILE
               DISPLAY "ERROR: Cannot create temporary user file."
               DISPLAY "FILE STATUS: " WS-USER-TEMP-FS
               EXIT PARAGRAPH
           END-IF

           PERFORM UNTIL EOF-YES
               READ USER-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF UR-USERNAME = WS-USERNAME
                           MOVE UR-USERNAME TO UTR-USERNAME
                           MOVE UR-PASSWORD-HASH TO UTR-PASSWORD-HASH
                           MOVE UR-LOCKED TO UTR-LOCKED
                           MOVE UR-FAIL-COUNT TO UTR-FAIL-COUNT
                           WRITE USER-TEMP-RECORD
                       ELSE
                           MOVE UR-USERNAME TO UTR-USERNAME
                           MOVE UR-PASSWORD-HASH TO UTR-PASSWORD-HASH
                           MOVE UR-LOCKED TO UTR-LOCKED
                           MOVE UR-FAIL-COUNT TO UTR-FAIL-COUNT
                           WRITE USER-TEMP-RECORD
                       END-IF
               END-READ
           END-PERFORM

           CLOSE USER-FILE
           CLOSE USER-TEMP-FILE

           OPEN INPUT USER-TEMP-FILE
           IF WS-USER-TEMP-FS NOT = "00"
               DISPLAY "ERROR: Temporary user file verification failed."
               EXIT PARAGRAPH
           END-IF
           CLOSE USER-TEMP-FILE

           DELETE FILE "SV-USERS.DAT"

           OPEN INPUT USER-TEMP-FILE
           OPEN OUTPUT USER-FILE

           IF WS-USER-FS NOT = "00"
               DISPLAY "ERROR: Cannot rebuild user database."
               CLOSE USER-TEMP-FILE
               EXIT PARAGRAPH
           END-IF

           MOVE "N" TO WS-EOF

           PERFORM UNTIL EOF-YES
               READ USER-TEMP-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       MOVE UTR-USERNAME TO UR-USERNAME
                       MOVE UTR-PASSWORD-HASH TO UR-PASSWORD-HASH
                       MOVE UTR-LOCKED TO UR-LOCKED
                       MOVE UTR-FAIL-COUNT TO UR-FAIL-COUNT
                       WRITE USER-RECORD
               END-READ
           END-PERFORM

           CLOSE USER-TEMP-FILE
           CLOSE USER-FILE

           DELETE FILE "SV-USERS.TMP"

           IF WS-USER-FS = "00"
               CONTINUE
           ELSE
               DISPLAY "ERROR: User update may have failed."
               DISPLAY "FILE STATUS: " WS-USER-FS
           END-IF.

      ******************************************************************
      * GET NEXT RECORD ID
      ******************************************************************
       GET-NEXT-ID.
           MOVE 1 TO WS-NEXT-ID
           MOVE "N" TO WS-EOF

           OPEN INPUT VAULT-FILE
           IF WS-VAULT-FS NOT = "00"
               EXIT PARAGRAPH
           END-IF

           PERFORM UNTIL EOF-YES
               READ VAULT-FILE
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       IF VR-ID >= WS-NEXT-ID
                           COMPUTE WS-NEXT-ID = VR-ID + 1
                       END-IF
               END-READ
           END-PERFORM

           CLOSE VAULT-FILE.

      ******************************************************************
      * GET RECORD ID
      ******************************************************************
       GET-RECORD-ID.
           MOVE "N" TO WS-VALID

           DISPLAY "Record ID: " WITH NO ADVANCING
           ACCEPT WS-NUMERIC-INPUT

           MOVE "Y" TO WS-NUMERIC-VALID

           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > 5
               IF WS-NUMERIC-INPUT(WS-I:1) < "0"
                   MOVE "N" TO WS-NUMERIC-VALID
               END-IF
               IF WS-NUMERIC-INPUT(WS-I:1) > "9"
                   MOVE "N" TO WS-NUMERIC-VALID
               END-IF
           END-PERFORM

           IF WS-NUMERIC-VALID = "N"
               DISPLAY "Invalid record ID."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-NUMERIC-INPUT TO WS-RECORD-ID
           MOVE "Y" TO WS-VALID.

      ******************************************************************
      * VALIDATE USERNAME
      ******************************************************************
       VALIDATE-USERNAME.
           MOVE "N" TO WS-VALID
           MOVE 0 TO WS-LENGTH

           INSPECT WS-USERNAME
               TALLYING WS-LENGTH FOR CHARACTERS BEFORE INITIAL SPACE

           IF WS-LENGTH = 0
               EXIT PARAGRAPH
           END-IF

           IF WS-LENGTH > 30
               EXIT PARAGRAPH
           END-IF

           MOVE "Y" TO WS-VALID.

      ******************************************************************
      * VALIDATE TITLE
      ******************************************************************
       VALIDATE-TITLE.
           MOVE "N" TO WS-VALID
           MOVE 0 TO WS-LENGTH

           INSPECT WS-TITLE
               TALLYING WS-LENGTH FOR CHARACTERS BEFORE INITIAL SPACE

           IF WS-LENGTH = 0
               EXIT PARAGRAPH
           END-IF

           MOVE "Y" TO WS-VALID.

      ******************************************************************
      * VALIDATE PASSWORD
      ******************************************************************
       VALIDATE-PASSWORD.
           MOVE "N" TO WS-VALID
           MOVE 0 TO WS-LENGTH

           INSPECT WS-PASSWORD
               TALLYING WS-LENGTH FOR CHARACTERS BEFORE INITIAL SPACE

           IF WS-LENGTH < 8
               EXIT PARAGRAPH
           END-IF

           IF WS-LENGTH > 100
               EXIT PARAGRAPH
           END-IF

           MOVE "N" TO WS-FOUND

           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-LENGTH
               IF WS-PASSWORD(WS-I:1) >= "0"
                   AND WS-PASSWORD(WS-I:1) <= "9"
                   MOVE "Y" TO WS-FOUND
               END-IF
           END-PERFORM

           IF WS-FOUND = "N"
               EXIT PARAGRAPH
           END-IF

           MOVE "Y" TO WS-VALID.

      ******************************************************************
      * PASSWORD DIGEST
      ******************************************************************
       HASH-PASSWORD.
           MOVE 2166136261 TO WS-HASH
           MOVE 0 TO WS-LENGTH

           INSPECT WS-PASSWORD
               TALLYING WS-LENGTH FOR CHARACTERS BEFORE INITIAL SPACE

           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-LENGTH
               MOVE FUNCTION ORD(WS-PASSWORD(WS-I:1))
                   TO WS-CHAR-CODE
               COMPUTE WS-HASH =
                   FUNCTION MOD(
                       ((WS-HASH * 16777619) + WS-CHAR-CODE),
                       9999999999)
           END-PERFORM.

      ******************************************************************
      * CLEAN SHUTDOWN
      ******************************************************************
       CLEAN-SHUTDOWN.
           MOVE SPACES TO WS-PASSWORD
           MOVE SPACES TO WS-PASSWORD-2
           MOVE SPACES TO WS-OLD-PASSWORD
           MOVE SPACES TO WS-NEW-PASSWORD
           MOVE SPACES TO WS-NEW-PASSWORD-2
           MOVE ZERO TO WS-HASH
           DISPLAY SPACE
           DISPLAY "SecureVault closed safely."
           DISPLAY "Goodbye, Daniel."
           DISPLAY SPACE.

       END PROGRAM SECUREVAULT.
