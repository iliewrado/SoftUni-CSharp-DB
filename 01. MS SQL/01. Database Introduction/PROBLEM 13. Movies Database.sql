--Problem 13.	Movies Database
CREATE TABLE [Directors](
[Id] INT PRIMARY KEY IDENTITY(1,1),
[DirectorName] NVARCHAR(30) NOT NULL,
[Notes] NVARCHAR(300)
);
CREATE TABLE [Genres](
[Id] INT PRIMARY KEY IDENTITY(1,1),
[GenreName] NVARCHAR(30) NOT NULL,
[Notes] NVARCHAR(300)
);
CREATE TABLE [Categories](
[Id] INT PRIMARY KEY IDENTITY(1,1),
[CategoryName] NVARCHAR(30) NOT NULL,
[Notes] NVARCHAR(300)
);
CREATE TABLE [Movies](
[Id] INT PRIMARY KEY IDENTITY(1,1),
[Title] NVARCHAR(30) NOT NULL,
[DirectorId] INT NOT NULL FOREIGN KEY ([DirectorId]) REFERENCES [Directors] ([Id]),
[CopyrightYear] INT,
[Length] TIME,
[GenreId] INT NOT NULL FOREIGN KEY ([GenreId]) REFERENCES [Genres] ([Id]),
[CategoryId] INT NOT NULL FOREIGN KEY ([CategoryId]) REFERENCES [Genres] ([Id]),
[Rating] INT,
[Notes] NVARCHAR(300)
);
INSERT INTO [Directors] VALUES
('PESHO', 'DIRECTOR'),
('GOSHO', 'JURNAL'),
('SASHO', 'FANTAST'),
('MISHO', 'QWERTY'),
('TOSHO', NULL);
INSERT INTO [Genres] VALUES
('STRASHNO', 'ASDFG'),
('QWERT', NULL),
('INDUSTRY', 'INDIAN'),
('ZCXVBN', 'POIJ'),
('KINO', NULL);
INSERT INTO [Categories] VALUES
('HORROR', 'STRASHNO'),
('DOCUMENTAL', 'JURNAL'),
('FANTASY', 'FANTAST'),
('MOVIE', 'QWERTY'),
('TEATER', NULL);
INSERT INTO [Movies] VALUES
--Title, DirectorId, CopyrightYear, Length, GenreId, CategoryId, Rating, Notes
('STRASHEN FILM', 3, 1234, '3:23', 4, 5, NULL, NULL),
('FANTASTIC 4', 2, 1987, NULL, 3 ,2, 1, NULL),
('TITANIC', 1, NULL, '4:44', 2, 3, 0, 'QWERTYYUIOP[;'),
('ALO ALO', 4, 1885, '0:33:01', 5, 5, NULL, 'NBVCZCXZ'),
('MEXICAN', 5, 2000, NULL, 4, 4, 2, NULL);	