SET SERVEROUTPUT ON

--view for approved transactions
CREATE OR REPLACE VIEW APPROVED_TRANSACTIONS_VIEW
AS
SELECT * FROM
TRANSACTIONS
WHERE STATUS = 'Approved';

--view for rejected transactions
CREATE OR REPLACE VIEW APPROVED_TRANSACTIONS_VIEW
AS
SELECT * FROM
TRANSACTIONS
WHERE STATUS = 'Rejected';

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
