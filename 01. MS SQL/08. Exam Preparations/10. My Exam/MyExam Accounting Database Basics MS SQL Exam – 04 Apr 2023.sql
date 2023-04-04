-- Section 1. DDL (30 pts)
CREATE DATABASE 
Accounting
GO

USE 
Accounting
GO

-- 1.	Database design
CREATE TABLE Countries (
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY 
,StreetName NVARCHAR(20) NOT NULL
,StreetNumber INT NULL
,PostCode INT NOT NULL
,City VARCHAR(25) NOT NULL
,CountryId INT FOREIGN KEY REFERENCES Countries (Id) NOT NULL
)

CREATE TABLE Vendors (
Id INT PRIMARY KEY IDENTITY 
,[Name] NVARCHAR(25) NOT NULL
,NumberVAT NVARCHAR(15) NOT NULL
,AddressId INT FOREIGN KEY REFERENCES Addresses (Id) NOT NULL
)

CREATE TABLE Clients (
Id INT PRIMARY KEY IDENTITY 
,[Name] NVARCHAR(25) NOT NULL
,NumberVAT NVARCHAR(15) NOT NULL
,AddressId INT FOREIGN KEY REFERENCES Addresses (Id) NOT NULL
)

CREATE TABLE Categories (
Id INT PRIMARY KEY IDENTITY 
,[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE Products (
Id INT PRIMARY KEY IDENTITY 
,[Name] NVARCHAR(35) NOT NULL
,Price DECIMAL(18, 2) NOT NULL
,CategoryId INT FOREIGN KEY REFERENCES Categories (Id) NOT NULL
,VendorId INT FOREIGN KEY REFERENCES Vendors (Id) NOT NULL
)

CREATE TABLE Invoices (
Id INT PRIMARY KEY IDENTITY 
,Number INT UNIQUE NOT NULL
,IssueDate DATETIME2 NOT NULL
,DueDate DATETIME2 NOT NULL
,Amount DECIMAL(18, 2) NOT NULL
,Currency VARCHAR(5) NOT NULL
,ClientId INT FOREIGN KEY REFERENCES Clients (Id) NOT NULL

)

CREATE TABLE ProductsClients (
ProductId INT NOT NULL FOREIGN KEY REFERENCES Products (Id) 
,ClientId INT NOT NULL FOREIGN KEY REFERENCES Clients (Id)
PRIMARY KEY (ProductId , ClientId)
)

 
 -- Section 2. DML (10 pts)
 -- 2.	Insert
INSERT INTO Products ([Name],	Price,	CategoryId,	VendorId	)
VALUES
('SCANIA Oil Filter XD01',	78.69,	1,	1 )
,('MAN Air Filter XD01	',97.38,	1,	5	  )
,('DAF Light Bulb 05FG87',	55.00,	2,	13)
,('ADR Shoes 47-47.5	',49.85,	3,	5	  )
,('Anti-slip pads S',	5.87,	5,	7		  )


INSERT INTO Invoices (Number,	IssueDate,	DueDate,	Amount,	Currency,	ClientId	)
VALUES
('1219992181',	'2023-03-01', '2023-04-30',	180.96, 'BGN',	3 )
,('1729252340',	'2022-11-06', '2023-01-04',	158.18, 'EUR',	13)
,('1950101013',	'2023-02-17', '2023-04-18',	615.15, 'USD',	19)


-- 3.	Update
UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE DATEPART(MONTH, IssueDate) = '11' 
AND DATEPART(YEAR, IssueDate) = '2022'

UPDATE Clients 
SET AddressId = 3
WHERE [Name] LIKE '%CO%'

-- 4.	Delete
DELETE FROM Invoices
WHERE ClientId IN (SELECT Id FROM Clients
					WHERE NumberVAT LIKE 'IT%' )
DELETE FROM ProductsClients
WHERE ClientId IN (SELECT Id FROM Clients
					WHERE NumberVAT LIKE 'IT%' )

DELETE FROM Clients 
WHERE NumberVAT LIKE 'IT%'

 -- Section 3. Querying (40 pts)

 -- 5.
 SELECT
 Number
 ,Currency
 FROM Invoices
 ORDER BY Amount DESC
 
 -- 6.
 SELECT
 P.Id
 ,P.[Name]
 ,Price
 ,C.[Name] AS CategoryName 
 FROM Products AS P
 JOIN Categories AS C ON P.CategoryId = C.Id
 WHERE C.[Name] IN ('ADR', 'Others') 
 ORDER BY P.Price DESC

 
 -- 7.
 SELECT
 C.Id
 ,C.[Name] AS Client
 ,CONCAT(A.StreetName, ' ', A.StreetNumber, ', ', A.City, ', ', A.PostCode, ', ', CT.Name) AS Address
 FROM Clients AS C 
 LEFT JOIN ProductsClients AS PC ON C.Id = PC.ClientId
 JOIN Addresses AS A ON C.AddressId = A.Id
 JOIN Countries AS CT ON A.CountryId = CT.Id
 WHERE PC.ProductId IS NULL
 ORDER BY C.[Name]


 -- 8.	
 SELECT TOP(7)
 I.Number
 ,I.Amount	
 ,C.[Name] AS Client
 FROM Invoices AS I 
 JOIN Clients AS C ON I.ClientId = C.Id
 WHERE (I.IssueDate < '2023-01-01' AND I.Currency = 'EUR')
	OR (I.Amount > 500.00 AND C.NumberVAT LIKE 'DE%')
ORDER BY I.Number ASC, I.Amount DESC

 -- 9.	
 SELECT
 C.[Name] AS Client
 ,MAX(P.Price) AS Price
 ,C.NumberVAT AS [VAT Number]
 FROM Clients AS C
 JOIN ProductsClients AS PC ON C.Id = PC.ClientId 
 JOIN Products AS P ON PC.ProductId = P.Id
 WHERE C.[Name] NOT LIKE '%KG' 
 GROUP BY C.[Name], C.NumberVAT
 ORDER BY Price DESC


 -- 10.
 SELECT 
 C.[Name] AS Client
 ,FLOOR(AVG(P.Price)) AS [Average Price]
 FROM Clients AS C
 LEFT JOIN ProductsClients AS PC ON C.Id = PC.ClientId
 LEFT JOIN Products AS P ON PC.ProductId = P.Id
 JOIN Vendors AS V ON P.VendorId = V.Id
 WHERE V.NumberVAT LIKE '%FR%'
 GROUP BY C.[Name]
 ORDER BY [Average Price] ASC, C.[Name] DESC

 
 -- Section 4. Programmability (20 pts)

 -- 11.	Create a user-defined function
GO
CREATE FUNCTION  udf_ProductWithClients(@name NVARCHAR(35))
RETURNS INT
AS
BEGIN

RETURN (SELECT COUNT(C.Id)
	FROM Products AS P
	JOIN ProductsClients AS PC ON P.Id = PC.ProductId
	JOIN Clients AS C ON PC.ClientId = C.Id
	WHERE P.[Name] = @name)

END
GO


---- 12.	Create a stored procedure
CREATE PROC usp_SearchByCountry(@country VARCHAR(10)) 
AS
BEGIN 
SELECT
V.[Name] AS Vendor
,V.NumberVAT AS VAT
,CONCAT(A.StreetName, ' ', A.StreetNumber) AS [Street Info]
,CONCAT(A.City, ' ', A.PostCode) AS [City Info]
FROM Vendors AS V
JOIN Addresses AS A ON V.AddressId = A.Id
JOIN Countries AS C ON A.CountryId = C.Id
WHERE C.[Name] = @country
ORDER BY V.[Name], A.City
END
GO