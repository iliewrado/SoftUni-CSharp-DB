-- Database Basics MS SQL Exam � 13 February 2021

-- N.B: Use VARCHAR for strings, not NVARCHAR! 
-- Keep in mind that Judge doesn�t accept �ALTER� statement 
-- and square brackets naming, when the names are not keywords.

-- Section 1. DDL (30 pts)
CREATE DATABASE Bitbucket
GO

USE Bitbucket
GO

-- 1.	Database Design
CREATE TABLE Users (
Id INT PRIMARY KEY IDENTITY
,Username VARCHAR(30) NOT NULL
,[Password] VARCHAR(30) NOT NULL
,Email VARCHAR(50) NOT NULL
)

CREATE TABLE Repositories (
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE RepositoriesContributors (
RepositoryId INT FOREIGN KEY REFERENCES Repositories (Id) NOT NULL
,ContributorId INT FOREIGN KEY REFERENCES Users(Id) NOT NULL
PRIMARY KEY(RepositoryId ,ContributorId)
)

CREATE TABLE Issues (
Id INT PRIMARY KEY IDENTITY
,Title VARCHAR(255) NOT NULL
,IssueStatus VARCHAR(6) NOT NULL
,RepositoryId INT FOREIGN KEY REFERENCES Repositories (Id) NOT NULL
,AssigneeId INT FOREIGN KEY REFERENCES Users (Id) NOT NULL
)

CREATE TABLE Commits (
Id INT PRIMARY KEY IDENTITY
,[Message] VARCHAR(255) NOT NULL
,IssueId INT FOREIGN KEY REFERENCES Issues (Id)
,RepositoryId INT FOREIGN KEY REFERENCES Repositories (Id) NOT NULL
,ContributorId INT FOREIGN KEY REFERENCES Users (Id) NOT NULL
)

CREATE TABLE Files (
Id INT PRIMARY KEY IDENTITY
,[Name] VARCHAR(100) NOT NULL
,Size DECIMAL(18,2) NOT NULL
,ParentId INT FOREIGN KEY REFERENCES Files (Id)
,CommitId INT FOREIGN KEY REFERENCES Commits (Id) NOT NULL
)

-- Section 2. DML (10 pts)

-- Before you start, you must import �DataSet-Bitbucket.sql�.
-- If you have created the structure correctly, 
-- the data should be successfully inserted without any errors.

-- 2.	Insert

