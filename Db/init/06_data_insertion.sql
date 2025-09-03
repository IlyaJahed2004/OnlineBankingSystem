- ---------------------------
-- Banks (explicit BankID)
-- ---------------------------
INSERT INTO Bank (BankID, BankName, HeadquartersLocation) VALUES
(1, 'Global Bank', 'New York'),
(2, 'Trust Bank', 'London');

-- ---------------------------
-- Branches (composite PK)
-- ---------------------------
INSERT INTO Branch (BankID, BranchCode, BranchName, LOCATION, PhoneNumber) VALUES
(1, 101, 'Global NY Main', '5th Avenue, NY', '123-456-7890'),
(1, 102, 'Global NY Uptown', 'Broadway, NY', '123-555-7890'),
(2, 201, 'Trust London Central', 'Baker Street, London', '44-20-1234-5678'),
(2, 202, 'Trust London West', 'Oxford Street, London', '44-20-9876-5432');

-- ---------------------------
-- Users (explicit UserID)
-- ---------------------------
INSERT INTO Users (UserID, FirstName, LastName, PhoneNumber, Email, NationalID, UserType, PasswordHash, IsActive, CreatedAt, UpdatedAt) VALUES
(1, 'Alice', 'Smith', '111-222-3333', 'alice@example.com', 'A123456789', 'Customer', 'pbkdf2$alicehash', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'Bob', 'Johnson', '222-333-4444', 'bob@example.com', 'B987654321', 'Customer', 'pbkdf2$bobhash', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'Carol', 'Williams', '333-444-5555', 'carol@example.com', 'C112233445', 'Customer', 'pbkdf2$carolhash', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'David', 'Brown', '444-555-6666', 'david@example.com', 'D556677889', 'Employee', 'pbkdf2$davidhash', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'Eva', 'Davis', '555-666-7777', 'eva@example.com', 'E998877665', 'Employee', 'pbkdf2$evahash', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 'Frank', 'Miller', '666-777-8888', 'frank@example.com', 'F334455667', 'Manager', 'pbkdf2$frankhash', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- ---------------------------
-- Customers (CustomerID = UserID)
-- ---------------------------
INSERT INTO Customer (CustomerID, RegistrationDate, LoyaltyLevel, CanViewOwnTransactions, CanPerformTransactions, CanEditOwnInfo) VALUES
(1, CURRENT_TIMESTAMP, 'Gold', TRUE, TRUE, TRUE),
(2, CURRENT_TIMESTAMP, 'Silver', TRUE, FALSE, FALSE),
(3, CURRENT_TIMESTAMP, 'Bronze', TRUE, FALSE, FALSE);

-- ---------------------------
-- Employees (EmployeeID = UserID)
-- ---------------------------
INSERT INTO Employee (EmployeeID, BankID, BranchCode, _POSITION, HireDate, EmploymentStatus, CanViewOwnTransactions, CanViewCustomerTransactions, CanPerformTransactions, CanEditCustomerInfo) VALUES
(4, 1, 101, 'Teller', CURRENT_DATE, 'Active', TRUE, TRUE, TRUE, FALSE),
(5, 2, 201, 'Customer Service', CURRENT_DATE, 'Active', TRUE, TRUE, TRUE, TRUE);

-- ---------------------------
-- Managers (ManagerID = UserID)
-- ---------------------------
INSERT INTO Manager (ManagerID, BankID, BranchCode, ROLE, HireDate, EmploymentStatus, CanViewOwnTransactions, CanViewAllTransactions, CanApproveTransactions, CanDeleteTransactions, CanEditCustomerInfo) VALUES
(6, 1, 101, 'GeneralManager', CURRENT_DATE, 'Active', TRUE, TRUE, TRUE, TRUE, TRUE);

-- ---------------------------
-- BankAccounts (explicit AccountID)
-- ---------------------------
INSERT INTO BankAccount (AccountID, AccountNumber, Balance, OpeningDate, UserID, BankID, BranchCode, AccountType, Status) VALUES
(1, 'ACC1001', 5000.00, CURRENT_DATE, 1, 1, 101, 'Savings', 'Active'),
(2, 'ACC1002', 1500.00, CURRENT_DATE, 2, 1, 102, 'Current', 'Active'),
(3, 'ACC2001', 3000.00, CURRENT_DATE, 3, 2, 201, 'Savings', 'Active'),
(4, 'ACC3001', 250.00, CURRENT_DATE, 2, 1, 102, 'Savings', 'Active'),
(5, 'ACC4001', 12000.00, CURRENT_DATE, 1, 1, 101, 'Current', 'Active');

-- ---------------------------
-- Transactions (explicit TransactionID)
-- ---------------------------
INSERT INTO Transactions (TransactionID, TransactionType, Amount, TransactionDate, Status, ReferenceNumber, CreatedBy) VALUES
(1, 'Deposit', 1000.00, CURRENT_TIMESTAMP, 'Completed', 'REF-0001', 1),
(2, 'Withdrawal', 200.00, CURRENT_TIMESTAMP, 'Completed', 'REF-0002', 1),
(3, 'Deposit', 500.00, CURRENT_TIMESTAMP, 'Completed', 'REF-0003', 2),
(4, 'Withdrawal', 100.00, CURRENT_TIMESTAMP, 'Completed', 'REF-0004', 2),
(5, 'Transfer', 300.00, CURRENT_TIMESTAMP, 'Completed', 'REF-0005', 1),
(6, 'Fee', 15.00, CURRENT_TIMESTAMP, 'Completed', 'REF-0006', 1);

-- ---------------------------
-- TransactionInvolvement
-- ---------------------------
INSERT INTO TransactionInvolvement (TransactionID, BankAccountID, _ROLE) VALUES
(1, 1, 'To'),
(2, 1, 'From'),
(3, 2, 'To'),
(4, 2, 'From'),
(5, 1, 'From'),
(5, 3, 'To'),
(6, 1, 'From');

-- ---------------------------
-- BankLoans (explicit LoanID)
-- ---------------------------
INSERT INTO BankLoan (LoanID, LoanAmount, LoanType, LoanDate, UserID, Status, DueDate) VALUES
(1, 10000.00, 'Personal', CURRENT_TIMESTAMP, 1, 'Pending', CURRENT_DATE + INTERVAL '365 days'),
(2, 5000.00, 'Auto', CURRENT_TIMESTAMP, 2, 'Approved', CURRENT_DATE + INTERVAL '180 days');

-- ---------------------------
-- Notifications
-- ---------------------------
INSERT INTO Notification (EntityType, EntityID, Message, NotificationType, NotificationTime, SentTo) VALUES
('Transaction', 1, 'Deposit successful to your account ACC1001', 'TransactionAlert', CURRENT_TIMESTAMP, 1),
('Transaction', 2, 'Withdrawal processed from your account ACC1001', 'TransactionAlert', CURRENT_TIMESTAMP, 1),
('Loan', 1, 'Your loan request has been received', 'LoanApproval', CURRENT_TIMESTAMP, 1),
('Loan', 2, 'Your loan was approved', 'LoanApproval', CURRENT_TIMESTAMP, 2),
('Transaction', 5, 'Transfer sent from ACC1001 to ACC2001', 'TransactionAlert', CURRENT_TIMESTAMP, 1);

-- ---------------------------
-- Fix sequences (very important if we inserted IDs explicitly)
-- For each SERIAL column set sequence to MAX(current IDs)
-- so that while adding there is no dublicate values bacause the sequence naturally is added by one but we explicitly can add anything we want.
-- ---------------------------
SELECT setval(pg_get_serial_sequence('Bank','BankID'), COALESCE((SELECT MAX(BankID) FROM Bank), 0), true);
SELECT setval(pg_get_serial_sequence('Users','UserID'), COALESCE((SELECT MAX(UserID) FROM Users), 0), true);
SELECT setval(pg_get_serial_sequence('BankAccount','AccountID'), COALESCE((SELECT MAX(AccountID) FROM BankAccount), 0), true);
SELECT setval(pg_get_serial_sequence('Transactions','TransactionID'), COALESCE((SELECT MAX(TransactionID) FROM Transactions), 0), true);
SELECT setval(pg_get_serial_sequence('BankLoan','LoanID'), COALESCE((SELECT MAX(LoanID) FROM BankLoan), 0), true);
