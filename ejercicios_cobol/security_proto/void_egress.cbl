       IDENTIFICATION DIVISION.
       PROGRAM-ID. SECUREBANK.
       AUTHOR. "Daniel Simonetta".
       DATE-WRITTEN. 20260915.
       DATE-COMPILED. 20260915.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. GNUCOBOL.
       OBJECT-COMPUTER. GNUCOBOL.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT CLIENT-FILE
               ASSIGN TO "clients.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS CLIENT-ID
               FILE STATUS IS CLIENT-STATUS.

           SELECT ACCOUNT-FILE
               ASSIGN TO "accounts.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS ACCOUNT-ID
               FILE STATUS IS ACCOUNT-STATUS.

           SELECT TRANSACTION-FILE
               ASSIGN TO "transactions.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS TRANSACTION-ID
               FILE STATUS IS TRANSACTION-STATUS.

           SELECT AUDIT-FILE
               ASSIGN TO "audit.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS AUDIT-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  CLIENT-FILE.
       01  CLIENT-RECORD.
           05 CLIENT-ID             PIC 9(10).
           05 CLIENT-NAME           PIC X(60).
           05 CLIENT-DOCUMENT       PIC X(20).
           05 CLIENT-PHONE          PIC X(25).
           05 CLIENT-EMAIL          PIC X(80).
           05 CLIENT-STATUS-FLAG    PIC X.
           05 CLIENT-CREATED        PIC 9(8).

       FD  ACCOUNT-FILE.
       01  ACCOUNT-RECORD.
           05 ACCOUNT-ID            PIC 9(10).
           05 ACCOUNT-CLIENT-ID     PIC 9(10).
           05 ACCOUNT-TYPE         PIC X(12).
           05 ACCOUNT-BALANCE      PIC S9(12)V99.
           05 ACCOUNT-LIMIT        PIC S9(12)V99.
           05 ACCOUNT-STATUS-FLAG  PIC X.
           05 ACCOUNT-CREATED      PIC 9(8).

       FD  TRANSACTION-FILE.
       01  TRANSACTION-RECORD.
           05 TRANSACTION-ID       PIC 9(10).
           05 TRANSACTION-ACCOUNT  PIC 9(10).
           05 TRANSACTION-TYPE     PIC X(12).
           05 TRANSACTION-AMOUNT   PIC 9(12)V99.
           05 TRANSACTION-BALANCE  PIC S9(12)V99.
           05 TRANSACTION-DATE     PIC 9(8).
           05 TRANSACTION-TIME     PIC 9(6).
           05 TRANSACTION-DETAIL   PIC X(100).

       FD  AUDIT-FILE.
       01  AUDIT-RECORD            PIC X(300).

       WORKING-STORAGE SECTION.

       01  CLIENT-STATUS           PIC XX.
       01  ACCOUNT-STATUS          PIC XX.
       01  TRANSACTION-STATUS      PIC XX.
       01  AUDIT-STATUS            PIC XX.

       01  WS-OPTION               PIC 99 VALUE 0.
       01  WS-SUBOPTION            PIC 99 VALUE 0.
       01  WS-CONTINUE             PIC X VALUE "Y".
       01  WS-FOUND                PIC X VALUE "N".
       01  WS-VALID                PIC X VALUE "N".
       01  WS-EOF                  PIC X VALUE "N".
       01  WS-ERROR                PIC X VALUE "N".

       01  WS-TODAY                PIC 9(8).
       01  WS-TIME                 PIC 9(8).
       01  WS-DATE-TEXT            PIC X(10).
       01  WS-TIME-TEXT            PIC X(8).

       01  WS-NEXT-CLIENT          PIC 9(10) VALUE 1.
       01  WS-NEXT-ACCOUNT         PIC 9(10) VALUE 1.
       01  WS-NEXT-TRANSACTION     PIC 9(10) VALUE 1.

       01  WS-CLIENT-ID            PIC 9(10).
       01  WS-ACCOUNT-ID           PIC 9(10).
       01  WS-TRANSFER-ACCOUNT     PIC 9(10).
       01  WS-TRANSACTION-ID       PIC 9(10).

       01  WS-AMOUNT               PIC 9(12)V99.
       01  WS-BALANCE              PIC S9(12)V99.
       01  WS-NEW-BALANCE          PIC S9(12)V99.
       01  WS-AVAILABLE            PIC S9(12)V99.

       01  WS-NAME                 PIC X(60).
       01  WS-DOCUMENT             PIC X(20).
       01  WS-PHONE                PIC X(25).
       01  WS-EMAIL                PIC X(80).
       01  WS-TYPE                 PIC X(12).
       01  WS-DETAIL               PIC X(100).
       01  WS-SEARCH               PIC X(80).
       01  WS-INPUT                PIC X(120).

       01  WS-AUDIT-USER           PIC X(30) VALUE "SYSTEM".
       01  WS-AUDIT-ACTION         PIC X(40).
       01  WS-AUDIT-DATA           PIC X(180).

       01  WS-DISPLAY-BALANCE      PIC Z,ZZZ,ZZZ,ZZZ,ZZ9.99.
       01  WS-DISPLAY-AMOUNT       PIC Z,ZZZ,ZZZ,ZZZ,ZZ9.99.

       01  WS-YES-NO               PIC X.

       01  WS-COUNT-CLIENTS        PIC 9(10) VALUE 0.
       01  WS-COUNT-ACCOUNTS       PIC 9(10) VALUE 0.
       01  WS-COUNT-TRANSACTIONS   PIC 9(10) VALUE 0.

       01  WS-TOTAL-BALANCES       PIC S9(15)V99 VALUE 0.
       01  WS-TOTAL-DEPOSITS       PIC S9(15)V99 VALUE 0.
       01  WS-TOTAL-WITHDRAWALS    PIC S9(15)V99 VALUE 0.

       01  WS-REPORT-BALANCE       PIC S9(15)V99 VALUE 0.
       01  WS-REPORT-DEPOSITS      PIC S9(15)V99 VALUE 0.
       01  WS-REPORT-WITHDRAWALS   PIC S9(15)V99 VALUE 0.

       01  WS-CURRENT-DATE-GROUP.
           05 WS-CURRENT-YEAR      PIC 9(4).
           05 WS-CURRENT-MONTH     PIC 9(2).
           05 WS-CURRENT-DAY       PIC 9(2).
           05 WS-CURRENT-HOUR      PIC 9(2).
           05 WS-CURRENT-MINUTE    PIC 9(2).
           05 WS-CURRENT-SECOND    PIC 9(2).
           05 WS-CURRENT-MSEC      PIC 9(2).

       01  WS-LOWER                PIC X(120).
       01  WS-CHAR                 PIC X.
       01  WS-INDEX                PIC 999 VALUE 0.
       01  WS-LENGTH               PIC 999 VALUE 0.
       01  WS-ALPHA-COUNT          PIC 999 VALUE 0.
       01  WS-DIGIT-COUNT          PIC 999 VALUE 0.

       PROCEDURE DIVISION.

       MAIN-PROGRAM.

           PERFORM INITIALIZE-SYSTEM
           PERFORM MAIN-MENU
           PERFORM CLOSE-FILES
           STOP RUN.

       INITIALIZE-SYSTEM.

           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-GROUP
           MOVE WS-CURRENT-YEAR TO WS-TODAY
           COMPUTE WS-TODAY =
               WS-CURRENT-YEAR * 10000 +
               WS-CURRENT-MONTH * 100 +
               WS-CURRENT-DAY
           MOVE WS-CURRENT-HOUR TO WS-TIME
           COMPUTE WS-TIME =
               WS-CURRENT-HOUR * 10000 +
               WS-CURRENT-MINUTE * 100 +
               WS-CURRENT-SECOND

           PERFORM OPEN-CLIENT-FILE
           PERFORM OPEN-ACCOUNT-FILE
           PERFORM OPEN-TRANSACTION-FILE
           PERFORM OPEN-AUDIT-FILE
           PERFORM LOAD-SEQUENCES.

       OPEN-CLIENT-FILE.

           OPEN I-O CLIENT-FILE
           IF CLIENT-STATUS = "35"
               OPEN OUTPUT CLIENT-FILE
               CLOSE CLIENT-FILE
               OPEN I-O CLIENT-FILE
           END-IF.

       OPEN-ACCOUNT-FILE.

           OPEN I-O ACCOUNT-FILE
           IF ACCOUNT-STATUS = "35"
               OPEN OUTPUT ACCOUNT-FILE
               CLOSE ACCOUNT-FILE
               OPEN I-O ACCOUNT-FILE
           END-IF.

       OPEN-TRANSACTION-FILE.

           OPEN I-O TRANSACTION-FILE
           IF TRANSACTION-STATUS = "35"
               OPEN OUTPUT TRANSACTION-FILE
               CLOSE TRANSACTION-FILE
               OPEN I-O TRANSACTION-FILE
           END-IF.

       OPEN-AUDIT-FILE.

           OPEN EXTEND AUDIT-FILE
           IF AUDIT-STATUS NOT = "00"
               OPEN OUTPUT AUDIT-FILE
           END-IF.

       CLOSE-FILES.

           CLOSE CLIENT-FILE
           CLOSE ACCOUNT-FILE
           CLOSE TRANSACTION-FILE
           CLOSE AUDIT-FILE.

       LOAD-SEQUENCES.

           MOVE 1 TO WS-NEXT-CLIENT
           START CLIENT-FILE KEY IS NOT LESS THAN 9999999999
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   READ CLIENT-FILE PREVIOUS RECORD
                   IF CLIENT-STATUS = "00"
                       COMPUTE WS-NEXT-CLIENT = CLIENT-ID + 1
                   END-IF
           END-START

           MOVE 1 TO WS-NEXT-ACCOUNT
           START ACCOUNT-FILE KEY IS NOT LESS THAN 9999999999
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   READ ACCOUNT-FILE PREVIOUS RECORD
                   IF ACCOUNT-STATUS = "00"
                       COMPUTE WS-NEXT-ACCOUNT = ACCOUNT-ID + 1
                   END-IF
           END-START

           MOVE 1 TO WS-NEXT-TRANSACTION
           START TRANSACTION-FILE KEY IS NOT LESS THAN 9999999999
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   READ TRANSACTION-FILE PREVIOUS RECORD
                   IF TRANSACTION-STATUS = "00"
                       COMPUTE WS-NEXT-TRANSACTION =
                           TRANSACTION-ID + 1
                   END-IF
           END-START.

       MAIN-MENU.

           MOVE "Y" TO WS-CONTINUE

           PERFORM UNTIL WS-CONTINUE = "N"

               DISPLAY SPACE
               DISPLAY "=========================================="
               DISPLAY "           SECUREBANK CORE               "
               DISPLAY "=========================================="
               DISPLAY "1. Client management"
               DISPLAY "2. Account management"
               DISPLAY "3. Deposit"
               DISPLAY "4. Withdrawal"
               DISPLAY "5. Transfer"
               DISPLAY "6. Account statement"
               DISPLAY "7. System report"
               DISPLAY "8. Exit"
               DISPLAY "=========================================="
               DISPLAY "Select option: " WITH NO ADVANCING
               ACCEPT WS-INPUT

               MOVE 0 TO WS-OPTION
               IF WS-INPUT IS NUMERIC
                   MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-OPTION
               END-IF

               EVALUATE WS-OPTION
                   WHEN 1
                       PERFORM CLIENT-MENU
                   WHEN 2
                       PERFORM ACCOUNT-MENU
                   WHEN 3
                       PERFORM DEPOSIT
                   WHEN 4
                       PERFORM WITHDRAWAL
                   WHEN 5
                       PERFORM TRANSFER
                   WHEN 6
                       PERFORM ACCOUNT-STATEMENT
                   WHEN 7
                       PERFORM SYSTEM-REPORT
                   WHEN 8
                       MOVE "N" TO WS-CONTINUE
                   WHEN OTHER
                       DISPLAY "Invalid option."
               END-EVALUATE

           END-PERFORM.

       CLIENT-MENU.

           MOVE "Y" TO WS-CONTINUE

           PERFORM UNTIL WS-CONTINUE = "N"

               DISPLAY SPACE
               DISPLAY "----------- CLIENT MANAGEMENT -----------"
               DISPLAY "1. Create client"
               DISPLAY "2. Search client"
               DISPLAY "3. List clients"
               DISPLAY "4. Return"
               DISPLAY "Select option: " WITH NO ADVANCING
               ACCEPT WS-INPUT

               MOVE 0 TO WS-SUBOPTION
               IF WS-INPUT IS NUMERIC
                   MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-SUBOPTION
               END-IF

               EVALUATE WS-SUBOPTION
                   WHEN 1
                       PERFORM CREATE-CLIENT
                   WHEN 2
                       PERFORM SEARCH-CLIENT
                   WHEN 3
                       PERFORM LIST-CLIENTS
                   WHEN 4
                       MOVE "N" TO WS-CONTINUE
                   WHEN OTHER
                       DISPLAY "Invalid option."
               END-EVALUATE

           END-PERFORM.

       CREATE-CLIENT.

           DISPLAY SPACE
           DISPLAY "----------- CREATE CLIENT ---------------"

           DISPLAY "Full name: " WITH NO ADVANCING
           ACCEPT WS-NAME

           PERFORM VALIDATE-NAME
           IF WS-VALID = "N"
               DISPLAY "Invalid name."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Document: " WITH NO ADVANCING
           ACCEPT WS-DOCUMENT

           PERFORM VALIDATE-DOCUMENT
           IF WS-VALID = "N"
               DISPLAY "Invalid document."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Phone: " WITH NO ADVANCING
           ACCEPT WS-PHONE

           DISPLAY "Email: " WITH NO ADVANCING
           ACCEPT WS-EMAIL

           PERFORM VALIDATE-EMAIL
           IF WS-VALID = "N"
               DISPLAY "Invalid email."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-NEXT-CLIENT TO CLIENT-ID
           MOVE WS-NAME TO CLIENT-NAME
           MOVE WS-DOCUMENT TO CLIENT-DOCUMENT
           MOVE WS-PHONE TO CLIENT-PHONE
           MOVE WS-EMAIL TO CLIENT-EMAIL
           MOVE "A" TO CLIENT-STATUS-FLAG
           MOVE WS-TODAY TO CLIENT-CREATED

           WRITE CLIENT-RECORD
               INVALID KEY
                   DISPLAY "Unable to create client."
                   EXIT PARAGRAPH
           END-WRITE

           PERFORM WRITE-AUDIT

           DISPLAY "Client created successfully."
           DISPLAY "Client ID: " CLIENT-ID

           ADD 1 TO WS-NEXT-CLIENT.

       SEARCH-CLIENT.

           DISPLAY SPACE
           DISPLAY "Client ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid client ID."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-CLIENT-ID
           MOVE WS-CLIENT-ID TO CLIENT-ID

           READ CLIENT-FILE
               INVALID KEY
                   DISPLAY "Client not found."
                   EXIT PARAGRAPH
           END-READ

           DISPLAY "ID:       " CLIENT-ID
           DISPLAY "Name:     " CLIENT-NAME
           DISPLAY "Document: " CLIENT-DOCUMENT
           DISPLAY "Phone:    " CLIENT-PHONE
           DISPLAY "Email:    " CLIENT-EMAIL
           DISPLAY "Status:   " CLIENT-STATUS-FLAG
           DISPLAY "Created:  " CLIENT-CREATED.

       LIST-CLIENTS.

           DISPLAY SPACE
           DISPLAY "------------- CLIENT LIST ---------------"

           MOVE LOW-VALUES TO CLIENT-ID

           START CLIENT-FILE KEY IS NOT LESS THAN CLIENT-ID
               INVALID KEY
                   DISPLAY "No clients registered."
                   EXIT PARAGRAPH
           END-START

           MOVE "N" TO WS-EOF

           PERFORM UNTIL WS-EOF = "Y"

               READ CLIENT-FILE NEXT RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       DISPLAY CLIENT-ID " | "
                           CLIENT-NAME " | "
                           CLIENT-DOCUMENT
               END-READ

           END-PERFORM.

       ACCOUNT-MENU.

           MOVE "Y" TO WS-CONTINUE

           PERFORM UNTIL WS-CONTINUE = "N"

               DISPLAY SPACE
               DISPLAY "----------- ACCOUNT MANAGEMENT ----------"
               DISPLAY "1. Create account"
               DISPLAY "2. Search account"
               DISPLAY "3. List accounts"
               DISPLAY "4. Return"
               DISPLAY "Select option: " WITH NO ADVANCING
               ACCEPT WS-INPUT

               MOVE 0 TO WS-SUBOPTION
               IF WS-INPUT IS NUMERIC
                   MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-SUBOPTION
               END-IF

               EVALUATE WS-SUBOPTION
                   WHEN 1
                       PERFORM CREATE-ACCOUNT
                   WHEN 2
                       PERFORM SEARCH-ACCOUNT
                   WHEN 3
                       PERFORM LIST-ACCOUNTS
                   WHEN 4
                       MOVE "N" TO WS-CONTINUE
                   WHEN OTHER
                       DISPLAY "Invalid option."
               END-EVALUATE

           END-PERFORM.

       CREATE-ACCOUNT.

           DISPLAY SPACE
           DISPLAY "----------- CREATE ACCOUNT --------------"

           DISPLAY "Client ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid client ID."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-CLIENT-ID
           MOVE WS-CLIENT-ID TO CLIENT-ID

           READ CLIENT-FILE
               INVALID KEY
                   DISPLAY "Client does not exist."
                   EXIT PARAGRAPH
           END-READ

           IF CLIENT-STATUS-FLAG NOT = "A"
               DISPLAY "Client is inactive."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Account type:"
           DISPLAY "1. CHECKING"
           DISPLAY "2. SAVINGS"
           DISPLAY "Select: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           EVALUATE WS-INPUT
               WHEN "1"
                   MOVE "CHECKING" TO WS-TYPE
               WHEN "2"
                   MOVE "SAVINGS" TO WS-TYPE
               WHEN OTHER
                   DISPLAY "Invalid account type."
                   EXIT PARAGRAPH
           END-EVALUATE

           DISPLAY "Initial deposit: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid amount."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-AMOUNT

           IF WS-AMOUNT < 0
               DISPLAY "Amount cannot be negative."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-NEXT-ACCOUNT TO ACCOUNT-ID
           MOVE WS-CLIENT-ID TO ACCOUNT-CLIENT-ID
           MOVE WS-TYPE TO ACCOUNT-TYPE
           MOVE WS-AMOUNT TO ACCOUNT-BALANCE
           MOVE 0 TO ACCOUNT-LIMIT
           MOVE "A" TO ACCOUNT-STATUS-FLAG
           MOVE WS-TODAY TO ACCOUNT-CREATED

           WRITE ACCOUNT-RECORD
               INVALID KEY
                   DISPLAY "Unable to create account."
                   EXIT PARAGRAPH
           END-WRITE

           PERFORM WRITE-AUDIT

           IF WS-AMOUNT > 0
               MOVE ACCOUNT-ID TO WS-ACCOUNT-ID
               MOVE WS-AMOUNT TO WS-AMOUNT
               MOVE "OPENING" TO WS-TYPE
               MOVE "Initial account balance" TO WS-DETAIL
               PERFORM REGISTER-TRANSACTION
           END-IF

           DISPLAY "Account created successfully."
           DISPLAY "Account ID: " ACCOUNT-ID

           ADD 1 TO WS-NEXT-ACCOUNT.

       SEARCH-ACCOUNT.

           DISPLAY "Account ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid account ID."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-ACCOUNT-ID
           MOVE WS-ACCOUNT-ID TO ACCOUNT-ID

           READ ACCOUNT-FILE
               INVALID KEY
                   DISPLAY "Account not found."
                   EXIT PARAGRAPH
           END-READ

           MOVE ACCOUNT-BALANCE TO WS-DISPLAY-BALANCE

           DISPLAY "ID:       " ACCOUNT-ID
           DISPLAY "Client:   " ACCOUNT-CLIENT-ID
           DISPLAY "Type:     " ACCOUNT-TYPE
           DISPLAY "Balance:  " WS-DISPLAY-BALANCE
           DISPLAY "Status:   " ACCOUNT-STATUS-FLAG
           DISPLAY "Created:  " ACCOUNT-CREATED.

       LIST-ACCOUNTS.

           DISPLAY SPACE
           DISPLAY "------------ ACCOUNT LIST ---------------"

           MOVE LOW-VALUES TO ACCOUNT-ID

           START ACCOUNT-FILE KEY IS NOT LESS THAN ACCOUNT-ID
               INVALID KEY
                   DISPLAY "No accounts registered."
                   EXIT PARAGRAPH
           END-START

           MOVE "N" TO WS-EOF

           PERFORM UNTIL WS-EOF = "Y"

               READ ACCOUNT-FILE NEXT RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END
                       MOVE ACCOUNT-BALANCE TO WS-DISPLAY-BALANCE
                       DISPLAY ACCOUNT-ID " | "
                           ACCOUNT-CLIENT-ID " | "
                           ACCOUNT-TYPE " | "
                           WS-DISPLAY-BALANCE " | "
                           ACCOUNT-STATUS-FLAG
               END-READ

           END-PERFORM.

       DEPOSIT.

           DISPLAY SPACE
           DISPLAY "--------------- DEPOSIT ----------------"

           PERFORM READ-ACCOUNT
           IF WS-FOUND = "N"
               EXIT PARAGRAPH
           END-IF

           IF ACCOUNT-STATUS-FLAG NOT = "A"
               DISPLAY "Account is inactive."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Amount: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid amount."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-AMOUNT

           IF WS-AMOUNT <= 0
               DISPLAY "Amount must be greater than zero."
               EXIT PARAGRAPH
           END-IF

           IF WS-AMOUNT > 999999999999.99
               DISPLAY "Amount exceeds allowed limit."
               EXIT PARAGRAPH
           END-IF

           COMPUTE WS-NEW-BALANCE =
               ACCOUNT-BALANCE + WS-AMOUNT

           IF WS-NEW-BALANCE < ACCOUNT-BALANCE
               DISPLAY "Arithmetic overflow prevented."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-NEW-BALANCE TO ACCOUNT-BALANCE

           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   DISPLAY "Transaction cancelled."
                   EXIT PARAGRAPH
           END-REWRITE

           MOVE "DEPOSIT" TO WS-TYPE
           MOVE "Cash deposit" TO WS-DETAIL
           PERFORM REGISTER-TRANSACTION
           PERFORM WRITE-AUDIT

           MOVE ACCOUNT-BALANCE TO WS-DISPLAY-BALANCE

           DISPLAY "Deposit completed."
           DISPLAY "New balance: " WS-DISPLAY-BALANCE.

       WITHDRAWAL.

           DISPLAY SPACE
           DISPLAY "-------------- WITHDRAWAL --------------"

           PERFORM READ-ACCOUNT
           IF WS-FOUND = "N"
               EXIT PARAGRAPH
           END-IF

           IF ACCOUNT-STATUS-FLAG NOT = "A"
               DISPLAY "Account is inactive."
               EXIT PARAGRAPH
           END-IF

           DISPLAY "Amount: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid amount."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-AMOUNT

           IF WS-AMOUNT <= 0
               DISPLAY "Amount must be greater than zero."
               EXIT PARAGRAPH
           END-IF

           IF WS-AMOUNT > ACCOUNT-BALANCE
               DISPLAY "Insufficient funds."
               EXIT PARAGRAPH
           END-IF

           COMPUTE WS-NEW-BALANCE =
               ACCOUNT-BALANCE - WS-AMOUNT

           IF WS-NEW-BALANCE > ACCOUNT-BALANCE
               DISPLAY "Arithmetic error prevented."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-NEW-BALANCE TO ACCOUNT-BALANCE

           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   DISPLAY "Transaction cancelled."
                   EXIT PARAGRAPH
           END-REWRITE

           MOVE "WITHDRAWAL" TO WS-TYPE
           MOVE "Cash withdrawal" TO WS-DETAIL
           PERFORM REGISTER-TRANSACTION
           PERFORM WRITE-AUDIT

           MOVE ACCOUNT-BALANCE TO WS-DISPLAY-BALANCE

           DISPLAY "Withdrawal completed."
           DISPLAY "New balance: " WS-DISPLAY-BALANCE.

       TRANSFER.

           DISPLAY SPACE
           DISPLAY "--------------- TRANSFER ---------------"

           PERFORM READ-ACCOUNT
           IF WS-FOUND = "N"
               EXIT PARAGRAPH
           END-IF

           IF ACCOUNT-STATUS-FLAG NOT = "A"
               DISPLAY "Source account is inactive."
               EXIT PARAGRAPH
           END-IF

           MOVE ACCOUNT-ID TO WS-ACCOUNT-ID
           MOVE ACCOUNT-BALANCE TO WS-BALANCE

           DISPLAY "Destination account: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid destination account."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT)
               TO WS-TRANSFER-ACCOUNT

           IF WS-TRANSFER-ACCOUNT = WS-ACCOUNT-ID
               DISPLAY "Source and destination must differ."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-TRANSFER-ACCOUNT TO ACCOUNT-ID

           READ ACCOUNT-FILE
               INVALID KEY
                   DISPLAY "Destination account not found."
                   EXIT PARAGRAPH
           END-READ

           IF ACCOUNT-STATUS-FLAG NOT = "A"
               DISPLAY "Destination account is inactive."
               EXIT PARAGRAPH
           END-IF

           MOVE ACCOUNT-ID TO WS-TRANSFER-ACCOUNT

           DISPLAY "Amount: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid amount."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-AMOUNT

           IF WS-AMOUNT <= 0
               DISPLAY "Amount must be greater than zero."
               EXIT PARAGRAPH
           END-IF

           IF WS-AMOUNT > WS-BALANCE
               DISPLAY "Insufficient funds."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-ACCOUNT-ID TO ACCOUNT-ID

           READ ACCOUNT-FILE
               INVALID KEY
                   DISPLAY "Source account unavailable."
                   EXIT PARAGRAPH
           END-READ

           COMPUTE WS-NEW-BALANCE =
               ACCOUNT-BALANCE - WS-AMOUNT

           IF WS-NEW-BALANCE < 0
               DISPLAY "Transfer rejected."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-NEW-BALANCE TO ACCOUNT-BALANCE

           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   DISPLAY "Transfer rejected."
                   EXIT PARAGRAPH
           END-REWRITE

           MOVE WS-ACCOUNT-ID TO TRANSACTION-ACCOUNT
           MOVE "TRANSFER-OUT" TO TRANSACTION-TYPE
           MOVE WS-AMOUNT TO TRANSACTION-AMOUNT
           MOVE WS-NEW-BALANCE TO TRANSACTION-BALANCE
           MOVE WS-TODAY TO TRANSACTION-DATE
           MOVE WS-TIME TO TRANSACTION-TIME
           STRING
               "Transfer to account "
               DELIMITED BY SIZE
               WS-TRANSFER-ACCOUNT
               DELIMITED BY SIZE
               INTO TRANSACTION-DETAIL
           END-STRING

           MOVE WS-NEXT-TRANSACTION TO TRANSACTION-ID

           WRITE TRANSACTION-RECORD
               INVALID KEY
                   DISPLAY "Audit transaction failure."
           END-WRITE

           ADD 1 TO WS-NEXT-TRANSACTION

           MOVE WS-TRANSFER-ACCOUNT TO ACCOUNT-ID

           READ ACCOUNT-FILE
               INVALID KEY
                   DISPLAY "Destination account unavailable."
                   EXIT PARAGRAPH
           END-READ

           COMPUTE WS-NEW-BALANCE =
               ACCOUNT-BALANCE + WS-AMOUNT

           IF WS-NEW-BALANCE < ACCOUNT-BALANCE
               DISPLAY "Transfer rejected."
               EXIT PARAGRAPH
           END-IF

           MOVE WS-NEW-BALANCE TO ACCOUNT-BALANCE

           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   DISPLAY "Transfer rejected."
                   EXIT PARAGRAPH
           END-REWRITE

           MOVE WS-TRANSFER-ACCOUNT TO TRANSACTION-ACCOUNT
           MOVE "TRANSFER-IN" TO TRANSACTION-TYPE
           MOVE WS-AMOUNT TO TRANSACTION-AMOUNT
           MOVE WS-NEW-BALANCE TO TRANSACTION-BALANCE
           MOVE WS-TODAY TO TRANSACTION-DATE
           MOVE WS-TIME TO TRANSACTION-TIME
           STRING
               "Transfer from account "
               DELIMITED BY SIZE
               WS-ACCOUNT-ID
               DELIMITED BY SIZE
               INTO TRANSACTION-DETAIL
           END-STRING

           MOVE WS-NEXT-TRANSACTION TO TRANSACTION-ID

           WRITE TRANSACTION-RECORD
               INVALID KEY
                   DISPLAY "Audit transaction failure."
           END-WRITE

           ADD 1 TO WS-NEXT-TRANSACTION

           MOVE "TRANSFER" TO WS-AUDIT-ACTION
           STRING
               "SOURCE=" WS-ACCOUNT-ID
               " DESTINATION=" WS-TRANSFER-ACCOUNT
               " AMOUNT=" WS-AMOUNT
               DELIMITED BY SIZE
               INTO WS-AUDIT-DATA
           END-STRING

           PERFORM WRITE-AUDIT

           DISPLAY "Transfer completed successfully.".

       READ-ACCOUNT.

           MOVE "N" TO WS-FOUND

           DISPLAY "Account ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT

           IF WS-INPUT IS NOT NUMERIC
               DISPLAY "Invalid account ID."
               EXIT PARAGRAPH
           END-IF

           MOVE FUNCTION NUMVAL(WS-INPUT) TO WS-ACCOUNT-ID
           MOVE WS-ACCOUNT-ID TO ACCOUNT-ID

           READ ACCOUNT-FILE
               INVALID KEY
                   DISPLAY "Account not found."
                   EXIT PARAGRAPH
           END-READ

           MOVE "Y" TO WS-FOUND.

       REGISTER-TRANSACTION.

           MOVE WS-NEXT-TRANSACTION TO TRANSACTION-ID
           MOVE WS-ACCOUNT-ID TO TRANSACTION-ACCOUNT
           MOVE WS-TYPE TO TRANSACTION-TYPE
           MOVE WS-AMOUNT TO TRANSACTION-AMOUNT
           MOVE ACCOUNT-BALANCE TO TRANSACTION-BALANCE
           MOVE WS-TODAY TO TRANSACTION-DATE
           MOVE WS-TIME TO TRANSACTION-TIME
           MOVE WS-DETAIL TO TRANSACTION-DETAIL

           WRITE TRANSACTION-RECORD
               INVALID KEY
                   DISPLAY "Unable to register transaction."
                   EXIT PARAGRAPH
           END-WRITE

           ADD 1 TO WS-NEXT-TRANSACTION.

       ACCOUNT-STATEMENT.

           DISPLAY SPACE
           DISPLAY "------------ ACCOUNT STATEMENT ---------"

           PERFORM READ-ACCOUNT
           IF WS-FOUND = "N"
               EXIT PARAGRAPH
           END-IF

           MOVE ACCOUNT-BALANCE TO WS-DISPLAY-BALANCE

           DISPLAY "Account: " ACCOUNT-ID
           DISPLAY "Balance: " WS-DISPLAY-BALANCE
           DISPLAY SPACE

           MOVE 0 TO WS-REPORT-DEPOSITS
           MOVE 0 TO WS-REPORT-WITHDRAWALS
           MOVE 0 TO WS-REPORT-BALANCE

           MOVE LOW-VALUES TO TRANSACTION-ID

           START TRANSACTION-FILE
               KEY IS NOT LESS THAN TRANSACTION-ID
               INVALID KEY
                   DISPLAY "No transactions."
                   EXIT PARAGRAPH
           END-START

           MOVE "N" TO WS-EOF

           PERFORM UNTIL WS-EOF = "Y"

               READ TRANSACTION-FILE NEXT RECORD
                   AT END
                       MOVE "Y" TO WS-EOF
                   NOT AT END

                       IF TRANSACTION-ACCOUNT = ACCOUNT-ID

                           MOVE TRANSACTION-AMOUNT
                               TO WS-DISPLAY-AMOUNT

                           DISPLAY TRANSACTION-DATE " "
                               TRANSACTION-TIME " | "
                               TRANSACTION-TYPE " | "
                               WS-DISPLAY-AMOUNT " | "
                               TRANSACTION-DETAIL

                           EVALUATE TRANSACTION-TYPE
                               WHEN "DEPOSIT"
                                   ADD TRANSACTION-AMOUNT
                                       TO WS-REPORT-DEPOSITS
                               WHEN "WITHDRAWAL"
                                   ADD TRANSACTION-AMOUNT
                                       TO WS-REPORT-WITHDRAWALS
                           END-EVALUATE

                       END-IF

               END-READ

           END-PERFORM

           DISPLAY SPACE
           MOVE WS-REPORT-DEPOSITS TO WS-DISPLAY-AMOUNT
           DISPLAY "Deposits:    " WS-DISPLAY-AMOUNT

           MOVE WS-REPORT-WITHDRAWALS TO WS-DISPLAY-AMOUNT
           DISPLAY "Withdrawals: " WS-DISPLAY-AMOUNT.

       SYSTEM-REPORT.

           DISPLAY SPACE
           DISPLAY "------------- SYSTEM REPORT ------------"

           MOVE 0 TO WS-COUNT-CLIENTS
           MOVE 0 TO WS-COUNT-ACCOUNTS
           MOVE 0 TO WS-COUNT-TRANSACTIONS
           MOVE 0 TO WS-TOTAL-BALANCES
           MOVE 0 TO WS-TOTAL-DEPOSITS
           MOVE 0 TO WS-TOTAL-WITHDRAWALS

           MOVE LOW-VALUES TO CLIENT-ID

           START CLIENT-FILE KEY IS NOT LESS THAN CLIENT-ID
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   MOVE "N" TO WS-EOF
                   PERFORM UNTIL WS-EOF = "Y"
                       READ CLIENT-FILE NEXT RECORD
                           AT END
                               MOVE "Y" TO WS-EOF
                           NOT AT END
                               ADD 1 TO WS-COUNT-CLIENTS
                       END-READ
                   END-PERFORM
           END-START

           MOVE LOW-VALUES TO ACCOUNT-ID

           START ACCOUNT-FILE KEY IS NOT LESS THAN ACCOUNT-ID
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   MOVE "N" TO WS-EOF
                   PERFORM UNTIL WS-EOF = "Y"
                       READ ACCOUNT-FILE NEXT RECORD
                           AT END
                               MOVE "Y" TO WS-EOF
                           NOT AT END
                               ADD 1 TO WS-COUNT-ACCOUNTS
                               ADD ACCOUNT-BALANCE
                                   TO WS-TOTAL-BALANCES
                       END-READ
                   END-PERFORM
           END-START

           MOVE LOW-VALUES TO TRANSACTION-ID

           START TRANSACTION-FILE
               KEY IS NOT LESS THAN TRANSACTION-ID
               INVALID KEY
                   CONTINUE
               NOT INVALID KEY
                   MOVE "N" TO WS-EOF
                   PERFORM UNTIL WS-EOF = "Y"
                       READ TRANSACTION-FILE NEXT RECORD
                           AT END
                               MOVE "Y" TO WS-EOF
                           NOT AT END
                               ADD 1 TO WS-COUNT-TRANSACTIONS
                               EVALUATE TRANSACTION-TYPE
                                   WHEN "DEPOSIT"
                                       ADD TRANSACTION-AMOUNT
                                           TO WS-TOTAL-DEPOSITS
                                   WHEN "WITHDRAWAL"
                                       ADD TRANSACTION-AMOUNT
                                           TO WS-TOTAL-WITHDRAWALS
                               END-EVALUATE
                       END-READ
                   END-PERFORM
           END-START

           DISPLAY "Clients:       " WS-COUNT-CLIENTS
           DISPLAY "Accounts:      " WS-COUNT-ACCOUNTS
           DISPLAY "Transactions:  " WS-COUNT-TRANSACTIONS

           MOVE WS-TOTAL-BALANCES TO WS-DISPLAY-BALANCE
           DISPLAY "Total balance: " WS-DISPLAY-BALANCE

           MOVE WS-TOTAL-DEPOSITS TO WS-DISPLAY-AMOUNT
           DISPLAY "Deposits:      " WS-DISPLAY-AMOUNT

           MOVE WS-TOTAL-WITHDRAWALS TO WS-DISPLAY-AMOUNT
           DISPLAY "Withdrawals:   " WS-DISPLAY-AMOUNT.

       VALIDATE-NAME.

           MOVE "N" TO WS-VALID
           MOVE 0 TO WS-ALPHA-COUNT
           MOVE FUNCTION LENGTH(FUNCTION TRIM(WS-NAME))
               TO WS-LENGTH

           IF WS-LENGTH < 3
               EXIT PARAGRAPH
           END-IF

           PERFORM VARYING WS-INDEX FROM 1 BY 1
               UNTIL WS-INDEX > WS-LENGTH

               MOVE WS-NAME(WS-INDEX:1) TO WS-CHAR

               IF WS-CHAR NOT = SPACE
                   ADD 1 TO WS-ALPHA-COUNT
               END-IF

           END-PERFORM

           IF WS-ALPHA-COUNT >= 3
               MOVE "Y" TO WS-VALID
           END-IF.

       VALIDATE-DOCUMENT.

           MOVE "N" TO WS-VALID

           IF FUNCTION LENGTH(FUNCTION TRIM(WS-DOCUMENT)) >= 5
               MOVE "Y" TO WS-VALID
           END-IF.

       VALIDATE-EMAIL.

           MOVE "N" TO WS-VALID

           IF WS-EMAIL = SPACES
               EXIT PARAGRAPH
           END-IF

           IF WS-EMAIL NOT CONTAINS "@"
               EXIT PARAGRAPH
           END-IF

           IF WS-EMAIL NOT CONTAINS "."
               EXIT PARAGRAPH
           END-IF

           MOVE "Y" TO WS-VALID.

       WRITE-AUDIT.

           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-GROUP

           MOVE WS-CURRENT-YEAR TO WS-DATE-TEXT(1:4)
           MOVE "-" TO WS-DATE-TEXT(5:1)
           MOVE WS-CURRENT-MONTH TO WS-DATE-TEXT(6:2)
           MOVE "-" TO WS-DATE-TEXT(8:1)
           MOVE WS-CURRENT-DAY TO WS-DATE-TEXT(9:2)

           MOVE WS-CURRENT-HOUR TO WS-TIME-TEXT(1:2)
           MOVE ":" TO WS-TIME-TEXT(3:1)
           MOVE WS-CURRENT-MINUTE TO WS-TIME-TEXT(4:2)
           MOVE ":" TO WS-TIME-TEXT(6:1)
           MOVE WS-CURRENT-SECOND TO WS-TIME-TEXT(7:2)

           MOVE SPACES TO AUDIT-RECORD

           STRING
               WS-DATE-TEXT
               DELIMITED BY SIZE
               " "
               DELIMITED BY SIZE
               WS-TIME-TEXT
               DELIMITED BY SIZE
               " | USER="
               DELIMITED BY SIZE
               WS-AUDIT-USER
               DELIMITED BY SIZE
               " | ACTION="
               DELIMITED BY SIZE
               WS-AUDIT-ACTION
               DELIMITED BY SIZE
               " | "
               DELIMITED BY SIZE
               WS-AUDIT-DATA
               DELIMITED BY SIZE
               INTO AUDIT-RECORD
           END-STRING

           WRITE AUDIT-RECORD.

       END PROGRAM SECUREBANK.