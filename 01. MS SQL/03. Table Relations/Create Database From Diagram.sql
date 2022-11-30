--Problem 5.	Online Store Database
CREATE DATABASE [Online Store]

USE [Online Store]

CREATE TABLE [Cities](
[CityID] INT NOT NULL PRIMARY KEY
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [ItemTypes](
[ItemTypeID] INT NOT NULL PRIMARY KEY
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Items](
[ItemID] INT NOT NULL PRIMARY KEY
,[Name] VARCHAR(50) NOT NULL
,[ItemTypeID] INT NOT NULL
,CONSTRAINT FK_ItemTypes FOREIGN KEY ([ItemTypeID])
REFERENCES [ItemTypes]([ItemTypeID])
)

CREATE TABLE [Customers](
[CustomerID] INT NOT NULL PRIMARY KEY
,[Name] VARCHAR(50) NOT NULL
,[Birthday] DATE
,[CityID] INT NOT NULL
,CONSTRAINT FK_Cities FOREIGN KEY([CityID])
REFERENCES [Cities]([CityID])
)

CREATE TABLE [Orders](
[OrderID] INT NOT NULL PRIMARY KEY
,[CustomerID] INT NOT NULL
,CONSTRAINT FK_Customer FOREIGN KEY([CustomerID])
REFERENCES [Customers]([CustomerID])
)

CREATE TABLE [OrderItems](
[OrderID] INT NOT NULL
,[ItemID] INT NOT NULL
,CONSTRAINT PK_OrderItems PRIMARY KEY([OrderID], [ItemID])
,CONSTRAINT FK_OrderItems_Order FOREIGN KEY(OrderID)
REFERENCES [Orders]([OrderID])
,CONSTRAINT FK_OrderItems_Item FOREIGN KEY (ItemID)
REFERENCES [Items]([ItemID])
)

--Problem 6.	University Database
CREATE DATABASE [University Database]

USE [University Database]

CREATE TABLE [Majors](
[MajorID] INT NOT NULL PRIMARY KEY
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Students](
[StudentID] INT NOT NULL PRIMARY KEY
,[StudentNumber] VARCHAR(10) NOT NULL UNIQUE
,[StudentName] VARCHAR(50) NOT NULL
,[MajorID] INT NOT NULL
,CONSTRAINT FK_MajorID FOREIGN KEY([MajorID])
REFERENCES [Majors]([MajorID])
)

CREATE TABLE [Subjects](
[SubjectID] INT NOT NULL PRIMARY KEY
,[SubjectName] VARCHAR(50) NOT NULL
)

CREATE TABLE [Agenda](
[StudentID] INT NOT NULL
,[SubjectID] INT NOT NULL
,CONSTRAINT PK_StudenSubjectIDS PRIMARY KEY([StudentID], [SubjectID])
,CONSTRAINT FK_Agenda_Student FOREIGN KEY ([StudentID])
REFERENCES [Students]([StudentID])
,CONSTRAINT FK_Agenda_Subject FOREIGN KEY([SubjectID])
REFERENCES [Subjects]([SubjectID])
)

CREATE TABLE [Payments](
[PaymentID] INT NOT NULL PRIMARY KEY
,[PaymentDate] DATE 
,[PaymentAmount] DECIMAL(8, 2)
,[StudentID] INT NOT NULL
,CONSTRAINT FK_Student FOREIGN KEY ([StudentID])
REFERENCES [Students]([StudentID])
)

--Problem 9.	Peaks in Rila
USE [Geography]

SELECT [MountainRange]
,[PeakName]
,[Elevation]
FROM [Peaks]
JOIN [Mountains] ON [Peaks].MountainId = [Mountains].Id
WHERE [Peaks].MountainId = 
(SELECT [Id]
FROM [Mountains]
WHERE [MountainRange] = 'Rila')
ORDER BY [Peaks].Elevation DESC