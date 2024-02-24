-- Create tables and write queries to answer the questions below
-- 1. Find Top 3 Spenders of Jan. 2024
-- 2. Calculate shipping fee for each order
-- 3. Find January sales commissions for employees whose names start with 'T' 

-- Bakery owner
-- The bakery shop is located in New York.
-- Using SQLite

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  first_name TEXT,
  last_name TEXT,
  states TEXT
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  order_date TEXT,
  customer_id INT,
  employee_id INT,
  purchase_amount REAL
);

CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  first_name TEXT,
  last_name TEXT,
  commission REAL
);

INSERT INTO customers VALUES
    (1, 'Mary', 'Jane', 'New York'),
    (2, 'John', 'Demio', 'Texas'),
    (3, 'Karol', 'Taylor', 'New York'),
    (4, 'Meori', 'Anna', 'Ohio'),
    (5, 'Kelvin', 'Koff', 'California');
    
INSERT INTO orders VALUES
    (1, '2023-12-05', '5', '3', '125.00'),
    (2, '2023-12-29', '1', '1', '137.75'),
    (3, '2024-01-03', '1', '2', '368.99'),
    (4, '2024-01-03', '4', '1', '120.00'),
    (5, '2024-01-06', '2', '3', '255.20'),
    (6, '2024-01-12', '3', '4', '133.33'),
    (7, '2024-01-15', '3', '3', '122.80');

INSERT INTO employees VALUES
    (1, 'Eva', 'Brown', '0.12'),
    (2, 'Thomas', 'Miller', '0.10'),
    (3, 'Robert', 'Waltz', '0.15'),
    (4, 'Tom', 'Smith', '0.10');
    
-- QUERY 1: Find Top 3 Spenders of Jan. 2024 (to give voucher rewards)
SELECT 
     a.first_name || ' ' || a.last_name AS customer_name,
     a.customer_id,
     ROUND (SUM(b.purchase_amount), 2) AS total_purchase_amount
FROM customers a 
JOIN orders b
ON a.customer_id = b.customer_id
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY a.customer_id
ORDER BY 3 DESC
LIMIT 3;

-- QUERY 2: Calculate shipping fee for each order
WITH sub AS (
SELECT 
  customer_id, 
  first_name,
  last_name,
  CASE 
      WHEN states = 'New York' THEN 'Free shipping'
      WHEN states = 'Ohio' THEN '20 USD'
      ELSE '40 USD'
  END AS shipping_fee
  FROM customers
)
 
 SELECT 
    a.order_id,
    a.order_date,
    b.customer_id,
    b.first_name,
    b.last_name,
    b.shipping_fee
 FROM orders a, sub b 
 WHERE a.customer_id = b.customer_id;
    
-- QUERY 3: Find January sales commissions for employees whose names start with 'T'
SELECT 
    emp.first_name,
    emp.last_name,
    emp.commission*100 || '%' AS commission_rate,
    ROUND(SUM(ord.purchase_amount)*emp.commission,2) AS Jan_commission
FROM employees emp
JOIN orders ord
ON emp.employee_id = ord.employee_id
GROUP BY emp.first_name
HAVING emp.first_name LIKE 'T%';

