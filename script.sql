CREATE DATABASE ECOM;

USE ECOM;


CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20)
);


CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);


CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);


CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- INSERTING --

INSERT INTO Categories (CategoryName) VALUES
('Electronics'),
('Apparel'),
('Home Goods');

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

INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-09-01'),
(2, '2024-09-02'),
(1, '2024-09-03');

INSERT INTO OrderItems (OrderID, ProductID, Quantity) VALUES
(1, 1, 1), -- Alice buys 1 Smartphone
(1, 3, 2), -- Alice buys 2 T-Shirts
(2, 2, 1), -- Bob buys 1 Laptop
(3, 4, 1), -- Alice buys 1 Coffee Maker
(3, 5, 1); -- Alice buys 1 Headphones


-- BASIC REQUIREMENTS

SELECT
    c.CustomerName,
    cat.CategoryName,
    SUM(oi.Quantity) AS TotalQuantity,
    SUM(oi.Quantity * p.Price) AS TotalSpent
FROM
    Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
INNER JOIN Products p ON oi.ProductID = p.ProductID
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
WHERE
    o.OrderDate >= '2024-09-01'
GROUP BY
    c.CustomerName,
    cat.CategoryName
ORDER BY
    TotalSpent DESC;

-- EXPLANATION --

# query to find out the total amount each customer has spent on
# each product category since '2024-09-01', sorted by the highest spenders.



-- ADDITIONALS --

SELECT
    ProductName AS Name,
    'Product' AS Type
FROM
    Products
UNION ALL
SELECT
    CategoryName AS Name,
    'Category' AS Type
FROM
    Categories;

#  labeling each row as 'Product'
#  union all combines this with labels 'Category' (CategoryName) from Categories
#  result -  list of all product and category names with their types


--  CTE (Common Table Expression) --

WITH CustomerOrders AS (
    SELECT
        c.CustomerID,
        c.CustomerName,
        o.OrderID,
        o.OrderDate
    FROM
        Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE
        o.OrderDate >= '2024-09-01'
),
OrderDetails AS (
    SELECT
        co.CustomerName,
        cat.CategoryName,
        oi.Quantity,
        p.Price
    FROM
        CustomerOrders co
    INNER JOIN OrderItems oi ON co.OrderID = oi.OrderID
    INNER JOIN Products p ON oi.ProductID = p.ProductID
    INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
)
SELECT
    od.CustomerName,
    od.CategoryName,
    SUM(od.Quantity) AS TotalQuantity,
    SUM(od.Quantity * od.Price) AS TotalSpent
FROM
    OrderDetails od
GROUP BY
    od.CustomerName,
    od.CategoryName
ORDER BY
    TotalSpent DESC;


# personally I prefer cte due to its readability
