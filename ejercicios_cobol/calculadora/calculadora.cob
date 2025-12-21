       IDENTIFICATION DIVISION.
       PROGRAM-ID. CALCULATOR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-MENU.
          05 WS-OPTION        PIC 9.
       01 WS-TEMP            PIC X(20).
       01 WS-ENTER           PIC X(1) VALUE SPACE.
       01 NUMS.
          05 NUM1             PIC 9(7)V99.
          05 NUM2             PIC 9(7)V99.
          05 RESULT           PIC 9(15)V99.

       PROCEDURE DIVISION.
       MAIN-PARA.
           PERFORM UNTIL WS-OPTION = 5
               PERFORM MENU
               IF WS-OPTION = 5
                   CONTINUE
               ELSE
                   PERFORM READ-NUMBERS
                   PERFORM DO-OP
               END-IF
               PERFORM PAUSE
           END-PERFORM
           DISPLAY "Thank you for using the calculator. Goodbye!".
           STOP RUN.

       MENU.
           DISPLAY "===================================="
           DISPLAY "           COBOL CALCULATOR         "
           DISPLAY "===================================="
           DISPLAY "1. Add"
           DISPLAY "2. Subtract"
           DISPLAY "3. Multiply"
           DISPLAY "4. Divide"
           DISPLAY "5. Exit"
           DISPLAY "Enter option (1-5): " WITH NO ADVANCING
           ACCEPT WS-TEMP
           INSPECT WS-TEMP TALLYING WS-TEMP FOR ALL SPACES
           *
           *> Basic guard: if input not single digit 1-5, set to 0
           IF WS-TEMP(1:1) >= "1" AND WS-TEMP(1:1) <= "5"
               MOVE FUNCTION NUMVAL-C(WS-TEMP(1:1)) TO WS-OPTION
           ELSE
               MOVE 0 TO WS-OPTION
               DISPLAY "Invalid option. Please enter 1 to 5."
           END-IF.

       READ-NUMBERS.
           *> Read first number
           DISPLAY "Enter first number: " WITH NO ADVANCING
           ACCEPT WS-TEMP
           IF WS-TEMP = SPACE
               MOVE 0 TO NUM1
           ELSE
               MOVE FUNCTION NUMVAL(WS-TEMP) TO NUM1
           END-IF
           *> Read second number
           DISPLAY "Enter second number: " WITH NO ADVANCING
           ACCEPT WS-TEMP
           IF WS-TEMP = SPACE
               MOVE 0 TO NUM2
           ELSE
               MOVE FUNCTION NUMVAL(WS-TEMP) TO NUM2
           END-IF.

       DO-OP.
           EVALUATE WS-OPTION
               WHEN 1
                   ADD NUM1 TO NUM2 GIVING RESULT
                   DISPLAY "Result: " RESULT
               WHEN 2
                   SUBTRACT NUM2 FROM NUM1 GIVING RESULT
                   DISPLAY "Result: " RESULT
               WHEN 3
                   MULTIPLY NUM1 BY NUM2 GIVING RESULT
                   DISPLAY "Result: " RESULT
               WHEN 4
                   IF NUM2 = 0
                       DISPLAY "Error: Division by zero."
                   ELSE
                       DIVIDE NUM1 BY NUM2 GIVING RESULT
                       DISPLAY "Result: " RESULT
                   END-IF
               WHEN OTHER
                   DISPLAY "Invalid option selected."
           END-EVALUATE.

       PAUSE.
           DISPLAY "Press Enter to continue..." WITH NO ADVANCING
           ACCEPT WS-ENTER
           MOVE SPACE TO WS-ENTER.

