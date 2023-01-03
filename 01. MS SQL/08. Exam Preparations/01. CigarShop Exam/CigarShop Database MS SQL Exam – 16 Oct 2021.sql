-- Database Basics MS SQL Exam – 16 Oct 2021
-- N.B: Keep in mind that Judge doesn’t accept “ALTER” statement
-- and square brackets naming, when the names are not keywords.
-- Section 1. DDL (30 pts)
CREATE DATABASE CigarShop
GO

USE CigarShop

GO

-- 1.	Database design
CREATE TABLE Sizes (
Id INT PRIMARY KEY IDENTITY
,[Length] INT NOT NULL CHECK([Length] BETWEEN 10 AND 25) 
,RingRange DECIMAL(18, 2) NOT NULL CHECK(RingRange BETWEEN 1.5 AND 7.5)
)

CREATE TABLE Tastes(
Id INT PRIMARY KEY IDENTITY 
,TasteType VARCHAR(20) NOT NULL
,TasteStrength VARCHAR(15) NOT NULL
,ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Brands(
Id INT PRIMARY KEY IDENTITY 
,BrandName VARCHAR(30) NOT NULL UNIQUE
,BrandDescription VARCHAR(MAX)
)

CREATE TABLE Cigars(
Id INT PRIMARY KEY IDENTITY 
,CigarName VARCHAR(80) NOT NULL
,BrandId INT NOT NULL FOREIGN KEY REFERENCES Brands(Id)
,TastId	INT NOT NULL FOREIGN KEY REFERENCES Tastes(Id)
,SizeId INT NOT NULL FOREIGN KEY REFERENCES Sizes(Id)
,PriceForSingleCigar MONEY NOT NULL
,ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Addresses(
Id INT PRIMARY KEY IDENTITY 
,Town VARCHAR(30) NOT NULL
,Country NVARCHAR(30) NOT NULL
,Streat	NVARCHAR(100) NOT NULL
,ZIP VARCHAR(20) NOT NULL
)

CREATE TABLE Clients(
Id INT PRIMARY KEY IDENTITY 
,FirstName NVARCHAR(30) NOT NULL 
,LastName  NVARCHAR(30) NOT NULL 
,Email	   NVARCHAR(50) NOT NULL 
,AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id)
)

CREATE TABLE ClientsCigars(
ClientId INT NOT NULL FOREIGN KEY REFERENCES Clients(Id)
,CigarId INT NOT NULL FOREIGN KEY REFERENCES Cigars(Id)
PRIMARY KEY (ClientId, CigarId)
)

-- Section 2. DML (10 pts)
-- Before you start you have to import "01-DDL-Data-Seeder.sql ".
-- If you have created the structure correctly the data should be successfully inserted.

-- 2.	Insert
INSERT INTO Cigars
(CigarName,	BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL)
VALUES
('COHIBA ROBUSTO',	9,	1,	5,	15.50,	'cohiba-robusto-stick_18.jpg')
,('COHIBA SIGLO I',	9,	1,	10,	410.00,	'cohiba-siglo-i-stick_12.jpg')
,('HOYO DE MONTERREY LE HOYO DU MAIRE',	14,	5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg')
,('HOYO DE MONTERREY LE HOYO DE SAN JUAN',	14,	4, 15,	32.00, 'hoyo-de-san-juan-stick_20.jpg')
,('TRINIDAD COLONIALES',	2,	3,	8,	85.21,	'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses (Town, Country, Streat, ZIP)
VALUES
('Sofia', 'Bulgaria', '18 Bul. Vasil levski', '1000')
,('Athens', 'Greece', '4342 McDonald Avenue', '10435')
,('Zagreb', 'Croatia', '4333 Lauren Drive', '10000')

-- 3.	Update
UPDATE Cigars
SET PriceForSingleCigar = PriceForSingleCigar * 1.2
WHERE TastId = 1

UPDATE Brands
SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

-- 4.	Delete
DELETE FROM Clients
WHERE AddressId IN (
	SELECT Id FROM Addresses
	WHERE SUBSTRING(Country, 1, 1) = 'C')

DELETE FROM Addresses
WHERE SUBSTRING(Country, 1, 1) = 'C'

-- Section 3. Querying (40 pts)
-- You need to start with a fresh dataset, 
-- so recreate your DB and import the sample data again (01-DDL-Data-Seeder.sql).

-- 5.	Cigars by Price
SELECT
	CigarName
	,PriceForSingleCigar
	,ImageURL
FROM Cigars
ORDER BY PriceForSingleCigar, CigarName DESC

-- 6.	Cigars by Taste
SELECT 
C.Id
,C.CigarName
,C.PriceForSingleCigar
,T.TasteType
,T.TasteStrength
FROM Cigars AS C
JOIN Tastes AS T ON C.TastId = T.Id
WHERE T.TasteType IN ('Earthy', 'Woody')
ORDER BY C.PriceForSingleCigar DESC

-- 7.	Clients without Cigars
SELECT
	 Id
	,CONCAT(FirstName, ' ', LastName) AS ClientName
	,Email
FROM Clients
WHERE (SELECT TOP 1 1 FROM ClientsCigars WHERE ClientId = Id) IS NULL
ORDER BY ClientName 

-- 8.	First 5 Cigars
SELECT TOP(5)
  CigarName
 ,PriceForSingleCigar
 ,ImageURL
FROM Cigars AS C
JOIN Sizes AS S ON C.SizeId = S.Id
WHERE [Length] >= 12 AND (C.CigarName LIKE '%ci%' OR PriceForSingleCigar > 50)
					 AND S.RingRange > 2.55
ORDER BY C.CigarName, C.PriceForSingleCigar DESC

-- 9.	Clients with ZIP Codes
SELECT
	 CONCAT(C.FirstName, ' ', C.LastName) AS  FullName
	,Country
	,ZIP
	,CONCAT('$', (SELECT MAX(PriceForSingleCigar) FROM Cigars AS CG
					JOIN ClientsCigars AS CC ON CG.Id = CC.CigarId 
					AND CC.ClientId = C.Id)) AS CigarPrice
FROM Clients AS C
JOIN Addresses AS A ON C.AddressId = A.Id
WHERE ISNUMERIC(A.ZIP) = 1
ORDER BY FullName
