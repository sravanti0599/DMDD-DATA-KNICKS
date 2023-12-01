ALTER SESSION SET CURRENT_SCHEMA = EBTAPP;

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




BEGIN
    user_management_pkg.userLogin(416, 'Su5XdlEP');
    user_management_pkg.resetPassword(414, 'Strong@Password123');
END;
/
