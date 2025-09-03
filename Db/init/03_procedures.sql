-- procedure to deposit money
CREATE OR REPLACE PROCEDURE DepositMoney(acc_id INT, amt NUMERIC)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE BankAccount SET Balance = Balance + amt WHERE AccountID = acc_id;
    INSERT INTO Transactions(TransactionType, Amount, TransactionDate, CreatedBy)
    VALUES ('Deposit', amt, NOW(), acc_id);
END;
$$;

-- procedure to withdraw money
CREATE OR REPLACE PROCEDURE WithdrawMoney(acc_id INT, amt NUMERIC)
LANGUAGE plpgsql AS $$
BEGIN
    IF CanWithdraw(acc_id, amt) THEN
        UPDATE BankAccount SET Balance = Balance - amt WHERE AccountID = acc_id;
        INSERT INTO Transactions(TransactionType, Amount, TransactionDate, CreatedBy)
        VALUES ('Withdrawal', amt, NOW(), acc_id);
    ELSE
        RAISE EXCEPTION 'Insufficient funds for account %', acc_id;
    END IF;
END;
$$;

-- procedure to transfer between accounts
CREATE OR REPLACE PROCEDURE TransferMoney(from_acc INT, to_acc INT, amt NUMERIC)
LANGUAGE plpgsql AS $$
BEGIN
    PERFORM WithdrawMoney(from_acc, amt);
    PERFORM DepositMoney(to_acc, amt);
END;
$$;
