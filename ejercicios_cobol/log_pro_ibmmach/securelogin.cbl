       IDENTIFICATION DIVISION.
       PROGRAM-ID. SECURELOGIN.
       AUTHOR. DANIEL SIMONETTA.
       DATE-WRITTEN. 20261001.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  WS-USER-NAME       PIC X(32).
       01  WS-PASSWORD        PIC X(64).
       01  WS-STORED-USER     PIC X(32)
           VALUE "OPERADOR".
       01  WS-STORED-PASSWORD PIC X(64)
           VALUE "C0BOL-Local#2026-9xQ!".
       01  WS-ATTEMPTS        PIC 9 VALUE 0.
       01  WS-AUTHENTICATED   PIC X VALUE "N".
       01  WS-EXIT-CODE       PIC 9 VALUE 0.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           DISPLAY "================================"
               UPON CONSOLE
           DISPLAY "       SECURE LOGIN SYSTEM"
               UPON CONSOLE
           DISPLAY "================================"
               UPON CONSOLE
           DISPLAY "AUTHOR: DANIEL SIMONETTA"
               UPON CONSOLE
           DISPLAY "DATE: 20261001"
               UPON CONSOLE
           DISPLAY " " UPON CONSOLE

           PERFORM UNTIL WS-ATTEMPTS >= 3
               OR WS-AUTHENTICATED = "Y"

               MOVE SPACES TO WS-USER-NAME
               MOVE SPACES TO WS-PASSWORD

               DISPLAY "USERNAME: " UPON CONSOLE
               ACCEPT WS-USER-NAME FROM CONSOLE

               DISPLAY "PASSWORD: " UPON CONSOLE
               ACCEPT WS-PASSWORD FROM CONSOLE

               IF WS-USER-NAME = SPACES
                   OR WS-PASSWORD = SPACES

                   ADD 1 TO WS-ATTEMPTS

                   DISPLAY "INVALID CREDENTIALS."
                       UPON CONSOLE

               ELSE
                   IF WS-USER-NAME = WS-STORED-USER
                       AND WS-PASSWORD =
                           WS-STORED-PASSWORD

                       MOVE "Y" TO WS-AUTHENTICATED

                   ELSE
                       ADD 1 TO WS-ATTEMPTS

                       DISPLAY "INVALID CREDENTIALS."
                           UPON CONSOLE
                   END-IF
               END-IF

               IF WS-AUTHENTICATED NOT = "Y"
                   DISPLAY "ATTEMPTS REMAINING: "
                       WS-ATTEMPTS
                       UPON CONSOLE
               END-IF

               DISPLAY " " UPON CONSOLE

           END-PERFORM

           IF WS-AUTHENTICATED = "Y"

               DISPLAY "AUTHENTICATION SUCCESSFUL."
                   UPON CONSOLE
               DISPLAY "ACCESS GRANTED."
                   UPON CONSOLE

           ELSE

               MOVE 1 TO WS-EXIT-CODE

               DISPLAY "ACCESS DENIED."
                   UPON CONSOLE
               DISPLAY "MAXIMUM ATTEMPTS EXCEEDED."
                   UPON CONSOLE

           END-IF

           MOVE SPACES TO WS-PASSWORD
           MOVE SPACES TO WS-USER-NAME

           MOVE WS-EXIT-CODE TO RETURN-CODE

           STOP RUN.