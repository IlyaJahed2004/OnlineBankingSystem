/***************************************************************
 1) List all customer accounts with balances
 -- Shows each customer's bank accounts and their current balances.
 ***************************************************************/
SELECT u.userID, u.firstName, u.lastName, ba.accountID, ba.accountNumber, ba.balance
FROM Users u
JOIN BankAccount ba ON ba.userID = u.userID
WHERE u.userType = 'Customer'
ORDER BY u.userID, ba.accountID;


----------------------------------------------------------------
/***************************************************************
 2) Total balance per customer (sum of all their accounts)
 -- Summarizes total assets for each customer.
 ***************************************************************/
SELECT u.userID, u.firstName, u.lastName, SUM(ba.balance) AS total_balance
FROM Users u
JOIN BankAccount ba ON ba.userID = u.userID
WHERE u.userType = 'Customer'
GROUP BY u.userID, u.firstName, u.lastName
ORDER BY total_balance DESC;


----------------------------------------------------------------
/***************************************************************
 3) Last 3 transactions for a specific user
 -- Replace :user_id with the desired user ID. Shows the 3 most recent transactions created by that user.
 ***************************************************************/
-- Example: change 1 to another user id if needed
SELECT *
FROM Transactions
WHERE createdBy = 1
ORDER BY transactionDate DESC
LIMIT 3;


----------------------------------------------------------------
/***************************************************************
 4) Count and sum of transactions grouped by type
 -- Gives number of transactions and total amount for each transaction type.
 ***************************************************************/
SELECT transactionType, COUNT(*) AS count_tx, SUM(amount) AS sum_amount
FROM Transactions
GROUP BY transactionType
ORDER BY sum_amount DESC;


----------------------------------------------------------------
/***************************************************************
 5) Accounts with balance below a threshold
 -- Replace 500 with your threshold. Finds low-balance accounts.
 ***************************************************************/
SELECT accountID, accountNumber, userID, balance
FROM BankAccount
WHERE balance < 500;  -- change 500 to desired threshold


----------------------------------------------------------------
/***************************************************************
 6) Unread notifications per user
 -- Shows how many unread notifications each user has.
 ***************************************************************/
SELECT sentTo AS userID, COUNT(*) AS unread_count
FROM Notification
WHERE isRead = FALSE
GROUP BY sentTo
ORDER BY unread_count DESC;


----------------------------------------------------------------
/***************************************************************
 7) Active or in-process loans (Pending or Approved)
 -- Lists loans that still need attention (not closed/rejected).
 ***************************************************************/
SELECT loanID, userID, loanAmount, status, dueDate
FROM BankLoan
WHERE status IN ('Pending','Approved')
ORDER BY dueDate;


----------------------------------------------------------------
/***************************************************************
 8) Accounts with no transactions
 -- Finds accounts that have no entries in TransactionInvolvement.
 ***************************************************************/
SELECT ba.accountID, ba.accountNumber, ba.userID
FROM BankAccount ba
LEFT JOIN TransactionInvolvement ti ON ba.accountID = ti.bankAccountID
WHERE ti.transactionID IS NULL;


----------------------------------------------------------------
/***************************************************************
 9) Top 5 customers by total balance
 -- Quick leaderboard of 5 customers with highest combined balances.
 ***************************************************************/
SELECT u.userID, u.firstName, u.lastName, SUM(ba.balance) AS total_balance
FROM Users u
JOIN BankAccount ba ON ba.userID = u.userID
WHERE u.userType = 'Customer'
GROUP BY u.userID, u.firstName, u.lastName
ORDER BY total_balance DESC
LIMIT 5;


----------------------------------------------------------------
/***************************************************************
 10) Transactions in the last 30 days by branch (count and sum)
 -- For each branch, count transactions and sum amounts over the past 30 days.
 ***************************************************************/
SELECT ba.bankID, ba.branchCode,
       COUNT(DISTINCT ti.transactionID) AS tx_count,
       SUM(t.amount) AS total_amount
FROM TransactionInvolvement ti
JOIN Transactions t ON t.transactionID = ti.transactionID
JOIN BankAccount ba ON ba.accountID = ti.bankAccountID
WHERE t.transactionDate >= NOW() - INTERVAL '30 days'
GROUP BY ba.bankID, ba.branchCode
ORDER BY tx_count DESC;
