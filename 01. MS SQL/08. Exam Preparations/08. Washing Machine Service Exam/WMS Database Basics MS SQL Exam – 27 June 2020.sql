-- Section 1. DDL (30 pts)
CREATE DATABASE 
WMS
GO

USE 
WMS
GO

-- 1.	Database design
CREATE TABLE Clients (
ClientId INT PRIMARY KEY IDENTITY
,FirstName  NVARCHAR(50) NOT NULL
,LastName NVARCHAR(50) NOT NULL
,Phone VARCHAR(12) NOT NULL CHECK(LEN(Phone) = 12)
)

CREATE TABLE Mechanics (
MechanicId	INT PRIMARY KEY IDENTITY 
,FirstName  NVARCHAR(50) NOT NULL
,LastName  NVARCHAR(50) NOT NULL
,[Address] NVARCHAR(255) NOT NULL
)


CREATE TABLE Models (
ModelId INT PRIMARY KEY IDENTITY 
,[Name]  NVARCHAR(50) UNIQUE NOT NULL 
)

CREATE TABLE Jobs (
JobId INT PRIMARY KEY IDENTITY 
,ModelId  INT FOREIGN KEY REFERENCES Models (ModelId) NOT NULL
,[Status]  NVARCHAR(11) NOT NULL CHECK([Status] IN('Pending', 'In Progress', 'Finished')) DEFAULT  1
,ClientId   INT FOREIGN KEY REFERENCES Clients (ClientId) NOT NULL
,MechanicId  INT FOREIGN KEY REFERENCES Mechanics (MechanicId) NULL
,IssueDate DATE NOT NULL
,FinishDate DATE NULL
)

CREATE TABLE Orders (
OrderId INT PRIMARY KEY IDENTITY 
,JobId INT FOREIGN KEY REFERENCES Jobs (JobId) NOT NULL
,IssueDate DATE NULL
,Delivered BIT DEFAULT 0
)

CREATE TABLE Vendors (
VendorId INT PRIMARY KEY IDENTITY 
,[Name]  NVARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Parts (
PartId INT PRIMARY KEY IDENTITY 
,SerialNumber  NVARCHAR(50) UNIQUE NOT NULL 
,[Description]  NVARCHAR(255) NULL
,Price MONEY CHECK(Price > 0 OR Price <= 9999.99)
,VendorId   INT FOREIGN KEY REFERENCES Vendors (VendorId)
,StockQty INT CHECK(StockQty >= 0) DEFAULT 0
)

CREATE TABLE OrderParts (
OrderId INT NOT NULL FOREIGN KEY REFERENCES Orders (OrderId)
,PartId INT NOT NULL FOREIGN KEY REFERENCES Parts (PartId)
PRIMARY KEY (OrderId , PartId)
,Quantity INT CHECK(Quantity > 0) DEFAULT 1
)

CREATE TABLE PartsNeeded (
JobId INT NOT NULL FOREIGN KEY REFERENCES Jobs (JobId)
,PartId INT NOT NULL FOREIGN KEY REFERENCES Parts (PartId)
PRIMARY KEY (JobId , PartId)
,Quantity INT CHECK(Quantity > 0) DEFAULT 1
)
 
 -- Section 2. DML (10 pts)
 -- 2.	Insert
INSERT INTO Clients (FirstName,	LastName,	Phone)
VALUES
('Teri', 'Ennaco',	'570-889-5187')
,('Merlyn',	'Lawler', '201-588-7810')
,('Georgene',	'Montezuma',	'925-615-5185')
,('Jettie',	'Mconnell',	'908-802-3564')
,('Lemuel',	'Latzke', '631-748-6479')
,('Melodie', 'Knipp',	'805-690-1682')
,('Candida',	'Corbley',	'908-275-8357')

INSERT INTO Parts (SerialNumber, [Description],	Price,	VendorId)
VALUES
('WP8182119',	'Door Boot Seal',	117.86,	2 )
,('W10780048',	'Suspension Rod',	42.81,	1 )
,('W10841140',	'Silicone Adhesive', 	6.77,	4 )
,('WPY055980',	'High Temperature Adhesive',	13.94,	3)


-- 3.	Update
UPDATE Jobs
SET MechanicId = (SELECT MechanicId FROM Mechanics
		WHERE (FirstName = 'Ryan') AND (LastName = 'Harnos'))
WHERE [Status] = 'Pending'

UPDATE Jobs
SET [Status] = 'In Progress'
WHERE [Status] = 'Pending' AND MechanicId = (SELECT MechanicId FROM Mechanics
		WHERE (FirstName = 'Ryan') AND (LastName = 'Harnos'))


-- 4.	Delete
DELETE FROM OrderParts
WHERE OrderId = 19

DELETE FROM Orders
WHERE OrderId = 19


 -- Section 3. Querying (40 pts)

 -- 5.
SELECT
CONCAT(M.FirstName, ' ', M.LastName) AS Mechanic
,J.[Status]
,J.IssueDate
FROM Mechanics AS M
JOIN Jobs AS J ON J.MechanicId = M.MechanicId
ORDER BY M.MechanicId, J.IssueDate, J.JobId

 -- 6.
SELECT
 CONCAT(C.FirstName, ' ', C.LastName) AS Client	
 ,DATEDIFF(DAY, J.IssueDate, '24 April 2017') AS [Days going]
 ,J.[Status]
FROM Clients AS C
JOIN Jobs AS J ON J.ClientId = C.ClientId
WHERE J.[Status] != 'Finished'
ORDER BY [Days going] DESC, C.ClientId ASC
 
 -- 7.	
SELECT 
CONCAT(M.FirstName, ' ', M.LastName) AS Mechanic
,AVG(DATEDIFF(DAY, J.IssueDate, J.FinishDate)) AS [Average Days]
FROM Mechanics AS M
JOIN Jobs AS J ON J.MechanicId = M.MechanicId
GROUP BY M.FirstName, M.LastName, M.MechanicId
ORDER BY M.MechanicId

 -- 8.	
SELECT
CONCAT(M.FirstName, ' ', M.LastName) AS Available 
FROM Mechanics AS M
JOIN Jobs AS J ON J.MechanicId = M.MechanicId
WHERE ((J.[Status] != 'In Progress') 
		OR (J.[Status] IS NULL))
		AND (M.MechanicId NOT IN (SELECT MechanicId
									FROM Jobs 
									WHERE Jobs.[Status] = 'In Progress'))
GROUP BY M.FirstName, M.LastName, M.MechanicId
ORDER BY M.MechanicId

 -- 9.	
SELECT
J.JobId AS JobId
,ISNULL(SUM(P.Price * Quantity), 0) Total
FROM Jobs AS J
LEFT JOIN Orders AS O ON O.JobId = J.JobId
LEFT JOIN OrderParts AS OP ON O.OrderId = OP.OrderId
LEFT JOIN Parts AS P ON OP.PartId = P.PartId
WHERE J.[Status] = 'Finished'
GROUP BY J.JobId
ORDER BY Total DESC, J.JobId ASC


 -- 10.
SELECT
P.PartId
,P.[Description]
,PN.Quantity AS [Required]
,P.StockQty AS [In Stock] 
,IIF(O.Delivered = 'False', OP.Quantity, 0) AS Ordered
FROM Parts AS P 
LEFT JOIN PartsNeeded AS PN ON P.PartId = PN.PartId
LEFT JOIN Jobs AS J ON PN.JobId = J.JobId
LEFT JOIN OrderParts AS OP ON P.PartId = OP.PartId
LEFT JOIN Orders AS O ON J.JobId = O.JobId
    WHERE J.[Status] != 'Finished' AND P.StockQty < PN.Quantity AND O.Delivered IS NULL
 ORDER BY P.PartId

 
 -- Section 4. Programmability (20 pts)

 -- 11.	Create a user-defined function
GO
CREATE FUNCTION udf_GetCost (@JobId int)
RETURNS DECIMAL (15, 2)
AS
BEGIN
 DECLARE @Result MONEY = (SELECT
	SUM(P.Price * Quantity) AS Result
	FROM Jobs AS J
	JOIN Orders AS O ON O.JobId = J.JobId
	JOIN OrderParts AS OP ON O.OrderId = OP.OrderId
	JOIN Parts AS P ON OP.PartId = P.PartId
	WHERE J.JobId = @JobId)
		IF(@Result IS NULL)
		BEGIN
			RETURN 0
		END
RETURN @Result
END
GO


---- 12.	Create a stored procedure
CREATE PROC usp_PlaceOrder(@jobId INT, @partSerialNumber VARCHAR(50), @quantity INT)
AS
	IF(@quantity <= 0)
		THROW 50012, 'Part quantity must be more than zero!', 1;

	DECLARE @jobIdVerified INT = (SELECT TOP (1) JobId 
									FROM Jobs 
									WHERE JobId = @jobId);

	IF(@jobIdVerified IS NULL)
		THROW 50013, 'Job not found!', 1;

	DECLARE @jobStatus VARCHAR(11) = (SELECT TOP (1) [Status] 
										FROM Jobs 
										WHERE JobId = @jobIdVerified);
	
	IF(@jobStatus = 'Finished')
		THROW 50011, 'This job is not active!', 1;

	DECLARE @partIdVerified INT = (SELECT TOP (1) PartId 
									 FROM Parts 
									WHERE SerialNumber = @partSerialNumber);

	IF(@partIdVerified IS NULL)
		THROW 50014, 'Part not found!', 1;

	DECLARE @orderId INT = (SELECT OrderId 
							  FROM Orders
							 WHERE JobId = @jobIdVerified AND IssueDate IS NULL);

	IF(@orderId IS NULL)
	BEGIN
		INSERT INTO Orders (JobId, IssueDate, Delivered) VALUES
			(@jobIdVerified, NULL, 0);

		DECLARE @newOrderId INT = (SELECT OrderId 
									 FROM Orders 
									WHERE JobId = @jobIdVerified AND IssueDate IS NULL);

		INSERT INTO OrderParts (OrderId, PartId, Quantity) VALUES
			(@newOrderId, @partIdVerified, @quantity);
	END

	ELSE
	BEGIN
		DECLARE @partQuantity INT = (SELECT Quantity 
									   FROM OrderParts 
									  WHERE OrderId = @orderId AND PartId = @partIdVerified);

		IF(@partQuantity IS NULL)
		BEGIN
			INSERT INTO OrderParts (OrderId, PartId, Quantity) VALUES
				(@orderId, @partIdVerified, @quantity);
		END

		ELSE
		BEGIN
			 UPDATE OrderParts
				SET Quantity += @quantity
			  WHERE OrderId = @orderId AND PartId = @partIdVerified;
		END
	END
GO