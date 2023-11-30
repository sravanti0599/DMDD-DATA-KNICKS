SET SERVEROUTPUT ON
BEGIN
	FOR K IN(
        WITH EBT_FKS AS (
			SELECT 'EBTAPPLICATION_ADMIN_FK' FK_NAME FROM DUAL
			UNION ALL
			SELECT 'EBTCARD_EBTACCOUNT_FK' FROM DUAL
			UNION ALL
			SELECT 'EBTACCOUNT_EBTAPPLICATION_FK' FROM DUAL
			UNION ALL
			SELECT 'TRANSACTIONS_EBTCARD_FK' FROM DUAL
			UNION ALL
            SELECT 'EBTACCOUNT_EBTSCHEDULE_FK' FROM DUAL
            UNION ALL
			SELECT 'TRANSACTIONITEMLIST_ITEM_FK' FROM DUAL
			UNION ALL
            SELECT 'TRANSACTIONS_MERCHANT_FK' FROM DUAL
            UNION ALL
			SELECT 'TRANSACTIONITEMLIST_TRANSACTIONS_FK' FROM DUAL
			UNION ALL
			SELECT 'EBTAPPLICATION_USERS_FK' FROM DUAL
        )
        SELECT F.FK_NAME, C.TABLE_NAME
        FROM EBT_FKS F 
        INNER JOIN USER_CONSTRAINTS C
        ON F.FK_NAME = C.CONSTRAINT_NAME
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('FOREIGN KEYS TO BE DROPPED:'|| K.FK_NAME);
        EXECUTE IMMEDIATE 'ALTER TABLE '|| K.TABLE_NAME ||' DROP CONSTRAINT '||K.FK_NAME;
    END LOOP;
    FOR J IN(
        WITH INVT_OBJ AS (
			SELECT 'USERS' OBJ_NAME FROM DUAL
			UNION ALL
			SELECT 'USERS_SEQ' FROM DUAL
			UNION ALL
			SELECT 'TRANSACTIONS' FROM DUAL
			UNION ALL
			SELECT 'TRANSACTIONS_SEQ' FROM DUAL
			UNION ALL
            SELECT 'TRANSACTIONITEMLIST' FROM DUAL
            UNION ALL
			SELECT 'TRANSACTIONITEMLIST_SEQ' FROM DUAL
			UNION ALL
            SELECT 'MERCHANT' FROM DUAL
            UNION ALL
			SELECT 'MERCHANT_SEQ' FROM DUAL
			UNION ALL
			SELECT 'ITEM' FROM DUAL
            UNION ALL
			SELECT 'ITEM_SEQ' FROM DUAL
			UNION ALL
            SELECT 'EBTSCHEDULE' FROM DUAL
            UNION ALL
			SELECT 'EBTSCHEDULE_SEQ' FROM DUAL
			UNION ALL
            SELECT 'EBTCARD' FROM DUAL
            UNION ALL
			SELECT 'EBTCARD_SEQ' FROM DUAL
			UNION ALL
            SELECT 'EBTAPPLICATION' FROM DUAL
            UNION ALL
			SELECT 'EBTAPPLICATION_SEQ' FROM DUAL
			UNION ALL
            SELECT 'EBTACCOUNT' FROM DUAL
            UNION ALL
			SELECT 'EBTACCOUNT_SEQ' FROM DUAL
			UNION ALL
            SELECT 'ADMIN' FROM DUAL
			UNION ALL
			SELECT 'ADMIN_SEQ' FROM DUAL
            UNION ALL
			SELECT 'ACCOUNT_NUMBER_SEQ' FROM DUAL
            UNION ALL
			SELECT 'EBTCARD_NUMBER_SEQ' FROM DUAL
        )
        SELECT I.OBJ_NAME, O.OBJECT_TYPE
        FROM INVT_OBJ I 
        INNER JOIN USER_OBJECTS O
        ON I.OBJ_NAME = O.OBJECT_NAME
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('TABLE/SEQUENCE/VIEW/PROCEDURE TO BE DROPPED:'|| J.OBJ_NAME);
        EXECUTE IMMEDIATE 'DROP '||J.OBJECT_TYPE||' '||J.OBJ_NAME;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


CREATE SEQUENCE admin_seq;
CREATE TABLE admin (
    adminid   NUMBER,
    firstname VARCHAR2(100) NOT NULL,
    lastname  VARCHAR2(100) NOT NULL,
    ssn       VARCHAR2(11) UNIQUE NOT NULL,
    address   VARCHAR2(100) NOT NULL,
    phone     VARCHAR2(20),
    email     VARCHAR2(255),
    password  VARCHAR2(255)
);

ALTER TABLE admin ADD CONSTRAINT admin_pk PRIMARY KEY ( adminid );

CREATE SEQUENCE ebtaccount_seq;
create sequence account_number_seq;
CREATE TABLE ebtaccount (
    accountid                    NUMBER,
    accountnumber                VARCHAR2(200) UNIQUE NOT NULL,
    foodbalance                  NUMBER(20, 2) NOT NULL,
    cashbalance                  NUMBER(20, 2) NOT NULL,
    ebtapplication_applicationid NUMBER NOT NULL,
    ebtschedule_scheduleid       NUMBER NOT NULL
);

CREATE UNIQUE INDEX ebtaccount__idx ON
    ebtaccount (
        ebtapplication_applicationid
    ASC );

ALTER TABLE ebtaccount ADD CONSTRAINT ebtaccount_pk PRIMARY KEY ( accountid );

CREATE SEQUENCE ebtapplication_seq;
CREATE TABLE ebtapplication (
    applicationid      NUMBER,
    proofofincome      BLOB NOT NULL,
    immigrationproof   BLOB NOT NULL,
    proofofresidence   BLOB NOT NULL,
    proofofidentity    BLOB NOT NULL,
    benefitprogramname VARCHAR2(100),
    status             VARCHAR2(50) DEFAULT 'PENDING' CHECK (UPPER(status) IN ('PENDING', 'APPROVED', 'REJECTED')),
    users_userid       NUMBER NOT NULL,
    admin_adminid     NUMBER NOT NULL,
    created_at DATE DEFAULT SYSDATE NOT NULL,
    updated_at DATE DEFAULT SYSDATE
);

ALTER TABLE ebtapplication ADD CONSTRAINT ebtapplication_pk PRIMARY KEY ( applicationid );

CREATE SEQUENCE ebtcard_seq;
create sequence ebtcard_number_seq;
CREATE TABLE ebtcard (
    cardid               NUMBER,
    cardnumber           VARCHAR2(16) UNIQUE NOT NULL,
    activationdate       DATE NOT NULL,
    statusofcard         VARCHAR2(20)  DEFAULT 'PENDING' CHECK (UPPER(statusofcard) IN ('ACTIVE', 'INACTIVE', 'PENDING','BLOCKED')) NOT NULL,
    pin                  NUMBER(4),
    expirydate           DATE NOT NULL,
    ebtaccount_accountid NUMBER NOT NULL
);

ALTER TABLE ebtcard ADD CONSTRAINT ebtcard_pk PRIMARY KEY ( cardid );

CREATE SEQUENCE ebtschedule_seq;
CREATE TABLE ebtschedule (
    scheduleid            NUMBER,
    disbursementfrequency VARCHAR2(50),
    nextdisbursementdate  DATE,
    benefitprogramname    VARCHAR2(50) UNIQUE NOT NULL
);

ALTER TABLE ebtschedule ADD CONSTRAINT ebtschedule_pk PRIMARY KEY ( scheduleid );

CREATE SEQUENCE item_seq;
CREATE TABLE item (
    itemid      NUMBER,
    name        VARCHAR2(50) NOT NULL,
    upc         VARCHAR2(20) NOT NULL,
    price       NUMBER(20, 2) NOT NULL,
    description VARCHAR2(100),
    eligibility VARCHAR2(1) NOT NULL
);

ALTER TABLE item ADD CONSTRAINT item_pk PRIMARY KEY ( itemid );

CREATE SEQUENCE merchant_seq;
CREATE TABLE merchant (
    merchantid    NUMBER,
    type          VARCHAR2(50) NOT NULL,
    name          VARCHAR2(50) NOT NULL,
    address       VARCHAR2(100),
    accountnumber VARCHAR2(200) UNIQUE,
    routingnumber VARCHAR2(100),
    archive       CHAR(1)
);

ALTER TABLE merchant ADD CONSTRAINT merchant_pk PRIMARY KEY ( merchantid );

CREATE SEQUENCE transactionitemlist_seq;
CREATE TABLE transactionitemlist (
    transactionitemid          NUMBER,
    quantity                   NUMBER(10) NOT NULL,
    item_itemid                NUMBER NOT NULL,
    transactions_transactionid NUMBER NOT NULL
);

ALTER TABLE transactionitemlist ADD CONSTRAINT transactionitemlist_pk PRIMARY KEY ( transactionitemid );

CREATE SEQUENCE transactions_seq;
CREATE TABLE transactions (
    transactionid       NUMBER,
    amount              NUMBER(20, 2) NOT NULL,
    status              VARCHAR2(20) DEFAULT 'PENDING' CHECK (UPPER(status) IN ('PENDING', 'SUCCESS', 'FAILURE','REFUNDED')) NOT NULL,
    recorded_date       DATE NOT NULL,
    merchant_merchantid NUMBER NOT NULL,
    ebtcard_cardid      NUMBER NOT NULL
);

ALTER TABLE transactions ADD CONSTRAINT transactions_pk PRIMARY KEY ( transactionid );

CREATE SEQUENCE users_seq;
CREATE TABLE users (
    userid    NUMBER,
    firstname VARCHAR2(50) NOT NULL,
    lastname  VARCHAR2(50) NOT NULL,
    ssn       VARCHAR2(11) UNIQUE NOT NULL,
    address   VARCHAR2(100) NOT NULL,
    phone     VARCHAR2(20),
    email     VARCHAR2(255),
    password  VARCHAR2(255)
);

ALTER TABLE users ADD CONSTRAINT users_pk PRIMARY KEY ( userid );

ALTER TABLE ebtaccount
    ADD CONSTRAINT ebtaccount_ebtapplication_fk FOREIGN KEY ( ebtapplication_applicationid )
        REFERENCES ebtapplication ( applicationid );

ALTER TABLE ebtaccount
    ADD CONSTRAINT ebtaccount_ebtschedule_fk FOREIGN KEY ( ebtschedule_scheduleid )
        REFERENCES ebtschedule ( scheduleid );

ALTER TABLE ebtapplication
    ADD CONSTRAINT ebtapplication_admin_fk FOREIGN KEY ( admin_adminid )
        REFERENCES admin ( adminid );

ALTER TABLE ebtapplication
    ADD CONSTRAINT ebtapplication_users_fk FOREIGN KEY ( users_userid )
        REFERENCES users ( userid );

ALTER TABLE ebtcard
    ADD CONSTRAINT ebtcard_ebtaccount_fk FOREIGN KEY ( ebtaccount_accountid )
        REFERENCES ebtaccount ( accountid );

ALTER TABLE transactionitemlist
    ADD CONSTRAINT transactionitemlist_item_fk FOREIGN KEY ( item_itemid )
        REFERENCES item ( itemid );

ALTER TABLE transactionitemlist
    ADD CONSTRAINT transactionitemlist_transactions_fk FOREIGN KEY ( transactions_transactionid )
        REFERENCES transactions ( transactionid );

ALTER TABLE transactions
    ADD CONSTRAINT transactions_ebtcard_fk FOREIGN KEY ( ebtcard_cardid )
        REFERENCES ebtcard ( cardid );

ALTER TABLE transactions
    ADD CONSTRAINT transactions_merchant_fk FOREIGN KEY ( merchant_merchantid )
        REFERENCES merchant ( merchantid );
        

--Creating views for all the tables
CREATE OR REPLACE VIEW VIEW_ADMIN
AS
SELECT * FROM ADMIN;

CREATE OR REPLACE VIEW VIEW_EBTACCOUNT
AS
SELECT * FROM EBTACCOUNT;

CREATE OR REPLACE VIEW VIEW_EBTCARD
AS
SELECT * FROM EBTCARD;

CREATE OR REPLACE VIEW VIEW_EBTSCHEDULE
AS
SELECT * FROM EBTSCHEDULE;

CREATE OR REPLACE VIEW VIEW_ITEM
AS
SELECT * FROM ITEM;

CREATE OR REPLACE VIEW VIEW_EBTAPPLICATION
AS
SELECT * FROM EBTAPPLICATION;

CREATE OR REPLACE VIEW VIEW_MERCHANT
AS
SELECT * FROM MERCHANT;

CREATE OR REPLACE VIEW VIEW_USERS
AS
SELECT * FROM USERS;

CREATE OR REPLACE VIEW VIEW_TRANSACTIONITEMLIST
AS
SELECT * FROM TRANSACTIONITEMLIST;

CREATE OR REPLACE VIEW VIEW_TRANSACTIONS
AS
SELECT * FROM TRANSACTIONS;