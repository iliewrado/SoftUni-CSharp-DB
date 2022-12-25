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

-- 4.	Employees from Town
CREATE PROC usp_GetEmployeesFromTown (@townName NVARCHAR(50))
AS
BEGIN
	SELECT 
		FirstName
		,LastName
	FROM Employees AS E
	 LEFT JOIN Addresses AS A ON E.AddressID = A.AddressID
	 LEFT JOIN Towns AS T ON A.TownID = T.TownID
	WHERE T.[Name] = @townName
END
GO

-- 5.	Salary Level Function
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10)
AS 
BEGIN 
	DECLARE @salaryLevel VARCHAR(10)
		IF @salary < 30000 
			BEGIN
				SET @salaryLevel = 'Low'
			END
		ELSE IF @salary > 50000 
			BEGIN
				SET @salaryLevel = 'High'
			END
		ELSE 
			BEGIN 
				SET @salaryLevel = 'Average'
			END
	RETURN @salaryLevel
END
GO

-- 6.	Employees by Salary Level
CREATE PROC usp_EmployeesBySalaryLevel (@salaryLevel VARCHAR(10))
AS
BEGIN
	SELECT 
		FirstName
		,LastName
	FROM Employees
	WHERE @salaryLevel = [dbo].ufn_GetSalaryLevel(Salary)
END
GO

-- 7.	Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
	DECLARE @index SMALLINT = 1;
	WHILE(@index <= LEN(@word))
		BEGIN
			IF(CHARINDEX(SUBSTRING(@word, @index, 1), @setOfLetters) = 0)
			BEGIN
				RETURN 0
			END
		SET @index += 1;
		END
		RETURN 1
END
GO

-- 8.	* Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS
BEGIN
	DELETE FROM EmployeesProjects
		   WHERE EmployeeID IN (SELECT EmployeeID
								    FROM Employees
							       WHERE DepartmentID = @departmentId)
	 UPDATE Employees
	    SET ManagerID = NULL
		WHERE ManagerID IN (SELECT EmployeeID
							   FROM Employees
							  WHERE DepartmentID = @departmentId)
	 ALTER TABLE Departments
	 ALTER COLUMN ManagerID INT

	 UPDATE Departments
		SET ManagerID = NULL
		WHERE ManagerID IN (SELECT EmployeeID
							   FROM Employees
							  WHERE DepartmentID = @departmentID)
	 DELETE FROM Employees
		   WHERE DepartmentID = @departmentId

	 DELETE FROM Departments
	       WHERE DepartmentID = @departmentId

	 SELECT COUNT(EmployeeId)
	   FROM Employees
	   WHERE DepartmentID = @departmentId
END
GO