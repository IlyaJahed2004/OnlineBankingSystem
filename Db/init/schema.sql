-- ENUM types
CREATE TYPE user_type AS ENUM ('Customer', 'Employee', 'Manager');
CREATE TYPE loyalty_level AS ENUM ('Bronze', 'Silver', 'Gold', 'Platinum');
CREATE TYPE manager_role AS ENUM ('GeneralManager','OperationsManager','SupportManager');
CREATE TYPE transaction_type AS ENUM ('Deposit','Withdrawal','Transfer','Fee','Refund');
CREATE TYPE notification_type AS ENUM ('TransactionAlert','LoanApproval','AccountUpdate','TransactionFailure','BankEvent');
CREATE TYPE reference_type AS ENUM ('Transaction', 'Loan');


-- Bank Table
CREATE TABLE Bank (
    BankID SERIAL PRIMARY KEY,
    BankName VARCHAR(100),
    HeadquartersLocation VARCHAR(255)
);


-- Branch Table
CREATE TABLE Branch (
    BankID INT,
    BranchCode INT,   -- internal branch identifier
    BranchName VARCHAR(100),
    LOCATION VARCHAR(255),
    PhoneNumber VARCHAR(20),
    PRIMARY KEY (BankID, BranchCode),
    FOREIGN KEY (BankID) REFERENCES Bank(BankID)
);


-- Users Table (superclass)
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,  
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    NationalID CHAR(10) UNIQUE,
    UserType user_type
);


-- UserAddress Table
CREATE TABLE UserAddress (
    UserID INT,  
    Street VARCHAR(100),
    City VARCHAR(50),
    ZipCode VARCHAR(10),
    PRIMARY KEY (UserID, Street, City, ZipCode),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);


-- Customer Table (subclass)
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,  -- FK to Users(UserID)
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LoyaltyLevel loyalty_level,
    CanViewOwnTransactions BOOLEAN DEFAULT FALSE,
    CanPerformTransactions BOOLEAN DEFAULT FALSE,
    CanEditOwnInfo BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID) ON DELETE CASCADE
);


-- Manager Table
CREATE TABLE Manager (
    ManagerID INT PRIMARY KEY,  -- FK to Users(UserID)
    BankID INT NOT NULL,
    BranchCode INT NOT NULL,
    ROLE manager_role,
    CanViewOwnTransactions BOOLEAN,
    CanViewAllTransactions BOOLEAN,
    CanApproveTransactions BOOLEAN,
    CanDeleteTransactions BOOLEAN,
    CanEditCustomerInfo BOOLEAN,
    FOREIGN KEY (ManagerID) REFERENCES Users(UserID),
    FOREIGN KEY (BankID, BranchCode) REFERENCES Branch(BankID, BranchCode)
);


-- Employee Table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,  -- FK to Users(UserID)
    BankID INT NOT NULL,
    BranchCode INT NOT NULL,
    _POSITION VARCHAR(100),
    CanViewOwnTransactions BOOLEAN,
    CanViewCustomerTransactions BOOLEAN,
    CanPerformTransactions BOOLEAN,
    CanEditCustomerInfo BOOLEAN,
    FOREIGN KEY (EmployeeID) REFERENCES Users(UserID),
    FOREIGN KEY (BankID, BranchCode) REFERENCES Branch(BankID, BranchCode)
);



-- BankAccount Table
CREATE TABLE BankAccount (
    AccountID SERIAL PRIMARY KEY,
    AccountNumber VARCHAR(20) UNIQUE,
    Balance DECIMAL(18,2),
    OpeningDate DATE,
    UserID INT NOT NULL,   --FK to Users(UserID)
    BankID INT NOT NULL,
    BranchCode INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (BankID, BranchCode) REFERENCES Branch(BankID, BranchCode) ON DELETE CASCADE
);


-- BankLoan Table
CREATE TABLE BankLoan (
    LoanID SERIAL PRIMARY KEY,
    LoanAmount DECIMAL(18, 2),
    LoanType VARCHAR(50),
    LoanDate TIMESTAMP,
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);


-- Transactions Table
CREATE TABLE Transactions (
    TransactionID SERIAL PRIMARY KEY,
    TransactionType transaction_type,
    Amount DECIMAL(18, 2),
    TransactionDate TIMESTAMP
);


-- TransactionInvolvement Table (many-to-many between Transactions and BankAccounts)
CREATE TABLE TransactionInvolvement (
    TransactionID INT,
    BankAccountID INT,
    _ROLE VARCHAR(10),  -- 'From' or 'To'
    PRIMARY KEY (TransactionID, BankAccountID),
    FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID) ON DELETE CASCADE,
    FOREIGN KEY (BankAccountID) REFERENCES BankAccount(AccountID) ON DELETE CASCADE
);  


-- Notification Table
CREATE TABLE Notification (
    NotificationID SERIAL PRIMARY KEY,
    EntityType reference_type NOT NULL,  -- 'Transaction' or 'Loan'
    EntityID INT NOT NULL,                -- ID of the Transaction or Loan
    Message TEXT,
    NotificationType notification_type,     --  'TransactionAlert','LoanApproval',....
    NotificationTime TIMESTAMP,
    SentTo INT NOT NULL,
    FOREIGN KEY (SentTo) REFERENCES Users(UserID) ON DELETE CASCADE,
    -- EntityID references Transactions(TransactionID) or BankLoan(LoanID)
    -- Cannot enforce FK due to polymorphic relation, enforce in application logic or triggers
    UNIQUE (EntityType, EntityID, SentTo)
);
