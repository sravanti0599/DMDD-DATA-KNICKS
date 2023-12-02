# DMDD-DATA-KNICKS

Order for running Script
1. Run 1_System Admin Script (System_Admin_Script.sql) - this will create an EBTAPP User
2. Run 2_EBTAPP_Script.sql in the EBTAPP User -this will create tables, Views, Procedures, Packages, Functions & Triggers
3. Run 3_EBTAPP_Admin_Script.sql in the EBTAPP User - this will create users (ebtuser, ebtadmin, & ebtmerchant) & will grant access for the Views, Procedures, Packages, Functions & Triggers
4. Run 4_EBTADMIN.sql in EBTADMIN User - will insert or update ebtschedule info, admin info, item & merchant
5. Run 5_EBTCUSTOMER.sql in EBTCUSTOMER User - will insert or update User info, ebt application info,  & merchant
6. Run 6_EBTADMIN.sql in EBTADMIN User - will update ebt application info, update card & account status
7. Run 7_EBTCUSTOMER.sql in EBTCUSTOMER User - will create or reset pin, & initiate transactions
8. Run 8_EBTMERCHANT.sql in EBTMERCHANT User - will display different views related to merchant
8. Run 7_EBTANALYSIS.sql in EBTADMIN User - will display different views related to the  application