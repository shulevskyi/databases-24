CREATE DATABASE ECOM;

USE ECOM;

-- Creating table to store customer information
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20)
);

-- Creating table to store product categories
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

-- Creating table to store products and their categorization
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Creating table to store orders and relate them to customers
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Creating table to store items within each order
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Inserting initial data into the Categories, Products, and Customers tables
INSERT INTO Categories (CategoryName) VALUES ('Electronics'), ('Apparel'), ('Home Goods');
INSERT INTO Products (ProductName, Price, CategoryID) VALUES
('Smartphone', 699.99, 1),
('Laptop', 1299.99, 1),
('T-Shirt', 19.99, 2),
('Coffee Maker', 49.99, 3),
('Headphones', 199.99, 1);
INSERT INTO Customers (CustomerName, Email, Phone) VALUES
('Alice Smith', 'alice@example.com', '555-1234'),
('Bob Johnson', 'bob@example.com', '555-5678'),
('Carol Williams', 'carol@example.com', '555-8765');

-- Inserting order data and order items
INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-09-01'),
(2, '2024-09-02'),
(1, '2024-09-03');
INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 4, 1),
(3, 5, 1);


SELECT
    Customers.CustomerName,
    Categories.CategoryName,
    SUM(OrderItems.Quantity) AS TotalItems,
    SUM(OrderItems.Quantity * Products.Price) AS TotalAmount
FROM
    Customers
JOIN
    Orders ON Customers.CustomerID = Orders.CustomerID
JOIN
    OrderItems ON Orders.OrderID = OrderItems.OrderID
JOIN
    Products ON OrderItems.ProductID = Products.ProductID
JOIN
    Categories ON Products.CategoryID = Categories.CategoryID
WHERE
    Orders.OrderDate >= '2024-09-01'
GROUP BY
    Customers.CustomerName, Categories.CategoryName
ORDER BY
    TotalAmount DESC;





-- Using a CTE 
WITH CustomerCategorySummary AS (
    SELECT
        Customers.CustomerName,
        Categories.CategoryName,
        SUM(OrderItems.Quantity) AS TotalItems,
        SUM(OrderItems.Quantity * Products.Price) AS TotalAmount
    FROM
        Customers
    JOIN
        Orders ON Customers.CustomerID = Orders.CustomerID
    JOIN
        OrderItems ON Orders.OrderID = OrderItems.OrderID
    JOIN
        Products ON OrderItems.ProductID = Products.ProductID
    JOIN
        Categories ON Products.CategoryID = Categories.CategoryID
    WHERE
        Orders.OrderDate >= '2024-09-01'
    GROUP BY
        Customers.CustomerName, Categories.CategoryName
)

-- Select top spending customers in each category
SELECT * FROM CustomerCategorySummary
WHERE CategoryName = 'Electronics'
UNION ALL
SELECT * FROM CustomerCategorySummary
WHERE CategoryName = 'Apparel'
UNION ALL
SELECT * FROM CustomerCategorySummary
WHERE CategoryName = 'Home Goods'
ORDER BY TotalAmount DESC;
