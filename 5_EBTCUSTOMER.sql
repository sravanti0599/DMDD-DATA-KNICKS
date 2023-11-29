-- As part of phase four all the user flows will be showcased here

exec insertUser('Sanjana', 'Doe', '123-45-6789', '123 Main St', '5551239476', 'sanjana.doe@email.com', 'P@ss1234');
exec insertUser( 'Sai Kiran', 'M', '987-65-4321', '456 Oak St', '5555678776', 'kiran.M@email.com', 'P@ss1234');
exec insertUser('Mithali', 'K', '987-95-5421', '456 Oak St', '5557778901', 'mithali.K@email.com', 'P@ss1234');
exec insertUser('Sravanti', 'M', '987-95-2321', '456 Oak St', '5555678101', 'sravanti.M@email.com', 'P@ss1234');
exec insertUser('Sravya', 'K', '987-75-4121', '456 Oak St', '5555678202', 'sravya.K@email.com', 'P@ss1234'); 


                    --TODO: ADD VALIDATE PASSWORD, RESET PASSWORD, UPDATE ADMIN DETAILS --


EXEC createEBTApplication(utl_raw.cast_to_raw('proof of income'), empty_blob(), empty_blob(), empty_blob(), 1);
EXEC createEBTApplication(utl_raw.cast_to_raw('proof of income'),utl_raw.cast_to_raw('proof of immigration'), utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'),2);
EXEC createEBTApplication(utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration'), utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'),3);
EXEC createEBTApplication(utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration'), utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'),4);
EXEC createEBTApplication(utl_raw.cast_to_raw('proof of income'), utl_raw.cast_to_raw('proof of immigration'), utl_raw.cast_to_raw('proof of residence'), utl_raw.cast_to_raw('proof of identity'),5);


select * from users;
select * from ebtapplication;