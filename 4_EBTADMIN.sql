-- As part of phase four all the admin flows will be showcased here

EXEC  ADDEBTSchedule('30');

exec insertAdmin('AdminOne', 'Doe', '123-45-6789', '123 Main St', '5551234517', 'AdminOne.doe@email.com', 'Passs1234');
exec insertAdmin('AdminTwo', 'M', '987-65-4321', '456 Oak St', '5551284567', 'AdminTwo.M@email.com', 'P@ss12345');
exec insertAdmin('Admin Three', 'K', '987-95-5421', '456 Oak St', '5551734567', 'AdminThree.K@email.com', 'P@ss1234');
exec insertAdmin( 'Admin Four', 'M', '987-95-2321', '456 Oak St', '5551264567', 'AdminFour.M@email.com', 'P@ss1234');
exec insertAdmin('Admin Five', 'Kanchi', '987-75-4121', '456 Oak St', '5551434567', 'AdminFive.Kanchi@email.com', 'P@ss1234');

                    --TODO: ADD VALIDATE PASSWORD, RESET PASSWORD, UPDATE ADMIN DETAILS --

select * from admin;
select *  from ebtschedule;