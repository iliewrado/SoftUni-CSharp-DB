-- Part II – Queries for Bank Database
USE Bank
GO

-- 9.	Find Full Name
CREATE PROC usp_GetHoldersFullName
AS 
BEGIN
	SELECT 
		CONCAT(FirstName, ' ', LastName) AS [Full Name]
	FROM AccountHolders
END
GO

-- 10.	People with Balance Higher Than
CREATE PROC usp_GetHoldersWithBalanceHigherThan(@minBalance DECIMAL(18, 4))
AS
BEGIN
	SELECT 
	FirstName AS [First Name]
	,LastName AS [Last Name]
	FROM AccountHolders AS H
	LEFT JOIN Accounts AS A ON H.Id = A.AccountHolderId
	GROUP BY FirstName, LastName
	HAVING SUM(Balance) > @minBalance
	ORDER BY FirstName, LastName
END
GO

-- 11.	Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue 
(@initialSum DECIMAL(18, 4), @yearlyInterestRate FLOAT, @numberOfYears INT)
RETURNS DECIMAL (18, 4)
AS
BEGIN
	DECLARE @futureValue DECIMAL(18, 4)
	SET @futureValue = @initialSum * (POWER((1 + @yearlyInterestRate), @numberOfYears))
	RETURN @futureValue
END
GO

-- 12.	Calculating Interest
CREATE PROC usp_CalculateFutureValueForAccount (@accountId INT, @interestRate FLOAT)
AS
BEGIN
	SELECT
	A.Id AS [Account Id]
	,H.FirstName AS [First Name]
	,H.LastName AS [Last Name]
	,A.Balance AS [Current Balance]
	,dbo.ufn_CalculateFutureValue (A.Balance, @interestRate, 5) AS [Balance in 5 years]
	FROM AccountHolders AS H
	JOIN Accounts AS A ON H.Id = A.AccountHolderId
	WHERE A.Id = @accountId
END
GO

-- Exercises: Triggers and Transactions

-- 14. Create Table Logs
CREATE TABLE Logs (
LogId INT PRIMARY KEY IDENTITY 
,AccountId INT NOT NULL FOREIGN KEY REFERENCES Accounts (Id)
,OldSum MONEY NOT NULL
,NewSum MONEY NOT NULL
)
GO 

CREATE TRIGGER tr_AddToLogsOnAccountsUpdate
ON Accounts FOR UPDATE
AS
BEGIN
	INSERT INTO Logs (AccountId, OldSum, NewSum)
	SELECT I.Id, D.Balance, I.Balance
	FROM inserted AS I
	JOIN deleted AS D ON I.Id = D.Id
	WHERE I.Balance != D.Balance
END
GO

-- 15. Create Table Emails
CREATE TABLE NotificationEmails (
Id INT PRIMARY KEY IDENTITY 
,Recipient INT NOT NULL
,[Subject] NVARCHAR (50) NOT NULL
,Body NVARCHAR (100) NOT NULL
)
GO

CREATE TRIGGER tr_EmailNotifications
ON Logs AFTER INSERT
AS
BEGIN 
	INSERT INTO NotificationEmails (Recipient, [Subject], Body)
	SELECT 
		I.AccountId
		,CONCAT('Balance change for account: ', I.AccountId)
		,CONCAT('On ', GETDATE(),' your balance was changed from ', I.OldSum ,' to ', I.NewSum,'.')
	FROM inserted AS I
END
GO

-- 16.	Deposit Money
CREATE PROC usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(15, 4)) 
AS
BEGIN 
	BEGIN TRANSACTION
        UPDATE Accounts
           SET Balance += @MoneyAmount
         WHERE Id = @AccountId
    COMMIT
END 
GO

-- 17. 	Withdraw Money
CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(15, 4))
AS
BEGIN
	BEGIN TRANSACTION
        UPDATE Accounts
           SET Balance -= @MoneyAmount
         WHERE Id = @AccountId
    COMMIT
END 
GO

-- 18.	Money Transfer
CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15, 4))
AS
BEGIN 
	BEGIN TRANSACTION
        IF (@Amount <= 0)
        BEGIN
            RAISERROR('Amount cannot be negative or zero', 16, 1)
            ROLLBACK
            RETURN
        END
        EXEC usp_DepositMoney @ReceiverId, @Amount
        EXEC usp_WithdrawMoney @SenderId, @Amount
        COMMIT
END
GO