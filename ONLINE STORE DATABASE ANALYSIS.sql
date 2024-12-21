-- DATABASE CREATION --
CREATE SCHEMA online_store_database;
USE online_store_database;

-- CATEGORIES TABLE CREATION --
CREATE TABLE Categories (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT ,
    Category_Name VARCHAR(50)
);

-- PRODUCTS TABLE CREATION --
CREATE TABLE Products (
    Product_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    Product_Name VARCHAR(50),
    Category_ID INT,
    Price DECIMAL (20,2),
    Stock_Quantity INT
);

-- CUSTOMERS TABLE CREATION --
CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_Name VARCHAR(50),
    Email VARCHAR(50) ,
    Phone_No VARCHAR(50),
    Address VARCHAR(50)
);

-- ORDERS TABLE CREATION --
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT,
    Order_Date DATE,
    Total_Amount DECIMAL(20,2)
);

-- ORDER DETAILS TABLE CREATION --
CREATE TABLE Order_Details (
    Order_Detail_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT,
    Product_ID INT,
    Quantity INT,
    Total DECIMAL(20,2)
);

-- VALUE INSERTION IN CATEGORIES TABLE --
INSERT INTO Categories (Category_Name) VALUES 
('Consoles'), ('Video Games'), ('Accessories'), ('Merchandise');

-- VALUE INSERTION IN PRODUCTS TABLE --
INSERT INTO Products (Product_Name, Category_ID, Price, Stock_Quantity) VALUES 
('PlayStation 5', 1, 499.99, 100),
('Xbox Series X', 1, 499.99, 120),
('The Last of Us Part II', 2, 59.99, 300),
('Call of Duty: Modern Warfare', 2, 39.99, 150),
('Gaming Headset', 3, 89.99, 250),
('Gaming Mouse', 3, 49.99, 200),
('T-shirt - Gamer Edition', 4, 19.99, 400),
('Gaming Mug', 4, 14.99, 350),
('Power Joystick', 0, 999.99, 20);

-- VALUE INSERTION IN CUSTOMERS TABLE --
INSERT INTO Customers (Customer_Name, Email, Phone_No, Address) VALUES
('TREVOR', 'trevorthegangster@gmail.com','9123456780', 'Africa'),
('MICHAEL', 'michaelthedon@gmail.com','9998877665','Cryodon'),
('FRANCIS','francissf@gmail.com','9977886654','Australia');

-- VALUE INSERTION IN ORDERS TABLE --
INSERT INTO Orders (Customer_ID, Order_Date, Total_Amount) VALUES
(1, '2024-12-10', 629.98),
(2, '2024-12-12', 149.98),
(3, '2024-12-14', 249.97),
(2, '2024-12-10', 629.98);

-- VALUE INSERTION IN ORDER DETAILS TABLE --
INSERT INTO Order_Details (Order_ID, Product_ID, Quantity, total)VALUES 
(1, 1, 1, 499.99),  
(1, 5, 1, 89.99),   
(2, 3, 2, 79.98),  
(3, 7, 2, 39.98);  

-- TO Retrieve ALL THE TABLES --
SELECT * FROM PRODUCTS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT * FROM ORDER_DETAILS;
SELECT * FROM CATEGORIES;

/* QUERIES */

# QUERY : 1 >  Get order details for each product in an order 
SELECT O.ORDER_ID, O.CUSTOMER_ID, P.PRODUCT_NAME, OD.QUANTITY, P.PRODUCT_ID
FROM ORDERS AS O
JOIN ORDER_DETAILS AS OD ON O.ORDER_ID = OD.ORDER_ID
JOIN PRODUCTS AS P ON OD.PRODUCT_ID = P.PRODUCT_ID; 

# QUERY : 2 > Join the Products table with the Categories table to display product details along with the category name 
SELECT P.PRODUCT_NAME, P.PRICE, C.CATEGORY_NAME
FROM PRODUCTS AS P
JOIN CATEGORIES AS c ON P.CATEGORY_ID = C.CATEGORY_ID;

# QUERY : 3 > To display all product, Including those without a category 
SELECT P.PRODUCT_NAME, P.PRICE, C.CATEGORY_NAME
FROM PRODUCTS AS P
LEFT JOIN CATEGORIES AS c ON P.CATEGORY_ID = C.CATEGORY_ID;

# QUERY : 4 > Find products with prices greater than a average price 
SELECT PRODUCT_NAME, PRICE FROM PRODUCTS
WHERE PRICE > (SELECT AVG(PRICE) FROM PRODUCTS);

# QUERY : 5 >Find products in a specific category where category_name is 'CONSOLES" 
SELECT PRODUCT_NAME FROM PRODUCTS
WHERE CATEGORY_ID = (SELECT CATEGORY_ID FROM CATEGORIES WHERE CATEGORY_NAME = 'CONSOLES');

# QUERY : 6 > Count the total number of products in each category 
SELECT C.CATEGORY_NAME, COUNT(PRODUCT_ID) AS PRODUCT_COUNT
FROM PRODUCTS AS P
JOIN CATEGORIES AS C ON P.CATEGORY_ID = C.CATEGORY_ID
GROUP BY C.CATEGORY_NAME;

# QUERY : 7 > List products with their stock availability, marking "Low Stock" for quantities less than 50 
SELECT PRODUCT_NAME, STOCK_QUANTITY,
CASE
	WHEN STOCK_QUANTITY < 50 THEN "LOW STOCK"
    ELSE "IN STOCK"
END AS STOCK_STATUS
FROM PRODUCTS;

# QUERY : 8 > List customers who have placed more than one order 
SELECT C.CUSTOMER_NAME, COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM CUSTOMERS AS C
JOIN ORDERS AS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_NAME
HAVING COUNT(O.ORDER_ID) > 1;

# QUERY : 9 > Update stock quantity when an order is placed 
UPDATE PRODUCTS SET STOCK_QUANTITY = STOCK_QUANTITY - 1 WHERE PRODUCT_ID = 1; 

# QUERY : 10 > Get total sales for each product 
SELECT P.PRODUCT_NAME, SUM(OD.QUANTITY) AS TOTAL_SOLD
FROM ORDER_DETAILS OD
JOIN PRODUCTS P ON OD.PRODUCT_ID = P.PRODUCT_ID
GROUP BY P.PRODUCT_NAME;

# QUERY : 11 > Get customers who purchased a specific product 
SELECT DISTINCT C.CUSTOMER_NAME, C.EMAIL, P.PRODUCT_NAME
FROM CUSTOMERS AS C 
JOIN ORDERS AS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
JOIN ORDER_DETAILS OD ON O.ORDER_ID = OD.ORDER_ID
join PRODUCTS AS P on OD.PRODUCT_ID = P.PRODUCT_ID
WHERE OD.PRODUCT_ID = 1;  

# QUERY : 12 > Stored Procedure: Total Sales for a Product 
DELIMITER $$
CREATE PROCEDURE Get_TOTAL_SALES(IN PROD_ID INT)
BEGIN
    SELECT 
        P.PRODUCT_NAME,
        SUM(OD.QUANTITY) AS TOTAL_UNITS_SOLD,
        SUM(OD.TOTAL) AS TOTAL_SALES_AMOUNT
    FROM ORDER_DETAILS AS OD
    JOIN PRODUCTS AS P ON OD.PRODUCT_ID = P.PRODUCT_ID
    WHERE P.PRODUCT_ID = PROD_ID
    GROUP BY P.PRODUCT_NAME;
END $$

DELIMITER ;
-- To Call Total Sales Stored Procedure --
CALL GET_TOTAL_SALES(1);






