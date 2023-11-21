-- Insert into users table
SET SERVEROUTPUT ON

BEGIN
    BEGIN
        INSERT INTO admin (adminid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (admin_seq.nextval, 'AdminOne', 'Doe', '123-45-6789', '123 Main St', '555-1234', 'AdminOne.doe@email.com', 'pass123');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the first INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO admin (adminid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (admin_seq.nextval, 'AdminTwo', 'M', '987-65-4321', '456 Oak St', '555-5678', 'AdminTwo.M@email.com', 'pass456');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the second INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO admin (adminid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (admin_seq.nextval, 'Admin Three', 'K', '987-95-5421', '456 Oak St', '555-5678', 'AdminThree.K@email.com', 'pass456');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO admin (adminid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (admin_seq.nextval, 'Admin Four', 'M', '987-95-2321', '456 Oak St', '555-5678', 'AdminFour.M@email.com', 'pass456');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO admin (adminid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (admin_seq.nextval, 'Admin Five', 'Kanchi', '987-75-4121', '456 Oak St', '555-5678', 'AdminFive.Kanchi@email.com', 'pass456');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

SELECT * FROM ADMIN;



BEGIN
    BEGIN
        INSERT INTO users (userid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (users_seq.nextval, 'Sanjana', 'Doe', '123-45-6789', '123 Main St', '555-1234', 'sanjana.doe@email.com', 'pass123');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the first INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO users (userid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (users_seq.nextval, 'Sai Kiran', 'M', '987-65-4321', '456 Oak St', '555-5678', 'kiran.M@email.com', 'pass456');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the second INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO users (userid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (users_seq.nextval, 'Mithali', 'K', '987-95-5421', '456 Oak St', '555-5678', 'mithali.K@email.com', 'pass456');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO users (userid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (users_seq.nextval, 'Sravanti', 'M', '987-95-2321', '456 Oak St', '555-5678', 'sravanti.M@email.com', 'pass456');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO users (userid, firstname, lastname, ssn, address, phone, email, password)
        VALUES (users_seq.nextval, 'Sravya', 'K', '987-75-4121', '456 Oak St', '555-5678', 'sravya.K@email.com', 'pass456');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

SELECT * FROM USERS;


BEGIN
    BEGIN 
        INSERT INTO EBTAPPLICATION (applicationid, proofofincome, immigrationproof, proofofresidence, proofofidentity, benefitprogramname, status, users_userid, admin_adminid)
        VALUES (ebtapplication_seq.nextval, empty_blob(), empty_blob(), empty_blob(), empty_blob(), 'EBT Program MA', 'Approved', 1, 1);
    EXCEPTION
     WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error in the First INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO EBTAPPLICATION (applicationid, proofofincome, immigrationproof, proofofresidence, proofofidentity, benefitprogramname, status, users_userid, admin_adminid)
        VALUES  (ebtapplication_seq.nextval, empty_blob(), empty_blob(), empty_blob(), empty_blob(), 'EBT Program MA', 'Approved', 2, 2);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Second INSERT: ' || SQLERRM);
    END;
    BEGIN
        INSERT INTO EBTAPPLICATION (applicationid, proofofincome, immigrationproof, proofofresidence, proofofidentity, benefitprogramname, status, users_userid, admin_adminid)
        VALUES (ebtapplication_seq.nextval, empty_blob(), empty_blob(), empty_blob(), empty_blob(), 'EBT Program MA', 'Rejected', 3, 3);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO EBTAPPLICATION (applicationid, proofofincome, immigrationproof, proofofresidence, proofofidentity, benefitprogramname, status, users_userid, admin_adminid)
        VALUES (ebtapplication_seq.nextval, empty_blob(), empty_blob(), empty_blob(), empty_blob(), 'EBT Program MA', 'Approved', 4, 4);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
    
        INSERT INTO EBTAPPLICATION (applicationid, proofofincome, immigrationproof, proofofresidence, proofofidentity, benefitprogramname, status, users_userid, admin_adminid)
        VALUES (ebtapplication_seq.nextval, empty_blob(), empty_blob(), empty_blob(), empty_blob(), 'EBT Program MA', 'Pending', 5, 5);
    EXCEPTION
         WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

SELECT * FROM EBTAPPLICATION;


BEGIN
    BEGIN 
        INSERT INTO ebtschedule (scheduleid, disbursementfrequency, nextdisbursementdate, benefitprogramname)
        VALUES (ebtschedule_seq.nextval, 'Monthly', SYSDATE + 30, 'EBT Program MA');
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the INSERT: ' || SQLERRM);
    END;

    COMMIT;
END;
/

SELECT * FROM ebtschedule;


BEGIN
    BEGIN 
        INSERT INTO ebtaccount (accountid, accountnumber, foodbalance, cashbalance, ebtapplication_applicationid, ebtschedule_scheduleid)
        VALUES (ebtaccount_seq.nextval, 'E123456', 500.00, 100.00, 1, 1);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the First INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO ebtaccount (accountid, accountnumber, foodbalance, cashbalance, ebtapplication_applicationid, ebtschedule_scheduleid)
        VALUES (ebtaccount_seq.nextval, 'E234567', 800.00, 200.00, 2, 1);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Second INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO ebtaccount (accountid, accountnumber, foodbalance, cashbalance, ebtapplication_applicationid, ebtschedule_scheduleid)
        VALUES (ebtaccount_seq.nextval, 'E345678', 600.00, 150.00, 4, 1);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Third INSERT: ' || SQLERRM);
    END;

    COMMIT;
END;
/

SELECT * FROM ebtaccount;

BEGIN
    BEGIN 
        INSERT INTO ebtcard (cardid, cardnumber, activationdate, statusofcard, pin, expirydate, ebtaccount_accountid)
        VALUES (ebtcard_seq.nextval, '1234567890123456', SYSDATE, 'Active', 1234, SYSDATE + 365, 1);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the First INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO ebtcard (cardid, cardnumber, activationdate, statusofcard, pin, expirydate, ebtaccount_accountid)
        VALUES (ebtcard_seq.nextval, '2345678901234567', SYSDATE, 'Active', 5678, SYSDATE + 365, 2);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Second INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO ebtcard (cardid, cardnumber, activationdate, statusofcard, pin, expirydate, ebtaccount_accountid)
        VALUES (ebtcard_seq.nextval, '3456789012345678', SYSDATE, 'Inactive', 9876, SYSDATE + 365, 3);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO ebtcard (cardid, cardnumber, activationdate, statusofcard, pin, expirydate, ebtaccount_accountid)
        VALUES (ebtcard_seq.nextval, '4567890123456789', SYSDATE, 'Active', 4321, SYSDATE + 365, 1);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO ebtcard (cardid, cardnumber, activationdate, statusofcard, pin, expirydate, ebtaccount_accountid)
        VALUES (ebtcard_seq.nextval, '5678901234567890', SYSDATE, 'Inactive', 8765, SYSDATE + 365, 2);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Fifth INSERT: ' || SQLERRM);
    END;

    COMMIT;
END;
/

SELECT * FROM ebtcard;








