CREATE DATABASE BoutiqueInventoryDB;
GO

USE BoutiqueInventoryDB;
GO

-- Tables are normally created by Entity Framework migrations.
-- This script is only for documentation/submission purposes.

CREATE TABLE Warehouses (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    IsActive BIT NOT NULL
);

CREATE TABLE Categories (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Type NVARCHAR(100) NOT NULL,
    Size NVARCHAR(50) NULL,
    ExpirationDate DATETIME2 NULL,
    ImagePath NVARCHAR(300) NULL,
    WarehouseId INT NOT NULL,
    ShelfLocation NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Products_Warehouses FOREIGN KEY (WarehouseId)
        REFERENCES Warehouses(Id)
);

CREATE TABLE ProductCategories (
    ProductId INT NOT NULL,
    CategoryId INT NOT NULL,
    PRIMARY KEY (ProductId, CategoryId),
    CONSTRAINT FK_ProductCategories_Products FOREIGN KEY (ProductId)
        REFERENCES Products(Id),
    CONSTRAINT FK_ProductCategories_Categories FOREIGN KEY (CategoryId)
        REFERENCES Categories(Id)
);
