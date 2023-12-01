-- As part of phase four all the user flows will be showcased here

-- User Login Procedure Test Cases
-- Case 1: Valid user ID and valid password
EXEC userLogin(416, 'Su5XdlEP');

-- Case 2: Valid user ID and incorrect password
EXEC userLogin(416, 'Rx62lRbD11');

-- Case 3: Invalid user ID and any password
EXEC userLogin(02225466, 'any_password');

-- Case 4: Invalid user ID and empty password
EXEC userLogin(02333234, '');

-- Reset Password Procedure Test Cases
-- Case 5: Valid user ID and strong password
EXEC resetPassword(416, 'Strong@Password123');

-- Case 6: Valid user ID and weak password
EXEC resetPassword(416, 'weak');

-- Case 7: Invalid user ID and any password
EXEC resetPassword(23345333, 'any_password');

-- Update User Details Procedure Test Cases
-- Case 9: Valid user ID and valid details
EXEC updateUserDetails(416, 'John1', 'Doe1', '123-45-6389', '133 Main St', '1224567890', 'john.doe1@example.com');

-- Case 10: Valid user ID and empty first name
EXEC updateUserDetails(416, '', 'Doe', '123-45-6789', '123 Main St', '1234567890', 'john.doe@example.com');

-- Case 11: Valid user ID and empty last name
EXEC updateUserDetails(416, 'John', '', '123-45-6789', '123 Main St', '1234567890', 'john.doe@example.com');

-- Case 12: Valid user ID and invalid email format
EXEC updateUserDetails(416, 'John', 'Doe', '123-45-6789', '123 Main St', '1234567890', 'invalid_email_format');

-- Case 13: Valid user ID and invalid SSN format
EXEC updateUserDetails(416, 'John', 'Doe', 'invalid_ssn_format', '123 Main St', '1234567890', 'john.doe@example.com');

-- Case 14: Valid user ID and invalid phone number format
EXEC updateUserDetails(416, 'John', 'Doe', '123-45-6789', '123 Main St', 'invalid_phone_format', 'john.doe@example.com');


-- Admin Login Procedure Test Cases
-- Case 16: Valid admin ID and valid password
EXEC adminLogin(6, 'P@ss1234');

-- Case 17: Valid admin ID and incorrect password
EXEC adminLogin(6, 'password');

-- Case 18: Invalid admin ID and any password
EXEC adminLogin(1231244162, 'any_password');

-- Case 19: Invalid admin ID and empty password
EXEC adminLogin(2124353525, '');


-- Reset Admin Password Procedure Test Cases
-- Case 20: Valid admin ID and strong password
EXEC resetAdminPassword(6, 'Strong@Password123');

-- Case 21: Valid admin ID and weak password
EXEC resetAdminPassword(6, 'weak');

-- Case 22: Invalid admin ID and any password
EXEC resetAdminPassword(6, 'any_password');

-- Update Admin Details Procedure Test Cases
-- Case 24: Valid admin ID and valid details
EXEC updateAdminDetails(6, 'Ajay', 'User', 'admin@ajay.com', '1234567890');

-- Case 25: Valid admin ID and empty first name
EXEC updateAdminDetails(6, '', 'User', 'admin@ajay.com', '1234567890');

-- Case 26: Valid admin ID and empty last name
EXEC updateAdminDetails(6, 'Ajay', '', 'admin@ajay.com', '1234567890');

-- Case 27: Valid admin ID and invalid email format
EXEC updateAdminDetails(6, 'Ajay', 'User', 'admin@ajay', '1234567890');

-- Case 28: Valid admin ID and invalid phone number format
EXEC updateAdminDetails(6, 'Ajay', 'User', 'admin@ajay.com', 'invalid_phone_format');