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

 select * from transaction_summary_view;
 select * from ebtaccount_balance_view;
 select * from pending_ebt_applications_view;
 select * from monthly_application_counts;