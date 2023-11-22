-- Insert into merchant table
SET SERVEROUTPUT ON

BEGIN
    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (1, 'STORE', 'ABC Store', '123 Main Street', NULL , NULL , 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the first INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (2, 'ATM', 'XYZ Bank ATM', '456 Oak Avenue', NULL , NULL , 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the second INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (3, 'STORE', '123 Mart', '789 Elm Boulevard', NULL , NULL , 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (4, 'ATM', 'PQR Bank ATM', '101 Pine Street', NULL , NULL , 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (5, 'STORE', 'LMN Supermarket', '202 Maple Lane', NULL, NULL, 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/


-----SELECT * FROM ADMIN;
---SELECT merchantid FROM merchant;
----DELETE FROM merchant;
----select * from merchant;


--------------- item table---------------------------------------------------------------------------------------------

-----select * from item;
BEGIN
    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (1, 'Bread', '123456789012', 2.99, 'Whole wheat bread', 'N');

    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the first INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (2, 'Apples', '234567890123', 1.99, 'Fresh red apples', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the second INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (3, 'Pasta', '345678901234', 3.49, 'Spaghetti pasta', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (4, 'Milk', '456789012345', 2.49, 'Whole milk', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (5, 'Cereal', '567890123456', 4.99, 'Healthy breakfast cereal', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

----select * from item;
------------------------------------------------------------------transactions---------------------------------------------------------------------
----select * from user_sequences;
----select * from transactions;
----select * from ebtcard;
BEGIN
    BEGIN 
        INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (1, 9.94, 'Completed', SYSDATE, 1, 1);
    EXCEPTION
     WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error in the First INSERT: ' || SQLERRM);
    END;

    BEGIN
         INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (2, 9.94, 'Completed', SYSDATE, 2, 2);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Second INSERT: ' || SQLERRM);
    END;
    BEGIN
         INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (3, 9.94, 'Completed', SYSDATE, 3, 3);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Third INSERT: ' || SQLERRM);
    END;

    BEGIN
         INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (4, 9.94, 'Completed', SYSDATE, 4, 4);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
    
         INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (5, 9.94, 'Completed', SYSDATE, 5, 5);
    EXCEPTION
         WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

SELECT * FROM EBTAPPLICATION;
SELECT * FROM MERCHANT;


-----------------------------------------------------------------transactionitemlist--------------------------------------------------------

BEGIN
    BEGIN 
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (1, 2, 1, 1);
    EXCEPTION
     WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error in the First INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (2, 3, 2, 2);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Second INSERT: ' || SQLERRM);
    END;
    BEGIN
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (3, 1, 3, 3);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (4, 2, 4, 4);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
    
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (5, 2, 5, 5);
    EXCEPTION
         WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

---select * from transactionitemlist;


