-- ============================================================
-- PROJECT : ACCOUNT BALANCE UPDATER
-- AUTHOR  : Simonetta, Daniel
-- DATE    : 2026-06-17
--
-- DESCRIPTION
-- Database schema used by the COBOL batch program.
-- ============================================================

DROP TABLE IF EXISTS ACCOUNTS;

CREATE TABLE ACCOUNTS
(
    ACCOUNT_NUMBER CHAR(10)      NOT NULL PRIMARY KEY,

    CUSTOMER_NAME  VARCHAR(50)   NOT NULL,

    BALANCE        DECIMAL(11,2) NOT NULL
        CHECK (BALANCE >= 0),

    STATUS         CHAR(1)       NOT NULL
        CHECK (STATUS IN ('A','I'))
);

CREATE INDEX IDX_ACCOUNT_STATUS
    ON ACCOUNTS (STATUS);