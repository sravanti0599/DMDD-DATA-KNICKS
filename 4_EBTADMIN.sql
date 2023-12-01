-- As part of phase four all the admin flows will be showcased here
ALTER SESSION SET CURRENT_SCHEMA = EBTADMIN;

EXEC  ADDEBTSchedule('30');

--Adding admins
exec insertAdmin('Alice', 'Smith', '123-45-6789', '123 Main St, Boston, MA', '5551234517', 'Alice.Smith@email.com', 'Pass1234');
exec insertAdmin('Bob', 'Johnson', '987-65-4321', '456 Oak St, Cambridge, MA', '5551284567', 'Bob.Johnson@email.com', 'P@ss12345');
exec insertAdmin('Charlie', 'Williams', '987-95-5421', '789 Pine St, Springfield, MA', '5551734567', 'Charlie.Williams@email.com', 'P@ss1234');
exec insertAdmin('David', 'Davis', '987-95-2321', '101 Elm St, Worcester, MA', '5551264567', 'David.Davis@email.com', 'P@ss1234');
exec insertAdmin('Emma', 'Miller', '987-75-4121', '202 Maple St, Lowell, MA', '5551434567', 'Emma.Miller@email.com', 'P@ss1234');
exec insertAdmin('Frank', 'Brown', '987-34-5678', '303 Oak St, Springfield, MA', '5559876543', 'Frank.Brown@email.com', 'P@ss5678');
exec insertAdmin('Grace', 'Clark', '987-23-4567', '404 Pine St, Worcester, MA', '5558765432', 'Grace.Clark@email.com', 'P@ss9876');
exec insertAdmin('Henry', 'Jones', '987-12-3456', '505 Elm St, Boston, MA', '5557654321', 'Henry.Jones@email.com', 'P@ss5432');
exec insertAdmin('Isabel', 'Taylor', '987-45-6789', '606 Maple St, Cambridge, MA', '5556543210', 'Isabel.Taylor@email.com', 'P@ss2109');
exec insertAdmin('Jack', 'Wilson', '987-56-7890', '707 Oak St, Lowell, MA', '5555432109', 'Jack.Wilson@email.com', 'P@ss0987');
exec insertAdmin('Katherine', 'Harris', '987-67-8901', '808 Pine St, Springfield, MA', '5554321098', 'Katherine.Harris@email.com', 'P@ss7654');
exec insertAdmin('Liam', 'Moore', '987-78-9012', '909 Elm St, Worcester, MA', '5553210987', 'Liam.Moore@email.com', 'P@ss4321');
exec insertAdmin('Mia', 'Allen', '987-89-0123', '1010 Maple St, Boston, MA', '5552109876', 'Mia.Allen@email.com', 'P@ss1098');
exec insertAdmin('Noah', 'Scott', '987-90-1234', '1111 Oak St, Cambridge, MA', '5551098765', 'Noah.Scott@email.com', 'P@ss6543');
exec insertAdmin('Olivia', 'Young', '987-01-2345', '1212 Pine St, Springfield, MA', '5550987654', 'Olivia.Young@email.com', 'P@ss2109');
exec insertAdmin('Parker', 'Lee', '987-10-2345', '1313 Elm St, Worcester, MA', '5559876543', 'Parker.Lee@email.com', 'P@ss0987');
exec insertAdmin('Quinn', 'Turner', '987-20-3456', '1414 Maple St, Lowell, MA', '5558765432', 'Quinn.Turner@email.com', 'P@ss7654');
exec insertAdmin('Ryan', 'Baker', '987-30-4567', '1515 Oak St, Boston, MA', '5557654321', 'Ryan.Baker@email.com', 'P@ss4321');
exec insertAdmin('Sophia', 'Evans', '987-40-5678', '1616 Pine St, Cambridge, MA', '5556543210', 'Sophia.Evans@email.com', 'P@ss1098');
exec insertAdmin('Thomas', 'Cooper', '987-50-6789', '1717 Elm St, Worcester, MA', '5555432109', 'Thomas.Cooper@email.com', 'P@ss0987');
exec insertAdmin('Victoria', 'Perez', '987-60-7890', '1818 Maple St, Boston, MA', '5554321098', 'Victoria.Perez@email.com', 'P@ss7654');
exec insertAdmin('William', 'Rogers', '987-70-8901', '1919 Oak St, Cambridge, MA', '5553210987', 'William.Rogers@email.com', 'P@ss4321');
exec insertAdmin('Xander', 'Gonzalez', '987-80-9012', '2020 Pine St, Lowell, MA', '5552109876', 'Xander.Gonzalez@email.com', 'P@ss1098');
exec insertAdmin('Yasmine', 'Torres', '987-90-1239', '2121 Elm St, Springfield, MA', '5551098765', 'Yasmine.Torres@email.com', 'P@ss6543');
exec insertAdmin('Zachary', 'Lopez', '987-01-2341', '2222 Maple St, Worcester, MA', '5550987654', 'Zachary.Lopez@email.com', 'P@ss2109');
exec insertAdmin('Ava', 'Hernandez', '987-11-2345', '2323 Oak St, Boston, MA', '5559876543', 'Ava.Hernandez@email.com', 'P@ss0987');
exec insertAdmin('Benjamin', 'Adams', '987-21-3456', '2424 Pine St, Cambridge, MA', '5558765432', 'Benjamin.Adams@email.com', 'P@ss7654');
exec insertAdmin('Chloe', 'Ramirez', '987-31-4567', '2525 Elm St, Lowell, MA', '5557654321', 'Chloe.Ramirez@email.com', 'P@ss4321');
exec insertAdmin('Daniel', 'Fisher', '987-41-5678', '2626 Maple St, Springfield, MA', '5556543210', 'Daniel.Fisher@email.com', 'P@ss1098');
exec insertAdmin('Ella', 'Martinez', '987-51-6789', '2727 Elm St, Worcester, MA', '5555432109', 'Ella.Martinez@email.com', 'P@ss0987');
exec insertAdmin('Finn', 'Ward', '987-61-7890', '2828 Pine St, Boston, MA', '5554321098', 'Finn.Ward@email.com', 'P@ss7654');
exec insertAdmin('Gabriella', 'Turner', '987-71-8901', '2929 Elm St, Cambridge, MA', '5553210987', 'Gabriella.Turner@email.com', 'P@ss4321');
exec insertAdmin('Henry', 'Morales', '987-81-9012', '3030 Maple St, Lowell, MA', '5552109876', 'Henry.Morales@email.com', 'P@ss1098');
exec insertAdmin('Isaac', 'Nelson', '987-91-1234', '3131 Oak St, Springfield, MA', '5551098765', 'Isaac.Nelson@email.com', 'P@ss6543');
exec insertAdmin('Jasmine', 'Hill', '987-02-2345', '3232 Elm St, Worcester, MA', '5550987654', 'Jasmine.Hill@email.com', 'P@ss2109');
exec insertAdmin('Kevin', 'Powell', '987-12-2345', '3333 Pine St, Boston, MA', '5559876543', 'Kevin.Powell@email.com', 'P@ss0987');
exec insertAdmin('Lily', 'Stewart', '987-22-3456', '3434 Oak St, Cambridge, MA', '5558765432', 'Lily.Stewart@email.com', 'P@ss7654');
exec insertAdmin('Mason', 'Cruz', '987-32-4567', '3535 Maple St, Lowell, MA', '5557654321', 'Mason.Cruz@email.com', 'P@ss4321');


        
        --TODO: ADD VALIDATE PASSWORD, RESET PASSWORD, UPDATE ADMIN DETAILS --

select * from admin;
select *  from ebtschedule;