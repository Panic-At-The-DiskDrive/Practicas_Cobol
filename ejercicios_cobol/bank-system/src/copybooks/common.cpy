      ******************************************************************
      * COPYBOOK: COMMON.CPY
      * Description:
      *   Shared variables used throughout the Banking System.
      ******************************************************************

       01 WS-GENERAL.

      *---------------------------------------------------------------*
      * End Of File Flags
      *---------------------------------------------------------------*

           05 WS-MASTER-EOF              PIC X VALUE 'N'.
              88 MASTER-EOF                    VALUE 'Y'.
              88 MASTER-NOT-EOF                VALUE 'N'.

           05 WS-TRANS-EOF               PIC X VALUE 'N'.
              88 TRANS-EOF                     VALUE 'Y'.
              88 TRANS-NOT-EOF                 VALUE 'N'.

      *---------------------------------------------------------------*
      * File Status Codes
      *---------------------------------------------------------------*

           05 WS-MASTER-STATUS           PIC XX VALUE SPACES.
           05 WS-TRANS-STATUS            PIC XX VALUE SPACES.
           05 WS-REPORT-STATUS           PIC XX VALUE SPACES.
           05 WS-LOG-STATUS              PIC XX VALUE SPACES.

      *---------------------------------------------------------------*
      * Counters
      *---------------------------------------------------------------*

           05 WS-COUNTERS.

              10 WS-TOTAL-ACCOUNTS       PIC 9(7) VALUE ZERO.

              10 WS-TOTAL-TRANSACTIONS   PIC 9(7) VALUE ZERO.

              10 WS-TOTAL-DEPOSITS       PIC 9(7) VALUE ZERO.

              10 WS-TOTAL-WITHDRAWALS    PIC 9(7) VALUE ZERO.

              10 WS-TOTAL-ERRORS         PIC 9(7) VALUE ZERO.

      *---------------------------------------------------------------*
      * Financial Totals
      *---------------------------------------------------------------*

           05 WS-TOTALS.

              10 WS-DEPOSIT-AMOUNT
                 PIC 9(11)V99 VALUE ZERO.

              10 WS-WITHDRAW-AMOUNT
                 PIC 9(11)V99 VALUE ZERO.

              10 WS-FINAL-BALANCE
                 PIC 9(13)V99 VALUE ZERO.

      *---------------------------------------------------------------*
      * Temporary Working Values
      *---------------------------------------------------------------*

           05 WS-WORK.

              10 WS-OLD-BALANCE
                 PIC 9(11)V99 VALUE ZERO.

              10 WS-NEW-BALANCE
                 PIC 9(11)V99 VALUE ZERO.

              10 WS-TRANSACTION-AMOUNT
                 PIC 9(11)V99 VALUE ZERO.

      *---------------------------------------------------------------*
      * Switches
      *---------------------------------------------------------------*

           05 WS-SWITCHES.

              10 WS-ACCOUNT-FOUND        PIC X VALUE 'N'.
                 88 ACCOUNT-FOUND              VALUE 'Y'.
                 88 ACCOUNT-NOT-FOUND          VALUE 'N'.

              10 WS-VALID-TRANSACTION    PIC X VALUE 'Y'.
                 88 VALID-TRANSACTION          VALUE 'Y'.
                 88 INVALID-TRANSACTION        VALUE 'N'.

      *---------------------------------------------------------------*
      * Report Formatting
      *---------------------------------------------------------------*

           05 WS-LINE-SEPARATOR
              PIC X(70)
              VALUE ALL '-'.

      *---------------------------------------------------------------*
      * Date
      *---------------------------------------------------------------*

           05 WS-CURRENT-DATE.

              10 WS-YEAR                 PIC 9(4).
              10 WS-MONTH                PIC 99.
              10 WS-DAY                  PIC 99.

      *---------------------------------------------------------------*
      * Time
      *---------------------------------------------------------------*

           05 WS-CURRENT-TIME.

              10 WS-HOUR                 PIC 99.
              10 WS-MINUTE               PIC 99.
              10 WS-SECOND               PIC 99.
              10 WS-HUNDREDTH            PIC 99.