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
    
    
    
--Analysis
CREATE OR REPLACE VIEW age_view AS
WITH age_categories AS (
    SELECT
        u.userid,
        CASE
            WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.dob) < 5 THEN 'Younger than 5 years'
            WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.dob) BETWEEN 5 AND 17 THEN '5 through 17'
            WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.dob) BETWEEN 18 AND 35 THEN '18 through 35'
            WHEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.dob) BETWEEN 36 AND 59 THEN '36 through 59'
            ELSE 'Elderly (60 or More)'
        END AS age_category
    FROM
        users u
)
SELECT
    ac.age_category,
    COUNT(*) AS total_applications,
    COUNT(CASE WHEN e.status = 'APPROVED' THEN 1 END) AS total_approved,
    COUNT(CASE WHEN e.status = 'REJECTED' THEN 1 END) AS total_rejected,
    COUNT(CASE WHEN e.status IN ('APPROVED', 'REJECTED') THEN 1 END) AS total_success,
    (COUNT(*) / (SELECT COUNT(*) FROM ebtapplication) * 100) AS percentage_total,
    (COUNT(CASE WHEN e.status = 'APPROVED' THEN 1 END) / COUNT(*) * 100) AS percentage_approved,
    (COUNT(CASE WHEN e.status = 'REJECTED' THEN 1 END) / COUNT(*) * 100) AS percentage_rejected
FROM
    age_categories ac
    JOIN ebtapplication e ON ac.userid = e.users_userid
GROUP BY
    ac.age_category;

 select * from transaction_summary_view;
 select * from ebtaccount_balance_view;
 select * from pending_ebt_applications_view;
 select * from monthly_application_counts;
 select * from age_view;
 
CREATE VIEW card_status_counts AS
SELECT
    COUNT(CASE WHEN statusofcard = 'LOST' THEN 1 END) AS lost_count,
    COUNT(CASE WHEN statusofcard = 'INACTIVE' THEN 1 END) AS inactive_count,
    COUNT(CASE WHEN statusofcard = 'ACTIVE' THEN 1 END) AS active_count,
    COUNT(CASE WHEN statusofcard = 'PENDING' THEN 1 END) AS pending_count,
    COUNT(CASE WHEN statusofcard = 'BLOCKED' THEN 1 END) AS blocked_count
FROM
    ebtcard;
    
SELECT * FROM card_status_counts;

