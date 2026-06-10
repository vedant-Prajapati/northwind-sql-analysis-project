# 🗄️ Northwind SQL Database Analysis Project

## 📌 Project Overview

This project is based on the **Northwind Database**, a popular sample database used for learning and practicing SQL concepts. The dataset represents a company's sales, inventory, customers, suppliers, employees, and shipping operations.

The project demonstrates SQL skills ranging from basic queries to advanced analytical queries using multiple related tables.

---

## 📂 Project Structure

```
Northwind-SQL-Project/
│
├── Dataset/
│   ├── categories.csv
│   ├── customers.csv
│   ├── employees.csv
│   ├── order_details.csv
│   ├── orders.csv
│   ├── products.csv
│   ├── shippers.csv
│   └── suppliers.csv
│
├── SQL Scripts/
│   ├── Northwind_Project_1.sql
│   └── Northwind_Project_2.sql
│
└── README.md
```

---

## 🛠️ Technologies Used

* SQL
* MySQL Workbench
* Relational Database Management System (RDBMS)
* CSV Dataset

---

## 📊 Dataset Information

The Northwind dataset contains business information related to:

| Table Name    | Description                     |
| ------------- | ------------------------------- |
| Categories    | Product categories              |
| Customers     | Customer details                |
| Suppliers     | Supplier information            |
| Products      | Product inventory and pricing   |
| Employees     | Employee records                |
| Shippers      | Shipping companies              |
| Orders        | Customer orders                 |
| Order Details | Products included in each order |

---

## 🗃️ Database Schema

### Categories

Stores product category information.

**Columns**

* CategoryID (PK)
* CategoryName
* Description
* Picture

### Customers

Stores customer information.

**Columns**

* CustomerID (PK)
* CompanyName
* ContactName
* ContactTitle
* Address
* City
* Region
* PostalCode
* Country
* Phone
* Fax

### Suppliers

Stores supplier details.

**Columns**

* SupplierID (PK)
* CompanyName
* ContactName
* ContactTitle
* Address
* City
* Region
* PostalCode
* Country
* Phone
* Fax
* HomePage

### Products

Stores product information.

**Columns**

* ProductID (PK)
* ProductName
* SupplierID (FK)
* CategoryID (FK)
* QuantityPerUnit
* UnitPrice
* UnitsInStock
* UnitsOnOrder
* ReorderLevel
* Discontinued

### Employees

Stores employee details.

**Columns**

* EmployeeID (PK)
* FirstName
* LastName
* Title
* BirthDate
* HireDate
* Address
* City
* Country
* ReportsTo (FK)

### Shippers

Stores shipping company information.

**Columns**

* ShipperID (PK)
* CompanyName
* Phone

### Orders

Stores customer order information.

**Columns**

* OrderID (PK)
* CustomerID (FK)
* EmployeeID (FK)
* OrderDate
* RequiredDate
* ShippedDate
* ShipVia (FK)
* Freight
* ShipCountry

### Order Details

Stores products associated with each order.

**Columns**

* OrderID (FK)
* ProductID (FK)
* UnitPrice
* Quantity
* Discount

---

## 🔗 Entity Relationship Overview

```
Customers ───< Orders >─── Employees
                 │
                 │
                 ▼
          Order_Details
                 │
                 ▼
             Products
             /      \
            ▼        ▼
      Categories  Suppliers

Orders ───► Shippers
```

---

## 📈 SQL Analysis Performed

The project includes two SQL script files:

### 📄 Northwind_Project_1.sql

Covers:

* Basic SELECT Statements
* Filtering Records
* Sorting Data
* Aggregate Functions
* GROUP BY & HAVING
* Joins
* Subqueries

### 📄 Northwind_Project_2.sql

Covers:

* Advanced Joins
* Common Table Expressions (CTEs)
* Window Functions
* Ranking Functions
* Running Totals
* Business Insights
* Sales & Profit Analysis
* Customer Analytics
* Product Performance Analysis

---

## 🎯 Key Learning Outcomes

* Database Design Understanding
* Primary & Foreign Key Relationships
* SQL Query Optimization
* Data Analysis Using SQL
* Complex Joins
* Window Functions
* CTEs and Subqueries
* Business Intelligence Reporting

---

## 🚀 How to Run

### Step 1

Create a new database in MySQL.

```sql
CREATE DATABASE northwind;
USE northwind;
```

### Step 2

Create all tables using the schema provided.

### Step 3

Import all CSV files into their respective tables.

### Step 4

Execute:

```sql
Northwind_Project_1.sql
```

and

```sql
Northwind_Project_2.sql
```

to perform analysis.

---

## 📌 Project Highlights

✔ Database Creation from CSV Files
✔ Relational Data Modeling
✔ SQL Queries from Basic to Advanced
✔ Business-Oriented Data Analysis
✔ Customer, Product, Sales, and Order Insights
✔ Real-World SQL Practice Project

---

## 👨‍💻 Author

**Vedant Prajapati**

* Bachelor of Engineering (Information Technology)
* SQL Developer & Data Analytics Enthusiast
* GitHub Portfolio Projects

---

## ⭐ Support

If you found this project helpful, consider giving it a ⭐ on GitHub and sharing your feedback.
