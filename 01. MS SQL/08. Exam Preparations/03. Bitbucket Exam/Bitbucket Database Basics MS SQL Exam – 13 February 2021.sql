-- Database Basics MS SQL Exam � 13 February 2021

-- N.B: Use VARCHAR for strings, not NVARCHAR! 
-- Keep in mind that Judge doesn�t accept �ALTER� statement 
-- and square brackets naming, when the names are not keywords.

-- Section 1. DDL (30 pts)
CREATE DATABASE Bitbucket
GO

USE Bitbucket
GO

-- 1.	Database Design
CREATE TABLE Users (
Id INT PRIMARY KEY IDENTITY
,Username VARCHAR(30) NOT NULL
,[Password] VARCHAR(30) NOT NULL
,Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories (
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors (
RepositoryId INT FOREIGN KEY REFERENCES Repositories (Id) NOT NULL
,ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
PRIMARY KEY(RepositoryId ,ContributorId)
)

CREATE TABLE Issues (
Id INT PRIMARY KEY IDENTITY
,Title VARCHAR(255) NOT NULL
,IssueStatus VARCHAR(6) NOT NULL
,RepositoryId INT FOREIGN KEY REFERENCES Repositories (Id) NOT NULL
,AssigneeId INT FOREIGN KEY REFERENCES Users (Id) NOT NULL
)

CREATE TABLE Commits (
Id INT PRIMARY KEY IDENTITY
,[Message] VARCHAR(255) NOT NULL
,IssueId INT FOREIGN KEY REFERENCES Issues (Id)
,RepositoryId INT FOREIGN KEY REFERENCES Repositories (Id) NOT NULL
,ContributorId INT FOREIGN KEY REFERENCES Users (Id) NOT NULL
)

CREATE TABLE Files (
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(100) NOT NULL
,Size DECIMAL(18,2) NOT NULL
,ParentId INT FOREIGN KEY REFERENCES Files (Id)
,CommitId INT FOREIGN KEY REFERENCES Commits (Id) NOT NULL
)

-- Section 2. DML (10 pts)

-- Before you start, you must import �DataSet-Bitbucket.sql�.
-- If you have created the structure correctly, 
-- the data should be successfully inserted without any errors.

-- 2.	Insert
INSERT INTO Files 
([Name], Size, ParentId, CommitId)
VALUES
 ('Trade.idk', 2598.0, 1, 1)
,('menu.net', 9238.31, 2, 2)
,('Administrate.soshy', 1246.93, 3,	3)
,('Controller.php', 7353.15, 4, 4)
,('Find.java', 9957.86, 5, 5)
,('Controller.json', 14034.87, 3, 6)
,('Operate.xix', 7662.92, 7, 7)

INSERT INTO Issues
(Title, IssueStatus, RepositoryId, AssigneeId)
VALUES
 ('Critical Problem with HomeController.cs file', 'open', 1, 4)
,('Typo fix in Judge.html', 'open', 4, 3)
,('Implement documentation for UsersService.cs', 'closed', 8, 2)
,('Unreachable code in Index.cs', 'open', 9 ,8)

-- 3.	Update
UPDATE Issues
SET IssueStatus = 'closed' 
WHERE AssigneeId = 6

-- 4.	Delete
DELETE FROM Issues
WHERE RepositoryId IN (SELECT Id FROM Repositories
						WHERE [Name] = 'Softuni-Teamwork')
DELETE FROM RepositoriesContributors
WHERE RepositoryId IN (SELECT Id FROM Repositories
						WHERE [Name] = 'Softuni-Teamwork')

-- Section 3. Querying (40 pts)

-- You need to start with a fresh dataset, 
-- so recreate your DB and import the sample data again (DataSet-Bitbucket.sql).

-- 5.	Commits
SELECT 
Id
,[Message]
,RepositoryId 
,ContributorId
FROM Commits
ORDER BY Id, [Message], RepositoryId, ContributorId

-- 6.	Front-end
SELECT 
Id
,[Name]
,Size
FROM Files
WHERE Size > 1000 AND [Name] LIKE '%html%'
ORDER BY Size DESC, Id, [Name]

-- 7.	Issue Assignment
SELECT
I.Id
,CONCAT(U.Username, ' : ', I.Title) AS IssueAssignee
FROM Issues AS I
LEFT JOIN Users AS U ON I.AssigneeId = U.Id
ORDER BY I.Id DESC, I.AssigneeId

-- 8.	Single Files
SELECT
F.Id
,F.[Name]
,CONCAT(F.Size, 'KB') AS Size
FROM Files AS F
LEFT JOIN Files AS P ON F.Id = P.ParentId
WHERE P.Id IS NULL
ORDER BY F.Id, F.[Name], F.Size DESC

-- 9.	Commits in Repositories
SELECT TOP(5)
R.Id
,[Name]
,COUNT(*) AS Commits
FROM Repositories AS R
JOIN Commits AS C ON C.RepositoryId = R.Id
JOIN RepositoriesContributors AS RC ON R.Id = RC.RepositoryId
GROUP BY R.Id, [Name]
ORDER BY Commits DESC, R.Id, R.[Name] 

-- 10.	Average Size
SELECT
U.Username
,AVG(F.Size) AS Size
FROM Users AS U
JOIN Commits AS C ON U.Id = C.ContributorId
JOIN Files AS F ON C.Id = F.CommitId
GROUP BY U.Id, U.Username
ORDER BY Size DESC, U.Username

-- Section 4. Programmability (20 pts)
GO
-- 11.	All User Commits
CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
AS 
BEGIN 
RETURN (SELECT 
		COUNT(C.Id)
		FROM Commits AS C
		JOIN Users AS U ON C.ContributorId = U.Id
		WHERE U.Username = @username)
END
GO

-- Query
-- SELECT dbo.udf_AllUserCommits('UnderSinduxrein')
-- Output
-- 6

-- 12.	 Search for Files
CREATE PROC usp_SearchForFiles(@fileExtension VARCHAR(30))
AS 
BEGIN
SELECT
Id
,[Name]
,CONCAT(Size, 'KB') AS Size
FROM Files
WHERE [Name] LIKE CONCAT('%', @fileExtension)
ORDER BY Id, [Name], Size DESC
END
GO

-- Query
-- EXEC usp_SearchForFiles 'txt'
-- Output
-- Id	Name		Size
-- 28	Jason.txt	10317.54KB
-- 31	file.txt	5514.02KB
-- 43	init.txt	16089.79KB