-- 食品采购系统数据库创建脚本
-- 适用于 SQL Server 2008

-- 创建数据库
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'FoodProcurement')
BEGIN
    CREATE DATABASE FoodProcurement
END
GO

USE FoodProcurement
GO

-- 创建分类表
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Categories' AND xtype='U')
BEGIN
    CREATE TABLE Categories (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(50) NOT NULL,
        Description NVARCHAR(200),
        CreateDate DATETIME DEFAULT GETDATE()
    )
END
GO

-- 创建食材表
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Foods' AND xtype='U')
BEGIN
    CREATE TABLE Foods (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        Description NVARCHAR(500),
        Price DECIMAL(10,2) NOT NULL,
        Unit NVARCHAR(20) NOT NULL,
        Stock INT DEFAULT 0,
        CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
        CreateDate DATETIME DEFAULT GETDATE(),
        UpdateDate DATETIME DEFAULT GETDATE()
    )
    
    -- 重命名现有Name列为FoodName以兼容旧版本数据库
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Foods' AND COLUMN_NAME = 'Name')
    BEGIN
        EXEC sp_rename 'Foods.Name', 'FoodName', 'COLUMN';
    END
END
GO

-- 创建用户表
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
BEGIN
    CREATE TABLE Users (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Username NVARCHAR(50) NOT NULL UNIQUE,
        Password NVARCHAR(100) NOT NULL,
        Email NVARCHAR(100),
        Role NVARCHAR(20) DEFAULT 'User',
        CreateDate DATETIME DEFAULT GETDATE()
    )
END
GO

-- 创建采购请求表
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ProcurementRequests' AND xtype='U')
BEGIN
    CREATE TABLE ProcurementRequests (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        FoodId INT FOREIGN KEY REFERENCES Foods(Id),
        Quantity INT NOT NULL,
        RequestDate DATETIME DEFAULT GETDATE(),
        Status NVARCHAR(20) DEFAULT 'Pending',
        RequestedBy NVARCHAR(50),
        Notes NVARCHAR(500)
    )
END
GO

-- 插入示例数据
-- 插入分类
IF NOT EXISTS (SELECT * FROM Categories WHERE Name = '蔬菜')
BEGIN
    INSERT INTO Categories (Name, Description) VALUES ('蔬菜', '新鲜蔬菜类')
END

IF NOT EXISTS (SELECT * FROM Categories WHERE Name = '肉类')
BEGIN
    INSERT INTO Categories (Name, Description) VALUES ('肉类', '各种肉类')
END

IF NOT EXISTS (SELECT * FROM Categories WHERE Name = '海鲜')
BEGIN
    INSERT INTO Categories (Name, Description) VALUES ('海鲜', '新鲜海鲜类')
END

IF NOT EXISTS (SELECT * FROM Categories WHERE Name = '调味料')
BEGIN
    INSERT INTO Categories (Name, Description) VALUES ('调味料', '各种调味料')
END

-- 插入食材
IF NOT EXISTS (SELECT * FROM Foods WHERE FoodName = '白菜')
BEGIN
    INSERT INTO Foods (FoodName, Description, Price, Unit, Stock, CategoryId) 
    VALUES ('白菜', '新鲜大白菜', 2.50, '斤', 100, (SELECT Id FROM Categories WHERE Name = '蔬菜'))
END

IF NOT EXISTS (SELECT * FROM Foods WHERE FoodName = '猪肉')
BEGIN
    INSERT INTO Foods (FoodName, Description, Price, Unit, Stock, CategoryId) 
    VALUES ('猪肉', '新鲜猪肉', 15.00, '斤', 50, (SELECT Id FROM Categories WHERE Name = '肉类'))
END

IF NOT EXISTS (SELECT * FROM Foods WHERE FoodName = '虾仁')
BEGIN
    INSERT INTO Foods (FoodName, Description, Price, Unit, Stock, CategoryId) 
    VALUES ('虾仁', '新鲜虾仁', 25.00, '斤', 30, (SELECT Id FROM Categories WHERE Name = '海鲜'))
END

IF NOT EXISTS (SELECT * FROM Foods WHERE FoodName = '生抽')
BEGIN
    INSERT INTO Foods (FoodName, Description, Price, Unit, Stock, CategoryId) 
    VALUES ('生抽', '优质生抽', 8.00, '瓶', 80, (SELECT Id FROM Categories WHERE Name = '调味料'))
END

-- 插入管理员用户
IF NOT EXISTS (SELECT * FROM Users WHERE Username = 'admin')
BEGIN
    INSERT INTO Users (Username, Password, Email, Role) 
    VALUES ('admin', 'admin123', 'admin@example.com', 'Admin')
END

GO

-- 创建存储过程
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetPopularFoods')
    DROP PROCEDURE GetPopularFoods
GO

CREATE PROCEDURE GetPopularFoods
    @TopCount INT = 4
AS
BEGIN
    SELECT TOP (@TopCount) f.Id, f.Name, f.Description, f.Price, f.Unit, f.Stock, c.Name AS CategoryName
    FROM Foods f 
    INNER JOIN Categories c ON f.CategoryId = c.Id
    ORDER BY f.Stock DESC
END
GO

PRINT '数据库创建完成！'