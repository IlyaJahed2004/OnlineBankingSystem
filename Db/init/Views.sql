-- view for all active customers with account balance
CREATE OR REPLACE VIEW ActiveCustomerAccounts AS
SELECT u.UserID, u.FirstName, u.LastName, c.LoyaltyLevel, b.AccountNumber, b.Balance
FROM Users u
JOIN Customer c ON u.UserID = c.CustomerID
JOIN BankAccount b ON u.UserID = b.UserID
WHERE u.IsActive = TRUE;

-- view for overdue loans
CREATE OR REPLACE VIEW OverdueLoans AS
SELECT l.LoanID, l.UserID, l.LoanAmount, l.DueDate
FROM BankLoan l
WHERE l.DueDate < CURRENT_DATE AND l.Status != 'Closed';

-- view for recent transactions
CREATE OR REPLACE VIEW RecentTransactions AS
SELECT t.TransactionID, t.TransactionType, t.Amount, t.TransactionDate, u.FirstName, u.LastName
FROM Transactions t
JOIN Users u ON t.CreatedBy = u.UserID
ORDER BY t.TransactionDate DESC;