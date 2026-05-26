IF DB_ID('BoutiqueInventoryDB') IS NULL BEGIN CREATE DATABASE BoutiqueInventoryDB; END
GO
USE BoutiqueInventoryDB;
GO
IF OBJECT_ID('dbo.ProductCategories','U') IS NOT NULL DROP TABLE dbo.ProductCategories;
IF OBJECT_ID('dbo.Products','U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Categories','U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Warehouses','U') IS NOT NULL DROP TABLE dbo.Warehouses;
GO
CREATE TABLE dbo.Warehouses(Id INT IDENTITY(1,1) PRIMARY KEY,Name NVARCHAR(100) NOT NULL,Location NVARCHAR(200) NOT NULL,IsActive BIT NOT NULL DEFAULT 1);
CREATE TABLE dbo.Categories(Id INT IDENTITY(1,1) PRIMARY KEY,Name NVARCHAR(100) NOT NULL);
CREATE TABLE dbo.Products(Id INT IDENTITY(1,1) PRIMARY KEY,Name NVARCHAR(100) NOT NULL,Type NVARCHAR(100) NOT NULL,Size NVARCHAR(50) NULL,ExpirationDate DATETIME2 NULL,ImagePath NVARCHAR(300) NULL,WarehouseId INT NOT NULL,ShelfLocation NVARCHAR(100) NOT NULL,CONSTRAINT FK_Products_Warehouses FOREIGN KEY(WarehouseId) REFERENCES dbo.Warehouses(Id));
CREATE TABLE dbo.ProductCategories(ProductId INT NOT NULL,CategoryId INT NOT NULL,PRIMARY KEY(ProductId,CategoryId),CONSTRAINT FK_ProductCategories_Products FOREIGN KEY(ProductId) REFERENCES dbo.Products(Id) ON DELETE CASCADE,CONSTRAINT FK_ProductCategories_Categories FOREIGN KEY(CategoryId) REFERENCES dbo.Categories(Id) ON DELETE CASCADE);
GO
CREATE OR ALTER PROCEDURE dbo.sp_InsertWarehouse @Name NVARCHAR(100),@Location NVARCHAR(200),@NewId INT OUTPUT AS BEGIN SET NOCOUNT ON; INSERT INTO dbo.Warehouses(Name,Location,IsActive) VALUES(@Name,@Location,1); SET @NewId=SCOPE_IDENTITY(); END
GO
CREATE OR ALTER PROCEDURE dbo.sp_UpdateWarehouse @Id INT,@Name NVARCHAR(100),@Location NVARCHAR(200),@IsActive BIT AS BEGIN SET NOCOUNT ON; UPDATE dbo.Warehouses SET Name=@Name,Location=@Location,IsActive=@IsActive WHERE Id=@Id; END
GO
CREATE OR ALTER PROCEDURE dbo.sp_InsertCategory @Name NVARCHAR(100),@NewId INT OUTPUT AS BEGIN SET NOCOUNT ON; INSERT INTO dbo.Categories(Name) VALUES(@Name); SET @NewId=SCOPE_IDENTITY(); END
GO
CREATE OR ALTER PROCEDURE dbo.sp_UpdateCategory @Id INT,@Name NVARCHAR(100) AS BEGIN SET NOCOUNT ON; UPDATE dbo.Categories SET Name=@Name WHERE Id=@Id; END
GO
CREATE OR ALTER PROCEDURE dbo.sp_InsertProduct @Name NVARCHAR(100),@Type NVARCHAR(100),@Size NVARCHAR(50)=NULL,@ExpirationDate DATETIME2=NULL,@ImagePath NVARCHAR(300)=NULL,@WarehouseId INT,@ShelfLocation NVARCHAR(100),@CategoryIds NVARCHAR(MAX)=NULL,@NewId INT OUTPUT AS BEGIN SET NOCOUNT ON; IF NOT EXISTS(SELECT 1 FROM dbo.Warehouses WHERE Id=@WarehouseId AND IsActive=1) BEGIN RAISERROR('Warehouse does not exist or is inactive.',16,1); RETURN; END INSERT INTO dbo.Products(Name,Type,Size,ExpirationDate,ImagePath,WarehouseId,ShelfLocation) VALUES(@Name,@Type,@Size,@ExpirationDate,@ImagePath,@WarehouseId,@ShelfLocation); SET @NewId=SCOPE_IDENTITY(); IF @CategoryIds IS NOT NULL AND LEN(@CategoryIds)>0 BEGIN INSERT INTO dbo.ProductCategories(ProductId,CategoryId) SELECT @NewId,TRY_CAST(value AS INT) FROM STRING_SPLIT(@CategoryIds,',') WHERE TRY_CAST(value AS INT) IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.Categories c WHERE c.Id=TRY_CAST(value AS INT)); END END
GO
CREATE OR ALTER PROCEDURE dbo.sp_UpdateProduct @Id INT,@Name NVARCHAR(100),@Type NVARCHAR(100),@Size NVARCHAR(50)=NULL,@ExpirationDate DATETIME2=NULL,@ImagePath NVARCHAR(300)=NULL,@WarehouseId INT,@ShelfLocation NVARCHAR(100),@CategoryIds NVARCHAR(MAX)=NULL AS BEGIN SET NOCOUNT ON; IF NOT EXISTS(SELECT 1 FROM dbo.Products WHERE Id=@Id) BEGIN RAISERROR('Product does not exist.',16,1); RETURN; END IF NOT EXISTS(SELECT 1 FROM dbo.Warehouses WHERE Id=@WarehouseId AND IsActive=1) BEGIN RAISERROR('Warehouse does not exist or is inactive.',16,1); RETURN; END UPDATE dbo.Products SET Name=@Name,Type=@Type,Size=@Size,ExpirationDate=@ExpirationDate,ImagePath=@ImagePath,WarehouseId=@WarehouseId,ShelfLocation=@ShelfLocation WHERE Id=@Id; DELETE FROM dbo.ProductCategories WHERE ProductId=@Id; IF @CategoryIds IS NOT NULL AND LEN(@CategoryIds)>0 BEGIN INSERT INTO dbo.ProductCategories(ProductId,CategoryId) SELECT @Id,TRY_CAST(value AS INT) FROM STRING_SPLIT(@CategoryIds,',') WHERE TRY_CAST(value AS INT) IS NOT NULL AND EXISTS(SELECT 1 FROM dbo.Categories c WHERE c.Id=TRY_CAST(value AS INT)); END END
GO
INSERT INTO dbo.Warehouses(Name,Location,IsActive) VALUES('Main Warehouse','Skopje Center',1),('Mall Storage','City Mall',1);
INSERT INTO dbo.Categories(Name) VALUES('Perfumes'),('Clothes'),('Accessories');
DECLARE @NewProductId INT;
EXEC dbo.sp_InsertProduct @Name='Luxury Perfume',@Type='Perfume',@Size='100ml',@ExpirationDate='2026-06-10',@ImagePath='images/perfume1.jpg',@WarehouseId=1,@ShelfLocation='Shelf A1',@CategoryIds='1',@NewId=@NewProductId OUTPUT;
EXEC dbo.sp_InsertProduct @Name='Summer Dress',@Type='Clothes',@Size='M',@ExpirationDate=NULL,@ImagePath='images/dress1.jpg',@WarehouseId=2,@ShelfLocation='Rack B2',@CategoryIds='2',@NewId=@NewProductId OUTPUT;
GO
