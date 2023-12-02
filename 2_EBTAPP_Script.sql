--ALTER SESSION SET CURRENT_SCHEMA = EBTAPP;

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
    status                       VARCHAR2(50) DEFAULT 'ACTIVE' CHECK (UPPER(status) IN ('ACTIVE','INACTIVE')),  
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
    statusofcard         VARCHAR2(20)  DEFAULT 'PENDING' CHECK (UPPER(statusofcard) IN ('ACTIVE', 'INACTIVE', 'PENDING','BLOCKED','LOST')) NOT NULL,
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
    dob       DATE NOT NULL,
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


--TODO : Should be moved to a single file

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION getAdminIdforAssignment RETURN EBTAPPLICATION.admin_adminid%TYPE IS
    v_random_admin_id EBTAPPLICATION.admin_adminid%TYPE;
BEGIN
    -- Randomly select an admin ID based on the number of applications assigned
    SELECT adminid
    INTO v_random_admin_id
    FROM (
        SELECT adminid,
               ROW_NUMBER() OVER (ORDER BY DBMS_RANDOM.VALUE) as rn
        FROM admin
    )
    WHERE rn = 1;
    RETURN v_random_admin_id;
END getAdminIdforAssignment;
/


--generation of account number
CREATE OR REPLACE FUNCTION generateAccountNumber
    RETURN ebtaccount.accountnumber%TYPE
IS
    v_account_number ebtaccount.accountnumber%TYPE;
BEGIN
    SELECT '1000'||LPAD('001', 3, '0')||LPAD(TO_CHAR(account_number_seq.nextval), 7, '0')
    INTO v_account_number
    FROM dual;

    RETURN v_account_number;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--generation of card number
CREATE OR REPLACE FUNCTION generateCardNumber RETURN ebtcard.cardnumber%TYPE IS
   v_prefix VARCHAR2(4) := '4000'; -- for now we choose a random prefix
   v_sequence NUMBER;
BEGIN
   SELECT ebtcard_number_seq.NEXTVAL INTO v_sequence FROM dual;
   RETURN v_prefix || LPAD(TO_CHAR(v_sequence), 12, '0');
END;
/


-------------------Stored Procedures-------------
--Procedure to insert admin information
CREATE OR REPLACE PROCEDURE insertAdmin (
    firstname IN admin.firstname%type,
    lastname  admin.lastname%type,
    ssn IN admin.ssn%type,
    address IN admin.address%type,
    phone IN admin.phone%type,
    email IN admin.email%type,
    password IN admin.password%type
)
AS
    v_adminid NUMBER;
    InvalidEmail EXCEPTION;
    InvalidSSN EXCEPTION;
    WeakPassword EXCEPTION;
    InvalidPhone EXCEPTION;

BEGIN
    IF email IS NULL OR NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
        RAISE InvalidEmail;
    END IF;

    IF NOT REGEXP_LIKE(ssn, '^\d{3}-\d{2}-\d{4}$') THEN
        RAISE InvalidSSN;
    END IF;

    IF NOT REGEXP_LIKE(phone, '^\d{10}$') THEN
        RAISE InvalidPhone;
    END IF;

    IF NOT REGEXP_LIKE(password, '^[a-zA-Z][a-zA-Z0-9@$!%*?&]{7,}$') THEN
        RAISE WeakPassword;
    END IF;

    SELECT admin_seq.nextval INTO v_adminid FROM dual;

    INSERT INTO admin (adminid, firstname, lastname, ssn, address, phone, email, password)
    VALUES (v_adminid, firstname, lastname, ssn, address, phone, email, password);

    COMMIT; -- Adding a COMMIT to persist changes to the database

    DBMS_OUTPUT.PUT_LINE('Admin inserted successfully');

EXCEPTION
    WHEN InvalidEmail THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid email format');
    WHEN InvalidSSN THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid SSN format');
    WHEN InvalidPhone THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid phone number format');
    WHEN WeakPassword THEN
        DBMS_OUTPUT.PUT_LINE('Error: Password must be at least 8 characters long and include at least one uppercase, one lowercase, one number, and one special character');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in the INSERT: ' || SQLERRM);
END;
/

-- Stored Procedure to adminLogin
CREATE OR REPLACE PROCEDURE adminLogin (
    p_adminid admin.adminid%type,
    p_password admin.password%type
)
AS
    v_stored_password admin.password%type;
BEGIN
    -- Retrieve the stored password for the given adminid
    SELECT password INTO v_stored_password
    FROM admin
    WHERE adminid = p_adminid;

    -- Check if the retrieved password matches the provided password
    IF v_stored_password = p_password THEN
        DBMS_OUTPUT.PUT_LINE('Login successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: Incorrect password');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Admin not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Stored Procedure to reset Admin Password
CREATE OR REPLACE PROCEDURE resetAdminPassword (
    p_adminid admin.adminid%type,
    p_new_password admin.password%type
)
AS
    -- Custom exception for weak password
    WeakPassword EXCEPTION;

BEGIN
    -- Validate password complexity
    IF NOT REGEXP_LIKE(p_new_password, '^[a-zA-Z][a-zA-Z0-9@$!%*?&]{7,}$') THEN
        -- Raise WeakPassword exception
        RAISE WeakPassword;
    END IF;

    -- Update the password for the given adminid
    UPDATE admin
    SET password = p_new_password
    WHERE adminid = p_adminid;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Password reset successful');
EXCEPTION
    WHEN WeakPassword THEN
        DBMS_OUTPUT.PUT_LINE('Error: Weak password');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Admin not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--- Stored Procedure to update admin details
CREATE OR REPLACE PROCEDURE updateAdminDetails (
    p_adminid admin.adminid%type,
    p_firstname admin.firstname%type,
    p_lastname admin.lastname%type,
    p_email admin.email%type,
    p_phone admin.phone%type
)
AS
    -- Custom exceptions
    InvalidEmail EXCEPTION;
    InvalidPhone EXCEPTION;

BEGIN
    -- Validate email format
    IF p_email IS NULL OR NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
        -- Raise InvalidEmail exception
        RAISE InvalidEmail;
    END IF;

    -- Validate phone number format (assuming 10-digit string format)
    IF NOT REGEXP_LIKE(p_phone, '^\d{10}$') THEN
        -- Raise InvalidPhone exception
        RAISE InvalidPhone;
    END IF;

    -- Update admin details
    UPDATE admin
    SET 
        firstname = p_firstname,
        lastname = p_lastname,
        email = p_email,
        phone = p_phone
    WHERE adminid = p_adminid;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Admin details updated successfully');
EXCEPTION
    WHEN InvalidEmail THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid email format');
    WHEN InvalidPhone THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid phone format');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Admin not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- Stored Proecdure to insert the User,  based on the buisness rules constraints have been added --

CREATE OR REPLACE PROCEDURE insertUser (
    p_firstname users.firstname%type,
    p_lastname users.lastname%type,
    p_ssn users.ssn%type,
    p_address users.address%type,
    p_phone users.phone%type,
    p_email users.email%type,
    p_dob  VARCHAR,
    p_password users.password%type
)
AS
    v_userid NUMBER;

    InvalidEmail EXCEPTION;
    InvalidSSN EXCEPTION;
    WeakPassword EXCEPTION;
    InvalidPhone EXCEPTION;

BEGIN
    IF p_email IS NULL OR NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
        RAISE InvalidEmail;
    END IF;

    IF NOT REGEXP_LIKE(p_ssn, '^\d{3}-\d{2}-\d{4}$') THEN
        RAISE InvalidSSN;
    END IF;

    IF NOT REGEXP_LIKE(p_phone, '^\d{10}$') THEN
        RAISE InvalidPhone;
    END IF;

    IF NOT REGEXP_LIKE(p_password, '^[a-zA-Z][a-zA-Z0-9@$!%*?&]{7,}$') THEN
        RAISE WeakPassword;
    END IF;

    SELECT users_seq.nextval INTO v_userid FROM dual;

    INSERT INTO users (
        userid,
        firstname,
        lastname,
        ssn,
        address,
        phone,
        email,
        dob,
        password
    )
    VALUES (
        v_userid,
        p_firstname,
        p_lastname,
        p_ssn,
        p_address,
        p_phone,
        p_email,
        TO_DATE(p_dob, 'DD-MM-YYYY'),
        p_password
    );

    COMMIT; 

    DBMS_OUTPUT.PUT_LINE('User inserted successfully');
EXCEPTION
    WHEN InvalidEmail THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid email format');
    WHEN InvalidSSN THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid SSN format');
    WHEN InvalidPhone THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid phone format');
    WHEN WeakPassword THEN
        DBMS_OUTPUT.PUT_LINE('Error: Weak password');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Stored Procedure to validate user login

CREATE OR REPLACE PROCEDURE userLogin (
    p_userid users.userid%type,
    p_password users.password%type
)
AS
    v_stored_password users.password%type;
    v_userid NUMBER;
    WeakPassword EXCEPTION;
BEGIN
    -- Retrieve the stored password for the given userid
    SELECT password INTO v_stored_password
    FROM users
    WHERE userid = p_userid;

    -- Check if the retrieved password matches the provided password
    IF v_stored_password = p_password THEN
        DBMS_OUTPUT.PUT_LINE('Login successful');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: Incorrect password');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: User not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Stored Procedure to reset Password

CREATE OR REPLACE PROCEDURE resetPassword (
    p_userid users.userid%type,
    p_new_password users.password%type
)
AS
    -- Custom exception for weak password
    WeakPassword EXCEPTION;

BEGIN
    -- Validate password complexity
    IF NOT REGEXP_LIKE(p_new_password, '^[a-zA-Z][a-zA-Z0-9@$!%*?&]{7,}$') THEN
        -- Raise WeakPassword exception
        RAISE WeakPassword;
    END IF;

    -- Update the password for the given userid
    UPDATE users
    SET password = p_new_password
    WHERE userid = p_userid;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Password reset successful');
EXCEPTION
    WHEN WeakPassword THEN
        DBMS_OUTPUT.PUT_LINE('Error: Weak password');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: User not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


--- Stored Procedure to update user details

CREATE OR REPLACE PROCEDURE updateUserDetails (
    p_userid users.userid%type,
    p_firstname users.firstname%type,
    p_lastname users.lastname%type,
    p_ssn users.ssn%type,
    p_address users.address%type,
    p_phone users.phone%type,
    p_email users.email%type
)
AS
    -- Custom exceptions
    InvalidEmail EXCEPTION;
    InvalidSSN EXCEPTION;
    InvalidPhone EXCEPTION;

BEGIN
    -- Validate email format
    IF p_email IS NULL OR NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
        -- Raise InvalidEmail exception
        RAISE InvalidEmail;
    END IF;

    -- Validate SSN format (assuming SSN is in the format 'XXX-XX-XXXX')
    IF NOT REGEXP_LIKE(p_ssn, '^\d{3}-\d{2}-\d{4}$') THEN
        -- Raise InvalidSSN exception
        RAISE InvalidSSN;
    END IF;

    -- Validate phone number format (assuming 10-digit string format)
    IF NOT REGEXP_LIKE(p_phone, '^\d{10}$') THEN
        -- Raise InvalidPhone exception
        RAISE InvalidPhone;
    END IF;

    -- Update user details
    UPDATE users
    SET 
        firstname = p_firstname,
        lastname = p_lastname,
        ssn = p_ssn,
        address = p_address,
        phone = p_phone,
        email = p_email
    WHERE userid = p_userid;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('User details updated successfully');
EXCEPTION
    WHEN InvalidEmail THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid email format');
    WHEN InvalidSSN THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid SSN format');
    WHEN InvalidPhone THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid phone format');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: User not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--Procedure to add ebt applications
CREATE OR REPLACE PROCEDURE createEBTApplication (
    p_proofofincome EBTAPPLICATION.proofofincome%TYPE,
    p_immigrationproof EBTAPPLICATION.immigrationproof%TYPE,
    p_proofofresidence EBTAPPLICATION.proofofresidence%TYPE,
    p_proofofidentity EBTAPPLICATION.proofofidentity%TYPE,
    p_users_userid EBTAPPLICATION.users_userid%TYPE,
    p_created_at EBTAPPLICATION.created_at%TYPE := NULL
)
AS
    v_pending_count NUMBER;
    v_active_account NUMBER;
    v_random_admin_id EBTAPPLICATION.admin_adminid%TYPE;
    PendingApplicationExists EXCEPTION;
    ActiveApplicationExists EXCEPTION;

BEGIN

    --TODO: DECIDE TO CHECK PENDING AS WELL AS SUCCESS SCENARIOS.
    SELECT COUNT(*)
    INTO v_pending_count
    FROM EBTAPPLICATION
    WHERE users_userid = p_users_userid AND status = 'PENDING';
    
    IF v_pending_count > 0 THEN
        RAISE PendingApplicationExists;
    END IF;

    
    SELECT COUNT(*)
    INTO v_active_account
    FROM EBTAPPLICATION A
    JOIN EBTACCOUNT AC ON A.APPLICATIONID = AC.ebtapplication_applicationid
    WHERE A.users_userid = p_users_userid
    AND A.status = 'APPROVED'
    AND AC.status = 'ACTIVE';


    IF v_active_account > 0 THEN
        RAISE ActiveApplicationExists;
    END IF;

    v_random_admin_id := getAdminIdforAssignment;
    INSERT INTO EBTAPPLICATION (
        applicationid,
        proofofincome,
        immigrationproof,
        proofofresidence,
        proofofidentity,
        benefitprogramname,
        status,
        users_userid,
        admin_adminid,
        created_at
    )
    VALUES (
        ebtapplication_seq.nextval,
        p_proofofincome,
        p_immigrationproof,
        p_proofofresidence,
        p_proofofidentity,
        'EBT Program MA',
        'PENDING',
        p_users_userid,
        v_random_admin_id,
        NVL(p_created_at, SYSTIMESTAMP)
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('EBT Application inserted successfully');

EXCEPTION
    WHEN PendingApplicationExists THEN
        DBMS_OUTPUT.PUT_LINE('Error: An existing record with Pending status already exists for the user.');
    WHEN ActiveApplicationExists THEN
        DBMS_OUTPUT.PUT_LINE('Error: An existing Account already exists.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- Procedure to update the status of an EBT application
CREATE OR REPLACE PROCEDURE updateEBTApplicationStatus (
    p_applicationid EBTAPPLICATION.applicationid%TYPE,
    p_status EBTAPPLICATION.status%TYPE
)
AS
    v_admin_id ADMIN.adminid%TYPE;
    v_current_status EBTAPPLICATION.status%TYPE;
    ApplicationAlreadyApproved EXCEPTION;

BEGIN


    SELECT admin_adminid, status  
    INTO v_admin_id, v_current_status
    FROM EBTAPPLICATION WHERE
    applicationid = p_applicationid;
    
    
    IF v_current_status = 'APPROVED' THEN
        RAISE ApplicationAlreadyApproved;
    END IF;
  
    UPDATE EBTAPPLICATION
    SET status = p_status, updated_at=SYSDATE
    WHERE applicationid = p_applicationid;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('EBT Application ' || p_status || ' successfully by ' || v_admin_id);
EXCEPTION
    WHEN ApplicationAlreadyApproved THEN
        DBMS_OUTPUT.PUT_LINE('Error: An appication has already been approved. Once approved cannot be reverted');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/





--stored procedure to  insertEBTAccount
CREATE OR REPLACE PROCEDURE addEBTAccount (
    p_accountid OUT ebtaccount.accountid%TYPE,
    p_ebtapplication_applicationid ebtaccount.ebtapplication_applicationid%TYPE,
    p_ebtschedule_scheduleid ebtaccount.ebtschedule_scheduleid%TYPE
)
AS
    v_account_number ebtaccount.accountnumber%TYPE;
    
BEGIN
    
    v_account_number := generateAccountNumber();
    p_accountid:= ebtaccount_seq.nextval;
    INSERT INTO ebtaccount (
        accountid,
        accountnumber,
        foodbalance,
        cashbalance,
        ebtapplication_applicationid,
        ebtschedule_scheduleid
    )
    VALUES (
        p_accountid,
        v_account_number,
        0,
        0,
        p_ebtapplication_applicationid,
        p_ebtschedule_scheduleid
    );
    DBMS_OUTPUT.PUT_LINE('EBT Account inserted successfully');
EXCEPTION
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Error in the Account Creation: ' || SQLERRM);
END;
/


--stored procedure to insert EBT Card
CREATE OR REPLACE PROCEDURE addEBTCard (
    p_ebtaccount_accountid ebtcard.ebtaccount_accountid%TYPE
)
AS
    v_cardnumber ebtcard.cardnumber%TYPE;
    v_existing_count NUMBER;

    UserHasActiveCard EXCEPTION;
BEGIN

    SELECT COUNT(*)
    INTO v_existing_count
    FROM ebtcard
    WHERE ebtaccount_accountid = p_ebtaccount_accountid
      AND statusofcard = 'ACTIVE';

    IF v_existing_count > 0 THEN
        RAISE UserHasActiveCard;
    END IF;

    v_cardnumber:= generateCardNumber();
    INSERT INTO ebtcard (
        cardid,
        cardnumber,
        activationdate,
        expirydate,
        ebtaccount_accountid
    )
    VALUES (
        ebtcard_seq.nextval,
        v_cardnumber,
        SYSDATE, -- Use the current date as the activation date
        ADD_MONTHS(SYSDATE, 24), -- Expiry date is 2 years from now
        p_ebtaccount_accountid
    );
    DBMS_OUTPUT.PUT_LINE('EBT Card inserted successfully');

EXCEPTION
    WHEN UserHasActiveCard THEN
        RAISE_APPLICATION_ERROR(-20001, 'User Already Has an Active Card!');
    WHEN OTHERS THEN 
        -- Raise exception for other errors
        RAISE_APPLICATION_ERROR(-20001, 'There is an issue while trying to genrate card details! ' || SQLERRM);
END;
/



-- Trigger to create account and card on application approval
CREATE OR REPLACE TRIGGER createAccountAndCard
AFTER UPDATE ON EBTAPPLICATION
FOR EACH ROW
WHEN (NEW.status = 'APPROVED')
DECLARE
    v_account_id ebtaccount.accountid%TYPE;
    v_card_id ebtcard.cardid%TYPE;
    v_schedule_id ebtschedule.scheduleid%TYPE;
BEGIN
    
    select scheduleid into v_schedule_id from ebtschedule where benefitprogramname = 'EBT Program MA';
    
    --TODO: FURTHER VERIFY FOR SAY IF THE TRIGGER HAS AN ISSUE,IS THE COMMIT HAPPENING ORIS IT ROLLED BACK
    -- Create an account
    addEBTAccount(v_account_id, :NEW.applicationid, v_schedule_id);
    -- Create a card
    addEBTCard(v_account_id);
    DBMS_OUTPUT.PUT_LINE('Your application has been approved. Account and Card created successfully for user!' || :NEW.users_userid);
EXCEPTION
    WHEN OTHERS THEN
        -- Raise custom exception for other errors
        DBMS_OUTPUT.PUT_LINE('Could not create Card and Account..' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20001, 'Could not Create an Account/card due to some reason ' || SQLERRM);
END;
/


--Stored Procedure to insert EBT Schedule
CREATE OR REPLACE PROCEDURE addEBTSchedule (
    p_interval_in_days VARCHAR2,
    p_disbursementfrequency VARCHAR2 DEFAULT 'Monthly',
    p_benefitprogramname VARCHAR2 DEFAULT 'EBT Program MA'
)
AS
BEGIN
    INSERT INTO ebtschedule (
        scheduleid,
        disbursementfrequency,
        nextdisbursementdate,
        benefitprogramname
    )
    VALUES (
        ebtschedule_seq.nextval,
        p_disbursementfrequency,
        SYSDATE + TO_NUMBER(p_interval_in_days),
        p_benefitprogramname
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('EBT Schedule inserted successfully');
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error in the INSERT: ' || SQLERRM);
END;
/

------procedure for blocking or unblocking card
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE BlockOrUnblockCard(
    p_cardNumber VARCHAR2,
    p_blockStatus VARCHAR2
)
AS
BEGIN
    
    IF p_blockStatus IN ('ACTIVE', 'INACTIVE', 'PENDING', 'BLOCKED','LOST') THEN
       
        UPDATE ebtcard
        SET statusofcard = p_blockStatus,
            pin = null
        WHERE cardnumber = p_cardNumber;

        
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Card status updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: Invalid status value provided');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Card with number ' || p_cardNumber || ' not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in the UPDATE: ' || SQLERRM);
END;
/



----------------create pin-------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CreatePin(
    p_cardNumber VARCHAR2,
    p_newPin NUMBER
)
AS
    p_statusofcard VARCHAR2(20);
BEGIN
    
    IF p_newPin IS NOT NULL THEN
       
        SELECT statusofcard INTO p_statusofcard FROM ebtcard WHERE cardnumber = p_cardNumber;
        UPDATE ebtcard
        SET pin = p_newPin,
            statusofcard = 'ACTIVE' 
        WHERE cardnumber = p_cardNumber AND statusofcard != 'BLOCKED';
        
        
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('PIN created and updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: Invalid new PIN provided');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Card with number ' || p_cardNumber || ' not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in the UPDATE: ' || SQLERRM);
END;
/

-----------reset pin------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ResetPin(
    p_cardNumber VARCHAR2,
    p_newPin NUMBER
)
AS
    old_pin NUMBER;
    p_statusofcard VARCHAR(20);
    oldPinError EXCEPTION;
    blockedCardError EXCEPTION;
BEGIN
    
    IF p_newPin IS NOT NULL THEN
        
        SELECT statusofcard INTO p_statusofcard FROM ebtcard WHERE cardnumber = p_cardNumber;
        SELECT pin INTO old_pin FROM ebtcard WHERE cardnumber = p_cardNumber;
        UPDATE ebtcard
        SET pin = p_newPin,
            statusofcard = 'ACTIVE' 
        WHERE cardnumber = p_cardNumber AND statusofcard != 'BLOCKED';
        IF p_statusofcard = 'BLOCKED' THEN 
            RAISE blockedCardError;
        END IF;
        IF old_pin = p_newPin THEN
            RAISE oldPinError;
        END IF;
        
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('PIN reset and updated successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: Invalid new PIN provided');
    END IF;
EXCEPTION
    WHEN oldPinError THEN
        DBMS_OUTPUT.PUT_LINE('Pin already used ');
    WHEN blockedCardError THEN
        DBMS_OUTPUT.PUT_LINE('Card already blocked ');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Card with number ' || p_cardNumber || ' not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in the UPDATE: ' || SQLERRM);
END;
/


------------------lost card----------------------------------------

CREATE OR REPLACE PROCEDURE LostCardAndDisable(
    p_cardNumber VARCHAR2
)
AS
    p_statusofcard VARCHAR(20);
BEGIN
    
    SELECT statusofcard INTO p_statusofcard FROM ebtcard WHERE cardnumber = p_cardNumber;
    UPDATE ebtcard
    SET statusofcard = 'LOST',
        expirydate = SYSDATE, 
        pin = NULL
    WHERE cardnumber = p_cardNumber;

    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Card ' || p_cardNumber || ' marked as lost, disabled, and archived successfully');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Card with number ' || p_cardNumber || ' not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in the UPDATE: ' || SQLERRM);
END;
/



-----------------updating food and card amount-----

CREATE OR REPLACE PROCEDURE UpdateNextDisbursementDate(
    p_benefitprogramname VARCHAR2
)
AS
    
BEGIN
    UPDATE ebtschedule
    SET nextdisbursementdate =
        CASE
            WHEN disbursementfrequency = 'Monthly' THEN ADD_MONTHS(TRUNC(SYSDATE), 1)
            WHEN disbursementfrequency = 'Quarterly' THEN ADD_MONTHS(TRUNC(SYSDATE), 3)
            WHEN disbursementfrequency = 'Yearly' THEN ADD_MONTHS(TRUNC(SYSDATE), 12)
            
            
        END
    WHERE benefitprogramname = p_benefitprogramname;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Next disbursement date updated successfully for ' || p_benefitprogramname);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Benefit program ' || p_benefitprogramname || ' not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in the UPDATE: ' || SQLERRM);
END;
/
----------------------status of account-----
CREATE OR REPLACE PROCEDURE MarkAccountAndCardInactive(
    p_accountNumber VARCHAR2
)
AS
    p_accountid EBTACCOUNT.ACCOUNTID%TYPE;
BEGIN
    
    UPDATE ebtaccount
    SET status = 'INACTIVE'
    WHERE accountnumber = p_accountNumber AND status = 'ACTIVE';
    SELECT accountid INTO p_accountid FROM ebtaccount WHERE accountnumber = p_accountNumber;

    
    UPDATE ebtcard
    SET statusofcard = 'INACTIVE'
    WHERE ebtaccount_accountid = p_accountid;

   
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Account and associated card marked as inactive successfully' || p_accountid);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Account with number ' || p_accountNumber || ' not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in the UPDATE: ' || SQLERRM);
END;
/





CREATE OR REPLACE TRIGGER UpdateAccountsOnDisbursementDateUpdate
AFTER UPDATE ON ebtschedule
FOR EACH ROW
DECLARE
BEGIN
    IF :OLD.nextdisbursementdate != :NEW.nextdisbursementdate THEN
        
        UPDATE ebtaccount
        SET foodbalance = foodbalance + 300,
            cashbalance = cashbalance + 200
        WHERE ebtschedule_scheduleid = :NEW.scheduleid
          AND status = 'ACTIVE';
    END IF;
END;
/



------------view to display active EBT accounts-----------

CREATE OR REPLACE VIEW ActiveEBTAccounts AS
SELECT *
FROM ebtcard
WHERE statusofcard = 'ACTIVE';



---------------------------------------------------------

SET SERVEROUTPUT ON

--view for successful transactions
CREATE OR REPLACE VIEW APPROVED_TRANSACTIONS_VIEW
AS
SELECT * FROM
TRANSACTIONS
WHERE STATUS = 'SUCCESS';

--view for rejected transactions
CREATE OR REPLACE VIEW FAILED_TRANSACTIONS_VIEW
AS
SELECT * FROM
TRANSACTIONS
WHERE STATUS = 'FAILURE';

--view for Merchant transaction details
CREATE OR REPLACE VIEW MERCHANT_TRANSACTION_DETAILS
AS
SELECT  U.FIRSTNAME||' '||U.LASTNAME CUSTOMER_NAME, T.TRANSACTIONID, T.AMOUNT, T.STATUS, T.RECORDED_DATE, M.TYPE MERCHANT_TYPE, M.NAME MERCHANT_NAME
FROM TRANSACTIONS T
INNER JOIN MERCHANT M
ON M.MERCHANTID = T.MERCHANT_MERCHANTID
INNER JOIN EBTCARD C
ON C.CARDID = T.EBTCARD_CARDID
INNER JOIN EBTACCOUNT A
ON A.ACCOUNTID = C.EBTACCOUNT_ACCOUNTID
INNER JOIN EBTAPPLICATION EA
ON EA.APPLICATIONID = A.EBTAPPLICATION_APPLICATIONID
INNER JOIN USERS U
ON U.USERID = EA.USERS_USERID;

--view of eligible items
CREATE OR REPLACE VIEW ELIGIBLE_ITEMS_VIEW
AS
SELECT * FROM 
ITEM
WHERE ELIGIBILITY = 'Y';

--view of active merchants
CREATE OR REPLACE VIEW ACTIVE_MERCHANTS_VIEW
AS
SELECT * FROM 
MERCHANT
WHERE ARCHIVE = 'N';

--view of in-active merchants
CREATE OR REPLACE VIEW INACTIVE_MERCHANTS_VIEW
AS
SELECT * FROM 
MERCHANT
WHERE ARCHIVE = 'Y';

--function to check item existence
CREATE OR REPLACE FUNCTION CheckItemExistence(pi_Name VARCHAR) RETURN NUMBER
AS 
itemExists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO itemExists
    FROM Item
    WHERE UPPER(Name) = UPPER(pi_Name);
    RETURN itemExists;
END CheckItemExistence;
/

--stored procedure to add or update item
CREATE OR REPLACE PROCEDURE AddOrUpdateItem(
    pi_Name VARCHAR2,
    pi_UPC VARCHAR2,
    pi_Price NUMBER,
    pi_Description VARCHAR2,
    pi_Eligibility VARCHAR2
)
AS
    itemExists NUMBER;
	e_invalid_price EXCEPTION;
BEGIN
	-- check if price is valid
	IF pi_Price <= 0 THEN
		RAISE e_invalid_price;
    END IF;
    -- Check if the item already exists
    itemExists := CheckItemExistence(pi_Name);

    IF itemExists = 0 THEN
        -- Item does not exist, insert new record
        INSERT INTO Item (ItemID, Name, UPC, Price, Description, Eligibility)
        VALUES (ITEM_SEQ.nextval, pi_Name, pi_UPC, pi_Price, pi_Description, pi_Eligibility);
        COMMIT;
    ELSE
        -- Item exists, update the existing record
        UPDATE Item
        SET Name = pi_Name,
            UPC = pi_UPC,
            Price = pi_Price,
            Description = pi_Description,
            Eligibility = pi_Eligibility
        WHERE UPPER(Name) = UPPER(pi_Name);
        COMMIT;
    END IF;
EXCEPTION
	WHEN e_invalid_price THEN
		DBMS_OUTPUT.PUT_LINE('Enter a valid price!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END AddOrUpdateItem;
/

--function to check merchant existence
CREATE OR REPLACE FUNCTION CheckMerchantExistence(pi_Name VARCHAR) RETURN NUMBER
AS 
merchantExists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO merchantExists
    FROM Merchant
    WHERE UPPER(Name) = UPPER(pi_Name);
    RETURN merchantExists;
END CheckMerchantExistence;
/

--stored procedure to add or update merchant
CREATE OR REPLACE PROCEDURE AddOrUpdateMerchant(
    pi_Type VARCHAR2,
    pi_Name VARCHAR2,
    pi_Address VARCHAR2,
    pi_AccountNumber VARCHAR2,
    pi_RoutingNumber VARCHAR2,
	pi_Archive VARCHAR2
)
AS
    merchantExists NUMBER;
	e_invalid_type EXCEPTION;
BEGIN
	-- check if merchant type is store or ATM
	IF pi_Type <> 'Store' AND pi_Type <> 'ATM' THEN
		RAISE e_invalid_type;
	END IF;
	
    -- Check if the merchant already exists
    merchantExists := CheckMerchantExistence(pi_Name);

    IF merchantExists = 0 THEN
        -- Merchant does not exist, insert new record
        INSERT INTO Merchant (MerchantID, Type, Name, Address, AccountNumber, RoutingNumber, Archive)
        VALUES (MERCHANT_SEQ.nextval, pi_Type, pi_Name, pi_Address, pi_AccountNumber, pi_RoutingNumber, pi_Archive);
        COMMIT;
    ELSE
        -- Merchant exists, update the existing record
        UPDATE Merchant
        SET Type = pi_Type,
            Name = pi_Name,
            Address = pi_Address,
            AccountNumber = pi_AccountNumber,
            RoutingNumber = pi_RoutingNumber,
			Archive = pi_Archive
        WHERE UPPER(Name) = UPPER(pi_Name);
        COMMIT;
    END IF;
EXCEPTION
	WHEN e_invalid_type THEN
		DBMS_OUTPUT.PUT_LINE('Merchant type is invalid! It can be either `Store` or `ATM` only');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END AddOrUpdateMerchant;
/

--ebtaccount_balance_view
CREATE OR REPLACE VIEW ebtaccount_balance_view AS
SELECT
    ea.accountid,
    ea.accountnumber,
    u.firstname,
    u.ssn,
    ea.foodbalance,
    ea.cashbalance,
    ea.foodbalance + ea.cashbalance AS totalbalance
FROM
    VIEW_EBTACCOUNT ea
JOIN 
    view_ebtapplication eap
ON 
    ea.ebtapplication_applicationid = eap.applicationid
JOIN 
    view_users u
ON
    eap.users_userid = u.userid;
    

--function to check user balance
CREATE OR REPLACE FUNCTION CheckUserBalance(pi_accountnumber VARCHAR) RETURN NUMBER
AS
    userBalance NUMBER;
BEGIN
    SELECT totalbalance INTO userBalance
    FROM ebtaccount_balance_view
    WHERE accountnumber = pi_accountnumber;
    RETURN userBalance;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END CheckUserBalance;
/


--function to check transaction eligibility at store
CREATE OR REPLACE FUNCTION CheckStoreTransactionEligibility(
    pi_CardID NUMBER,
    pi_MerchantID NUMBER,
    pi_ItemID NUMBER
)
RETURN NUMBER
AS
    isEligible NUMBER;
    v_expiry_dt DATE;
BEGIN
    -- Check if the EBT card is active
    SELECT CASE
        WHEN StatusOfCard = 'ACTIVE' AND ExpiryDate >= SYSDATE THEN 1
        ELSE 0
    END INTO isEligible
    FROM EBTCard
    WHERE CardID = pi_CardID;

    -- To extract expiry date of the card
	SELECT ExpiryDate INTO v_expiry_dt
	FROM EBTCard 
	WHERE CardID = pi_CardID;
	
	-- updating card status as inactive if expiry date is expired
	IF v_expiry_dt < SYSDATE THEN
		UPDATE EBTCard 
		SET StatusOfCard = 'INACTIVE'
		WHERE CardID = pi_CardID;
        COMMIT;
    END IF;
    
    -- Check if the merchant is eligible
    IF isEligible = 1 THEN
        SELECT CASE
            WHEN Archive = 'N' AND Type='Store' THEN 1 ELSE 0
        END INTO isEligible
        FROM Merchant
        WHERE MerchantID = pi_MerchantID;
    END IF;

    -- Check if the item is eligible 
    IF isEligible = 1 THEN
        SELECT CASE
            WHEN Eligibility = 'Y' THEN 1 ELSE 0
        END INTO isEligible
        FROM Item
        WHERE ItemID = pi_ItemID;
    END IF;
    RETURN isEligible;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END CheckStoreTransactionEligibility;
/

--function to check transaction eligibility at ATM
CREATE OR REPLACE FUNCTION CheckATMTransactionEligibility(
    pi_CardID NUMBER,
    pi_MerchantID NUMBER
)
RETURN NUMBER
AS
    isEligible NUMBER;
	v_expiry_dt DATE;
BEGIN
    -- Check if the EBT card is active
    SELECT CASE
        WHEN StatusOfCard = 'ACTIVE' AND ExpiryDate >= SYSDATE THEN 1
        ELSE 0
    END INTO isEligible
    FROM EBTCard
    WHERE CardID = pi_CardID;
	
	-- To extract expiry date of the card
	SELECT ExpiryDate INTO v_expiry_dt
	FROM EBTCard 
	WHERE CardID = pi_CardID;
	
	-- updating card status as inactive if expiry date is expired
	IF v_expiry_dt < SYSDATE THEN
		UPDATE EBTCard 
		SET StatusOfCard = 'INACTIVE'
		WHERE CardID = pi_CardID;
    END IF;
    
    -- Check if the merchant is eligible
    IF isEligible = 1 THEN
        SELECT CASE
            WHEN Archive = 'N' AND Type = 'ATM' THEN 1 ELSE 0
        END INTO isEligible
        FROM Merchant
        WHERE MerchantID = pi_MerchantID;
    END IF;

    RETURN isEligible;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END CheckATMTransactionEligibility;
/


-- stored procedure to initiate transaction at store
CREATE OR REPLACE PROCEDURE InitiateTransactionAtStore(
    pi_CardID NUMBER,
    pi_MerchantID NUMBER,
    pi_ItemID NUMBER,
    pi_Quantity NUMBER
)
AS
    v_TransactionID NUMBER;
    v_ItemPrice NUMBER;
    v_amount NUMBER := 0;
    v_foodBalance_check NUMBER;
    e_insufficient_food_balance EXCEPTION;
	e_invalid_qty EXCEPTION;
BEGIN
	-- check for valid quantity
	IF pi_Quantity <=0 THEN
		RAISE e_invalid_qty;
	END IF;
    -- Check transaction eligibility
    IF CheckStoreTransactionEligibility(pi_CardID, pi_MerchantID, pi_ItemID) = 1 THEN
        -- Get item price
        SELECT Price INTO v_ItemPrice
        FROM Item
        WHERE ItemID = pi_ItemID;

        -- Calculate amount
        v_amount := v_ItemPrice * pi_Quantity;
        
        -- check food balance
        SELECT CASE WHEN FoodBalance >= v_amount THEN 1 ELSE 0 END INTO v_foodBalance_check
        FROM EBTAccount A
        INNER JOIN EBTCard C
        ON C.EBTAccount_AccountID = A.AccountID
        WHERE C.CardID = pi_CardID;
        
        IF v_foodBalance_check = 1 THEN
            -- Insert transaction record
            INSERT INTO Transactions (TransactionID, Amount, Status, Recorded_Date, Merchant_MerchantID, EBTCard_CardID)
            VALUES (TRANSACTIONS_SEQ.nextval, v_amount, 'SUCCESS', SYSDATE, pi_MerchantID, pi_CardID)
            RETURNING TransactionID INTO v_TransactionID;
            
            -- Record transaction item list
            INSERT INTO TransactionItemList (TransactionItemID, Quantity, Item_ItemID, Transactions_TransactionID)
            VALUES (TransactionItemList_seq.nextval, pi_Quantity, pi_ItemID, v_TransactionID);

            -- Update EBT account balance
            UPDATE EBTAccount
            SET FoodBalance = FoodBalance - v_amount
            WHERE AccountID = (SELECT EBTAccount_AccountID 
                                FROM EBTCard 
                                WHERE CardID = pi_CardID);
            
            COMMIT;
        ELSE 
            RAISE e_insufficient_food_balance;
        END IF;
    ELSE
        -- Handle ineligible transaction
        INSERT INTO Transactions (TransactionID, Amount, Status, Recorded_Date, Merchant_MerchantID, EBTCard_CardID)
        VALUES (TRANSACTIONS_SEQ.nextval, v_amount, 'FAILURE', SYSDATE, pi_MerchantID, pi_CardID);
        DBMS_OUTPUT.PUT_LINE('Transaction is not eligible.');
        COMMIT;
    END IF;
EXCEPTION
	WHEN e_invalid_qty THEN
		DBMS_OUTPUT.PUT_LINE('Please enter a valid quantity');
    WHEN e_insufficient_food_balance THEN
        DBMS_OUTPUT.PUT_LINE('Your Food Balance is Insufficient to make a transaction');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InitiateTransactionAtStore;
/

-- stored procedure to initiate transaction at ATM
CREATE OR REPLACE PROCEDURE InitiateTransactionAtATM(
    pi_CardID NUMBER, 
    pi_MerchantID NUMBER,
    pi_Amount NUMBER DEFAULT 0
)
AS
    v_cashBalance_check NUMBER;
    e_insufficient_cash_balance EXCEPTION;
    e_invalid_amount EXCEPTION;
BEGIN
    -- Check transaction eligibility
    IF CheckATMTransactionEligibility(pi_CardID, pi_MerchantID) = 1 THEN
       
        --check for valid amount
        IF pi_Amount < 0 THEN
            RAISE e_invalid_amount;
        END IF;
        
        -- check food balance
        SELECT CASE WHEN CashBalance >= pi_Amount THEN 1 ELSE 0 END INTO v_cashBalance_check
        FROM EBTAccount A
        INNER JOIN EBTCard C
        ON C.EBTAccount_AccountID = A.AccountID
        WHERE C.CardID = pi_CardID;
        
        IF v_cashBalance_check = 1 THEN
            
            -- Insert transaction record
            INSERT INTO Transactions (TransactionID, Amount, Status, Recorded_Date, Merchant_MerchantID, EBTCard_CardID)
            VALUES (TRANSACTIONS_SEQ.nextval, pi_Amount, 'SUCCESS', SYSDATE, pi_MerchantID, pi_CardID);
                
            -- Update EBT account balance
            UPDATE EBTAccount
            SET CashBalance = CashBalance - pi_Amount
            WHERE AccountID = (SELECT EBTAccount_AccountID 
                                FROM EBTCard 
                                WHERE CardID = pi_CardID);
                                    
            COMMIT;
        ELSE
            RAISE e_insufficient_cash_balance;
        END IF;
    ELSE
         -- Handle ineligible transaction
        INSERT INTO Transactions (TransactionID, Amount, Status, Recorded_Date, Merchant_MerchantID, EBTCard_CardID)
        VALUES (TRANSACTIONS_SEQ.nextval, pi_Amount, 'FAILURE', SYSDATE, pi_MerchantID, pi_CardID);
        DBMS_OUTPUT.PUT_LINE('Transaction is not eligible.');
        COMMIT;
    END IF;
EXCEPTION
    WHEN e_invalid_amount THEN
        DBMS_OUTPUT.PUT_LINE('Enter a valid amount');
    WHEN e_insufficient_cash_balance THEN
        DBMS_OUTPUT.PUT_LINE('Your Cash Balance is Insufficient to make a transaction');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END InitiateTransactionAtATM;
/


-- Trigger to alert Low Balance to the user 
CREATE OR REPLACE TRIGGER LowBalanceAlertTrigger
AFTER UPDATE ON EBTAccount
FOR EACH ROW
DECLARE
    v_ThresholdBalance NUMBER := 10; 
BEGIN
    IF (:NEW.FoodBalance + :NEW.CashBalance)<= v_ThresholdBalance AND (:OLD.FoodBalance + :OLD.CashBalance) >= v_ThresholdBalance THEN      
        DBMS_OUTPUT.PUT_LINE('Low Balance Alert: Dear Customer, your EBT account ending with '||SUBSTR(:NEW.AccountNumber,-5) ||' has low balance.');      
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END LowBalanceAlertTrigger;
/

---Report gives the no of transactions made and total amount spent on food at store and cash drawn at ATM by each customer

CREATE OR REPLACE VIEW CUST_FOOD_VS_CASH_VIEW
AS
select ft.userid, ft.customer_name, ft.no_of_food_transactions, ft.food_amount_spent, at.no_of_atm_transactions, at.ATM_amount_spent
from
(select u.userid, u.firstname||' '||u.lastname customer_name, count(*) no_of_food_transactions, sum(t.amount) as food_amount_spent
from transactions t
left join ebtcard c
on c.cardid = t.ebtcard_cardid
left join ebtaccount a
on a.accountid = c.ebtaccount_accountid
left join ebtapplication ap
on ap.applicationid = a.ebtapplication_applicationid
left join users u
on u.userid = ap.users_userid
where t.merchant_merchantid in (select merchantid 
                                from merchant 
                                where type = 'Store')
and t.status = 'SUCCESS'
group by u.userid, u.firstname||' '||u.lastname) ft
left join
(select u.userid, u.firstname||' '||u.lastname customer_name,count(*) no_of_atm_transactions, sum(t.amount) as ATM_amount_spent
from transactions t
left join ebtcard c
on c.cardid = t.ebtcard_cardid
left join ebtaccount a
on a.accountid = c.ebtaccount_accountid
left join ebtapplication ap
on ap.applicationid = a.ebtapplication_applicationid
left join users u
on u.userid = ap.users_userid
where t.merchant_merchantid in (select merchantid 
                                from merchant 
                                where type = 'ATM')
and t.status = 'SUCCESS'
group by u.userid, u.firstname||' '||u.lastname) at
on at.userid = ft.userid
and at.customer_name = ft.customer_name
order by userid;

--transaction_summary_view
CREATE or replace VIEW transaction_summary_view AS
SELECT
    t.transactionid,
    u.firstname,
    u.email,
    t.status,
    t.recorded_date,
    t.merchant_merchantid,
    t.ebtcard_cardid,
    til.quantity,
    til.item_itemid,
    i.name AS item_name,
    i.price AS item_price,
    (til.quantity * i.price) AS subtotal
FROM
    view_transactions t
JOIN
    view_transactionitemlist til ON t.transactionid = til.transactions_transactionid
JOIN
    view_item i ON til.item_itemid = i.itemid
JOIN 
    view_ebtcard ec on ec.cardid = t.ebtcard_cardid
JOIN 
    view_ebtapplication eap on eap.applicationid = ec.ebtaccount_accountid
JOIN 
    view_users u on u.userid = eap.users_userid;
    
    
---Report gives the item wise total quantity and total amount

CREATE OR REPLACE VIEW ITEM_QTY_VS_AMOUNT_VIEW
AS
select Item_Name, Item_price, sum(subtotal) total
from transaction_summary_view
group by Item_Name, Item_price
order by total desc;

--Report gives overall successful and failed transactions

CREATE OR REPLACE VIEW COUNT_SUCCESS_FAIL_TRANSACTION_VIEW
AS
select 'SUCCESS' transaction_status , count(transactionid) no_of_transactions
from transactions
where status = 'SUCCESS'
union all
select 'FALIED' transaction_status, count(transactionid) no_of_transactions
from transactions
where status = 'FAILURE';

--------------------------

-- select * from ebtaccount_balance_view;
   
--pending_ebt_applications_view
CREATE OR REPLACE VIEW pending_ebt_applications_view AS
SELECT
    e.applicationid,
    e.benefitprogramname,
    e.status,
    e.users_userid,
    u.firstname,
    u.email,
    e.admin_adminid
FROM
    view_ebtapplication e
JOIN view_users u
ON e.users_userid = u.userid
WHERE
    e.status = 'Pending' or e.status = 'PENDING';


--last_month_summary_view
CREATE OR REPLACE VIEW monthly_application_counts AS
SELECT
    TO_CHAR(created_at, 'YYYY-MM') AS month,
    COUNT(*) AS created_count,
    SUM(CASE WHEN status = 'REJECTED' THEN 1 ELSE 0 END) AS REJECTED_APPLICATIONS,
    SUM(CASE WHEN status = 'APPROVED' THEN 1 ELSE 0 END) AS APPROVED_APPLICATIONS

FROM
    EBTAPPLICATION
GROUP BY
    TO_CHAR(created_at, 'YYYY-MM');

--Analysis
CREATE OR REPLACE VIEW age_view AS
WITH age_categories AS (
    SELECT
        u.userid,
        CASE
            WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.dob) < 5 THEN 'Younger than 5 years'
            WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.dob) BETWEEN 5 AND 17 THEN '5 through 17'
            WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.dob) BETWEEN 18 AND 35 THEN '18 through 35'
            WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.dob) BETWEEN 36 AND 59 THEN '36 through 59'
            ELSE 'Elderly (60 or More)'
        END AS age_category
    FROM
        users u
)
SELECT
    ac.age_category,
    COUNT(*) AS total_applications,
    COUNT(CASE WHEN e.status = 'APPROVED' THEN 1 END) AS total_approved,
    COUNT(CASE WHEN e.status = 'REJECTED' THEN 1 END) AS total_rejected,
    COUNT(CASE WHEN e.status IN ('APPROVED', 'REJECTED') THEN 1 END) AS total_success,
    (COUNT(*) / (SELECT COUNT(*) FROM ebtapplication) * 100) AS percentage_total,
    (COUNT(CASE WHEN e.status = 'APPROVED' THEN 1 END) / COUNT(*) * 100) AS percentage_approved,
    (COUNT(CASE WHEN e.status = 'REJECTED' THEN 1 END) / COUNT(*) * 100) AS percentage_rejected
FROM
    age_categories ac
    JOIN ebtapplication e ON ac.userid = e.users_userid
GROUP BY
    ac.age_category;


/*
 select * from transaction_summary_view;
 select * from ebtaccount_balance_view;
 select * from pending_ebt_applications_view;
 select * from monthly_application_counts;
 select * from age_view;
 */

 
CREATE OR REPLACE VIEW card_status_counts AS
SELECT
    COUNT(CASE WHEN statusofcard = 'LOST' THEN 1 END) AS lost_count,
    COUNT(CASE WHEN statusofcard = 'INACTIVE' THEN 1 END) AS inactive_count,
    COUNT(CASE WHEN statusofcard = 'ACTIVE' THEN 1 END) AS active_count,
    COUNT(CASE WHEN statusofcard = 'PENDING' THEN 1 END) AS pending_count,
    COUNT(CASE WHEN statusofcard = 'BLOCKED' THEN 1 END) AS blocked_count
FROM
    ebtcard;
    
--SELECT * FROM card_status_counts;

----------------------------------

CREATE OR REPLACE PACKAGE user_management_pkg AS
    -- Procedure to validate user login
    PROCEDURE userLogin (
        p_userid users.userid%type,
        p_password users.password%type
    );

    -- Procedure to reset user password
    PROCEDURE resetPassword (
        p_userid users.userid%type,
        p_new_password users.password%type
    );

    -- Procedure to update user details
    PROCEDURE updateUserDetails (
        p_userid users.userid%type,
        p_firstname users.firstname%type,
        p_lastname users.lastname%type,
        p_ssn users.ssn%type,
        p_address users.address%type,
        p_phone users.phone%type,
        p_email users.email%type
    );
END user_management_pkg;
/

CREATE OR REPLACE PACKAGE BODY user_management_pkg AS
    -- Procedure to validate user login
    PROCEDURE userLogin (
        p_userid users.userid%type,
        p_password users.password%type
    )
    AS
        v_stored_password users.password%type;
    BEGIN
        -- Retrieve the stored password for the given userid
        SELECT password INTO v_stored_password
        FROM users
        WHERE userid = p_userid;

        -- Check if the retrieved password matches the provided password
        IF v_stored_password = p_password THEN
            DBMS_OUTPUT.PUT_LINE('Login successful');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error: Incorrect password');
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: User not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END userLogin;

    -- Procedure to reset user password
    PROCEDURE resetPassword (
        p_userid users.userid%type,
        p_new_password users.password%type
    )
    AS
        -- Custom exception for weak password
        WeakPassword EXCEPTION;
    BEGIN
        -- Validate password complexity
        IF NOT REGEXP_LIKE(p_new_password, '^[a-zA-Z][a-zA-Z0-9@$!%*?&]{7,}$') THEN
            -- Raise WeakPassword exception
            RAISE WeakPassword;
        END IF;

        -- Update the password for the given userid
        UPDATE users
        SET password = p_new_password
        WHERE userid = p_userid;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Password reset successful');
    EXCEPTION
        WHEN WeakPassword THEN
            DBMS_OUTPUT.PUT_LINE('Error: Weak password');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: User not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END resetPassword;

    -- Procedure to update user details
    PROCEDURE updateUserDetails (
        p_userid users.userid%type,
        p_firstname users.firstname%type,
        p_lastname users.lastname%type,
        p_ssn users.ssn%type,
        p_address users.address%type,
        p_phone users.phone%type,
        p_email users.email%type
    )
    AS
        -- Custom exceptions
        InvalidEmail EXCEPTION;
        InvalidSSN EXCEPTION;
        InvalidPhone EXCEPTION;
    BEGIN
        -- Validate email format
        IF p_email IS NULL OR NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
            -- Raise InvalidEmail exception
            RAISE InvalidEmail;
        END IF;

        -- Validate SSN format (assuming SSN is in the format 'XXX-XX-XXXX')
        IF NOT REGEXP_LIKE(p_ssn, '^\d{3}-\d{2}-\d{4}$') THEN
            -- Raise InvalidSSN exception
            RAISE InvalidSSN;
        END IF;

        -- Validate phone number format (assuming 10-digit string format)
        IF NOT REGEXP_LIKE(p_phone, '^\d{10}$') THEN
            -- Raise InvalidPhone exception
            RAISE InvalidPhone;
        END IF;

        -- Update user details
        UPDATE users
        SET 
            firstname = p_firstname,
            lastname = p_lastname,
            ssn = p_ssn,
            address = p_address,
            phone = p_phone,
            email = p_email
        WHERE userid = p_userid;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('User details updated successfully');
    EXCEPTION
        WHEN InvalidEmail THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid email format');
        WHEN InvalidSSN THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid SSN format');
        WHEN InvalidPhone THEN
            DBMS_OUTPUT.PUT_LINE('Error: Invalid phone format');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: User not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END updateUserDetails;
END user_management_pkg;
/




--BEGIN
--    user_management_pkg.userLogin(416, 'Su5XdlEP');
--    user_management_pkg.resetPassword(414, 'Strong@Password123');
--END;
--/

