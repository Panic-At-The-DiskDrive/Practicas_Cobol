      ******************************************************************
      * COPYBOOK: FILES.CPY
      * Description:
      *   File Definitions
      ******************************************************************

      *===============================================================*
      * MASTER FILE
      *===============================================================*

       SELECT MASTER-FILE
           ASSIGN TO "../data/ACCOUNTS.DAT"
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-MASTER-STATUS.

      *===============================================================*
      * TRANSACTION FILE
      *===============================================================*

       SELECT TRANS-FILE
           ASSIGN TO "../data/TRANSACTIONS.DAT"
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-TRANS-STATUS.

      *===============================================================*
      * REPORT FILE
      *===============================================================*

       SELECT REPORT-FILE
           ASSIGN TO "../data/REPORT.TXT"
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-REPORT-STATUS.

      *===============================================================*
      * ERROR LOG
      *===============================================================*

       SELECT LOG-FILE
           ASSIGN TO "../data/ERROR.LOG"
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-LOG-STATUS.