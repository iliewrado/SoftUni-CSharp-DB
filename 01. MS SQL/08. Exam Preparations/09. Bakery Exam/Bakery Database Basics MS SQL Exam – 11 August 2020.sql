-- Section 1. DDL (30 pts)
CREATE DATABASE 
Bakery
GO

USE 
Bakery
GO

-- 1.	Database design
CREATE TABLE Countries (
Id INT PRIMARY KEY IDENTITY
,[Name]  NVARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Customers (
Id INT PRIMARY KEY IDENTITY 
,FirstName NVARCHAR(25) NOT NULL
,LastName NVARCHAR(25) NOT NULL
,Gender CHAR(1) NOT NULL CHECK(Gender = 'F' OR Gender = ' M')
,Age INT NOT NULL
,PhoneNumber VARCHAR(10) NOT NULL CHECK(LEN(PhoneNumber) = 10)
,CountryId  INT FOREIGN KEY REFERENCES Countries (Id)
)

CREATE TABLE Products (
Id INT PRIMARY KEY IDENTITY 
,[Name] NVARCHAR(25) UNIQUE NOT NULL
,[Description] NVARCHAR(250)
,Recipe VARCHAR(MAX) NOT NULL
,Price MONEY CHECK(Price > 0) NOT NULL
)

CREATE TABLE Feedbacks (
Id INT PRIMARY KEY IDENTITY 
,[Description] NVARCHAR(255) NOT NULL
,Rate DECIMAL(15, 2) CHECK(Rate BETWEEN 0 AND 10) 
,ProductId INT FOREIGN KEY REFERENCES Products (Id)
,CustomerId INT FOREIGN KEY REFERENCES Customers (Id)
)

CREATE TABLE Distributors (
Id INT PRIMARY KEY IDENTITY 
,[Name] NVARCHAR(25) UNIQUE NOT NULL
,AddressText NVARCHAR(30) NOT NULL
,Summary NVARCHAR(200) 
,CountryId INT FOREIGN KEY REFERENCES Countries (Id)
)

CREATE TABLE Ingredients (
Id INT PRIMARY KEY IDENTITY 
,[Name] NVARCHAR(30) NOT NULL
,[Description] NVARCHAR(200)
,OriginCountryId INT FOREIGN KEY REFERENCES Countries (Id)
,DistributorId INT FOREIGN KEY REFERENCES Distributors (Id)
)

CREATE TABLE ProductsIngredients (
ProductId INT NOT NULL FOREIGN KEY REFERENCES Products (Id)
,IngredientId INT NOT NULL FOREIGN KEY REFERENCES Ingredients (Id)
PRIMARY KEY (ProductId , IngredientId)
)

 
 -- Section 2. DML (10 pts)
 -- 2.	Insert
INSERT INTO Distributors ([Name],	CountryId,	AddressText,	Summary)
VALUES
 ('Deloitte & Touche',	2,	'6 Arch St #9757',	'Customizable neutral traveling')
,('Congress Title',	13,	'58 Hancock St',	'Customer loyalty')
,('Kitchen People',	1,	'3 E 31st St #77',	'Triple-buffered stable delivery')
,('General Color Co Inc',	21,	'6185 Bohn St #72',	'Focus group')
,('Beck Corporation',	23,	'21 E 64th Ave',	'Quality-focused 4th generation hardware')


INSERT INTO Customers (FirstName,	LastName,	Age,	Gender,	PhoneNumber,	CountryId)
VALUES
 ('Francoise',	'Rautenstrauch',	15,	'M',	'0195698399',	5)
,('Kendra',	'Loud',	22,	'F',	'0063631526',	11)
,('Lourdes',	'Bauswell',	50,	'M',	'0139037043',	8		 )
,('Hannah',	'Edmison',	18,	'F',	'0043343686',	1)
,('Tom',	'Loeza',	31,	'M',	'0144876096',	23				 )
,('Queenie',	'Kramarczyk',	30,	'F',	'0064215793',	29)
,('Hiu',	'Portaro',	25,	'M',	'0068277755',	16				 )
,('Josefa',	'Opitz',	43,	'F',	'0197887645',	17)


-- 3.	Update
UPDATE Ingredients
SET DistributorId = 35
WHERE [Name] IN ('Bay Leaf', 'Paprika', 'Poppy')

UPDATE Ingredients
SET OriginCountryId = 14
WHERE OriginCountryId = 8

-- 4.	Delete
DELETE FROM Feedbacks
WHERE CustomerId = 14 OR ProductId = 5


 -- Section 3. Querying (40 pts)

 -- 5.
 SELECT 
 [Name]
 ,CAST(Price AS DECIMAL(15, 2))Price
 ,[Description]
 FROM Products
 ORDER BY Price DESC, [Name] ASC
 
 -- 6.
 SELECT
 F.ProductId
 ,F.Rate
 ,F.[Description]
 ,C.Id AS CustomerId
 ,C.Age
 ,C.Gender 
 FROM Feedbacks AS F
 LEFT JOIN Customers AS C ON F.CustomerId = C.Id
 WHERE F.Rate < 5.0
 ORDER BY ProductId DESC, Rate ASC

 
 -- 7.	
 SELECT 
 CONCAT(C.FirstName, ' ', C.LastName) CustomerName
 ,PhoneNumber
 ,Gender
 FROM Customers AS C
 LEFT JOIN Feedbacks AS F ON C.Id = F.CustomerId
 WHERE F.CustomerId IS NULL
 ORDER BY C.Id

 -- 8.	
 SELECT 
 FirstName
 ,Age
 ,PhoneNumber
 FROM Customers
 WHERE (Age >= 21 AND FirstName LIKE '%an%')
	OR (RIGHT(PhoneNumber, 2) = '38' AND CountryId != 
	(SELECT Id FROM Countries
	WHERE [Name] = 'Greece'))
ORDER BY FirstName ASC, Age DESC

 -- 9.	
 SELECT
 D.[Name] AS DistributorName
 ,I.[Name] AS IngredientName
 ,P.[Name] AS ProductName
 ,AVG(F.Rate) AS AverageRate
 FROM Distributors AS D
 JOIN Ingredients AS I ON D.Id = I.DistributorId
 JOIN ProductsIngredients AS PP ON I.Id = PP.IngredientId
 JOIN Products AS P ON PP.ProductId = P.Id
 JOIN Feedbacks AS F ON P.Id = F.ProductId
 WHERE F.Rate BETWEEN 5 AND 8
 GROUP BY D.[Name], I.[Name], P.[Name]
 ORDER BY DistributorName, IngredientName, ProductName


 -- 10.
 SELECT
 C.[Name] AS CountryName
 ,D.[Name] AS DisributorName
 FROM Countries AS C
 JOIN Distributors AS D ON D.CountryId = C.Id
 JOIN Ingredients AS I ON I.DistributorId = D.Id
 GROUP BY C.[Name], D.[Name]
 ORDER BY CountryName, DisributorName

 
 -- Section 4. Programmability (20 pts)

 -- 11.	Create a user-defined function
GO
CREATE FUNCTION  ( )
RETURNS 
AS
BEGIN
RETURN 

END
GO


---- 12.	Create a stored procedure
CREATE PROC  ( )
AS
BEGIN 

END
GO