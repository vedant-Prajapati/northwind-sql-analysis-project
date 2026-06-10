create database if not exists northwind; USE northwind;

create table categories(
categoryID int primary key,	
categoryName varchar(200), 
description varchar(200),	
picture text
);

create table customers(
customerID varchar(10) primary key,
companyName	varchar(200),
contactName	varchar(200),
contactTitle varchar(200),
address	varchar(200),
city varchar(200),
region varchar(200),	
postalCode	varchar(200),
country	varchar(200),
phone varchar(200),
fax varchar(200)
);

create table suppliers(
supplierID int primary key,
companyName	varchar(100) not null,
contactName	varchar(100),
contactTitle varchar(100),
address varchar(100),
city varchar(100),
region varchar(100),
postalCode varchar(100),
country varchar(100),
phone varchar(100),
fax varchar(100),
homePage varchar(100)
);

create table products(
productID int primary key,
productName	varchar(100) not null,
supplierID int,
categoryID int,
quantityPerUnit	varchar(50),
unitPrice decimal(10,2),
unitsInStock int,
unitsOnOrder int,
reorderLevel int,
discontinued tinyint,
foreign key(supplierID) references suppliers(supplierID),
foreign key(categoryID) references categories(categoryID)
);


create table employees(
employeeID int primary key,
lastName varchar(200) not null,
firstName varchar(200) not null,
title varchar(200),
titleOfCourtesy	varchar(200),
birthDate date,
hireDate date,
address	varchar(200),
city varchar(200),
region varchar(200),
postalCode varchar(200),
country varchar(200),
homePhone varchar(200),
extension varchar(200),
photo varchar(200),
notes varchar(200),
reportsTo int,
photoPath varchar(200),
foreign key (reportsTo) references employees(employeeID)
);

create table shippers(
shipperID int primary key, 
companyName varchar(200) not null, 
phone varchar(200)
);



create table orders(
orderID	int primary key,
customerID varchar(20),	
employeeID int,
orderDate date,
requiredDate date,	
shippedDate	date,
shipVia	int,
freight	decimal(10,2),
shipName varchar(200),	
shipAddress	varchar(200),
shipCity varchar(200),
shipRegion varchar(200),
shipPostalCode varchar(200),
shipCountry varchar(200),
foreign key (customerID) references customers(customerID),
foreign key (employeeID) references employees(employeeID),
foreign key (shipVia) references shippers(shipperID)
);

create table order_details(
orderID	int,
productID int,
unitPrice decimal(10,2) not null,
quantity int not null,
discount decimal(10,2) not null default 0,
primary key (orderID),
foreign key (orderID) references orders(orderID),
foreign key (productID) references products(productID)
);


SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM categories;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM order_details;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM shippers;
SELECT COUNT(*) FROM suppliers;


-- Data Retrieval & Filtering: Basic SELECT

-- Get all columns
SELECT * FROM customers;

-- Get only specific columns (Best Practice)
SELECT CompanyName, City, Country, Phone 
FROM customers;

-- LIMIT (Very Useful for Beginners)

-- Get only first 10 customers
SELECT CompanyName, City, Country 
FROM customers 
LIMIT 10;

-- Get first 20 orders
SELECT OrderID, OrderDate, CustomerID 
FROM orders 
LIMIT 20;

-- ORDER BY (Sorting)

-- Sort customers by Company Name (A to Z)
SELECT CompanyName, City, Country
FROM customers 
ORDER BY CompanyName;
-- Sort in descending order (Z to A)
SELECT CompanyName, City, Country
FROM customers 
ORDER BY CompanyName DESC;
-- Sort by multiple columns
SELECT Country, City, CompanyName
FROM customers 
ORDER BY Country ASC, City ASC;

--  WHERE Clause (Filtering)

-- Simple filtering
SELECT CompanyName, City, Country
FROM customers 
WHERE Country = 'Germany';
-- Multiple conditions with AND
SELECT OrderID, OrderDate, Freight
FROM orders 
WHERE Country = 'USA' 
  AND Freight > 100;
-- OR condition
SELECT ProductName, UnitPrice
FROM products 
WHERE CategoryID = 1 OR CategoryID = 2;
-- Using NOT
SELECT CompanyName, Country
FROM customers 
WHERE Country != 'USA';

-- Practical Examples:

-- LIKE examples
SELECT CompanyName, ContactName 
FROM customers 
WHERE CompanyName LIKE 'A%';        -- Starts with A
SELECT ProductName 
FROM products 
WHERE ProductName LIKE '%chocolate%';   -- Contains chocolate
-- IN example
SELECT CompanyName, Country
FROM customers 
WHERE Country IN ('USA', 'UK', 'France', 'Germany')
ORDER BY Country;

-- DISTINCT (Remove Duplicates)

-- Get unique countries
SELECT DISTINCT Country 
FROM customers 
ORDER BY Country;
-- Get unique cities from Germany
SELECT DISTINCT City 
FROM customers 
WHERE Country = 'Germany'
ORDER BY City;

-- combined

SELECT 
    c.CompanyName,
    c.City,
    c.Country,
    o.OrderID,
    o.OrderDate,
    o.Freight
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
WHERE c.Country IN ('USA', 'Germany', 'UK')
ORDER BY o.Freight DESC
LIMIT 15;

-- GROUP BY + HAVING + Aggregate Functions

-- Basic
USE northwind;

-- Simple Aggregates (on whole table)
SELECT 
    COUNT(*) AS Total_Orders,
    SUM(Freight) AS Total_Freight,
    AVG(Freight) AS Average_Freight,
    MAX(Freight) AS Highest_Freight,
    MIN(Freight) AS Lowest_Freight
FROM orders;

-- GROUP BY

-- Number of orders per customer
SELECT 
    CustomerID,
    COUNT(*) AS Number_of_Orders
FROM orders
GROUP BY CustomerID
ORDER BY Number_of_Orders DESC
LIMIT 15;
-- Total sales value per product
SELECT 
    ProductID,
    SUM(Quantity) AS Total_Quantity_Sold,
    SUM(UnitPrice * Quantity) AS Total_Revenue
FROM order_details
GROUP BY ProductID
ORDER BY Total_Revenue DESC
LIMIT 10;

-- GROUP BY with Multiple Columns

-- Orders per country and city
SELECT 
    c.Country,
    c.City,
    COUNT(o.OrderID) AS Total_Orders
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Country, c.City
ORDER BY Total_Orders DESC;

-- HAVING Clause

-- Customers who placed more than 10 orders
SELECT 
    CustomerID,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY CustomerID
HAVING Order_Count > 10
ORDER BY Order_Count DESC;
-- Countries with more than 20 orders
SELECT 
    c.Country,
    COUNT(o.OrderID) AS Total_Orders
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Country
HAVING Total_Orders >= 20
ORDER BY Total_Orders DESC;

-- Average order value per customer (Top 10)

SELECT c.CompanyName, COUNT(o.OrderID) AS Number_of_Orders, AVG(o.Freight) AS Avg_Freight, SUM(o.Freight) AS Total_Freight 
FROM customers c 
JOIN orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.CompanyName 
HAVING Number_of_Orders >= 5 
ORDER BY Total_Freight DESC 
LIMIT 10;

-- Products that sold more than 100 units
SELECT p.ProductName, p.UnitPrice, SUM(od.Quantity) AS Total_Sold, COUNT(DISTINCT od.OrderID) AS Times_Ordered 
FROM products p 
JOIN order_details od ON p.ProductID = od.ProductID 
GROUP BY p.ProductName, p.UnitPrice 
HAVING Total_Sold > 100 
ORDER BY Total_Sold DESC;

-- INNER JOIN (Most Common)
USE northwind;

-- Basic INNER JOIN
SELECT 
    o.OrderID,
    c.CompanyName,
    o.OrderDate,
    o.Freight
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
LIMIT 20;

-- Show Product Name + Category Name
SELECT p.ProductName, c.CategoryName, p.UnitPrice 
FROM products p 
INNER JOIN categories c ON p.CategoryID = c.CategoryID 
ORDER BY p.UnitPrice DESC 
LIMIT 15;

-- Show Order Details with Product and Customer
SELECT o.OrderID, c.CompanyName, p.ProductName, od.Quantity, od.UnitPrice 
FROM orders o 
INNER JOIN customers c ON o.CustomerID = c.CustomerID 
INNER JOIN order_details od ON o.OrderID = od.OrderID 
INNER JOIN products p ON od.ProductID = p.ProductID 
LIMIT 20;

-- LEFT JOIN
-- All customers, even those who never placed any order
SELECT 
    c.CompanyName,
    c.Country,
    o.OrderID,
    o.OrderDate
FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID DESC
LIMIT 30;


-- Customers who never placed any order
SELECT 
    c.CompanyName,
    c.Country,
    c.Phone
FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- RIGHT JOIN
-- All products, even those never sold
SELECT 
    p.ProductName,
    p.UnitPrice,
    od.OrderID
FROM order_details od
RIGHT JOIN products p ON od.ProductID = p.ProductID
WHERE od.OrderID IS NULL;   -- Products never ordered

-- FULL OUTER JOIN

-- MySQL does not support FULL OUTER JOIN directly
-- FULL OUTER JOIN simulation
SELECT * FROM customers c
LEFT JOIN orders o ON c.CustomerID = o.CustomerID

UNION

SELECT * FROM customers c
RIGHT JOIN orders o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL;

-- CROSS JOIN (Cartesian Product)
-- Example: All categories with all shippers
SELECT 
    c.CategoryName,
    s.CompanyName AS Shipper
FROM categories c
CROSS JOIN shippers s
ORDER BY c.CategoryName
LIMIT 30;

-- SELF JOIN (Join table with itself)

-- Employee and their Manager
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Title,
    m.FirstName AS Manager_FirstName,
    m.LastName AS Manager_LastName
FROM employees e
LEFT JOIN employees m ON e.ReportsTo = m.EmployeeID;


-- Non-Correlated Subquery (Independent) Correlated Subquery (Dependent)

-- Non-Correlated Subquery
USE northwind;

-- Example 1: Find products that are more expensive than average price
SELECT ProductName, UnitPrice
FROM products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM products)
ORDER BY UnitPrice DESC;


-- Example 2: Find customers who placed more orders than average
SELECT 
    c.CompanyName,
    COUNT(o.OrderID) AS OrderCount
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName
HAVING OrderCount > (
    SELECT AVG(OrderCount)
    FROM (
        SELECT COUNT(*) AS OrderCount 
        FROM orders 
        GROUP BY CustomerID
    ) AS avg_orders
)
ORDER BY OrderCount DESC;

-- Correlated Subquery	
-- Example: Find orders that have higher freight than the average freight of that customer
SELECT 
    o.OrderID,
    o.CustomerID,
    o.Freight,
    (SELECT AVG(Freight) 
     FROM orders o2 
     WHERE o2.CustomerID = o.CustomerID) AS Avg_Customer_Freight
FROM orders o
WHERE o.Freight > (
    SELECT AVG(Freight) 
    FROM orders o2 
    WHERE o2.CustomerID = o.CustomerID
)
ORDER BY o.CustomerID, o.Freight DESC;

-- Examples
-- 1. Products that were never ordered
SELECT ProductName, UnitPrice
FROM products p
WHERE ProductID NOT IN (
    SELECT ProductID FROM order_details
);
-- 2. Customers who ordered 'Chai' product
SELECT CompanyName, Country
FROM customers c
WHERE CustomerID IN (
    SELECT o.CustomerID 
    FROM orders o
    JOIN order_details od ON o.OrderID = od.OrderID
    WHERE od.ProductID = (SELECT ProductID FROM products WHERE ProductName = 'Chai')
);
-- 3. Employee who has the highest number of orders
SELECT FirstName, LastName, Title
FROM employees e
WHERE EmployeeID = (
    SELECT EmployeeID 
    FROM orders 
    GROUP BY EmployeeID 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- IN vs EXISTS vs =
-- Using IN
SELECT CompanyName FROM customers 
WHERE CustomerID IN (SELECT CustomerID FROM orders);

-- Using EXISTS (Usually faster for large data)
SELECT CompanyName FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o 
    WHERE o.CustomerID = c.CustomerID
);

-- Common Table Expressions (CTEs)

USE northwind;
-- Example 1: Simple CTE
WITH CustomerOrderCount AS (
    SELECT 
        CustomerID,
        COUNT(*) AS Total_Orders
    FROM orders
    GROUP BY CustomerID
)
SELECT 
    c.CompanyName,
    c.Country,
    co.Total_Orders
FROM customers c
JOIN CustomerOrderCount co ON c.CustomerID = co.CustomerID
ORDER BY co.Total_Orders DESC
LIMIT 15;

-- Multiple CTEs in one query (Very Powerful)
WITH 
OrderSummary AS (
    SELECT 
        CustomerID,
        COUNT(*) AS OrderCount,
        SUM(Freight) AS TotalFreight
    FROM orders
    GROUP BY CustomerID
),
HighValueCustomers AS (
    SELECT CustomerID 
    FROM OrderSummary 
    WHERE TotalFreight > 1000
)
SELECT 
    c.CompanyName,
    c.Country,
    os.OrderCount,
    os.TotalFreight
FROM customers c
JOIN OrderSummary os ON c.CustomerID = os.CustomerID
WHERE c.CustomerID IN (SELECT CustomerID FROM HighValueCustomers)
ORDER BY os.TotalFreight DESC;

-- 1. Employee Sales Performance
WITH EmployeeOrders AS (
    SELECT 
        EmployeeID,
        COUNT(*) AS Total_Orders,
        SUM(Freight) AS Total_Freight
    FROM orders
    GROUP BY EmployeeID
)
SELECT 
    e.FirstName,
    e.LastName,
    eo.Total_Orders,
    eo.Total_Freight,
    ROUND(eo.Total_Freight / eo.Total_Orders, 2) AS Avg_Freight_Per_Order
FROM employees e
JOIN EmployeeOrders eo ON e.EmployeeID = eo.EmployeeID
ORDER BY eo.Total_Freight DESC;

-- Monthly Sales Trend
-- 2. Monthly Sales Trend
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(OrderDate, '%Y-%m') AS OrderMonth,
        COUNT(*) AS OrderCount,
        SUM(Freight) AS MonthlyFreight
    FROM orders
    GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
)
SELECT 
    OrderMonth,
    OrderCount,
    MonthlyFreight,
    LAG(MonthlyFreight) OVER (ORDER BY OrderMonth) AS Previous_Month_Freight
FROM MonthlySales
ORDER BY OrderMonth;

-- Creating a Simple View
USE northwind;

-- Basic View
CREATE VIEW customer_orders AS
SELECT 
    c.CompanyName,
    c.Country,
    c.City,
    o.OrderID,
    o.OrderDate,
    o.Freight
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID;

-- Using the View:
-- Now you can use it like a normal table
SELECT * FROM customer_orders LIMIT 20;

SELECT 
    CompanyName,
    COUNT(*) AS Total_Orders,
    SUM(Freight) AS Total_Freight
FROM customer_orders
GROUP BY CompanyName
ORDER BY Total_Freight DESC
LIMIT 10;

-- More Useful Views

-- View 1: Order Details with Product & Customer Info
CREATE VIEW order_details_full AS
SELECT 
    o.OrderID,
    o.OrderDate,
    c.CompanyName AS CustomerName,
    c.Country,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS TotalValue,
    s.CompanyName AS ShipperName
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
JOIN products p ON od.ProductID = p.ProductID
JOIN shippers s ON o.ShipVia = s.ShipperID;
-- Use it
SELECT * FROM order_details_full LIMIT 15;

-- More view:

-- View 2: Sales Summary by Category
CREATE VIEW category_sales AS
SELECT 
    c.CategoryName,
    COUNT(DISTINCT o.OrderID) AS Total_Orders,
    SUM(od.Quantity) AS Total_Units_Sold,
    SUM(od.UnitPrice * od.Quantity) AS Total_Revenue,
    AVG(od.UnitPrice) AS Avg_Price
FROM categories c
JOIN products p ON c.CategoryID = p.CategoryID
JOIN order_details od ON p.ProductID = od.ProductID
JOIN orders o ON od.OrderID = o.OrderID
GROUP BY c.CategoryName;

-- String Functions
SELECT 
    ProductName,
    TRIM(ProductName) AS Clean_Name,
    REPLACE(ProductName, ' ', '_') AS Replaced,
    LEFT(ProductName, 10) AS First_10,
    RIGHT(ProductName, 8) AS Last_8
FROM products;

-- Date Functions
SELECT 
    OrderDate,
    YEAR(OrderDate) AS Order_Year,
    MONTH(OrderDate) AS Order_Month,
    DAY(OrderDate) AS Order_Day,
    DATE_FORMAT(OrderDate, '%d-%b-%Y') AS Formatted_Date,
    DATEDIFF(NOW(), OrderDate) AS Days_Ago
FROM orders
LIMIT 15;

-- Math Functions
SELECT 
    UnitPrice,
    ROUND(UnitPrice, 2) AS Rounded,
    CEIL(UnitPrice) AS Ceiling,
    FLOOR(UnitPrice) AS Floor_Value,
    POWER(Quantity, 2) AS Squared,
    SQRT(UnitPrice) AS Square_Root
FROM order_details
LIMIT 10;


-- Constraints
-- Demo

USE northwind;

-- Create a new table with all constraints
CREATE TABLE student (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    RollNo VARCHAR(20) UNIQUE NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Age INT CHECK (Age >= 15 AND Age <= 40),
    Gender CHAR(1) CHECK (Gender IN ('M','F')),
    City VARCHAR(50) DEFAULT 'Ahmedabad',
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Example

-- See existing constraints in Northwind
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'northwind';

-- Check Foreign Key in order_details
SHOW CREATE TABLE order_details;

-- Adding Constraints to Existing Tables

-- Add NOT NULL
ALTER TABLE customers MODIFY ContactName VARCHAR(100) NOT NULL;

-- Add UNIQUE
ALTER TABLE customers ADD CONSTRAINT unique_phone UNIQUE (Phone);

-- Add CHECK (MySQL 8.0+)
ALTER TABLE products ADD CONSTRAINT chk_price CHECK (UnitPrice > 0);

-- Indexing

USE northwind;
-- 1. See existing indexes
SHOW INDEX FROM customers;
SHOW INDEX FROM orders;
SHOW INDEX FROM order_details;
-- 2. Create Simple Index
CREATE INDEX idx_customer_country ON customers(Country);
CREATE INDEX idx_order_date ON orders(OrderDate);
CREATE INDEX idx_product_name ON products(ProductName);
-- 3. Create Composite Index (Very Important)
CREATE INDEX idx_order_customer ON orders(CustomerID, OrderDate);
-- 4. Create Unique Index
CREATE UNIQUE INDEX idx_unique_phone ON customers(Phone);


-- How to Check if Index is Being Used?

-- Check query performance
EXPLAIN SELECT * FROM orders 
WHERE OrderDate = '1996-07-04';

-- Range Partitioning
USE northwind;
-- Create a partitioned copy of Orders table by Year
CREATE TABLE orders_partitioned (
    OrderID INT,
    CustomerID VARCHAR(10),
    EmployeeID INT,
    OrderDate DATE NOT NULL,
    RequiredDate DATE,
    ShippedDate DATE,
    Freight DECIMAL(10,2),
    PRIMARY KEY (OrderID, OrderDate)   -- Important: Partition column must be in PK
)
PARTITION BY RANGE (YEAR(OrderDate)) (
    PARTITION p0 VALUES LESS THAN (1996),
    PARTITION p1 VALUES LESS THAN (1997),
    PARTITION p2 VALUES LESS THAN (1998),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);

-- Insert Data into Partitioned Table
-- Copy data from original orders table
INSERT INTO orders_partitioned
SELECT * FROM orders;
-- Check Partitions
-- See partition information
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    PARTITION_EXPRESSION
FROM information_schema.PARTITIONS 
WHERE TABLE_NAME = 'orders_partitioned';

-- Real Benefits of Partitioning

-- Fast delete of old data (Drops entire partition)
ALTER TABLE orders_partitioned DROP PARTITION p0;

-- Query only specific partition (faster)
SELECT * FROM orders_partitioned 
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01';

-- Stored Procedure with Parameters

-- Example 2: Procedure with Input Parameter
DELIMITER //
CREATE PROCEDURE GetCustomerOrders(IN custID VARCHAR(10))
BEGIN
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.Freight,
        SUM(od.Quantity * od.UnitPrice) AS OrderValue
    FROM orders o
    JOIN order_details od ON o.OrderID = od.OrderID
    WHERE o.CustomerID = custID
    GROUP BY o.OrderID, o.OrderDate, o.Freight
    ORDER BY o.OrderDate DESC;
END //
DELIMITER ;
-- Call it
CALL GetCustomerOrders('ALFKI');

-- Window Functions

-- Basic Window Functions
USE northwind;

-- ROW_NUMBER() - Gives unique rank
SELECT 
    ProductName,
    UnitPrice,
    ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS Price_Rank
FROM products
LIMIT 15;

-- RANK & DENSE_RANK
SELECT 
    CompanyName,
    Country,
    COUNT(*) AS Order_Count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank_With_Gap,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank_No_Gap
FROM customers c
JOIN orders o ON c.CustomerID = o.CustomerID
GROUP BY CompanyName, Country
ORDER BY Order_Count DESC
LIMIT 20;

-- PARTITION BY
-- Rank products within each category
SELECT 
    c.CategoryName,
    p.ProductName,
    p.UnitPrice,
    ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.UnitPrice DESC) AS Rank_In_Category
FROM products p
JOIN categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName, Rank_In_Category;

-- LEAD & LAG
-- Compare current order freight with previous order of same customer
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    Freight,
    LAG(Freight) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS Previous_Freight,
    LEAD(Freight) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS Next_Freight,
    Freight - LAG(Freight) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS Difference
FROM orders
ORDER BY CustomerID, OrderDate
LIMIT 30;

-- Running Total & Moving Average

-- Running total of freight per customer
SELECT 
    CustomerID,
    OrderDate,
    Freight,
    SUM(Freight) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS Running_Total,
    AVG(Freight) OVER (PARTITION BY CustomerID ORDER BY OrderDate 
                       ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS Moving_Avg_4_Orders
FROM orders
ORDER BY CustomerID, OrderDate;

--

