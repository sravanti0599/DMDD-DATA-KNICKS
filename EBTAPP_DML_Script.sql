ALTER SESSION SET CURRENT_SCHEMA = EBTAPP;
SET SERVEROUTPUT ON;

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
    -- Validate email format
    IF email IS NULL OR NOT REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
        RAISE InvalidEmail;
    END IF;

    -- Validate SSN format (assuming SSN is in the format 'XXX-XX-XXXX')
    IF NOT REGEXP_LIKE(ssn, '^\d{3}-\d{2}-\d{4}$') THEN
        RAISE InvalidSSN;
    END IF;

    -- Validate phone number format (assuming US phone number format '(')
    IF NOT REGEXP_LIKE(phone, '^\d{10}$') THEN
        -- Raise InvalidPhone exception
        RAISE InvalidPhone;
    END IF;

    -- Validate password complexity
    IF NOT REGEXP_LIKE(password, '^[a-zA-Z][a-zA-Z0-9@$!%*?&]{7,}$') THEN
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

-- Stored Procedure to adminLogin
CREATE OR REPLACE PROCEDURE adminLogin (
    p_adminid admins.adminid%type,
    p_password admins.password%type
)
AS
    v_stored_password admins.password%type;
BEGIN
    -- Retrieve the stored password for the given adminid
    SELECT password INTO v_stored_password
    FROM admins
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
    p_adminid admins.adminid%type,
    p_new_password admins.password%type
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
    UPDATE admins
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
    p_adminid admins.adminid%type,
    p_firstname admins.firstname%type,
    p_lastname admins.lastname%type,
    p_email admins.email%type,
    p_phone admins.phone%type
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
    UPDATE admins
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
    IF NOT REGEXP_LIKE(p_password, '^[a-zA-Z][a-zA-Z0-9@$!%*?&]{7,}$') THEN
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
    PendingApplicationExists EXCEPTION;
BEGIN
    SELECT COUNT(*)
    INTO v_pending_count
    FROM EBTAPPLICATION
    WHERE users_userid = p_users_userid AND status = 'Pending';

    -- Raise custom exception if there is an existing record with 'Pending' status
    IF v_pending_count > 0 THEN
        RAISE PendingApplicationExists;
    END IF;

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

EXCEPTION
    WHEN PendingApplicationExists THEN
        DBMS_OUTPUT.PUT_LINE('Error: An existing record with Pending status already exists for the user.');
    WHEN OTHERS THEN
        -- Raise custom exception for other errors
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

--Stored Procedure to insert EBT Schedule
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


--stored procedure to  insertEBTAccount
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

--stored procedure to insert EBT Card
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

    -- Custom Exceptions
    DuplicateCardNumber EXCEPTION;
    UserHasActiveCard EXCEPTION;

BEGIN
    -- Check if the card number already exists
    SELECT COUNT(*)
    INTO v_existing_count
    FROM ebtcard
    WHERE cardnumber = p_cardnumber;

    -- Raise exception if the card number is not unique
    IF v_existing_count > 0 THEN
        RAISE DuplicateCardNumber;
    END IF;

    -- Check if the user already has an active card
    SELECT COUNT(*)
    INTO v_existing_count
    FROM ebtcard
    WHERE ebtaccount_accountid = p_ebtaccount_accountid
      AND statusofcard = 'Active';

    -- Raise exception if the user already has an active card
    IF v_existing_count > 0 THEN
        RAISE UserHasActiveCard;
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
    WHEN DuplicateCardNumber THEN
        DBMS_OUTPUT.PUT_LINE('Error: There is an existing card with the same number');
    WHEN UserHasActiveCard THEN
        DBMS_OUTPUT.PUT_LINE('Error: User already has an active card');
    WHEN OTHERS THEN 
        -- Raise exception for other errors
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


exec insertUser('Sanjana', 'Doe', '123-45-6789', '123 Main St', '5551239476', 'sanjana.doe@email.com', 'P@ss1234');
exec insertUser( 'Sai Kiran', 'M', '987-65-4321', '456 Oak St', '5555678776', 'kiran.M@email.com', 'P@ss1234');
exec insertUser('Mithali', 'K', '987-95-5421', '456 Oak St', '5557778901', 'mithali.K@email.com', 'P@ss1234');
exec insertUser('Sravanti', 'M', '987-95-2321', '456 Oak St', '5555678101', 'sravanti.M@email.com', 'P@ss1234');
exec insertUser('Sravya', 'K', '987-75-4121', '456 Oak St', '5555678202', 'sravya.K@email.com', 'P@ss1234'); 



exec insertAdmin('AdminOne', 'Doe', '123-45-6789', '123 Main St', '5551234517', 'AdminOne.doe@email.com', 'Passs1234');
exec insertAdmin('AdminTwo', 'M', '987-65-4321', '456 Oak St', '5551284567', 'AdminTwo.M@email.com', 'P@ss12345');
exec insertAdmin('Admin Three', 'K', '987-95-5421', '456 Oak St', '5551734567', 'AdminThree.K@email.com', 'P@ss1234');
exec insertAdmin( 'Admin Four', 'M', '987-95-2321', '456 Oak St', '5551264567', 'AdminFour.M@email.com', 'P@ss1234');
exec insertAdmin('Admin Five', 'Kanchi', '987-75-4121', '456 Oak St', '5551434567', 'AdminFive.Kanchi@email.com', 'P@ss1234');


EXEC insertEBTApplication(utl_raw.cast_to_raw('proof of income'), empty_blob(), empty_blob(), empty_blob(), 'Approved', 1, 1);
EXEC insertEBTApplication(utl_raw.cast_to_raw('proof of income'),utl_raw.cast_to_raw('proof of immigration'), utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'), 'Approved', 2, 2);
EXEC insertEBTApplication(utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration'), utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'), 'Rejected', 3, 3);
EXEC insertEBTApplication(utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration'), utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'), 'Approved', 4, 4);
EXEC insertEBTApplication(utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration'), utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'), 'Pending', 5, 5);


EXEC  insertEBTSchedule('30');

EXEC  insertEBTAccount( 'E123456', 500.00, 100.00, 1, 1);
EXEC  insertEBTAccount( 'E234567', 800.00, 200.00, 2, 1);
EXEC  insertEBTAccount ('E345678', 600.00, 150.00, 4, 1);


EXEC  insertEBTCard( '5678901234567890', SYSDATE, 'Inactive', 8765, SYSDATE + 365, 2);
EXEC  insertEBTCard('4567890123456789', SYSDATE, 'InActive', 4321, SYSDATE + 365, 1);
EXEC  insertEBTCard ('3456789012345678', SYSDATE, 'Active', 9876, SYSDATE + 365, 3);
EXEC  insertEBTCard( '1234567890123456', SYSDATE, 'Active', 1234, SYSDATE + 365, 1);
EXEC  insertEBTCard( '2345678901234567', SYSDATE, 'Active', 5678, SYSDATE + 365, 2);


select * from admin;
select * from users;
select * from ebtapplication;
select *  from ebtschedule;
select * from ebtaccount;
select * from ebtcard;