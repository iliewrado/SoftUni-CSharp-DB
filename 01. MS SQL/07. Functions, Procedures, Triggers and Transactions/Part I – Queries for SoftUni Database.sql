-- Part I – Queries for SoftUni Database
USE [SoftUni]
GO

-- 1.	Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000 
AS
BEGIN
	SELECT 
		FirstName
		,LastName
	FROM Employees
	WHERE Salary > 35000
END
GO

-- 2.	Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber (@minSalary DECIMAL(18,4))
AS
BEGIN
	SELECT 
		FirstName
		,LastName
	FROM Employees
	WHERE Salary >= @minSalary
END
GO

-- 3.	Town Names Starting With
CREATE PROC usp_GetTownsStartingWith (@startWith NVARCHAR(50))
AS
BEGIN
	SELECT 
		[Name] AS [Town]
	FROM Towns
	WHERE [Name] LIKE @startWith + '%'
END
GO

