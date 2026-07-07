      ******************************************************************
      * COPYBOOK: ACCOUNT.CPY
      * Description:
      *   Account Master Record Layout
      ******************************************************************

       01 ACCOUNT-RECORD.

      *---------------------------------------------------------------*
      * Account Information
      *---------------------------------------------------------------*

           05 ACCT-NUMBER.
              10 ACCT-ID                 PIC 9(6).

           05 ACCT-CUSTOMER.
              10 ACCT-FIRST-NAME         PIC X(15).
              10 ACCT-LAST-NAME          PIC X(20).

           05 ACCT-TYPE                  PIC X.
              88 CHECKING-ACCOUNT             VALUE 'C'.
              88 SAVINGS-ACCOUNT              VALUE 'S'.

      *---------------------------------------------------------------*
      * Financial Information
      *---------------------------------------------------------------*

           05 ACCT-BALANCE               PIC 9(11)V99.

           05 ACCT-STATUS                PIC X.
              88 ACCOUNT-ACTIVE               VALUE 'A'.
              88 ACCOUNT-INACTIVE             VALUE 'I'.
              88 ACCOUNT-CLOSED               VALUE 'C'.

      *---------------------------------------------------------------*
      * Audit Information
      *---------------------------------------------------------------*

           05 ACCT-LAST-UPDATE.

              10 ACCT-LAST-YEAR          PIC 9(4).
              10 ACCT-LAST-MONTH         PIC 99.
              10 ACCT-LAST-DAY           PIC 99.

      *---------------------------------------------------------------*
      * Reserved Fields
      *---------------------------------------------------------------*

           05 ACCT-RESERVED              PIC X(20).