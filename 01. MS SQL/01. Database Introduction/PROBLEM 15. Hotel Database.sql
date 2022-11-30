--Problem 15.	Hotel Database
CREATE TABLE [Employees](
[Id] INT PRIMARY KEY IDENTITY (1,1)
,[FirstName] NVARCHAR(30) NOT NULL
,[LastName] NVARCHAR(30) NOT NULL
,[Title] NVARCHAR(30) NOT NULL
,[Notes] NVARCHAR(300)
)

CREATE TABLE [Customers](
[AccountNumber] BIGINT UNIQUE NOT NULL
,[FirstName] VARCHAR(30) NOT NULL
,[LastName] VARCHAR(30) NOT NULL
,[PhoneNumber] VARCHAR(12) NOT NULL
,[EmergencyName] VARCHAR(50)
,[EmergencyNumber] VARCHAR(15)
,[Notes] VARCHAR(300)
)

CREATE TABLE [RoomStatus](
[Id] INT PRIMARY KEY NOT NULL
,[RoomStatus] VARCHAR(50) NOT NULL
,[Notes] VARCHAR(200)
)

CREATE TABLE [RoomTypes](
[Id] INT PRIMARY KEY NOT NULL
,[RoomType] VARCHAR(50) NOT NULL
,[Notes] VARCHAR(200)
)

CREATE TABLE [BedTypes](
[Id] INT PRIMARY KEY NOT NULL
,[BedType] VARCHAR(50) NOT NULL
,[Notes] VARCHAR(200)
)

CREATE TABLE [Rooms](
[RoomNumber] INT UNIQUE NOT NULL
,[RoomType] INT NOT NULL FOREIGN KEY ([RoomType]) REFERENCES [RoomTypes](Id)
,[BedType] INT NOT NULL FOREIGN KEY ([BedType]) REFERENCES [BedTypes](Id)
,[Rate] DECIMAL NOT NULL
,[RoomStatus] INT NOT NULL FOREIGN KEY ([RoomStatus]) REFERENCES [RoomStatus](Id)
,[Notes] VARCHAR(200)
)

CREATE TABLE [Payments](
[Id] INT PRIMARY KEY NOT NULL
,[EmployeeId] INT NOT NULL FOREIGN KEY ([EmployeeId]) REFERENCES [Employees] (Id)
,[PaymentDate] DATETIME2 
,[AccountNumber] BIGINT NOT NULL FOREIGN KEY ([AccountNumber]) REFERENCES [Customers] ([AccountNumber])
,[FirstDateOccupied] DATETIME2
,[LastDateOccupied] DATETIME2
,[TotalDays] AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied)
,[AmountCharged] DECIMAL
,[TaxRate] DECIMAL
,[TaxAmount] DECIMAL
,[PaymentTotal] DECIMAL
,[Notes] VARCHAR(300)
)

CREATE TABLE [Occupancies](
[Id] INT PRIMARY KEY NOT NULL
,[EmployeeId] INT NOT NULL FOREIGN KEY ([EmployeeId]) REFERENCES [Employees]([Id])
,[DateOccupied] DATETIME2
,[AccountNumber] BIGINT NOT NULL FOREIGN KEY REFERENCES [Customers](AccountNumber)
,[RoomNumber] INT NOT NULL FOREIGN KEY REFERENCES [Rooms](RoomNumber)
,[RateApplied] DECIMAL 
,[PhoneCharge] DECIMAL
,[Notes] VARCHAR(300)
)

INSERT INTO Employees
VALUES
('Velizar', 'Velikov', 'Receptionist', 'Nice customer'),
('Ivan', 'Ivanov', 'Concierge', 'Nice one'),
('Elisaveta', 'Bagriana', 'Cleaner', 'Poetesa')

INSERT INTO Customers
VALUES
(123456789, 'Ginka', 'Shikerova', '359888777888', 'Sistry mi', '7708315342', 'Kinky'),
(123480933, 'Chaika', 'Stavreva', '359888777888', 'Sistry mi', '7708315342', 'Lawer'),
(123454432, 'Mladen', 'Isaev', '359888777888', 'Sistry mi', '7708315342', 'Wants a call girl')

INSERT INTO RoomStatus
VALUES
(1, 1,'Refill the minibar'),
(2, 2,'Check the towels'),
(3, 3,'Move the bed for couple')

INSERT INTO RoomTypes
VALUES
(1, 'Suite', 'Two beds'),
(2, 'Wedding suite', 'One king size bed'),
(3, 'Apartment', 'Up to 3 adults and 2 children')

INSERT INTO BedTypes
VALUES
(1, 'Double', 'One adult and one child'),
(2, 'King size', 'Two adults'),
(3, 'Couch', 'One child')

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
VALUES
(445, 2, 1, 2, 1, 'Free'),
(233, 1, 3, 3, 2, 'Free'),
(112, 3, 2, 1, 3, 'Clean it')

 
INSERT INTO Payments (Id, EmployeeId, PaymentDate, AccountNumber, AmountCharged)
VALUES
(1, 3, '12/12/2018', 123456789, 2000.40),
(2, 3, '12/12/2018', 123480933, 1500.40),
(3, 1, '12/12/2018', 123454432, 1000.40)

INSERT INTO Occupancies (Id, EmployeeId, AccountNumber, RoomNumber, RateApplied, Notes)
VALUES
(1, 2, 123454432, 445, 55.55, 'too'),
(2, 1, 123480933, 112, 15.55, 'much'),
(3, 1, 123456789, 233, 35.55, 'typing')