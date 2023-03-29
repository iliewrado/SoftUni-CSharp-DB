-- Section 1. DDL (30 pts)
CREATE DATABASE 
NationalTouristSitesOfBulgaria
GO

USE 
NationalTouristSitesOfBulgaria
GO

-- 1.	Database design
CREATE TABLE  Categories (
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations (
Id INT PRIMARY KEY IDENTITY 
,[Name] VARCHAR(50) NOT NULL
,Municipality VARCHAR(50) 
,Province VARCHAR(50) 
)

CREATE TABLE Sites (
Id INT PRIMARY KEY IDENTITY 
,[Name] VARCHAR(100) NOT NULL
,LocationId INT FOREIGN KEY REFERENCES Locations (Id)
,CategoryId INT FOREIGN KEY REFERENCES Categories (Id)
,Establishment VARCHAR(15) 
)

CREATE TABLE Tourists (
Id INT PRIMARY KEY IDENTITY 
,[Name] VARCHAR(50) NOT NULL
,Age INT NOT NULL CHECK(Age BETWEEN 0 AND 120) 
,PhoneNumber VARCHAR(20) NOT NULL
,Nationality VARCHAR(30) NOT NULL
,Reward VARCHAR(20) 
)

CREATE TABLE BonusPrizes (
Id INT PRIMARY KEY IDENTITY 
,[Name] VARCHAR(50) NOT NULL	
)

CREATE TABLE SitesTourists (
TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists (Id)
,SiteId INT NOT NULL FOREIGN KEY REFERENCES Sites (Id)
PRIMARY KEY (TouristId, SiteId)
)

CREATE TABLE TouristsBonusPrizes (
TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists (Id)
,BonusPrizeId INT NOT NULL FOREIGN KEY REFERENCES BonusPrizes (Id)
PRIMARY KEY (TouristId , BonusPrizeId)
)


 -- Section 2. DML (10 pts)
 -- 2.	Insert
INSERT INTO Tourists ([Name],	Age,	PhoneNumber,	Nationality,	Reward	)
VALUES
('Borislava Kazakova',	52,	'+359896354244',	'Bulgaria',	NULL)
,('Peter Bosh',	48,	'+447911844141',	'UK',	NULL					)
,('Martin Smith',	29,	'+353863818592',	'Ireland',	'Bronze badge'		)
,('Svilen Dobrev',	49,	'+359986584786',	'Bulgaria',	'Silver badge')
,('Kremena Popova',	38,	'+359893298604',	'Bulgaria',	NULL		)

INSERT INTO Sites ([Name],	LocationId,	CategoryId,	Establishment	)
VALUES
('Ustra fortress',	90,	7,	'X')
,('Karlanovo Pyramids',	65,	7,	NULL)
,('The Tomb of Tsar Sevt',	63,	8,	'V BC')
,('Sinite Kamani Natural Park',	17,	1,	NULL)
,('St. Petka of Bulgaria � Rupite',	92,	6,	'1994')



-- 3.	Update
UPDATE Sites
SET Establishment = '(not defined)'
WHERE Establishment IS NULL

-- 4.	Delete
DELETE FROM TouristsBonusPrizes
WHERE BonusPrizeId IN 
		(SELECT
		Id FROM BonusPrizes
		WHERE [Name] = 'Sleeping bag')

DELETE FROM BonusPrizes
WHERE [Name] = 'Sleeping bag'


 -- Section 3. Querying (40 pts)

 -- 5.
 
 -- 6.
 
 -- 7.	

 -- 8.	

 -- 9.	

 -- 10.
 
 -- Section 4. Programmability (20 pts)

 -- 11.	Create a user-defined function
GO
CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100))
RETURNS INT
AS
BEGIN
RETURN (SELECT 
COUNT(TouristId) 
FROM SitesTourists
WHERE SiteId IN (SELECT 
		Id	
		FROM Sites
		WHERE [Name] = @Site)
)
END
GO


---- 12.	Create a stored procedure
CREATE PROC usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
BEGIN 
UPDATE Tourists
SET Reward = CASE 
	WHEN 
	WHEN 
	THEN 
	END 
WHERE [Name] = @TouristName
END
GO