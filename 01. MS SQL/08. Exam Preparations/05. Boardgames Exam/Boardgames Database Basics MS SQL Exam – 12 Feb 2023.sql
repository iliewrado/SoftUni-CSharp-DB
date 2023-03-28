-- Section 1. DDL (30 pts)
CREATE DATABASE 
Boardgames
GO

USE 
Boardgames
GO

-- 1.	Database design
CREATE TABLE  Categories (
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses(
Id INT PRIMARY KEY IDENTITY 
,StreetName	NVARCHAR(100) NOT NULL
,StreetNumber INT NOT NULL 
,Town VARCHAR(30) NOT NULL
,Country VARCHAR(50) NOT NULL
,ZIP INT NOT NULL 
)

CREATE TABLE Publishers (
Id INT PRIMARY KEY IDENTITY 
,[Name] VARCHAR(30) NOT NULL
,AddressId INT FOREIGN KEY REFERENCES Addresses (Id)
,Website NVARCHAR(40)
,Phone NVARCHAR(20)
)

CREATE TABLE  PlayersRanges(
Id INT PRIMARY KEY IDENTITY 
,PlayersMin INT NOT NULL 
,PlayersMax INT NOT NULL 
)

CREATE TABLE  Boardgames(
Id INT PRIMARY KEY IDENTITY 
,[Name] NVARCHAR(30) NOT NULL
,YearPublished INT NOT NULL 
,Rating DECIMAL(15, 2) NOT NULL
,CategoryId INT FOREIGN KEY REFERENCES Categories (Id)
,PublisherId INT FOREIGN KEY REFERENCES Publishers (Id)
,PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges (Id)
)

CREATE TABLE  Creators(
Id INT PRIMARY KEY IDENTITY 
,FirstName NVARCHAR(30) NOT NULL
,LastName NVARCHAR(30) NOT NULL
,Email NVARCHAR(30) NOT NULL
)

CREATE TABLE  CreatorsBoardgames(
CreatorId INT NOT NULL FOREIGN KEY REFERENCES CreatorS (Id)
,BoardgameId INT NOT NULL FOREIGN KEY REFERENCES BoardgameS (Id)
PRIMARY KEY (CreatorId ,BoardgameId)
)

-- Section 2. DML (10 pts)

 -- 2.	Insert
INSERT INTO Boardgames([Name],	YearPublished,	Rating,	CategoryId,	PublisherId, PlayersRangeId)
VALUES
('Deep Blue',	2019,	5.67,	1,	15,	7		 )
,('Paris	',2016	,9.78	,7,	1,	5			 )
,('Catan: Starfarers',	2021,	9.87,	7,	13,	6)
,('Bleeding Kansas',	2020,	3.25,	3,	7,	4)
,('One Small Step	',2019	,5.75,	5,	9,	2)

INSERT INTO Publishers ([Name], AddressId,	Website,	Phone	)
VALUES
('Agman Games',	5,	'www.agmangames.com',	'+16546135542')
,('Amethyst Games',	7,'	www.amethystgames.com',	'+15558889992')
,('BattleBooks',	13,'	www.battlebooks.com','	+12345678907')

-- 3.	Update
UPDATE PlayersRanges 
SET PlayersMax = PlayersMax + 1
WHERE (PlayersMin = 2 AND PlayersMax = 2)

UPDATE Boardgames
SET [Name] = CONCAT([Name], 'V2')
WHERE YearPublished >= 2020

--4.	Delete
DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (
	SELECT Id FROM Boardgames
	WHERE PublisherId IN (
		SELECT Id 
		FROM Publishers
		WHERE AddressId IN (
			SELECT Id
			FROM Addresses
			WHERE Town LIKE 'L%')))

DELETE FROM Boardgames
WHERE PublisherId IN (
	SELECT Id 
	FROM Publishers
	WHERE AddressId IN (
		SELECT Id
		FROM Addresses
		WHERE Town LIKE 'L%'))

DELETE FROM Publishers
WHERE AddressId IN (
	SELECT Id
	FROM Addresses
	WHERE Town LIKE 'L%')

DELETE FROM Addresses
WHERE Town LIKE 'L%';

-- Section 3. Querying (40 pts)
 
 -- 5.	
SELECT 
[Name]
,Rating
FROM Boardgames
ORDER BY YearPublished ASC, [Name] DESC

-- 6.	
SELECT 
B.Id
,B.[Name]
,YearPublished
,C.[Name] AS CategoryName
FROM Boardgames AS B 
JOIN Categories AS C ON B.CategoryId = C.Id
WHERE C.[Name] = 'Strategy Games' OR C.[Name] = 'Wargames'
ORDER BY YearPublished DESC


-- 7.
SELECT 
Id
,CONCAT(FirstName, ' ', LastName) AS CreatorName
,C.Email
FROM Creators AS C 
WHERE C.Id NOT IN 
	(SELECT CreatorId
	FROM CreatorsBoardgames)
ORDER BY CreatorName

-- 8.	
SELECT TOP(5) 
B.[Name]
,Rating
,C.[Name] AS CategoryName
FROM Boardgames AS B
JOIN Categories AS C ON B.CategoryId = C.Id
JOIN PlayersRanges AS P ON B.PlayersRangeId = P.Id
WHERE (Rating > 7.00 AND B.[Name] LIKE '%a%') 
OR (Rating > 7.50 AND (P.PlayersMin = 2 AND P.PlayersMax = 5))
ORDER BY B.[Name]ASC, B.Rating DESC

-- 9.
SELECT 
CONCAT(C.FirstName, ' ', C.LastName) AS FullName
,C.Email
,MAX(B.Rating) AS Rating
FROM Creators AS C
JOIN CreatorsBoardgames AS CB ON CB.CreatorId = C.Id
JOIN Boardgames AS B ON CB.BoardgameId = B.Id
WHERE C.Email LIKE '%.com'
GROUP BY C.FirstName, C.LastName, C.Email
ORDER BY FullName

-- 10.	
SELECT 
C.LastName
,CEILING(AVG(B.Rating)) AS AverageRating	
,P.[Name] AS PublisherName
FROM Creators AS C
JOIN CreatorsBoardgames AS CB ON C.Id = CB.CreatorId
JOIN Boardgames AS B ON CB.BoardgameId = B.Id
JOIN Publishers AS P ON B.PublisherId = P.Id
WHERE P.[Name] = 'Stonemaier Games'
GROUP BY C.LastName, P.[Name]
ORDER BY AVG(B.Rating) DESC


-- Section 4. Programmability (20 pts)

-- 11. Create a user-defined function
GO
CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(30)) 
RETURNS INT
AS
BEGIN
RETURN (SELECT COUNT(B.Id) 
FROM Creators AS C
JOIN CreatorsBoardgames AS CG ON C.Id = CG.CreatorId
JOIN Boardgames AS B ON CG.BoardgameId = B.Id
WHERE FirstName = @name)
END
GO

-- 12.	Create a stored procedure
CREATE PROC usp_SearchByCategory(@category VARCHAR(50))
AS
BEGIN 
SELECT
B.[Name]
, B.YearPublished
, B.Rating
, C.[Name] AS CategoryName
, P.[Name] AS PublisherName
, CONCAT(PR.PlayersMin, ' people') AS MinPlayers
, CONCAT(PR.PlayersMax, ' people') AS MaxPlayers
FROM Boardgames AS B
JOIN Categories AS C ON B.CategoryId = C.Id
JOIN Publishers AS P ON B.PublisherId = P.Id
JOIN PlayersRanges AS PR ON B.PlayersRangeId = PR.Id 
WHERE C.[Name] = @category
ORDER BY P.[Name] ASC, B.YearPublished DESC 
END
GO
