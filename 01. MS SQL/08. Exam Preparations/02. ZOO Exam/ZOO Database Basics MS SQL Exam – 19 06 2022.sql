-- Database Basics MS SQL Exam – 19 06 2022
-- N.B.
-- Use VARCHAR for strings, not NVARCHAR. 
-- Keep in mind that Judge doesn’t accept the “ALTER” statement 
-- and square brackets naming when the names are not keywords.

-- Section 1. DDL (30 pts)
CREATE DATABASE Zoo

GO

USE Zoo

GO

-- 1.	Database design
CREATE TABLE Owners(
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(50) NOT NULL
,PhoneNumber VARCHAR(15) NOT NULL
,[Address] VARCHAR(50)
)

CREATE TABLE AnimalTypes(
Id INT PRIMARY KEY IDENTITY
,AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages(
Id INT PRIMARY KEY IDENTITY
,AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE Animals(
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(30) NOT NULL
,BirthDate DATE NOT NULL
,OwnerId INT FOREIGN KEY REFERENCES Owners(Id)
,AnimalTypeId INT NOT NULL FOREIGN KEY REFERENCES AnimalTypes(Id)
)

CREATE TABLE AnimalsCages(
CageId INT NOT NULL FOREIGN KEY REFERENCES Cages(Id)
,AnimalId INT NOT NULL FOREIGN KEY REFERENCES Animals(Id)
PRIMARY KEY (CageId ,AnimalId)
)

CREATE TABLE VolunteersDepartments(
Id INT PRIMARY KEY IDENTITY
, DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers(
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(50) NOT NULL
,PhoneNumber VARCHAR(15) NOT NULL
,[Address] VARCHAR(50) 
,AnimalId INT FOREIGN KEY REFERENCES Animals(Id)
,DepartmentId INT NOT NULL FOREIGN KEY REFERENCES VolunteersDepartments(Id)
)


-- Section 2. DML (10 pts)
-- Before you start you have to import "01. DDL_Dataset.sql ". 
-- If you have created the structure correctly the data should be successfully inserted. 

-- 2.	Insert
INSERT INTO Volunteers 
	([Name],	PhoneNumber, [Address], AnimalId, DepartmentId)
VALUES
 ('Anita Kostova' ,'0896365412', 'Sofia, 5 Rosa str.', 15, 1)
,('Dimitur Stoev', '0877564223', null, 42, 4)
,('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7)
,('Stoyan Tomov', '0898564100',	 'Montana, 1 Bor str.', 18, 8)
,('Boryana Mileva', '0888112233', null, 31, 5)

INSERT INTO Animals ([Name], BirthDate, OwnerId, AnimalTypeId)
VALUES
 ('Giraffe', '2018-09-21', 21,	1)
,('Harpy Eagle', '2015-04-17',	15,	3)
,('Hamadryas Baboon', '2017-11-02',	null, 1)
,('Tuatara', '2021-06-30',	2,	4)

-- 3.	Update
UPDATE Animals
SET OwnerId = (SELECT Id 
				FROM Owners
				WHERE [Name] = 'Kaloqn Stoqnov')
WHERE OwnerId IS NULL

-- 4.	Delete
DELETE FROM Volunteers
WHERE DepartmentId IN (SELECT Id 
						FROM VolunteersDepartments 
						WHERE DepartmentName = 'Education program assistant')

DELETE FROM VolunteersDepartments 
WHERE DepartmentName = 'Education program assistant'

-- Section 3. Querying (40 pts)
-- You need to start with a fresh dataset, 
-- so recreate your DB and import the sample data again (01. DDL_Dataset.sql).
-- DO NOT CHANGE OR INCLUDE DATA FROM DELETE, INSERT AND UDATE TASKS!!!

-- 5.	Volunteers
SELECT 
[Name]
,PhoneNumber
,[Address]
,AnimalId
,DepartmentId
FROM Volunteers
ORDER BY [Name], AnimalId, DepartmentId

-- 6.	Animals data
SELECT 
 [Name]
,AnimalType
,FORMAT(A.BirthDate, 'dd.MM.yyy') AS BirthDate
FROM Animals AS A
JOIN AnimalTypes AS T ON A.AnimalTypeId = T.Id
ORDER BY A.[Name]

-- 7.	Owners and Their Animals
SELECT TOP(5)
 O.[Name]
,COUNT(A.Id) AS CountOfAnimals
FROM Animals AS A
JOIN Owners AS O ON A.OwnerId = O.Id
GROUP BY O.[Name]
ORDER BY CountOfAnimals DESC, O.[Name]

-- 8.	Owners, Animals and Cages
SELECT 
 CONCAT(O.[Name], '-', A.[Name]) AS OwnersAnimals
,O.PhoneNumber
,C.CageId
FROM Animals AS A
JOIN Owners AS O ON A.OwnerId = O.Id
JOIN AnimalsCages AS C ON A.Id = C.AnimalId
JOIN AnimalTypes AS T ON A.AnimalTypeId = T.Id
WHERE T.AnimalType = 'Mammals'
ORDER BY O.[Name], A.[Name] DESC

-- 9.	Volunteers in Sofia
SELECT 
V.[Name]
,V.PhoneNumber
,REPLACE(REPLACE(V.[Address],' Sofia ', 'Sofia'),'Sofia, ', '') AS [Address]
FROM Volunteers AS V
JOIN VolunteersDepartments AS D ON V.DepartmentId = D.Id
WHERE D.DepartmentName = 'Education program assistant' 
AND V.Address LIKE '%Sofia%'
ORDER BY V.[Name]

-- 10.	Animals for Adoption
SELECT 
[Name]	
,DATEPART(YEAR,(SELECT BirthDate WHERE
				DATEDIFF(YEAR, A.BirthDate, '2022-01-01') < 5)) AS BirthYear
,AnimalType
FROM Animals AS A
JOIN AnimalTypes AS T ON A.AnimalTypeId = T.Id
WHERE OwnerId IS NULL AND AnimalType <> 'Birds'
ORDER BY A.[Name]

-- Section 4. Programmability (20 pts)
GO
-- 11.	All Volunteers in a Department
CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS 
BEGIN
RETURN (SELECT COUNT(*)
		FROM Volunteers
		WHERE DepartmentId IN (SELECT Id FROM VolunteersDepartments
								WHERE DepartmentName = @VolunteersDepartment))
END
GO


