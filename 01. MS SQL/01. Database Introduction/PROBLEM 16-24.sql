--Problem 16.	Create SoftUni Database
CREATE DATABASE [SoftUni]

CREATE TABLE [Towns](
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Addresses](
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL
,[AddressText] VARCHAR (100) NOT NULL
,[TownId] INT NOT NULL FOREIGN KEY REFERENCES [Towns](Id)
)

CREATE TABLE [Departments](
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Employees](
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL
,[FirstName] VARCHAR(50) NOT NULL
,[MiddleName] VARCHAR(50)
,[LastName] VARCHAR(50) NOT NULL
,[JobTitle] VARCHAR(50)
,[DepartmentId] INT NOT NULL FOREIGN KEY REFERENCES [Departments](Id)
,[HireDate] DATE
,[Salary] DECIMAL(8,2)
,[AddressId] INT FOREIGN KEY REFERENCES [Addresses](Id)
)

--Problem 17.	Backup Database
BACKUP DATABASE [SoftUni] TO DISK = 'D:\softuni-backup.bak'

DROP DATABASE [SoftUni]

RESTORE DATABASE [SoftUni] FROM DISK = 'D:\softuni-backup.bak'

--Problem 18.	Basic Insert
INSERT INTO Towns
VALUES 
('Sofia')
,('Plovdiv')
,('Varna')
,('Burgas')

INSERT INTO Departments
VALUES
('Engineering')
,('Sales')
,('Marketing')
,('Software Development')
,('Quality Assurance')

INSERT INTO Employees ([FirstName],	[MiddleName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary])
VALUES
( 'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '01.02.2013', 3500.00)
,('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '02.03.2004', 4000.00)
,('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '28.08.2016', 525.25)
,('Georgi', 'Teziev ', 'Ivanov', 'CEO', 2, '09.12.2007', 3000.00)
,('Peter', 'Pan ', 'Pan', 'Intern', 3, '28.08.2016', 599.88)

--Problem 19.	Basic Select All Fields
SELECT *
FROM [Towns]

SELECT *
FROM [Departments]

SELECT *
FROM [Employees]

--Problem 20.	Basic Select All Fields and Order Them
SELECT *
FROM [Towns]
ORDER BY [Name] ASC

SELECT *
FROM [Departments]
ORDER BY [Name] ASC

SELECT *
FROM [Employees]
ORDER BY [Salary] DESC

--Problem 21.	Basic Select Some Fields
SELECT [Name]
FROM [Towns]
ORDER BY [Name] ASC

SELECT [Name]
FROM [Departments]
ORDER BY [Name] ASC

SELECT [FirstName]
       ,[LastName]
       ,[JobTitle]
       ,[Salary]
FROM [Employees]
ORDER BY [Salary] DESC

--Problem 22.	Increase Employees Salary
UPDATE [Employees]
  SET [Salary] *= 1.10

SELECT [Salary]
FROM [Employees]

--Problem 23.	Decrease Tax Rate
USE Hotel

UPDATE [Payments]
  SET [TaxRate] = [TaxRate] - ([TaxRate] * 0.03)

SELECT [TaxRate]
FROM [Payments]

--Problem 24.	Delete All Records
TRUNCATE TABLE [Occupancies]