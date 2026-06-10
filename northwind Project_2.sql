-- write queries for the following:

-- Show first 15 products with their name and price, sorted by price (highest first).
SELECT
    ProductName,
    UnitPrice
FROM products
ORDER BY UnitPrice DESC
LIMIT 15;

-- Show all orders where Freight is more than 50.
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    Freight,
    ShipCountry
FROM orders
WHERE Freight > 50
ORDER BY Freight DESC;

-- Show unique countries from customers table.

SELECT DISTINCT Country
FROM customers
ORDER BY Country;

-- Show customer name and city for customers whose name starts with "B".

SELECT
    CompanyName,
    City
FROM customers
WHERE CompanyName LIKE 'B%';

-- Show OrderID, OrderDate for orders shipped after '1996-07-01' (first 20 only).

SELECT
    OrderID,
    OrderDate
FROM orders
WHERE ShippedDate > '1996-07-01'
ORDER BY ShippedDate
LIMIT 20;



-- ****************** Section 1: Data Retrieval & Filtering ***************************************

-- Show all columns from the customers table.

SELECT *
FROM customers;

-- Show CompanyName, City, Country, Phone from customers. Sort by CompanyName.

SELECT
    CompanyName,
    City,
    Country,
    Phone
FROM customers
ORDER BY CompanyName ASC;

-- Show the first 20 orders with OrderID, OrderDate, Freight. Sort by Freight descending.

SELECT
    OrderID,
    OrderDate,
    Freight
FROM orders
ORDER BY Freight DESC
LIMIT 20;

-- Find all customers from Germany or France.

SELECT *
FROM customers
WHERE Country IN ('Germany', 'France');

-- Find products where UnitPrice is between 20 and 50.

SELECT *
FROM products
WHERE UnitPrice BETWEEN 20 AND 50;

-- Show unique countries from the customers table.

SELECT DISTINCT Country
FROM customers
ORDER BY Country;

-- Find customers whose CompanyName starts with 'A' or 'B'.

SELECT
    CustomerID,
    CompanyName,
    City,
    Country
FROM customers
WHERE CompanyName LIKE 'A%'
   OR CompanyName LIKE 'B%'
ORDER BY CompanyName;

-- Show orders placed after '1997-01-01' with freight more than 100. Limit to 15 rows.

SELECT
    OrderID,
    CustomerID,
    OrderDate,
    Freight
FROM orders
WHERE OrderDate > '1997-01-01'
  AND Freight > 100
ORDER BY OrderDate
LIMIT 15;
		
-- Section 2: GROUP BY + HAVING

-- Count total number of orders.

SELECT COUNT(*) AS TotalOrders
FROM orders;

-- Show number of orders per customer (Top 10 customers).

SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS TotalOrders
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalOrders DESC
LIMIT 10;

-- Show total revenue (UnitPrice * Quantity) per category.

SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity) AS TotalRevenue
FROM categories c
JOIN products p
    ON c.CategoryID = p.CategoryID
JOIN order_details od
    ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalRevenue DESC;

-- Find countries that have more than 10 customers.

SELECT
    Country,
    COUNT(*) AS CustomerCount
FROM customers
GROUP BY Country
HAVING COUNT(*) > 10
ORDER BY CustomerCount DESC;

-- Show average freight per shipper.

SELECT
    s.ShipperID,
    s.CompanyName,
    AVG(o.Freight) AS AverageFreight
FROM shippers s
JOIN orders o
    ON s.ShipperID = o.ShipVia
GROUP BY s.ShipperID, s.CompanyName
ORDER BY AverageFreight DESC;

-- Find products that have been ordered more than 50 times.

SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantityOrdered
FROM products p
JOIN order_details od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING SUM(od.Quantity) > 50
ORDER BY TotalQuantityOrdered DESC;

-- Show customers who placed more than 8 orders.

 SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS OrderCount
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
HAVING COUNT(o.OrderID) > 8
ORDER BY OrderCount DESC;

-- Find categories where average product price is greater than 30.
SELECT
    c.CategoryID,
    c.CategoryName,
    AVG(p.UnitPrice) AS AveragePrice
FROM categories c
JOIN products p
    ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
HAVING AVG(p.UnitPrice) > 30
ORDER BY AveragePrice DESC;

-- Section 3: All Types of Joins

-- Show OrderID, CompanyName (customer), and OrderDate.

SELECT
    o.OrderID,
    c.CompanyName,
    o.OrderDate
FROM orders o
JOIN customers c
    ON o.CustomerID = c.CustomerID;
    
-- Show ProductName, CategoryName, and UnitPrice.

SELECT
    p.ProductName,
    c.CategoryName,
    p.UnitPrice
FROM products p
JOIN categories c
    ON p.CategoryID = c.CategoryID;
    
-- Show all customers and their orders (including customers with no orders) — use LEFT JOIN.
SELECT
    c.CustomerID,
    c.CompanyName,
    o.OrderID,
    o.OrderDate
FROM customers c
LEFT JOIN orders o
    ON c.CustomerID = o.CustomerID
ORDER BY c.CompanyName;

-- Show products that have never been ordered.
SELECT
    p.ProductID,
    p.ProductName
FROM products p
LEFT JOIN order_details od
    ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;

-- Show OrderID, Customer Name, Shipper Name.
SELECT
    o.OrderID,
    c.CompanyName,
    s.CompanyName AS ShipperName
FROM orders o
JOIN customers c
    ON o.CustomerID = c.CustomerID
JOIN shippers s
    ON o.ShipVia = s.ShipperID;
    
-- Show Employee Name and their Manager Name (Self Join).
SELECT
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
FROM employees e
LEFT JOIN employees m
    ON e.ReportsTo = m.EmployeeID;
    
-- Show OrderID, ProductName, Quantity, and Customer CompanyName.
SELECT
    o.OrderID,
    p.ProductName,
    od.Quantity,
    c.CompanyName
FROM orders o
JOIN customers c
    ON o.CustomerID = c.CustomerID
JOIN order_details od
    ON o.OrderID = od.OrderID
JOIN products p
    ON od.ProductID = p.ProductID;
    
-- Show all orders with Customer Name and Employee FirstName + LastName.
SELECT
    o.OrderID,
    c.CompanyName,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    o.OrderDate
FROM orders o
JOIN customers c
    ON o.CustomerID = c.CustomerID
JOIN employees e
    ON o.EmployeeID = e.EmployeeID;
    
-- Count how many orders each employee handled (include employees with 0 orders).
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    COUNT(o.OrderID) AS TotalOrders
FROM employees e
LEFT JOIN orders o
    ON e.EmployeeID = o.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY TotalOrders DESC;

-- Show total sales amount per customer (Join 3 tables).
SELECT
    c.CustomerID,
    c.CompanyName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
JOIN order_details od
    ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName
ORDER BY TotalSales DESC;

-- Section 4: Subqueries

-- Find products that are more expensive than the average price.
SELECT
    ProductID,
    ProductName,
    UnitPrice
FROM products
WHERE UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM products
);

-- Find customers who have never placed any order (using subquery).
SELECT
    CustomerID,
    CompanyName
FROM customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM orders
    WHERE CustomerID IS NOT NULL
);

-- Show orders where freight is higher than the average freight of all orders.
SELECT
    OrderID,
    CustomerID,
    Freight
FROM orders
WHERE Freight > (
    SELECT AVG(Freight)
    FROM orders
)
ORDER BY Freight DESC;

-- Find the product that was ordered the most.
SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantityOrdered
FROM products p
JOIN order_details od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalQuantityOrdered DESC
LIMIT 1;

-- Show employees who handled more orders than the average.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(o.OrderID) AS TotalOrders
FROM employees e
JOIN orders o
    ON e.EmployeeID = o.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
HAVING COUNT(o.OrderID) >
(
    SELECT AVG(OrderCount)
    FROM
    (
        SELECT COUNT(*) AS OrderCount
        FROM orders
        GROUP BY EmployeeID
    ) AS AvgOrders
);

-- Find products whose price is higher than the average price of their own category.
SELECT
    p.ProductID,
    p.ProductName,
    p.UnitPrice,
    p.CategoryID
FROM products p
WHERE p.UnitPrice >
(
    SELECT AVG(p2.UnitPrice)
    FROM products p2
    WHERE p2.CategoryID = p.CategoryID
);

-- Section 5: CTEs

-- Create a CTE to show customer order count, then show only customers with more than 5 orders.
WITH CustomerOrderCount AS (
    SELECT
        CustomerID,
        COUNT(OrderID) AS OrderCount
    FROM orders
    GROUP BY CustomerID
)
SELECT
    c.CustomerID,
    c.CompanyName,
    coc.OrderCount
FROM CustomerOrderCount coc
JOIN customers c
    ON coc.CustomerID = c.CustomerID
WHERE coc.OrderCount > 5
ORDER BY coc.OrderCount DESC;

-- Create a CTE that calculates total spending per customer, then show top 5.
WITH CustomerSpending AS (
    SELECT
        o.CustomerID,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpending
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
)
SELECT
    c.CompanyName,
    cs.TotalSpending
FROM CustomerSpending cs
JOIN customers c
    ON cs.CustomerID = c.CustomerID
ORDER BY cs.TotalSpending DESC
LIMIT 5;

-- Use CTE to show monthly total freight for the year 1996.
WITH MonthlyFreight AS (
    SELECT
        MONTH(OrderDate) AS MonthNo,
        SUM(Freight) AS TotalFreight
    FROM orders
    WHERE YEAR(OrderDate) = 1996
    GROUP BY MONTH(OrderDate)
)
SELECT *
FROM MonthlyFreight
ORDER BY MonthNo;

-- Create two CTEs — one for order value, another for customer summary.
WITH OrderValue AS (
    SELECT
        OrderID,
        SUM(UnitPrice * Quantity * (1 - Discount)) AS OrderTotal
    FROM order_details
    GROUP BY OrderID
),
CustomerSummary AS (
    SELECT
        o.CustomerID,
        COUNT(o.OrderID) AS TotalOrders,
        SUM(ov.OrderTotal) AS TotalSales
    FROM orders o
    JOIN OrderValue ov
        ON o.OrderID = ov.OrderID
    GROUP BY o.CustomerID
)
SELECT
    c.CompanyName,
    cs.TotalOrders,
    cs.TotalSales
FROM CustomerSummary cs
JOIN customers c
    ON cs.CustomerID = c.CustomerID
ORDER BY cs.TotalSales DESC;

-- Use CTE to rank customers by total spending.
WITH CustomerSpending AS (
    SELECT
        o.CustomerID,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpending
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
)
SELECT
    c.CompanyName,
    cs.TotalSpending,
    RANK() OVER (ORDER BY cs.TotalSpending DESC) AS CustomerRank
FROM CustomerSpending cs
JOIN customers c
    ON cs.CustomerID = c.CustomerID;
    
-- Show running total of orders using CTE + Window function.
WITH DailyOrders AS (
    SELECT
        OrderDate,
        COUNT(*) AS OrdersPerDay
    FROM orders
    GROUP BY OrderDate
)
SELECT
    OrderDate,
    OrdersPerDay,
    SUM(OrdersPerDay) OVER (
        ORDER BY OrderDate
    ) AS RunningTotalOrders
FROM DailyOrders
ORDER BY OrderDate;

-- Section 6: Functions & Operators 

-- Show ProductName, UnitPrice, and price category using CASE (Cheap/Medium/Expensive).
SELECT
    ProductName,
    UnitPrice,
    CASE
        WHEN UnitPrice < 20 THEN 'Cheap'
        WHEN UnitPrice BETWEEN 20 AND 50 THEN 'Medium'
        ELSE 'Expensive'
    END AS PriceCategory
FROM products;

-- Show OrderDate in format DD-MMM-YYYY and extract Year and Month.
SELECT
    OrderID,
    DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedDate,
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth
FROM orders;

-- Concatenate Employee FirstName and LastName with space.
SELECT
    EmployeeID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName
FROM employees;

-- Show number of days between OrderDate and ShippedDate for all orders.
SELECT
    OrderID,
    OrderDate,
    ShippedDate,
    DATEDIFF(ShippedDate, OrderDate) AS DaysToShip
FROM orders;

-- Use IF() to show whether freight is High (>100) or Normal.
SELECT
    OrderID,
    Freight,
    IF(Freight > 100, 'High', 'Normal') AS FreightStatus
FROM orders;

-- Show total revenue rounded to 2 decimal places per month.
SELECT
    YEAR(o.OrderDate) AS OrderYear,
    MONTH(o.OrderDate) AS OrderMonth,
    ROUND(
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ),
        2
    ) AS TotalRevenue
FROM orders o
JOIN order_details od
    ON o.OrderID = od.OrderID
GROUP BY
    YEAR(o.OrderDate),
    MONTH(o.OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;

-- Section 7: Window Functions 

-- Show products with their rank based on UnitPrice (highest first).
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    RANK() OVER (ORDER BY UnitPrice DESC) AS PriceRank
FROM products;

-- Rank orders of each customer by OrderDate using ROW_NUMBER().
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    ROW_NUMBER() OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS OrderRank
FROM orders;

-- Show running total of freight per customer.
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    Freight,
    SUM(Freight) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS RunningFreightTotal
FROM orders;

-- Use LAG() to show previous order freight for each customer.
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    Freight,
    LAG(Freight) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS PreviousFreight
FROM orders;

-- Show Top 3 most expensive products in each category.
WITH RankedProducts AS (
    SELECT
        ProductID,
        ProductName,
        CategoryID,
        UnitPrice,
        ROW_NUMBER() OVER (
            PARTITION BY CategoryID
            ORDER BY UnitPrice DESC
        ) AS PriceRank
    FROM products
)
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    PriceRank
FROM RankedProducts
WHERE PriceRank <= 3
ORDER BY CategoryID, PriceRank;

-- For each order, show what percentage it contributes to the customer's total spending.
WITH OrderTotals AS (
    SELECT
        o.OrderID,
        o.CustomerID,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS OrderValue
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.OrderID,
        o.CustomerID
)
SELECT
    OrderID,
    CustomerID,
    OrderValue,
    ROUND(
        100 * OrderValue /
        SUM(OrderValue) OVER (
            PARTITION BY CustomerID
        ),
        2
    ) AS ContributionPercent
FROM OrderTotals
ORDER BY CustomerID, OrderValue DESC;

-- *************************************** Assignment *****************************************

-- Show all products that are discontinued but still have units in stock. 
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    UnitsInStock,
    Discontinued
FROM products
WHERE Discontinued = 1
  AND UnitsInStock > 0;
  
-- Find the top 10 most expensive products that are not discontinued.
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    UnitsInStock
FROM products
WHERE Discontinued = 0
ORDER BY UnitPrice DESC
LIMIT 10;

-- Display customer names along with the number of distinct countries they belong to. 
SELECT
    CompanyName,
    Country,
    (
        SELECT COUNT(DISTINCT Country)
        FROM customers
    ) AS TotalDistinctCountries
FROM customers;

-- Find employees who were hired after 1992 and are older than 50 years (based on birthdate). 
SELECT
    CompanyName,
    (
        SELECT COUNT(DISTINCT Country)
        FROM customers
    ) AS DistinctCountryCount
FROM customers;

-- Show orders that were shipped after the required date. 
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    RequiredDate,
    ShippedDate
FROM orders
WHERE ShippedDate > RequiredDate;

-- Find the total number of orders placed in each quarter of 1996. 
SELECT
    QUARTER(OrderDate) AS Quarter,
    COUNT(*) AS TotalOrders
FROM orders
WHERE YEAR(OrderDate) = 1996
GROUP BY QUARTER(OrderDate)
ORDER BY Quarter;

-- Show the average freight cost per shipper for orders shipped to Germany. 
SELECT
    s.ShipperID,
    s.CompanyName AS ShipperName,
    AVG(o.Freight) AS AverageFreight
FROM shippers s
JOIN orders o
    ON s.ShipperID = o.ShipVia
WHERE o.ShipCountry = 'Germany'
GROUP BY
    s.ShipperID,
    s.CompanyName
ORDER BY AverageFreight DESC;

-- Find customers who have placed orders in all four years (1996, 1997, 1998). 
SELECT
    c.CustomerID,
    c.CompanyName
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) IN (1996, 1997, 1998)
GROUP BY
    c.CustomerID,
    c.CompanyName
HAVING COUNT(DISTINCT YEAR(o.OrderDate)) = 3;

-- Display product names that contain both 'ch' and 'ee' in their name. 
SELECT
    ProductID,
    ProductName
FROM products
WHERE ProductName LIKE '%ch%'
  AND ProductName LIKE '%ee%';
  
-- Show the total revenue generated from each category in 1997. 
SELECT
    c.CategoryID,
    c.CategoryName,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),
        2
    ) AS TotalRevenue
FROM categories c
JOIN products p
    ON c.CategoryID = p.CategoryID
JOIN order_details od
    ON p.ProductID = od.ProductID
JOIN orders o
    ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY TotalRevenue DESC;

-- Find the employee who handled the highest number of orders in 1996. 
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    COUNT(o.OrderID) AS TotalOrders
FROM employees e
JOIN orders o
    ON e.EmployeeID = o.EmployeeID
WHERE YEAR(o.OrderDate) = 1996
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY TotalOrders DESC
LIMIT 1;

-- Show all orders where freight is higher than the average freight of all orders. 
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    Freight
FROM orders
WHERE Freight > (
    SELECT AVG(Freight)
    FROM orders
)
ORDER BY Freight DESC;

-- Find products that have never been ordered by customers from France. 
SELECT
    p.ProductID,
    p.ProductName
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_details od
    JOIN orders o
        ON od.OrderID = o.OrderID
    JOIN customers c
        ON o.CustomerID = c.CustomerID
    WHERE od.ProductID = p.ProductID
      AND c.Country = 'France'
);

-- Display the top 5 customers by total spending in the year 1997. 
SELECT
    c.CustomerID,
    c.CompanyName,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),
        2
    ) AS TotalSpending
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
JOIN order_details od
    ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY
    c.CustomerID,
    c.CompanyName
ORDER BY TotalSpending DESC
LIMIT 5;

-- Show the difference between order date and shipped date for all orders (in days). 
SELECT
    OrderID,
    OrderDate,
    ShippedDate,
    DATEDIFF(ShippedDate, OrderDate) AS DaysToShip
FROM orders
ORDER BY OrderID;

-- Find customers who placed more than 20 orders but have never ordered 'Chai'. 
SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
GROUP BY
    c.CustomerID,
    c.CompanyName
HAVING COUNT(DISTINCT o.OrderID) > 20
   AND c.CustomerID NOT IN (
       SELECT DISTINCT o2.CustomerID
       FROM orders o2
       JOIN order_details od
           ON o2.OrderID = od.OrderID
       JOIN products p
           ON od.ProductID = p.ProductID
       WHERE p.ProductName = 'Chai'
   );
   
-- Show the ranking of products based on total units sold across all orders. 
SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalUnitsSold,
    RANK() OVER (
        ORDER BY SUM(od.Quantity) DESC
    ) AS ProductRank
FROM products p
JOIN order_details od
    ON p.ProductID = od.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY ProductRank;

-- Find the second highest selling product in each category. 
WITH ProductSales AS (
    SELECT
        c.CategoryID,
        c.CategoryName,
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity) AS TotalUnitsSold
    FROM categories c
    JOIN products p
        ON c.CategoryID = p.CategoryID
    JOIN order_details od
        ON p.ProductID = od.ProductID
    GROUP BY
        c.CategoryID,
        c.CategoryName,
        p.ProductID,
        p.ProductName
),
RankedProducts AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY CategoryID
            ORDER BY TotalUnitsSold DESC
        ) AS SalesRank
    FROM ProductSales
)
SELECT
    CategoryID,
    CategoryName,
    ProductID,
    ProductName,
    TotalUnitsSold
FROM RankedProducts
WHERE SalesRank = 2
ORDER BY CategoryID;

-- Show employees and their manager's name (use self join). 
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    m.EmployeeID AS ManagerID,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
FROM employees e
LEFT JOIN employees m
    ON e.ReportsTo = m.EmployeeID
ORDER BY e.EmployeeID;

-- Display the running total of freight cost per customer ordered by order date. 
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    Freight,
    SUM(Freight) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate, OrderID
    ) AS RunningFreightTotal
FROM orders
ORDER BY CustomerID, OrderDate, OrderID;

-- Find orders that were placed on the last day of any month. 
SELECT
    OrderID,
    CustomerID,
    OrderDate
FROM orders
WHERE OrderDate = LAST_DAY(OrderDate)
ORDER BY OrderDate;

-- Show the percentage contribution of each shipper in total freight charges. 
SELECT
    s.ShipperID,
    s.CompanyName AS ShipperName,
    ROUND(SUM(o.Freight), 2) AS TotalFreight,
    ROUND(
        100.0 * SUM(o.Freight) /
        (SELECT SUM(Freight) FROM orders),
        2
    ) AS FreightContributionPercent
FROM shippers s
JOIN orders o
    ON s.ShipperID = o.ShipVia
GROUP BY
    s.ShipperID,
    s.CompanyName
ORDER BY FreightContributionPercent DESC;

-- Find products whose price is higher than the average price of all products in their category. 
SELECT
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    p.UnitPrice
FROM products p
WHERE p.UnitPrice > (
    SELECT AVG(p2.UnitPrice)
    FROM products p2
    WHERE p2.CategoryID = p.CategoryID
)
ORDER BY p.CategoryID, p.UnitPrice DESC;

-- Display the number of orders placed on weekends vs weekdays. 
SELECT
    CASE
        WHEN DAYOFWEEK(OrderDate) IN (1, 7)
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    COUNT(*) AS TotalOrders
FROM orders
GROUP BY DayType;

-- Show customers who have the same city as their ship address in at least 3 orders. 
SELECT
    c.CustomerID,
    c.CompanyName,
    c.City AS CustomerCity,
    COUNT(*) AS MatchingOrders
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
WHERE c.City = o.ShipCity
GROUP BY
    c.CustomerID,
    c.CompanyName,
    c.City
HAVING COUNT(*) >= 3
ORDER BY MatchingOrders DESC;

-- Find the month with the highest average order value in 1997. 
WITH OrderValues AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS OrderValue
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 1997
    GROUP BY
        o.OrderID,
        o.OrderDate
)
SELECT
    MONTH(OrderDate) AS OrderMonth,
    ROUND(AVG(OrderValue), 2) AS AvgOrderValue
FROM OrderValues
GROUP BY MONTH(OrderDate)
ORDER BY AvgOrderValue DESC
LIMIT 1;

-- Show the top 3 employees by revenue generated through their orders. 
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)),
        2
    ) AS TotalRevenue
FROM employees e
JOIN orders o
    ON e.EmployeeID = o.EmployeeID
JOIN order_details od
    ON o.OrderID = od.OrderID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY TotalRevenue DESC
LIMIT 3;

-- Find all products that were supplied by suppliers from the same country as the customer. 
SELECT DISTINCT
    c.CustomerID,
    c.CompanyName AS CustomerName,
    c.Country AS CustomerCountry,
    p.ProductID,
    p.ProductName,
    s.SupplierID,
    s.CompanyName AS SupplierName,
    s.Country AS SupplierCountry
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
JOIN order_details od
    ON o.OrderID = od.OrderID
JOIN products p
    ON od.ProductID = p.ProductID
JOIN suppliers s
    ON p.SupplierID = s.SupplierID
WHERE c.Country = s.Country
ORDER BY c.Country, c.CompanyName, p.ProductName;

-- Display the growth percentage in sales month-over-month for the year 1997. 
WITH MonthlySales AS (
    SELECT
        MONTH(o.OrderDate) AS OrderMonth,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS TotalSales
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 1997
    GROUP BY MONTH(o.OrderDate)
)
SELECT
    OrderMonth,
    ROUND(TotalSales, 2) AS TotalSales,
    ROUND(
        LAG(TotalSales) OVER (ORDER BY OrderMonth),
        2
    ) AS PreviousMonthSales,
    ROUND(
        (
            (TotalSales - LAG(TotalSales) OVER (ORDER BY OrderMonth))
            / LAG(TotalSales) OVER (ORDER BY OrderMonth)
        ) * 100,
        2
    ) AS GrowthPercentage
FROM MonthlySales
ORDER BY OrderMonth;

-- Show orders where the freight cost is more than 10% of the total order value. 
WITH OrderTotals AS (
    SELECT
        o.OrderID,
        o.CustomerID,
        o.Freight,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS OrderValue
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.OrderID,
        o.CustomerID,
        o.Freight
)
SELECT
    OrderID,
    CustomerID,
    ROUND(OrderValue, 2) AS OrderValue,
    Freight,
    ROUND((Freight / OrderValue) * 100, 2) AS FreightPercentage
FROM OrderTotals
WHERE Freight > (OrderValue * 0.10)
ORDER BY FreightPercentage DESC;

-- Find the customer with the highest number of unique products purchased. 
SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(DISTINCT od.ProductID) AS UniqueProductsPurchased
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
JOIN order_details od
    ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName
ORDER BY UniqueProductsPurchased DESC
LIMIT 1;

-- Show the list of employees who report to the same manager. 
SELECT
    m.EmployeeID AS ManagerID,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName
FROM employees e
JOIN employees m
    ON e.ReportsTo = m.EmployeeID
ORDER BY m.EmployeeID, e.EmployeeID;

-- Find categories where the average unit price is higher than the overall average. 
SELECT
    c.CategoryID,
    c.CategoryName,
    ROUND(AVG(p.UnitPrice), 2) AS AvgCategoryPrice
FROM categories c
JOIN products p
    ON c.CategoryID = p.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
HAVING AVG(p.UnitPrice) > (
    SELECT AVG(UnitPrice)
    FROM products
)
ORDER BY AvgCategoryPrice DESC;

-- Display the cumulative profit (assuming 30% margin) per customer. 
WITH CustomerOrders AS (
    SELECT
        o.CustomerID,
        c.CompanyName,
        o.OrderID,
        o.OrderDate,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS OrderRevenue
    FROM orders o
    JOIN customers c
        ON o.CustomerID = c.CustomerID
    JOIN order_details od
        ON o.OrderID = od.OrderID
    GROUP BY
        o.CustomerID,
        c.CompanyName,
        o.OrderID,
        o.OrderDate
)
SELECT
    CustomerID,
    CompanyName,
    OrderID,
    OrderDate,
    ROUND(OrderRevenue * 0.30, 2) AS OrderProfit,
    ROUND(
        SUM(OrderRevenue * 0.30) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate, OrderID
        ),
        2
    ) AS CumulativeProfit
FROM CustomerOrders
ORDER BY
    CustomerID,
    OrderDate,
    OrderID;
    
-- Show products that have been ordered by more than 50 different customers. 
SELECT
    p.ProductID,
    p.ProductName,
    COUNT(DISTINCT o.CustomerID) AS CustomerCount
FROM products p
JOIN order_details od
    ON p.ProductID = od.ProductID
JOIN orders o
    ON od.OrderID = o.OrderID
GROUP BY
    p.ProductID,
    p.ProductName
HAVING COUNT(DISTINCT o.CustomerID) > 50
ORDER BY CustomerCount DESC;

-- Find the most frequently ordered product in each region (based on ship country). 
WITH ProductSalesByCountry AS (
    SELECT
        o.ShipCountry,
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity) AS TotalQuantityOrdered
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    JOIN products p
        ON od.ProductID = p.ProductID
    GROUP BY
        o.ShipCountry,
        p.ProductID,
        p.ProductName
),
RankedProducts AS (
    SELECT
        ShipCountry,
        ProductID,
        ProductName,
        TotalQuantityOrdered,
        RANK() OVER (
            PARTITION BY ShipCountry
            ORDER BY TotalQuantityOrdered DESC
        ) AS ProductRank
    FROM ProductSalesByCountry
)
SELECT
    ShipCountry,
    ProductID,
    ProductName,
    TotalQuantityOrdered
FROM RankedProducts
WHERE ProductRank = 1
ORDER BY ShipCountry;

-- Show the rank of each order based on freight cost within its ship country. 
SELECT
    OrderID,
    ShipCountry,
    Freight,
    RANK() OVER (
        PARTITION BY ShipCountry
        ORDER BY Freight DESC
    ) AS FreightRank
FROM orders
ORDER BY ShipCountry, FreightRank;

-- Find customers who placed orders in January but not in December of the same year. 
SELECT DISTINCT
    c.CustomerID,
    c.CompanyName,
    YEAR(o.OrderDate) AS OrderYear
FROM customers c
JOIN orders o
    ON c.CustomerID = o.CustomerID
WHERE MONTH(o.OrderDate) = 1
AND NOT EXISTS (
    SELECT 1
    FROM orders o2
    WHERE o2.CustomerID = c.CustomerID
      AND YEAR(o2.OrderDate) = YEAR(o.OrderDate)
      AND MONTH(o2.OrderDate) = 12
)
ORDER BY OrderYear, c.CompanyName;

-- Display the total discount given per category. 
SELECT
    c.CategoryID,
    c.CategoryName,
    ROUND(
        SUM(
            od.UnitPrice * od.Quantity * od.Discount
        ),
        2
    ) AS TotalDiscountGiven
FROM categories c
JOIN products p
    ON c.CategoryID = p.CategoryID
JOIN order_details od
    ON p.ProductID = od.ProductID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY TotalDiscountGiven DESC;

-- Show the top 5 cities with highest number of orders but lowest average freight. 
SELECT
    ShipCity,
    COUNT(*) AS TotalOrders,
    AVG(Freight) AS AvgFreight
FROM orders
GROUP BY ShipCity
ORDER BY TotalOrders DESC, AvgFreight ASC
LIMIT 5;

-- Find orders that were delayed by more than 10 days. 
SELECT
    OrderID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    DATEDIFF(ShippedDate, RequiredDate) AS DelayDays
FROM orders
WHERE DATEDIFF(ShippedDate, RequiredDate) > 10;

-- Show the percentage of orders shipped by each shipper per year. 
SELECT
    YEAR(OrderDate) AS OrderYear,
    s.CompanyName,
    COUNT(*) AS OrdersHandled,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(PARTITION BY YEAR(OrderDate)),
        2
    ) AS PercentageOrders
FROM orders o
JOIN shippers s
ON o.ShipVia = s.ShipperID
GROUP BY YEAR(OrderDate), s.CompanyName;

-- Find employees who have not handled any order in 1998. 
SELECT
    EmployeeID,
    FirstName,
    LastName
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.EmployeeID = e.EmployeeID
      AND YEAR(o.OrderDate) = 1998
);

-- Display products that were reordered (units on order > 0) but are discontinued. 
SELECT
    ProductID,
    ProductName,
    UnitsOnOrder,
    Discontinued
FROM products
WHERE UnitsOnOrder > 0
  AND Discontinued = 1;
  
-- Show the average time gap between consecutive orders for each customer. 
WITH OrderGap AS (
    SELECT
        CustomerID,
        OrderDate,
        LAG(OrderDate) OVER(
            PARTITION BY CustomerID
            ORDER BY OrderDate
        ) AS PrevOrderDate
    FROM orders
)
SELECT
    CustomerID,
    AVG(DATEDIFF(OrderDate, PrevOrderDate)) AS AvgGapDays
FROM OrderGap
WHERE PrevOrderDate IS NOT NULL
GROUP BY CustomerID;

-- Find the product with the highest variance in unit price across different orders. 
SELECT
    p.ProductID,
    p.ProductName,
    VARIANCE(od.UnitPrice) AS PriceVariance
FROM order_details od
JOIN products p
ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY PriceVariance DESC
LIMIT 1;

-- Show a list of customers who only buy from one category. 
SELECT
    c.CustomerID,
    c.CompanyName
FROM customers c
JOIN orders o
ON c.CustomerID = o.CustomerID
JOIN order_details od
ON o.OrderID = od.OrderID
JOIN products p
ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CompanyName
HAVING COUNT(DISTINCT p.CategoryID) = 1;

-- Display the top 10 orders with highest (freight / order value) ratio. 
SELECT
    o.OrderID,
    o.Freight,
    SUM(od.UnitPrice * od.Quantity *
       (1 - od.Discount)) AS OrderValue,
    o.Freight /
    SUM(od.UnitPrice * od.Quantity *
       (1 - od.Discount)) AS FreightRatio
FROM orders o
JOIN order_details od
ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.Freight
ORDER BY FreightRatio DESC
LIMIT 10;

-- Find how many customers have placed orders worth more than $10,000 in total. 
SELECT COUNT(*) AS CustomersAbove10000
FROM (
    SELECT
        o.CustomerID,
        SUM(
            od.UnitPrice * od.Quantity *
            (1 - od.Discount)
        ) AS TotalSpent
    FROM orders o
    JOIN order_details od
    ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
    HAVING TotalSpent > 10000
) x;

-- Show the distribution of order values in 4 buckets (0-500, 501-2000, etc.). 
WITH OrderValue AS (
    SELECT
        o.OrderID,
        SUM(
            od.UnitPrice * od.Quantity *
            (1 - od.Discount)
        ) AS TotalValue
    FROM orders o
    JOIN order_details od
    ON o.OrderID = od.OrderID
    GROUP BY o.OrderID
)
SELECT
CASE
    WHEN TotalValue BETWEEN 0 AND 500 THEN '0-500'
    WHEN TotalValue BETWEEN 501 AND 2000 THEN '501-2000'
    WHEN TotalValue BETWEEN 2001 AND 5000 THEN '2001-5000'
    ELSE '5001+'
END AS Bucket,
COUNT(*) AS OrdersCount
FROM OrderValue
GROUP BY Bucket;

-- Find suppliers who supply more than 5 products that are currently in stock. 
SELECT
    s.SupplierID,
    s.CompanyName,
    COUNT(*) AS ProductsInStock
FROM suppliers s
JOIN products p
ON s.SupplierID = p.SupplierID
WHERE p.UnitsInStock > 0
GROUP BY s.SupplierID, s.CompanyName
HAVING COUNT(*) > 5;

-- Show the month-wise comparison of total sales between 1996 and 1997. 
SELECT
    MONTH(o.OrderDate) AS MonthNo,
    SUM(CASE
        WHEN YEAR(o.OrderDate)=1996
        THEN od.UnitPrice*od.Quantity*(1-od.Discount)
        ELSE 0
    END) AS Sales1996,
    SUM(CASE
        WHEN YEAR(o.OrderDate)=1997
        THEN od.UnitPrice*od.Quantity*(1-od.Discount)
        ELSE 0
    END) AS Sales1997
FROM orders o
JOIN order_details od
ON o.OrderID = od.OrderID
GROUP BY MONTH(o.OrderDate)
ORDER BY MonthNo;

-- Display customers who have increased their spending from 1996 to 1997. 
WITH CustomerSales AS (
    SELECT
        o.CustomerID,
        YEAR(o.OrderDate) AS SalesYear,
        SUM(
            od.UnitPrice * od.Quantity *
            (1 - od.Discount)
        ) AS Revenue
    FROM orders o
    JOIN order_details od
    ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID, YEAR(o.OrderDate)
)
SELECT
    s96.CustomerID
FROM CustomerSales s96
JOIN CustomerSales s97
ON s96.CustomerID = s97.CustomerID
WHERE s96.SalesYear = 1996
  AND s97.SalesYear = 1997
  AND s97.Revenue > s96.Revenue;
  
-- Find the least profitable category after deducting 15% handling cost. 
SELECT
    c.CategoryName,
    SUM(
        od.UnitPrice * od.Quantity *
        (1 - od.Discount)
    ) * 0.85 AS NetProfit
FROM categories c
JOIN products p
ON c.CategoryID = p.CategoryID
JOIN order_details od
ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY NetProfit ASC
LIMIT 1;

-- Show the running total of quantity sold for each product. 
SELECT
    p.ProductID,
    p.ProductName,
    o.OrderDate,
    od.Quantity,
    SUM(od.Quantity) OVER(
        PARTITION BY p.ProductID
        ORDER BY o.OrderDate
    ) AS RunningTotal
FROM order_details od
JOIN orders o
ON od.OrderID = o.OrderID
JOIN products p
ON od.ProductID = p.ProductID;

-- Find orders where multiple products from the same category were purchased. 
SELECT DISTINCT
    od.OrderID,
    p.CategoryID
FROM order_details od
JOIN products p
ON od.ProductID = p.ProductID
GROUP BY od.OrderID, p.CategoryID
HAVING COUNT(DISTINCT p.ProductID) > 1;

-- Display the top 5 products with highest profit margin per unit. 
SELECT
    p.ProductID,
    p.ProductName,
    AVG(od.UnitPrice - p.UnitPrice) AS ProfitMargin
FROM products p
JOIN order_details od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY ProfitMargin DESC
LIMIT 5;

-- Show employees who handled orders from more than 10 different countries. 
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(DISTINCT o.ShipCountry) AS CountriesServed
FROM employees e
JOIN orders o
ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID,
         e.FirstName,
         e.LastName
HAVING COUNT(DISTINCT o.ShipCountry) > 10;

-- Find the correlation trend between discount and quantity ordered. 
SELECT
    Discount,
    AVG(Quantity) AS AvgQuantity
FROM order_details
GROUP BY Discount
ORDER BY Discount;

-- Show customers who have never ordered from 'Beverages' category. 
SELECT
    c.CustomerID,
    c.CompanyName
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    JOIN products p
        ON od.ProductID = p.ProductID
    JOIN categories cat
        ON p.CategoryID = cat.CategoryID
    WHERE o.CustomerID = c.CustomerID
      AND cat.CategoryName = 'Beverages'
);



-- Display the 3rd highest order value for each customer. 
WITH CustomerOrders AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) AS OrderValue,
        DENSE_RANK() OVER(
            PARTITION BY o.CustomerID
            ORDER BY SUM(od.UnitPrice * od.Quantity * (1-od.Discount)) DESC
        ) AS rn
    FROM orders o
    JOIN order_details od
        ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID, o.OrderID
)
SELECT *
FROM CustomerOrders
WHERE rn = 3;

-- Find the average number of days between order placement and shipping per shipper. 
SELECT
    s.ShipperID,
    s.CompanyName,
    ROUND(AVG(DATEDIFF(o.ShippedDate,o.OrderDate)),2) AS AvgShippingDays
FROM orders o
JOIN shippers s
    ON o.ShipVia = s.ShipperID
WHERE o.ShippedDate IS NOT NULL
GROUP BY s.ShipperID,s.CompanyName;

-- Show products that were ordered in every quarter of 1997. 
SELECT
    p.ProductID,
    p.ProductName
FROM products p
JOIN order_details od
    ON p.ProductID = od.ProductID
JOIN orders o
    ON od.OrderID = o.OrderID
WHERE YEAR(o.OrderDate)=1997
GROUP BY p.ProductID,p.ProductName
HAVING COUNT(DISTINCT QUARTER(o.OrderDate)) = 4;

-- Find the customer with the most consistent order value (lowest variance). 
WITH OrderValues AS (
    SELECT
        o.CustomerID,
        o.OrderID,
        SUM(od.UnitPrice*od.Quantity*(1-od.Discount)) AS OrderValue
    FROM orders o
    JOIN order_details od
        ON o.OrderID=od.OrderID
    GROUP BY o.CustomerID,o.OrderID
)
SELECT
    c.CustomerID,
    c.CompanyName,
    VARIANCE(OrderValue) AS OrderVariance
FROM OrderValues ov
JOIN customers c
    ON ov.CustomerID=c.CustomerID
GROUP BY c.CustomerID,c.CompanyName
ORDER BY OrderVariance
LIMIT 1;


-- Display year-wise total orders handled by each employee. 
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName,' ',e.LastName) AS EmployeeName,
    YEAR(o.OrderDate) AS OrderYear,
    COUNT(*) AS TotalOrders
FROM employees e
JOIN orders o
    ON e.EmployeeID=o.EmployeeID
GROUP BY e.EmployeeID,EmployeeName,YEAR(o.OrderDate)
ORDER BY EmployeeName,OrderYear;

-- Show the percentage of loss-making orders (negative profit not applicable here, but delayed orders). 
SELECT
ROUND(
100.0 *
SUM(
CASE
WHEN ShippedDate > RequiredDate
THEN 1
ELSE 0
END
)
/
COUNT(*),
2
) AS DelayedOrderPercent
FROM orders;

-- Find the most popular product combination (ordered together) using self join on order_details. 
SELECT
    p1.ProductName AS ProductA,
    p2.ProductName AS ProductB,
    COUNT(*) AS TimesBoughtTogether
FROM order_details od1
JOIN order_details od2
    ON od1.OrderID = od2.OrderID
   AND od1.ProductID < od2.ProductID
JOIN products p1
    ON od1.ProductID = p1.ProductID
JOIN products p2
    ON od2.ProductID = p2.ProductID
GROUP BY ProductA,ProductB
ORDER BY TimesBoughtTogether DESC
LIMIT 1;

-- Show the top 10 longest gaps between two consecutive orders for any customer. 
WITH OrderGap AS (
SELECT
    CustomerID,
    OrderDate,
    LAG(OrderDate) OVER(
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS PrevOrder
FROM orders
)
SELECT
    CustomerID,
    PrevOrder,
    OrderDate,
    DATEDIFF(OrderDate,PrevOrder) AS GapDays
FROM OrderGap
WHERE PrevOrder IS NOT NULL
ORDER BY GapDays DESC
LIMIT 10;

-- Display categories with more than 10 products that have zero units on order. 
SELECT
    c.CategoryID,
    c.CategoryName,
    COUNT(*) AS ProductCount
FROM categories c
JOIN products p
    ON c.CategoryID=p.CategoryID
WHERE p.UnitsOnOrder = 0
GROUP BY c.CategoryID,c.CategoryName
HAVING COUNT(*) > 10;

-- Find how many orders were shipped late by more than 7 days in each region. 
SELECT
    ShipRegion,
    COUNT(*) AS LateOrders
FROM orders
WHERE DATEDIFF(ShippedDate,RequiredDate) > 7
GROUP BY ShipRegion;

-- Show the contribution of each employee to total company revenue. 
WITH EmployeeRevenue AS (
SELECT
    e.EmployeeID,
    CONCAT(e.FirstName,' ',e.LastName) AS EmployeeName,
    SUM(
        od.UnitPrice * od.Quantity *
        (1-od.Discount)
    ) AS Revenue
FROM employees e
JOIN orders o
    ON e.EmployeeID=o.EmployeeID
JOIN order_details od
    ON o.OrderID=od.OrderID
GROUP BY e.EmployeeID,EmployeeName
)
SELECT *,
ROUND(
Revenue*100.0/
SUM(Revenue) OVER(),
2
) AS RevenuePercent
FROM EmployeeRevenue;

-- Find products whose name starts with a vowel and have been ordered more than 30 times. 
SELECT
    p.ProductID,
    p.ProductName,
    COUNT(*) AS TimesOrdered
FROM products p
JOIN order_details od
    ON p.ProductID=od.ProductID
WHERE LEFT(UPPER(p.ProductName),1)
IN ('A','E','I','O','U')
GROUP BY p.ProductID,p.ProductName
HAVING COUNT(*) > 30;

-- Display the rank of shippers based on on-time delivery percentage. 
WITH ShipperStats AS (
SELECT
    s.CompanyName,
    ROUND(
        100.0 *
        SUM(
            CASE
            WHEN ShippedDate <= RequiredDate
            THEN 1
            ELSE 0
            END
        )
        / COUNT(*),
    2) AS OnTimePercent
FROM shippers s
JOIN orders o
    ON s.ShipperID=o.ShipVia
GROUP BY s.CompanyName
)
SELECT *,
RANK() OVER(
ORDER BY OnTimePercent DESC
) AS ShipperRank
FROM ShipperStats;

-- Show customers who placed orders on the same day they were born (month and day). 
SELECT DISTINCT
    c.CustomerID,
    c.CompanyName,
    e.FirstName,
    e.LastName
FROM orders o
JOIN customers c
    ON o.CustomerID=c.CustomerID
JOIN employees e
    ON o.EmployeeID=e.EmployeeID
WHERE MONTH(o.OrderDate)=MONTH(e.BirthDate)
AND DAY(o.OrderDate)=DAY(e.BirthDate);

-- Find the total revenue generated by each territory (if territories loaded). 
SELECT
    TerritoryID,
    SUM(
        od.UnitPrice*od.Quantity*
        (1-od.Discount)
    ) AS Revenue
FROM orders o
JOIN order_details od
    ON o.OrderID=od.OrderID
GROUP BY TerritoryID;

-- Show the difference in average order value between weekdays and weekends. 
WITH OrderValue AS (
SELECT
    o.OrderID,
    o.OrderDate,
    SUM(
        od.UnitPrice*od.Quantity*
        (1-od.Discount)
    ) AS Value
FROM orders o
JOIN order_details od
    ON o.OrderID=od.OrderID
GROUP BY o.OrderID,o.OrderDate
)
SELECT
CASE
WHEN DAYOFWEEK(OrderDate)
IN (1,7)
THEN 'Weekend'
ELSE 'Weekday'
END AS DayType,
AVG(Value) AS AvgOrderValue
FROM OrderValue
GROUP BY DayType;

-- Find the top 5 products that contribute to more than 50% of a category’s revenue. 
WITH ProductRevenue AS (
SELECT
    p.CategoryID,
    p.ProductID,
    p.ProductName,
    SUM(
        od.UnitPrice*od.Quantity*
        (1-od.Discount)
    ) AS Revenue
FROM products p
JOIN order_details od
    ON p.ProductID=od.ProductID
GROUP BY p.CategoryID,p.ProductID,p.ProductName
),
CategoryRevenue AS (
SELECT
    CategoryID,
    SUM(Revenue) AS CatRevenue
FROM ProductRevenue
GROUP BY CategoryID
)
SELECT
    pr.*,
    ROUND(
        pr.Revenue*100.0/cr.CatRevenue,
        2
    ) AS RevenuePercent
FROM ProductRevenue pr
JOIN CategoryRevenue cr
    ON pr.CategoryID=cr.CategoryID
WHERE pr.Revenue > cr.CatRevenue*0.50
ORDER BY Revenue DESC
LIMIT 5;

-- Display orders where the customer and shipper are from the same country. 
SELECT
    o.OrderID,
    c.CompanyName,
    c.Country AS CustomerCountry,
    o.ShipCountry
FROM orders o
JOIN customers c
    ON o.CustomerID=c.CustomerID
WHERE c.Country = o.ShipCountry;

-- Show the growth rate of new customers acquired each year. 
WITH FirstOrder AS (
SELECT
    CustomerID,
    MIN(OrderDate) AS FirstOrderDate
FROM orders
GROUP BY CustomerID
),
YearlyCustomers AS (
SELECT
    YEAR(FirstOrderDate) AS Yr,
    COUNT(*) AS NewCustomers
FROM FirstOrder
GROUP BY YEAR(FirstOrderDate)
)
SELECT
    Yr,
    NewCustomers,
    ROUND(
        (
        NewCustomers -
        LAG(NewCustomers) OVER(ORDER BY Yr)
        )
        *100.0/
        LAG(NewCustomers) OVER(ORDER BY Yr),
    2
    ) AS GrowthRatePercent
FROM YearlyCustomers;


-- Find products that have the highest number of returns (assuming high discount = return proxy). 
SELECT
    p.ProductID,
    p.ProductName,
    COUNT(*) AS ReturnLikeOrders
FROM products p
JOIN order_details od
    ON p.ProductID = od.ProductID
WHERE od.Discount >= 0.20
GROUP BY p.ProductID,p.ProductName
ORDER BY ReturnLikeOrders DESC;

-- Display a summary of average, min, and max order value per segment. 
SELECT
    p.ProductID,
    p.ProductName,
    COUNT(*) AS ReturnLikeOrders
FROM products p
JOIN order_details od
    ON p.ProductID = od.ProductID
WHERE od.Discount >= 0.20
GROUP BY p.ProductID,p.ProductName
ORDER BY ReturnLikeOrders DESC;

-- Show employees who joined before 1993 and have handled more than 100 orders. 
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(o.OrderID) AS OrdersHandled
FROM employees e
JOIN orders o
    ON e.EmployeeID=o.EmployeeID
WHERE e.HireDate < '1993-01-01'
GROUP BY e.EmployeeID,e.FirstName,e.LastName
HAVING COUNT(o.OrderID) > 100;

-- Find the most delayed order (in days) and the customer associated with it. 
SELECT
    o.OrderID,
    c.CustomerID,
    c.CompanyName,
    DATEDIFF(
        o.ShippedDate,
        o.RequiredDate
    ) AS DelayDays
FROM orders o
JOIN customers c
    ON o.CustomerID=c.CustomerID
ORDER BY DelayDays DESC
LIMIT 1;

-- Show percentage of orders that were shipped within 3 days. 
SELECT
ROUND(
100.0 *
SUM(
CASE
WHEN DATEDIFF(
ShippedDate,
OrderDate
) <= 3
THEN 1
ELSE 0
END
)
/
COUNT(*),
2
) AS PercentageWithin3Days
FROM orders
WHERE ShippedDate IS NOT NULL;


-- Display the top 10 customers with highest lifetime value. 
SELECT
    c.CustomerID,
    c.CompanyName,
    SUM(
        od.UnitPrice *
        od.Quantity *
        (1-od.Discount)
    ) AS LifetimeValue
FROM customers c
JOIN orders o
    ON c.CustomerID=o.CustomerID
JOIN order_details od
    ON o.OrderID=od.OrderID
GROUP BY c.CustomerID,c.CompanyName
ORDER BY LifetimeValue DESC
LIMIT 10;

-- Find categories where average discount is higher than overall average discount. 
SELECT
    c.CategoryName,
    AVG(od.Discount) AS AvgDiscount
FROM categories c
JOIN products p
    ON c.CategoryID=p.CategoryID
JOIN order_details od
    ON p.ProductID=od.ProductID
GROUP BY c.CategoryName
HAVING AVG(od.Discount) >
(
SELECT AVG(Discount)
FROM order_details
);

-- Show how many unique suppliers are used per category. 
SELECT
    c.CategoryName,
    COUNT(
        DISTINCT p.SupplierID
    ) AS UniqueSuppliers
FROM categories c
JOIN products p
    ON c.CategoryID=p.CategoryID
GROUP BY c.CategoryName;

-- Find the customer who has the highest ratio of distinct products to total orders. 
WITH CustomerStats AS (
SELECT
    o.CustomerID,
    COUNT(DISTINCT od.ProductID) AS Products,
    COUNT(DISTINCT o.OrderID) AS OrdersCount
FROM orders o
JOIN order_details od
    ON o.OrderID=od.OrderID
GROUP BY o.CustomerID
)
SELECT *,
ROUND(
Products*1.0/OrdersCount,
2
) AS ProductOrderRatio
FROM CustomerStats
ORDER BY ProductOrderRatio DESC
LIMIT 1;

-- Display the trend of average freight cost over the years. 
SELECT
    YEAR(OrderDate) AS OrderYear,
    ROUND(
        AVG(Freight),
        2
    ) AS AvgFreight
FROM orders
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

-- Show products that were never discontinued but have very low stock. 
SELECT
    ProductID,
    ProductName,
    UnitsInStock
FROM products
WHERE Discontinued = 0
AND UnitsInStock < ReorderLevel;

-- Find the busiest shipping day of the week. 
SELECT
    DAYNAME(ShippedDate) AS DayName,
    COUNT(*) AS OrdersShipped
FROM orders
WHERE ShippedDate IS NOT NULL
GROUP BY DAYNAME(ShippedDate)
ORDER BY OrdersShipped DESC
LIMIT 1;

-- Display the top 5 most valuable (high monetary) inactive customers (no order in 1998). 
WITH CustomerRevenue AS (
SELECT
    o.CustomerID,
    SUM(
        od.UnitPrice *
        od.Quantity *
        (1-od.Discount)
    ) AS Revenue
FROM orders o
JOIN order_details od
    ON o.OrderID=od.OrderID
GROUP BY o.CustomerID
)
SELECT
    c.CustomerID,
    c.CompanyName,
    cr.Revenue
FROM customers c
JOIN CustomerRevenue cr
    ON c.CustomerID=cr.CustomerID
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM orders
    WHERE YEAR(OrderDate)=1998
)
ORDER BY cr.Revenue DESC
LIMIT 5;

-- Show the impact of employee on order freight cost (average per employee). 
SELECT
    e.EmployeeID,
    CONCAT(
        e.FirstName,' ',
        e.LastName
    ) AS EmployeeName,
    ROUND(
        AVG(o.Freight),
        2
    ) AS AvgFreight
FROM employees e
JOIN orders o
    ON e.EmployeeID=o.EmployeeID
GROUP BY e.EmployeeID,EmployeeName
ORDER BY AvgFreight DESC;

-- Find duplicate company names in customers and suppliers combined. 
SELECT
    CompanyName,
    COUNT(*) AS Occurrences
FROM (
    SELECT CompanyName
    FROM customers

    UNION ALL

    SELECT CompanyName
    FROM suppliers
) x
GROUP BY CompanyName
HAVING COUNT(*) > 1;

-- Display the total sales value handled by each employee per quarter. 
SELECT
    e.EmployeeID,
    CONCAT(
        e.FirstName,' ',
        e.LastName
    ) AS EmployeeName,
    YEAR(o.OrderDate) AS Yr,
    QUARTER(o.OrderDate) AS Qtr,
    SUM(
        od.UnitPrice *
        od.Quantity *
        (1-od.Discount)
    ) AS Revenue
FROM employees e
JOIN orders o
    ON e.EmployeeID=o.EmployeeID
JOIN order_details od
    ON o.OrderID=od.OrderID
GROUP BY
e.EmployeeID,
EmployeeName,
Yr,
Qtr
ORDER BY Yr,Qtr;

-- Show the percentage of international orders (ship country != customer country). 
SELECT
ROUND(
100.0 *
SUM(
CASE
WHEN c.Country <> o.ShipCountry
THEN 1
ELSE 0
END
)
/
COUNT(*),
2
) AS InternationalOrderPercent
FROM orders o
JOIN customers c
ON o.CustomerID=c.CustomerID;

-- Find the product with the longest time between first and last order. 
SELECT
    p.ProductID,
    p.ProductName,
    DATEDIFF(
        MAX(o.OrderDate),
        MIN(o.OrderDate)
    ) AS ProductLifeDays
FROM products p
JOIN order_details od
    ON p.ProductID=od.ProductID
JOIN orders o
    ON od.OrderID=o.OrderID
GROUP BY p.ProductID,p.ProductName
ORDER BY ProductLifeDays DESC
LIMIT 1;

-- Display customers who ordered all products from a particular category. 
SELECT
    c.CustomerID,
    c.CompanyName,
    cat.CategoryName
FROM customers c
JOIN orders o
    ON c.CustomerID=o.CustomerID
JOIN order_details od
    ON o.OrderID=od.OrderID
JOIN products p
    ON od.ProductID=p.ProductID
JOIN categories cat
    ON p.CategoryID=cat.CategoryID
GROUP BY
c.CustomerID,
c.CompanyName,
cat.CategoryID,
cat.CategoryName
HAVING COUNT(
DISTINCT p.ProductID
)
=
(
SELECT COUNT(*)
FROM products p2
WHERE p2.CategoryID=cat.CategoryID
);

-- Show the efficiency of each shipper (average shipping days). 
SELECT
    s.ShipperID,
    s.CompanyName,
    ROUND(
        AVG(
            DATEDIFF(
                o.ShippedDate,
                o.OrderDate
            )
        ),
        2
    ) AS AvgShippingDays
FROM shippers s
JOIN orders o
    ON s.ShipperID=o.ShipVia
GROUP BY
s.ShipperID,
s.CompanyName
ORDER BY AvgShippingDays;

-- Create a final ranking of all customers based on a weighted score of Recency, Frequency, and Monetary value. 
WITH RFM AS (
SELECT
    c.CustomerID,

    DATEDIFF(
        (SELECT MAX(OrderDate)
         FROM orders),
        MAX(o.OrderDate)
    ) AS Recency,

    COUNT(DISTINCT o.OrderID)
    AS Frequency,

    SUM(
        od.UnitPrice *
        od.Quantity *
        (1-od.Discount)
    ) AS Monetary

FROM customers c
JOIN orders o
    ON c.CustomerID=o.CustomerID
JOIN order_details od
    ON o.OrderID=od.OrderID

GROUP BY c.CustomerID
),

Scored AS (
SELECT *,

NTILE(5) OVER(
ORDER BY Recency ASC
) AS R,

NTILE(5) OVER(
ORDER BY Frequency DESC
) AS F,

NTILE(5) OVER(
ORDER BY Monetary DESC
) AS M

FROM RFM
)

SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,

    (R*0.30 +
     F*0.30 +
     M*0.40) AS WeightedScore,

    RANK() OVER(
        ORDER BY
        (R*0.30 +
         F*0.30 +
         M*0.40) DESC
    ) AS CustomerRank

FROM Scored;