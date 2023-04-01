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
 
 -- 6.
 
 -- 7.	

 -- 8.	

 -- 9.	

 -- 10.
 
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