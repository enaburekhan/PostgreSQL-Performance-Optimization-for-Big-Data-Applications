CREATE database commercedb;

-- Drop the Customers table if it already exists
DROP TABLE IF EXISTS Customers;

-- Create the Customers table
CREATE TABLE Customers (
    Customer_id SERIAL PRIMARY KEY,
    Customer_name VARCHAR(50),
    Contact_info TEXT,
    Customer_Address TEXT
);

-- Insert random data into the Customers table
INSERT INTO Customers (Customer_name, Contact_info, Customer_address)
SELECT 
   md5(random()::text) AS Customer_name,
   md5(random()::text) AS Contact_info,
   md5(random()::text) AS Customer_address
FROM
   generate_series(1, 30000000);   


-- Drop the Accounts table if it already exists
DROP TABLE IF EXISTS Accounts;

-- Create the Accounts table
CREATE TABLE Accounts (
    Account_id SERIAL PRIMARY KEY,
    Balance NUMERIC(6, 2),
    Customer_id INT UNIQUE, -- Ensuring each Customer_id is unique
    FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);

-- Insert random data into the Accounts table
INSERT INTO Accounts (Balance, Customer_id)
SELECT
    (random() * 9999)::NUMERIC(6, 2) AS Balance,
    Customer_id
FROM
    Customers;    


-- Drop the Suppliers table if it already exists
DROP TABLE IF EXISTS Suppliers;

-- Create the Suppliers table
CREATE TABLE Suppliers (
    Supplier_id SERIAL PRIMARY KEY,
    Supplier_name VARCHAR(50) NOT NULL,
    Contact_info TEXT NOT NULL
);

-- Insert random data into the Suppliers table
INSERT INTO Suppliers (Supplier_name, Contact_info)
SELECT 
   md5(random()::text) AS Supplier_name,
   md5(random()::text) AS Contact_info
FROM
   generate_series(1, 100000);
