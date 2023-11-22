-- Insert into users table
SET SERVEROUTPUT ON

-- Stored Proecdure to insert the Admin,  based on the buisness rules few constraints have been added --

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

    -- Custom exceptions
    InvalidEmail EXCEPTION;
    InvalidSSN EXCEPTION;
    WeakPassword EXCEPTION;
    InvalidPhone EXCEPTION;

BEGIN
    -- Validate email format
    IF email IS NULL OR NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
        -- Raise InvalidEmail exception
        RAISE InvalidEmail;
    END IF;

    -- Validate SSN format (assuming SSN is in the format 'XXX-XX-XXXX')
    IF NOT REGEXP_LIKE(ssn, '^\d{3}-\d{2}-\d{4}$') THEN
        -- Raise InvalidSSN exception
        RAISE InvalidSSN;
    END IF;

    -- Validate phone number format (assuming US phone number format '(XXX) XXX-XXXX')
    IF NOT REGEXP_LIKE(phone, '^\d{10}$') THEN
        -- Raise InvalidPhone exception
        RAISE InvalidPhone;
    END IF;

    -- Validate password complexity
    IF NOT REGEXP_LIKE(password, '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$') THEN
        -- Raise WeakPassword exception
        RAISE WeakPassword;
    END IF;

    -- If all validations pass, proceed with the insertion
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

-- Stored Proecdure to insert the User,  based on the buisness rules constraints have been added --

CREATE OR REPLACE PROCEDURE insertUser (
    p_firstname users.firstname%type,
    p_lastname users.lastname%type,
    p_ssn users.ssn%type,
    p_address users.address%type,
    p_phone users.phone%type,
    p_email users.email%type,
    p_password users.password%type
)
AS
    v_userid NUMBER;

    -- Custom exceptions
    InvalidEmail EXCEPTION;
    InvalidSSN EXCEPTION;
    WeakPassword EXCEPTION;
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

    -- Validate phone number format (assuming 9-digit string format)
    IF NOT REGEXP_LIKE(p_phone, '^\d{10}$') THEN
        -- Raise InvalidPhone exception
        RAISE InvalidPhone;
    END IF;

    -- Validate password complexity
    IF NOT REGEXP_LIKE(p_password, '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$') THEN
        -- Raise WeakPassword exception
        RAISE WeakPassword;
    END IF;

    -- If all validations pass, proceed with the insertion
    SELECT users_seq.nextval INTO v_userid FROM dual;

    INSERT INTO users (
        userid,
        firstname,
        lastname,
        ssn,
        address,
        phone,
        email,
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
        p_password
    );

    COMMIT; -- Adding a COMMIT to persist changes to the database

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


CREATE OR REPLACE PROCEDURE insertEBTApplication (
    p_proofofincome EBTAPPLICATION.proofofincome%TYPE,
    p_immigrationproof EBTAPPLICATION.immigrationproof%TYPE,
    p_proofofresidence EBTAPPLICATION.proofofresidence%TYPE,
    p_proofofidentity EBTAPPLICATION.proofofidentity%TYPE,
    p_status EBTAPPLICATION.status%TYPE,
    p_users_userid EBTAPPLICATION.users_userid%TYPE,
    p_admin_adminid EBTAPPLICATION.admin_adminid%TYPE
)
AS
    v_pending_count NUMBER;
BEGIN
    -- Check if there is an existing record for the given user with a 'Pending' status
    SELECT COUNT(*)
    INTO v_pending_count
    FROM EBTAPPLICATION
    WHERE users_userid = p_users_userid AND status = 'Pending';

    -- If no existing record with a 'Pending' status, then insert the new record
    IF v_pending_count = 0 THEN
        INSERT INTO EBTAPPLICATION (
            applicationid,
            proofofincome,
            immigrationproof,
            proofofresidence,
            proofofidentity,
            benefitprogramname,
            status,
            users_userid,
            admin_adminid
        )
        VALUES (
            ebtapplication_seq.nextval,
            p_proofofincome,
            p_immigrationproof,
            p_proofofresidence,
            p_proofofidentity,
            'EBT Program MA',
            p_status,
            p_users_userid,
            p_admin_adminid
        );

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('EBT Application inserted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('EBT Application not inserted. An existing record with Pending status already exists for the user.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/






CREATE OR REPLACE PROCEDURE insertEBTSchedule (
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




CREATE OR REPLACE PROCEDURE insertEBTAccount (
    p_accountnumber ebtaccount.accountnumber%TYPE,
    p_foodbalance ebtaccount.foodbalance%TYPE,
    p_cashbalance ebtaccount.cashbalance%TYPE,
    p_ebtapplication_applicationid ebtaccount.ebtapplication_applicationid%TYPE,
    p_ebtschedule_scheduleid ebtaccount.ebtschedule_scheduleid%TYPE
)
AS
BEGIN
    INSERT INTO ebtaccount (
        accountid,
        accountnumber,
        foodbalance,
        cashbalance,
        ebtapplication_applicationid,
        ebtschedule_scheduleid
    )
    VALUES (
        ebtaccount_seq.nextval,
        p_accountnumber,
        p_foodbalance,
        p_cashbalance,
        p_ebtapplication_applicationid,
        p_ebtschedule_scheduleid
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('EBT Account inserted successfully');
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error in the INSERT: ' || SQLERRM);
END;
/




CREATE OR REPLACE PROCEDURE insertEBTCard (
    p_cardnumber ebtcard.cardnumber%TYPE,
    p_activationdate ebtcard.activationdate%TYPE,
    p_statusofcard ebtcard.statusofcard%TYPE,
    p_pin ebtcard.pin%TYPE,
    p_expirydate ebtcard.expirydate%TYPE,
    p_ebtaccount_accountid ebtcard.ebtaccount_accountid%TYPE
)
AS
    v_existing_count NUMBER;
BEGIN
    -- Check if the card number already exists
    SELECT COUNT(*)
    INTO v_existing_count
    FROM ebtcard
    WHERE cardnumber = p_cardnumber;

    -- Raise exception if the card number is not unique
    IF v_existing_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: There is an existing card with same number');
    END IF;

    -- Check if the user already has an active card
    SELECT COUNT(*)
    INTO v_existing_count
    FROM ebtcard
    WHERE ebtaccount_accountid = p_ebtaccount_accountid
      AND statusofcard = 'Active';

    -- Raise exception if the user already has an active card
    IF v_existing_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: User already has an active card');
    END IF;

    -- Card number is unique, and the user doesn't have an active card, proceed with the insertion
    INSERT INTO ebtcard (
        cardid,
        cardnumber,
        activationdate,
        statusofcard,
        pin,
        expirydate,
        ebtaccount_accountid
    )
    VALUES (
        ebtcard_seq.nextval,
        p_cardnumber,
        p_activationdate,
        p_statusofcard,
        p_pin,
        p_expirydate,
        p_ebtaccount_accountid
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('EBT Card inserted successfully');
EXCEPTION
    WHEN OTHERS THEN 
        -- Raise exception for other errors
        RAISE_APPLICATION_ERROR(-20003, 'Error in the INSERT: ' || SQLERRM);
END;
/




BEGIN
insertAdmin('AdminOne', 'Doe', '123-45-6789', '123 Main St', '5551234517', 'AdminOne.doe@email.com', 'P@ss1234');
insertAdmin('AdminTwo', 'M', '987-65-4321', '456 Oak St', '5551284567', 'AdminTwo.M@email.com', 'P@ss1234');
insertAdmin('Admin Three', 'K', '987-95-5421', '456 Oak St', '5551734567', 'AdminThree.K@email.com', 'P@ss1234');
insertAdmin( 'Admin Four', 'M', '987-95-2321', '456 Oak St', '5551264567', 'AdminFour.M@email.com', 'P@ss1234');
insertAdmin('Admin Five', 'Kanchi', '987-75-4121', '456 Oak St', '5551434567', 'AdminFive.Kanchi@email.com', 'P@ss1234');

END;
/

SELECT * FROM ADMIN;

BEGIN
    insertUser('Sanjana', 'Doe', '123-45-6789', '123 Main St', '5551239476', 'sanjana.doe@email.com', 'P@ss1234');
    insertUser( 'Sai Kiran', 'M', '987-65-4321', '456 Oak St', '5555678776', 'kiran.M@email.com', 'P@ss1234');
    insertUser('Mithali', 'K', '987-95-5421', '456 Oak St', '5557778901', 'mithali.K@email.com', 'P@ss1234');
    insertUser('Sravanti', 'M', '987-95-2321', '456 Oak St', '5555678101', 'sravanti.M@email.com', 'P@ss1234');
    insertUser('Sravya', 'K', '987-75-4121', '456 Oak St', '5555678202', 'sravya.K@email.com', 'P@ss1234'); 
END;
/

SELECT * FROM USERS;

BEGIN
insertEBTApplication(utl_raw.cast_to_raw('proof of income'), empty_blob(), empty_blob(), empty_blob(), 'Approved', 1, 1);
insertebtapplication( utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration') ,  utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'), 'Approved', 2, 2);
insertebtapplication( utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration') ,  utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'), 'Rejected', 3, 3);
insertebtapplication(utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration') ,  utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'), 'Approved', 4, 4);
insertebtapplication( utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration') ,  utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'), 'Pending', 5, 5);
END;
/

SELECT * FROM EBTAPPLICATION;


BEGIN
    insertEBTSchedule('30'); -- Add your desired interval in days
END;
/

SELECT * FROM ebtschedule;


BEGIN
        insertEBTAccount( 'E123456', 500.00, 100.00, 1, 1);
        insertEBTAccount( 'E234567', 800.00, 200.00, 2, 1);
       insertEBTAccount ('E345678', 600.00, 150.00, 4, 1);
END;
/

SELECT * FROM ebtaccount;

BEGIN
      insertEBTCard( '5678901234567890', SYSDATE, 'Inactive', 8765, SYSDATE + 365, 2);
      insertEBTCard('4567890123456789', SYSDATE, 'InActive', 4321, SYSDATE + 365, 1);
      insertEBTCard ('3456789012345678', SYSDATE, 'Active', 9876, SYSDATE + 365, 3);
      insertEBTCard( '1234567890123456', SYSDATE, 'Active', 1234, SYSDATE + 365, 1);
      insertEBTCard( '2345678901234567', SYSDATE, 'Active', 5678, SYSDATE + 365, 2);

END;
/
SELECT * FROM ebtcard;





