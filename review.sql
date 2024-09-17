ALTER TABLE employees
RENAME COLUMN firt_name TO  first_name;

ALTER TABLE employees
MODIFY COLUMN email VARCHAR(20);

ALTER TABLE employees 
MODIFY email VARCHAR(20)
AFTER last_name;

ALTER TABLE employees 
DROP COLUMN email;

INSERT INTO employees 
VALUES (1, "Eugine", "Krabs", 25.5, "2024-09-13");

INSERT INTO employees 
VALUES  (2, "Squidward", "Tentacles", 15.00, "2023-01-01"),
		(3, "Spoongebob", "Squarepants" , 12.50, "2023-01-02"),
        (4, "Patric", "Star", 12.50, "2023-01-04"),
        (5, "Sandy", "Cheeks", 17.50, "2023-01-05");
        
INSERT INTO employees (employee_id, first_name, last_name)
VALUES (6, "Sheldon", "Plankton");       

UPDATE employees 
SET hourly_pay = 10.30 , hire_date = "2023-09-29"
WHERE first_name = "Sheldon" AND employee_id = 6;


-- DATE TIME 
CREATE TABLE test(
	my_date DATE,
    my_time TIME,
    my_datetime DATETIME
);

INSERT INTO test 
VALUES (CURRENT_DATE(), CURRENT_TIME(), NOW());

DROP TABLE test;

CREATE TABLE products(
	product_id INT,
    product_name VARCHAR(25),
    price DECIMAL(4, 2)
);


-- UNIQUE
ALTER TABLE products 
ADD CONSTRAINT 
UNIQUE(product_name);

INSERT INTO products 
VALUES	(100, "Hamburger", 3.99),
		(101, "Fries", 1.89),
        (102, "Soda", 1.00),
        (103, "Ise cream", 1.49);

ALTER TABLE products 
MODIFY price DECIMAL(4, 2) NOT NULL;

CREATE TABLE workers(
	e_id INT, 
    f_name VARCHAR(50),
    l_name VARCHAR(50),
    hourly_pay DECIMAL(5, 2),
    hire_date DATE,
    CONSTRAINT chk_hourly_pay CHECK (hourly_pay >= 10.00)
);

ALTER TABLE employees 
ADD CONSTRAINT check_horly_pay CHECK (hourly_pay >= 10.00);

ALTER TABLE employees 
DROP CHECK check_hourly_pay; 

INSERT INTO products (product_id, product_name) 
VALUES  (104, "Napkins"),
		(105, "Spoon"),
        (106, "Fork"),
		(107, "Straw");
        
DELETE FROM products 
WHERE product_id >= 104;

ALTER TABLE products
ALTER price SET DEFAULT 0;


-- PRIMARY KEY
CREATE TABLE transactions(
	trx_id INT PRIMARY KEY AUTO_INCREMENT,
    trx_amt DECIMAL(5, 2)
);

ALTER TABLE transactions 
ADD CONSTRAINT 
PRIMARY KEY(trx_id);

INSERT INTO transactions(trx_amt)
VALUES  (8.69),
		(6.45),
        (3.78);
        
ALTER TABLE transactions
AUTO_INCREMENT = 1000;

DELETE FROM transactions
WHERE trx_id < 1000;
DROP TABLE transactions;

CREATE TABLE customers(
	cust_id INT PRIMARY KEY AUTO_INCREMENT,
    f_name VARCHAR(50),
    l_name VARCHAR(50)
);


-- FOREIGN KEY
CREATE TABLE transactions(
	trx_id	 INT PRIMARY KEY AUTO_INCREMENT,
    trx_amt DECIMAL (5, 2),
    cust_id INT,
    FOREIGN KEY(cust_id) REFERENCES customers(cust_id)
);

ALTER TABLE transactions
DROP FOREIGN KEY transactions_ibfk_1;

ALTER TABLE transactions
ADD CONSTRAINT fk_cust_id
FOREIGN KEY(cust_id) REFERENCES customers(cust_id);

SET foreign_key_checks = 0;

SELECT * FROM customers;

INSERT INTO customers(f_name, l_name)
VALUES  ("Fred", "Pawel"),
		("Larry", "Lobster"),
        ("Bubble", "Bass");

INSERT INTO transactions(trx_amt, cust_id)
VALUES	(4.75, 4),
		(2.69, 5),
        (4.47, 6);
        
INSERT INTO transactions(trx_amt, cust_id)
VALUES (1.00, NULL);    
SELECT * FROM transactions AS t
RIGHT JOIN customers AS c
ON t.cust_id = c.cust_id;
    
SELECT CONCAT(first_name, " ", last_name) AS "FULL NAME"
FROM employees;

ALTER TABLE employees
ADD COLUMN job VARCHAR(25) AFTER hourly_pay;

-- Wild Cards
UPDATE employees
SET job = "director"
WHERE employee_id = 6;
SELECT * FROM employees;

SELECT * FROM employees
WHERE last_name LIKE "%r";

SELECT * FROM employees
LIMIT 1, 5;
   
-- UNION does not allow duplicates
-- If we want duplicates we will go to UNION ALL
SELECT * FROM products
UNION 
SELECT * FROM transactions; 

-- VIEWS
CREATE VIEW employee_attendance AS
SELECT first_name, last_name, job 
FROM employees;
SELECT * FROM employee_attendance;

-- INDEXES
SHOW INDEXES FROM customers;

CREATE INDEX l_name_idx
ON customers(l_name);

ALTER TABLE customers
DROP INDEX l_name_idx;

ALTER TABLE transactions 
ADD COLUMN order_date DATE;

UPDATE transactions
SET order_date = "2023-01-03"
WHERE trx_id = 1013;
SELECT * FROM transactions;

-- GROUP BY || HAVING || ROLLUP
SELECT SUM(trx_amt) AS t, order_date
FROM transactions
GROUP BY order_date
ORDER BY t DESC;

SELECT COUNT(trx_amt), cust_id
FROM transactions
GROUP BY cust_id
HAVING COUNT(trx_amt) > 1 AND cust_id IS NOT NULL;

SELECT SUM(trx_amt), order_date
FROM transactions
GROUP BY order_date WITH ROLLUP;

SELECT COUNT(trx_amt) AS "# OF ORDERS", order_date
FROM transactions
GROUP BY order_date WITH ROLLUP;


-- ON DELETE SET NULL = Whenn a FK is deleted, replace FK with NULL
-- ON DELETE CASCADE = Wen a FK is deleted delete with row

CREATE TABLE transactions_2 (
	transaction_id INT PRIMARY KEY,
    amount DECIMAL(5, 2),
    customer_id INT, 
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(cust_id)
    ON DELETE SET NULL
);
ALTER TABLE transactions_2 
DROP FOREIGN KEY transactions_2_ibfk_1;

ALTER TABLE transactions_2 
ADD CONSTRAINT fk_customer_id
FOREIGN KEY(customer_id) REFERENCES customers(cust_id);

ALTER TABLE transactions_2 DROP FOREIGN KEY fk_customer_id;

ALTER TABLE transactions_2 
ADD CONSTRAINT fk_customer_id 
FOREIGN KEY(customer_id) REFERENCES customers(cust_id)
ON DELETE CASCADE;


-- STORED PROCEDURE =   is prepared SQL code hat you can save
-- 						great if there is a query that you write often 
-- 						reduces network traffic
-- 						increases performance
-- 						secure, admin can grant permission
-- 						increases memory usage of every connsection

DELIMITER $$
CREATE PROCEDURE get_customers()
BEGIN
	SELECT * FROM customers;
END$$
DELIMITER ;

CALL get_customers();
DROP PROCEDURE get_customers;

DELIMITER $
CREATE PROCEDURE find_customer(IN id INT)
BEGIN 
	SELECT * FROM customers
    WHERE id = id;
END$
DELIMITER ;

CALL find_customer(4);
DROP PROCEDURE find_customer;

-- TRIGGER
-- When an event happens, do something 
-- ex. (INSERT, UPDATE, DELETE)
-- checks data, handles errors, auditing tables

CREATE TRIGGER before_hourly_pay
BEFORE UPDATE ON employees
FOR EACH ROW
SET NEW.salary = (NEW.hourly_pay * 2080);

USE mydb;
SET sql_safe_updates = 0;
