>>SOURCE FORMAT FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. RegisterLoginSimple.
AUTHOR. Simonetta, Daniel.

DATA DIVISION.
WORKING-STORAGE SECTION.

77 OPTION             PIC 9 VALUE 0.
77 EXIT-FLAG          PIC X VALUE "N".

77 USER-REGISTERED    PIC X(20) VALUE SPACES.
77 PASS-REGISTERED    PIC X(20) VALUE SPACES.

77 USER-INPUT         PIC X(20).
77 PASS-INPUT         PIC X(20).

77 USER-EXISTS        PIC X VALUE "N".
77 AUTHENTICATED      PIC X VALUE "N".

PROCEDURE DIVISION.
MAIN.
    PERFORM MAIN-MENU.
    STOP RUN.

MAIN-MENU.
    PERFORM UNTIL EXIT-FLAG = "S"
        DISPLAY "============================"
        DISPLAY " 1 - Register user"
        DISPLAY " 2 - Login"
        DISPLAY " 0 - Exit"
        DISPLAY "============================"
        DISPLAY "Select option: "
        ACCEPT OPTION

        EVALUATE OPTION
            WHEN 1
                PERFORM REGISTER-USER
            WHEN 2
                PERFORM LOGIN-USER
            WHEN 0
                MOVE "S" TO EXIT-FLAG
            WHEN OTHER
                DISPLAY "Invalid option"
        END-EVALUATE
    END-PERFORM.

REGISTER-USER.
    DISPLAY "===== REGISTER ====="
    DISPLAY "New user: "
    ACCEPT USER-REGISTERED

    DISPLAY "New password: "
    ACCEPT PASS-REGISTERED

    MOVE "S" TO USER-EXISTS

    DISPLAY "User registered successfully.".

LOGIN-USER.
    IF USER-EXISTS NOT = "S"
        DISPLAY "No registered users found."
        EXIT PARAGRAPH
    END-IF

    DISPLAY "===== LOGIN ====="
    DISPLAY "User: "
    ACCEPT USER-INPUT

    DISPLAY "Password: "
    ACCEPT PASS-INPUT

    IF USER-INPUT = USER-REGISTERED
       AND PASS-INPUT = PASS-REGISTERED
        MOVE "S" TO AUTHENTICATED
    ELSE
        MOVE "N" TO AUTHENTICATED
    END-IF

    IF AUTHENTICATED = "S"
        DISPLAY "Login successful. Welcome!"
    ELSE
        DISPLAY "Invalid user or password."
    END-IF.
