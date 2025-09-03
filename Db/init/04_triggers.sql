-- Trigger function for Notification integrity
CREATE OR REPLACE FUNCTION CheckNotificationEntity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.EntityType = 'Transaction' THEN
        -- Make sure the transaction exists
        IF NOT EXISTS (SELECT 1 FROM Transactions WHERE TransactionID = NEW.EntityID) THEN
            RAISE EXCEPTION 'Notification references non-existent Transaction %', NEW.EntityID;
        END IF;
    ELSIF NEW.EntityType = 'Loan' THEN
        -- Make sure the loan exists
        IF NOT EXISTS (SELECT 1 FROM BankLoan WHERE LoanID = NEW.EntityID) THEN
            RAISE EXCEPTION 'Notification references non-existent Loan %', NEW.EntityID;
        END IF;
    ELSE
        RAISE EXCEPTION 'Invalid EntityType: %', NEW.EntityType;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_notification_entity
BEFORE INSERT OR UPDATE ON Notification
FOR EACH ROW
EXECUTE FUNCTION CheckNotificationEntity();



-- Trigger: Auto-Update Loan Status
-- Purpose: When a loan is fully paid, automatically set its status to 'Closed'.
CREATE OR REPLACE FUNCTION AutoCloseLoan()
RETURNS TRIGGER AS $$
DECLARE
    total_paid NUMERIC;
BEGIN
    -- Sum all repayments for this loan
    SELECT COALESCE(SUM(Amount),0) INTO total_paid
    FROM Transactions t
    JOIN TransactionInvolvement ti ON t.TransactionID = ti.TransactionID
    WHERE ti.BankAccountID IN (SELECT AccountID FROM BankAccount WHERE UserID = NEW.UserID)
      AND t.TransactionType = 'LoanPayment';

    IF total_paid >= NEW.LoanAmount THEN
        UPDATE BankLoan SET Status = 'Closed' WHERE LoanID = NEW.LoanID;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_autoclose_loan
AFTER INSERT ON Transactions
FOR EACH ROW
WHEN (NEW.TransactionType = 'LoanPayment')
EXECUTE FUNCTION AutoCloseLoan();



-- Trigger: Auto-Set Customer CanPerformTransactions Based on Loyalty Level
-- Purpose: Automatically enable certain privileges for customers based on their loyalty level.
--  For example: Gold & Platinum customers can perform transactions without manual updates.

CREATE OR REPLACE FUNCTION SetCustomerTransactionPermission()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.LoyaltyLevel IN ('Gold', 'Platinum') THEN
        NEW.CanPerformTransactions := TRUE;
    ELSE
        NEW.CanPerformTransactions := FALSE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_customer_loyalty_update
BEFORE INSERT OR UPDATE ON Customer
FOR EACH ROW
EXECUTE FUNCTION SetCustomerTransactionPermission();
