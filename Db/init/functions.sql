-- function to get customer full name
CREATE OR REPLACE FUNCTION GetCustomerFullName(cust_id INT)
RETURNS TEXT AS $$
DECLARE
    fname TEXT;
    lname TEXT;
BEGIN
    SELECT FirstName, LastName INTO fname, lname FROM Users WHERE UserID = cust_id;
    RETURN fname || ' ' || lname;
END;
$$ LANGUAGE plpgsql;

-- function to calculate loan interest
CREATE OR REPLACE FUNCTION CalculateLoanInterest(loan_id INT, rate NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    amount NUMERIC;
BEGIN
    SELECT LoanAmount INTO amount FROM BankLoan WHERE LoanID = loan_id;
    RETURN amount * rate / 100;
END;
$$ LANGUAGE plpgsql;

-- function to check account balance before withdrawal
CREATE OR REPLACE FUNCTION CanWithdraw(account_id INT, amt NUMERIC)
RETURNS BOOLEAN AS $$
DECLARE
    bal NUMERIC;
BEGIN
    SELECT Balance INTO bal FROM BankAccount WHERE AccountID = account_id;
    RETURN bal >= amt;
END;
$$ LANGUAGE plpgsql;
