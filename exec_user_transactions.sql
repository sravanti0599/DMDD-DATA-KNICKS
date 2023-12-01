SET SERVEROUTPUT ON

--Add to Item table
exec AddOrUpdateItem('Apple', '876543210987', 10.50, 'fruits', 'Y');
exec AddOrUpdateItem('Banana', '765432109876', 8.99, 'fruits', 'Y');
exec AddOrUpdateItem('Orange', '654321098765', 12.75, 'citrus fruits', 'Y');
exec AddOrUpdateItem('Grapes', '543210987654', 15.25, 'seedless grapes', 'Y');
exec AddOrUpdateItem('Strawberry', '432109876543', 6.50, 'berries', 'Y');
exec AddOrUpdateItem('Wine', '36745982387', 6.30, 'Alcohol', 'N');
exec AddOrUpdateItem('Watermelon', '321098765432', 20.00, 'whole watermelon', 'Y');
exec AddOrUpdateItem('Pineapple', '210987654321', 14.50, 'tropical fruit', 'Y');
exec AddOrUpdateItem('Mango', '109876543210', 9.75, 'exotic fruit', 'Y');
exec AddOrUpdateItem('Blueberries', '987654321098', 5.99, 'fresh berries', 'Y');
exec AddOrUpdateItem('Kiwi', '876543210987', 3.25, 'tart and sweet', 'Y');
exec AddOrUpdateItem('Peach', '765432109876', 7.50, 'stone fruit', 'Y');
exec AddOrUpdateItem('Beer', '746892847893', 6.30, 'Alcohol', 'N');

select * from item;

--Updates in Item table if name exists
exec AddOrUpdateItem('PEACH', '0293875178835', 5.99, 'stone fruit', 'Y');

--adds to merchant table if merchant name is not present
exec AddOrUpdateMerchant('Store', 'Walmart', '5 Greent St Boston MA', '00828839973267849', '00000PNC6899368','N');
exec AddOrUpdateMerchant('ATM', 'PNC Bank', '123 Delicious Ave', '98765432101234567', '00000BOA1234567','N');
exec AddOrUpdateMerchant('Store', 'Fresh Express', '789 Trendy St', '1111222233334444', '00000CHASE5555555','N');
exec AddOrUpdateMerchant('Store', 'Food World', '456 Tech Blvd', '4444333322221111', '00000CITI8888888','N');
exec AddOrUpdateMerchant('Store', 'FreshMart', '101 Green Market', '9999888877776666', '00000WELLS9999999','N');
exec AddOrUpdateMerchant('ATM', 'Chase Bank', '777 Construction St', '1234987654328765', '00000USB4567890','N');
exec AddOrUpdateMerchant('Store', 'Food Haven', '222 Story Lane', '5555444433332222', '00000TD6789123','N');
exec AddOrUpdateMerchant('Store', 'EatFit', '888 Workout Way', '7777666655554444', '00000AMX9876543','N');
exec AddOrUpdateMerchant('Store', 'Paws and Claws', '333 Pet Avenue', '1212121212121212', '00000DISC3456789','Y');
exec AddOrUpdateMerchant('Store', 'Style Haven', '456 Decor Street', '9090909090909090', '00000VISA8765432','Y');

--updates merchant if merchant name is already present
exec AddOrUpdateMerchant('Store', 'WALMART', '5 Greent St', '00828839973267849', '00000PNC6899368','N');

-- SUCCESS transaction at Store
exec InitiateTransactionAtStore(4,5,4,2);
exec InitiateTransactionAtStore(8,3,5,3);
exec InitiateTransactionAtStore(5,7,10,5);
exec InitiateTransactionAtStore(8,3,5,1);

--FAILURE transaction at Store
exec InitiateTransactionAtStore(3,3,5,3); 
exec InitiateTransactionAtStore(5,6,10,5);

--SUCCESS transaction at ATM (MerchantID - 2 and 6 are ATMs)
exec InitiateTransactionAtATM(4,2,10);
exec InitiateTransactionAtATM(8,6,5);
exec InitiateTransactionAtATM(8,6,195);

--FAILURE transaction at ATM
exec InitiateTransactionAtATM(4,3,10);
