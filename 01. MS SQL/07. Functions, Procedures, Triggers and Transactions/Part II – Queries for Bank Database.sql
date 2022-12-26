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

