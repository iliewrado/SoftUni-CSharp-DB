--Problem 14.	Car Rental Database
CREATE TABLE [Categories](
[Id] INT PRIMARY KEY IDENTITY (1,1)
,[CategoryName] NVARCHAR (30) NOT NULL
,[DailyRate] DECIMAL NOT NULL
,[WeeklyRate] DECIMAL NOT NULL
,[MonthlyRate] DECIMAL NOT NULL
,[WeekendRate] DECIMAL NOT NULL
)

CREATE TABLE [Cars](
[Id] INT PRIMARY KEY IDENTITY (1,1)
,[PlateNumber] NVARCHAR(10) NOT NULL
,[Manufacturer] NVARCHAR(30) NOT NULL
,[Model] NVARCHAR(30) NOT NULL
,[CarYear] DATETIME2 NOT NULL
,[CategoryId] INT NOT NULL FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id])
,[Doors] INT 
,[Picture] VARBINARY(MAX)
,[Condition] NVARCHAR(200)
,[Available] BIT CHECK([Available] = 'TRUE' OR [Available] = 'FALSE')
)

CREATE TABLE [Employees](
[Id] INT PRIMARY KEY IDENTITY (1,1)
,[FirstName] NVARCHAR(50) NOT NULL
,[LastName] NVARCHAR(50) NOT NULL
,[Title] NVARCHAR(30) 
,[Notes] NVARCHAR (300)
)

CREATE TABLE [Customers](
[Id] INT PRIMARY KEY IDENTITY (1,1)
,[DriverLicenceNumber] NVARCHAR(30) NOT NULL
,[FullName] NVARCHAR(150) NOT NULL
,[Address] NVARCHAR(300) NOT NULL
,[City] NVARCHAR(50) NOT NULL
,[ZIPCode] NVARCHAR(10)
,[Notes] NVARCHAR(300)
)

CREATE TABLE [RentalOrders](
[Id] INT PRIMARY KEY IDENTITY (1,1)
,[EmployeeId] INT NOT NULL FOREIGN KEY ([EmployeeId]) REFERENCES [Employees] ([Id])
,[CustomerId] INT NOT NULL FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id])
,[CarId]  INT NOT NULL FOREIGN KEY ([CarId]) REFERENCES [Cars] ([Id])
,[TankLevel] NVARCHAR(30)
,[KilometrageStart] INT NOT NULL
,[KilometrageEnd] INT  NOT NULL
,[TotalKilometrage] INT NOT NULL
,[StartDate] DATETIME2 NOT NULL
,[EndDate] DATETIME2 NOT NULL
,[TotalDays] INT NOT NULL
,[RateApplied] DECIMAL NOT NULL
,[TaxRate] DECIMAL NOT NULL
,[OrderStatus] NVARCHAR(100) NOT NULL
,[Notes] NVARCHAR(400)
)

INSERT Categories
(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
VALUES
('Cheap', 10.50, 70, 220.20, 20),
('Budget', 15.50, 100, 250.20, 30),
('Lux', 40, 200, 500, 100)
 
INSERT Cars
(PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Condition, Available)
VALUES
('CA1010BA', 'Opel', 'Vectra', '2000-11-24', 1, 4, 'Good', 1),
('CA2020BA', 'Ford', 'Fiesta', '2000-11-24', 2, 4, 'Good', 1),
('CA3030BA', 'Tesla', 'Model S', '2016-11-24', 3, 4, 'New', 1)
 
INSERT Employees
( FirstName, LastName, Title, Notes)
VALUES
( 'Sange', 'Hindululu', 'Mr', 'Cheap Labor'),
( 'Ivan', 'Ivanov', 'Sir', 'Crazy'),
( 'Penka', 'Teslova', 'Ms', 'Cool name')
 
INSERT Customers
(DriverLicenceNumber, FullName, Address, City, ZIPCode)
VALUES
('ZZA46656', 'Ivan Vankov', 'Gorno Nadolnishe', 'Kichuka', 1000),
('ZZA43236', 'Petar Vankov', 'Sredno Nadolnishe', 'Kichuka', 1001),
('ZZA45466', 'Gosho Vankov', 'Dolno Nadolnishe', 'Kichuka', 1002)
 
INSERT RentalOrders
(EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes)
VALUES
(1, 2, 3, DEFAULT, 100, 200, 100, '2017-01-17', '2017-05-17', 1, 10.0, 10.0, 'YES', 'None'),
(1, 2, 3, DEFAULT, 100, 200, 100, '2017-01-17', '2017-04-18', 1, 10.0, 10.0, 'NO', 'None'),
(1, 2, 3, DEFAULT, 100, 200, 100, '2017-01-17', '2017-03-19', 1, 10.0, 10.0, 'NO', 'None')