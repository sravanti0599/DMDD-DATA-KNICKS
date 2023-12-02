--ALTER SESSION SET CURRENT_SCHEMA = EBTAPP;

SET SERVEROUTPUT ON
BEGIN
	FOR I IN(
		WITH MY_USERS AS(
			SELECT 'EBTMERCHANT' UNAME FROM DUAL
			UNION ALL
			SELECT 'EBTUSER' FROM DUAL
			UNION ALL
			SELECT 'EBTADMIN' FROM DUAL
		)
		SELECT MU.UNAME
		FROM MY_USERS MU
		INNER JOIN ALL_USERS AU
		ON AU.USERNAME = MU.UNAME
	)
	LOOP
		DBMS_OUTPUT.PUT_LINE('User to be dropped: '||I.UNAME);
		EXECUTE IMMEDIATE 'DROP USER '||I.UNAME;
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

create user EBTADMIN identified by DataKnicks2023ADMIN;
create user EBTMERCHANT identified by DataKnicks2023MERCH;
create user EBTUSER identified by DataKnicks2023USER;


GRANT CREATE SESSION TO EBTADMIN;
GRANT CREATE SESSION TO EBTUSER;
GRANT CREATE SESSION TO EBTMERCHANT;

GRANT SELECT ON VIEW_TRANSACTIONS TO EBTMERCHANT, EBTUSER, EBTADMIN;
GRANT SELECT ON VIEW_TRANSACTIONITEMLIST TO EBTMERCHANT, EBTUSER, EBTADMIN;
GRANT SELECT ON VIEW_MERCHANT TO EBTMERCHANT, EBTADMIN;

GRANT UPDATE, INSERT ON EBTAPP.USERS TO EBTUSER;
GRANT SELECT ON VIEW_USERS TO EBTUSER, EBTADMIN;
GRANT SELECT ON VIEW_EBTCARD TO EBTUSER, EBTADMIN;
GRANT SELECT ON VIEW_EBTACCOUNT TO EBTUSER, EBTADMIN;
GRANT SELECT ON VIEW_ITEM TO EBTUSER, EBTADMIN;
GRANT SELECT ON VIEW_EBTAPPLICATION TO EBTUSER, EBTADMIN;
GRANT SELECT ON VIEW_EBTSCHEDULE TO EBTUSER, EBTADMIN;

GRANT SELECT ON VIEW_ADMIN TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.USERS TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.EBTCARD TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.EBTACCOUNT TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.ADMIN TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.EBTAPPLICATION TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.EBTSCHEDULE TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.ITEM TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.MERCHANT TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.TRANSACTIONITEMLIST TO EBTADMIN;
--GRANT INSERT, UPDATE, DELETE ON EBTAPP.TRANSACTIONS TO EBTADMIN;

GRANT EXECUTE ON insertAdmin TO ebtadmin;
GRANT EXECUTE ON insertUser TO ebtuser;
GRANT EXECUTE ON userLogin TO ebtuser;
GRANT EXECUTE ON resetPassword TO ebtuser;
GRANT EXECUTE ON updateUserDetails TO ebtuser;
GRANT EXECUTE ON createEBTApplication TO ebtuser;
GRANT EXECUTE ON updateEBTApplicationStatus TO ebtadmin;
GRANT EXECUTE ON addEBTAccount TO ebtadmin;
GRANT EXECUTE ON addEBTCard TO ebtadmin;
GRANT EXECUTE ON addEBTSchedule TO ebtadmin;
GRANT EXECUTE ON UpdateNextDisbursementDate TO ebtadmin;
GRANT EXECUTE ON MarkAccountAndCardInactive TO ebtadmin;
GRANT SELECT ON card_status_counts TO ebtadmin;
GRANT SELECT ON age_view TO ebtadmin;
GRANT SELECT ON monthly_application_counts to ebtadmin;
GRANT SELECT ON pending_ebt_applications_view TO ebtadmin;
GRANT SELECT ON ebtaccount_balance_view TO ebtuser,ebtadmin;
GRANT SELECT ON transaction_summary_view TO ebtuser;
GRANT SELECT ON ActiveEBTAccounts TO ebtadmin;
GRANT SELECT ON CUST_FOOD_VS_CASH_VIEW TO ebtadmin;
GRANT SELECT ON ITEM_QTY_VS_AMOUNT_VIEW TO EBTADMIN;
GRANT SELECT ON COUNT_SUCCESS_FAIL_TRANSACTION_VIEW TO EBTADMIN;
GRANT EXECUTE ON adminLogin TO ebtadmin;
GRANT EXECUTE ON resetAdminPassword TO ebtadmin;
GRANT EXECUTE ON updateAdminDetails TO ebtadmin;

GRANT SELECT ON ELIGIBLE_ITEMS_VIEW TO EBTUSER, EBTMERCHANT, EBTADMIN;
GRANT SELECT ON ACTIVE_MERCHANTS_VIEW TO EBTMERCHANT, EBTADMIN;
GRANT SELECT ON INACTIVE_MERCHANTS_VIEW TO EBTMERCHANT, EBTADMIN;

GRANT EXECUTE ON InitiateTransactionAtStore TO EBTUSER;
GRANT EXECUTE ON InitiateTransactionAtATM TO EBTUSER;
GRANT EXECUTE ON CheckUserBalance TO EBTUSER;
GRANT EXECUTE ON CheckStoreTransactionEligibility TO EBTUSER;
GRANT EXECUTE ON CheckATMTransactionEligibility TO EBTUSER;
GRANT SELECT ON APPROVED_TRANSACTIONS_VIEW TO EBTUSER,EBTMERCHANT, EBTADMIN;
GRANT SELECT ON FAILED_TRANSACTIONS_VIEW TO EBTUSER,EBTMERCHANT, EBTADMIN;
GRANT SELECT ON MERCHANT_TRANSACTION_DETAILS TO EBTMERCHANT, EBTADMIN;

GRANT EXECUTE ON AddOrUpdateItem TO EBTMERCHANT,EBTADMIN;
GRANT EXECUTE ON AddOrUpdateMerchant TO EBTMERCHANT,EBTADMIN;
GRANT EXECUTE ON CheckItemExistence TO EBTMERCHANT,EBTADMIN;
GRANT EXECUTE ON CheckMerchantExistence TO EBTMERCHANT,EBTADMIN;

GRANT EXECUTE ON BlockOrUnblockCard TO ebtuser,ebtadmin;
GRANT EXECUTE ON CreatePin TO ebtuser;
GRANT EXECUTE ON ResetPin TO ebtuser;
GRANT EXECUTE ON LostCardAndDisable TO ebtadmin;

GRANT EXECUTE ON user_management_pkg to ebtuser;
