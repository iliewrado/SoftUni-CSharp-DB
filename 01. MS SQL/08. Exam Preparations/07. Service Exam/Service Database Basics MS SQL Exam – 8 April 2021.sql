-- Section 1. DDL (30 pts)
CREATE DATABASE 
[Service]
GO

USE 
[Service]
GO

-- 1.	Database design
CREATE TABLE Users (
Id INT PRIMARY KEY IDENTITY
,Username VARCHAR(30) UNIQUE NOT NULL
,[Password] VARCHAR(50) NOT NULL
,[Name] VARCHAR(50)
,Birthdate DATETIME 
,Age INT CHECK(Age BETWEEN 14 AND 110) 
,Email VARCHAR(50) NOT NULL
)

CREATE TABLE Departments (
Id INT PRIMARY KEY IDENTITY 
,[Name] VARCHAR(50) NOT NULL 
)

CREATE TABLE Employees (
Id INT PRIMARY KEY IDENTITY 
,FirstName VARCHAR(25)
,LastName VARCHAR(25)
,Birthdate DATETIME
,Age INT CHECK(Age BETWEEN 18 AND 110) 
,DepartmentId INT FOREIGN KEY REFERENCES Departments (Id)
)

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY 
,[Name] VARCHAR(50) NOT NULL
,DepartmentId INT FOREIGN KEY REFERENCES Departments (Id) NOT NULL
)

CREATE TABLE [Status] (
Id INT PRIMARY KEY IDENTITY 
,[Label] VARCHAR(20) NOT NULL
)

CREATE TABLE Reports (
Id INT PRIMARY KEY IDENTITY 
,CategoryId INT FOREIGN KEY REFERENCES Categories (Id) NOT NULL
,StatusId INT FOREIGN KEY REFERENCES [Status] (Id) NOT NULL
,OpenDate DATETIME NOT NULL
,CloseDate DATETIME
,[Description] VARCHAR(200) NOT NULL
,UserId INT FOREIGN KEY REFERENCES Users (Id) NOT NULL
,EmployeeId INT FOREIGN KEY REFERENCES Employees (Id)
)

 
 -- Section 2. DML (10 pts)
 -- 2.	Insert
INSERT INTO Employees (FirstName, LastName,	Birthdate,	DepartmentId)
VALUES
 ('Marlo',	'O\''Malley',	'1958-9-21',	1)
,('Niki',	'Stanaghan', '1969-11-26',	4)
,('Ayrton',	'Senna',	'1960-03-21',	9)
,('Ronnie', 'Peterson','1944-02-14',	9)
,('Giovanna', 'Amati', '1959-07-20',	5)


INSERT INTO Reports (CategoryId,	StatusId,	OpenDate,	CloseDate,	[Description],	UserId,	EmployeeId)
VALUES
(1,		1,	'2017-04-13',	 NULL,			'Stuck Road on Str.133',			6,	2)
,(6,	3,	'2015-09-05',	'2015-12-06',	'Charity trail running',			3,	5)
,(14,	2,	'2015-09-07',	 NULL,			'Falling bricks on Str.58',			5,	2)
,(4,	3,	'2017-07-03',	'2017-07-06',	'Cut off streetlight on Str.11',	1,	1)


-- 3.	Update
UPDATE Reports
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL

-- 4.	Delete
DELETE FROM Reports
WHERE [StatusId] = 4

 -- Section 3. Querying (40 pts)

 -- 5. TO  DO 
 SELECT
 [Description]
 ,FORMAT(OpenDate, 'dd-MM-yyyy') AS OpenDate
 FROM Reports
 WHERE EmployeeId IS NULL
 ORDER BY FORMAT(OpenDate, 'yyyy-MM-dd') ASC, [Description] ASC
 
 -- 6.
SELECT
[Description]
,C.[Name] AS CategoryName
FROM Reports AS R
JOIN Categories AS C ON R.CategoryId = C.Id
WHERE CategoryId IS NOT NULL
ORDER BY [Description] ASC, CategoryName ASC

 -- 7.
SELECT TOP(5)
C.[Name] AS CategoryName
,COUNT(R.Id) ReportsNumber
FROM Reports AS R
JOIN Categories AS C ON R.CategoryId = C.Id
GROUP BY C.[Name]
ORDER BY ReportsNumber DESC, CategoryName ASC

 -- 8.	
SELECT
Username,
C.[Name] AS CategoryName
FROM Reports AS R
JOIN Users AS U ON R.UserId = U.Id
JOIN Categories AS C ON R.CategoryId = C.Id 
WHERE (DATEPART(DAY, U.Birthdate) = DATEPART(DAY, R.OpenDate))
		AND (DATEPART(MONTH, U.Birthdate) = DATEPART(MONTH, R.OpenDate))
ORDER BY Username ASC, CategoryName ASC

 -- 9.	
SELECT
CONCAT(E.FirstName, ' ', E.LastName) AS FullName 
,COUNT(DISTINCT U.Id) AS UsersCount
FROM Employees AS E 
LEFT JOIN Reports AS R ON E.Id = R.EmployeeId
LEFT JOIN Users AS U ON R.UserId = U.Id
GROUP BY E.FirstName, E.LastName
ORDER BY UsersCount DESC, FullName ASC

 -- 10.
SELECT
	ISNULL(CONCAT(E.FirstName, ' ', E.LastName), 'None') AS Employee
	,ISNULL(D.[Name],'None') AS Department
	,ISNULL(C.[Name],'None') AS Category
	,ISNULL(R.[Description],'None') AS [Description]
	,ISNULL(FORMAT(R.OpenDate, 'dd.MM.yyyy'),'None') AS OpenDate
	,ISNULL(S.[Label],'None') AS [Status]
	,ISNULL(U.[Name],'None') AS [User]
FROM Reports AS R
	LEFT JOIN Employees AS E ON R.EmployeeId = E.Id
	LEFT JOIN Departments AS D ON E.DepartmentId = D.Id
	LEFT JOIN Categories AS C ON R.CategoryId = C.Id
	LEFT JOIN [Status] AS S ON R.StatusId = S.Id
	LEFT JOIN Users AS U ON R.UserId = U.Id
ORDER BY E.FirstName DESC, E.LastName DESC, D.[Name] ASC, 
		C.[Name] ASC, R.[Description] ASC, R.OpenDate ASC, S.[Label] ASC, U.[Name] ASC

 
 -- Section 4. Programmability (20 pts)

 -- 11.	Create a user-defined function
GO
CREATE FUNCTION udf_HoursToComplete(@StartDate DATETIME, @EndDate DATETIME) 
RETURNS INT
AS
BEGIN IF(@StartDate IS NULL OR @EndDate IS NULL)
		BEGIN
			RETURN 0
		END
RETURN DATEDIFF(HOUR, @StartDate, @EndDate)
END
GO


---- 12.	Create a stored procedure
CREATE PROC usp_AssignEmployeeToReport(@EmployeeId INT, @ReportId INT)
AS
BEGIN 
	DECLARE @EmployeeDepartmentId INT = (SELECT 
										DepartmentId
										FROM Employees
										WHERE Id = @EmployeeId)
	DECLARE @ReportDepartmentId INT = (SELECT
										C.DepartmentId
										FROM Reports AS R
										JOIN Categories AS C ON R.CategoryId = C.Id
										WHERE R.Id = @ReportId)
	IF(@EmployeeDepartmentId != @ReportDepartmentId)
		THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1

	UPDATE Reports
	SET EmployeeId = @EmployeeId
	WHERE Id = @ReportId
END
GO