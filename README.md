# DMDD-DATA-KNICKS

Order for running Script
1. Run System Admin Script (System_Admin_Script.sql) - this will create an EBTAPP User
2. Run EBT_DDL_Script.sql in the EBTAPP User -this will create tables
3. Run EBT_Views.sql in the EBTAPP User - this will create views
4. Run EBT_DML_Script in the EBT User - this will insert the info in users, admin,EBT application,  EBT schedule, EBT account, and EBT card.
5. Run EBT_DML_Script_PartTwo in the EBT User - this will insert the info into merchant, items, transactions, and transactioniteemlist
6. Run EBTAPP_Admin_Script.sql to grant access to EBTCustomer, EBTAdmin, and EBTMerchant.
