--TODO : Should be moved to a single file

ALTER SESSION SET CURRENT_SCHEMA = EBTAPP;
SET SERVEROUTPUT ON;


--FUNCTIONS

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




