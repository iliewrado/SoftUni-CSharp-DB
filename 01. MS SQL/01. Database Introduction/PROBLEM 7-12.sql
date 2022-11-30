--Problem 7.	Create Table People
CREATE TABLE People(
Id INT IDENTITY(1,1) PRIMARY KEY
,Name NVARCHAR(200) NOT NULL
,Picture IMAGE
,Height DECIMAL(10, 2)
,Weight DECIMAL(10, 2)
,Gender CHAR(1) NOT NULL CHECK(Gender = 'f' OR Gender = 'm')
,Birthdate DATE NOT NULL
,Biography VARCHAR(MAX)
)
INSERT INTO [PEOPLE] ([Name],[Height], [Weight], [Gender], [Birthdate]) VALUES
('Pesho', 21.63, 65.5, 'm', '10.01.1995')
,('Gosho', null, 78.0, 'm', '11.01.1996')
,('Mara', 78.1, 90.1, 'f', '02.01.1989')
,('Dara',null, 17.2, 'f', '11.01.1999')
,('Sasho', 17.3, 90.6,'m', '11.01.1998')

--Problem 8.	Create Table Users
CREATE TABLE [Users](
[Id] BIGINT PRIMARY KEY IDENTITY(1,1)
,[Username] VARCHAR(30) UNIQUE NOT NULL
,[Password] VARCHAR(26) NOT NULL
,[ProfilePicture] VARBINARY(MAX)
CHECK (DATALENGTH([ProfilePicture]) <= 900000)
,[LastLoginTime] DATETIME2
,[IsDeleted] BIT CHECK([IsDeleted] = 'true' OR [IsDeleted] = 'false')
)

INSERT INTO [Users] ([Username], [Password], [LastLoginTime], [IsDeleted]) VALUES
('Pesho', 'QWERTY', '10.01.1995', 'true')
,('Gosho', 'asdfgh', '11.01.1996', 'false')
,('Mara', 'zxcvbn', '02.01.1989', 'false')
,('Dara', '123456', '11.01.1999', 'false')
,('Sasho', 'tuiop', '11.01.1998', 'false')

--Problem 9.	Change Primary Key
ALTER TABLE Users
DROP CONSTRAINT PK__Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username)

--Problem 10.	Add Check Constraint
ALTER TABLE Users
ADD CONSTRAINT PasswordLength 
CHECK (DATALENGTH([Password]) >= 5)

--Problem 11.	Set Default Value of a Field
ALTER TABLE Users
ADD CONSTRAINT DefaultDate DEFAULT GETDATE() FOR [LastLoginTime]

--Problem 12.	Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_ID PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT UniqueUser UNIQUE (Username)

ALTER TABLE Users
ADD CONSTRAINT UniqueUserLength CHECK (DATALENGTH([Username]) >= 3)