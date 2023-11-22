-- Insert into merchant table
SET SERVEROUTPUT ON

BEGIN
    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (merchant_seq.nextval, 'STORE', 'ABC Store', '123 Main Street', '123456789' , '987654321', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the first INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (merchant_seq.nextval, 'ATM', 'XYZ Bank ATM', '456 Oak Avenue', NULL , NULL , 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the second INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (merchant_seq.nextval, 'STORE', '123 Mart', '789 Elm Boulevard','556677889' , '111223344' , 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (merchant_seq.nextval, 'ATM', 'PQR Bank ATM', '101 Pine Street', '222333444' , '777888999' , 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO merchant (merchantid, type, name, address, accountnumber, routingnumber, archive)
        VALUES (merchant_seq.nextval, 'STORE', 'LMN Supermarket', '202 Maple Lane', NULL, NULL, 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/



select * from merchant;


--------------- item table---------------------------------------------------------------------------------------------


BEGIN
    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (item_seq.nextval, 'Bread', '123456789012', 2.99, 'Whole wheat bread', 'N');

    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the first INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (item_seq.nextval, 'Apples', '234567890123', 1.99, 'Fresh red apples', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the second INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (item_seq.nextval, 'Pasta', '345678901234', 3.49, 'Spaghetti pasta', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (item_seq.nextval, 'Milk', '456789012345', 2.49, 'Whole milk', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO item (itemid, name, upc, price, description, eligibility)
        VALUES (item_seq.nextval, 'Cereal', '567890123456', 4.99, 'Healthy breakfast cereal', 'N');
    EXCEPTION 
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

select * from item;

------------------------------------------------------------------transactions---------------------------------------------------------------------

BEGIN
    BEGIN 
        INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (transactions_seq.nextval, 2.19, 'SUCCESS', SYSDATE, 1, 1);
    EXCEPTION
     WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error in the First INSERT: ' || SQLERRM);
    END;

    BEGIN
         INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (transactions_seq.nextval, 1.99, 'SUCCESS', SYSDATE, 2, 2);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Second INSERT: ' || SQLERRM);
    END;
    BEGIN
         INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (transactions_seq.nextval, 9.17, 'SUCCESS', SYSDATE, 3, 3);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Third INSERT: ' || SQLERRM);
    END;

    BEGIN
         INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (transactions_seq.nextval, 5.48, 'SUCCESS', SYSDATE, 4, 4);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
    
         INSERT INTO transactions (transactionid, amount, status, recorded_date, merchant_merchantid, ebtcard_cardid)
        VALUES (transactions_seq.nextval, 9.94, 'SUCCESS', SYSDATE, 5, 5);
    EXCEPTION
         WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

select * from transactions;




-----------------------------------------------------------------transactionitemlist--------------------------------------------------------

BEGIN
    BEGIN 
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (transactionitemlist_seq.nextval, 2, 1, 1);
    EXCEPTION
     WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error in the First INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (transactionitemlist_seq.nextval, 3, 2, 2);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Second INSERT: ' || SQLERRM);
    END;
    BEGIN
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (transactionitemlist_seq.nextval, 1, 3, 3);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Third INSERT: ' || SQLERRM);
    END;

    BEGIN
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (transactionitemlist_seq.nextval, 2, 4, 4);
    EXCEPTION
        WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the Fourth INSERT: ' || SQLERRM);
    END;

    BEGIN
    
        INSERT INTO transactionitemlist (transactionitemid, quantity, item_itemid, transactions_transactionid)
        VALUES (transactionitemlist_seq.nextval, 2, 5, 5);
    EXCEPTION
         WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Error in the fifth INSERT: ' || SQLERRM);
    END;
    COMMIT;
END;
/

select * from transactionitemlist;



