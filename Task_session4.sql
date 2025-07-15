
----------------------TASK

-- 1. Count the total number of products in the database.

SELECT COUNT(*) as total_products
FROM production.products;

--2. Find the average, minimum, and maximum price of all products.


SELECT
    AVG(list_price) as Average_price,
    MIN(list_price) as lowest_price,
    MAX(list_price) as highest_price
FROM production.products;


--3. Count how many products are in each category.


SELECT
    c.category_name,
COUNT(p.product_id ) as product_count
 from production.products p
INNER JOIN production.categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

--4. Find the total number of orders for each store.

select 
 s.store_name,
count (O.order_id)as total_orders
from sales.orders o
inner join sales.stores s on S.store_id = o.store_id
GROUP BY S.store_name;

--5.Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers.

SELECT
    first_name,
    last_name,
 
    UPPER(first_name) as name_upper,
    LOWER(last_name) as last_name_lower,
    first_name + ' ' + last_name as full_name
FROM sales.customers
WHERE customer_id <= 10;

--6.Get the length of each product name. Show product name and its length for the first 10 products.

SELECT 
Product_name,
len(Product_name) as length_of_name
from production.products
where product_id<=10
order by product_id;

--7.Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15.

SELECT
    customer_id,
    phone,
    LEFT(phone, 3) as area_code
FROM sales.customers
WHERE phone IS NOT NULL AND customer_id <= 15;

--8.Show the current date and extract the year and month from order dates for orders 1-10.


select
order_id,
order_date,
GETDATE() AS Current_D,
YEAR(order_date) as order_year,
MONTH(order_date) as order_month
from sales.orders
WHERE order_id <= 10;

--9.Join products with their categories. Show product name and category name for first 10 products.


SELECT
    p.product_name,
    c.category_name
FROM production.products p
INNER JOIN production.categories c ON p.category_id = c.category_id
where p.product_id <=10;

--10.Join customers with their orders. Show customer name and order date for first 10 orders.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    o.order_date
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
where order_id <=10
ORDER BY o.order_id;

--11.Show all products with their brand names, even if some products don't have brands. Include product name, brand name (show 'No Brand' if null).


SELECT
    p.product_name,
    ISNULL(b.brand_name, 'NO BRAND') AS brand_name
FROM production.products p
LEFT JOIN production.brands b ON p.brand_id = b.brand_id;

--12.Find products that cost more than the average product price. Show product name and price.

SELECT 
    product_name,
    list_price
FROM production.products
WHERE list_price > (
    SELECT AVG(list_price) FROM production.products
);

--13. Find customers who have placed at least one order. Use a subquery with IN. Show customer_id and customer_name.

SELECT 
    customer_id,
    first_name + ' ' + last_name AS customer_name
FROM sales.customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM sales.orders
    WHERE customer_id IS NOT NULL
);

--14.For each customer, show their name and total number of orders using a subquery in the SELECT clause.

SELECT 
    c.first_name + ' ' + c.last_name AS customer_name,
    (SELECT COUNT(*) FROM sales.orders o WHERE o.customer_id = c.customer_id) AS total_orders
FROM sales.customers c;

--15.Create a simple view called easy_product_list that shows product name, category name, and price. Then write a query to select all products from this view where price > 100.

create view  easy_product_list  AS

SELECT 
    p.product_name,
    c.category_name,
    p.list_price
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id;
GO
--using
SELECT *
FROM easy_product_list
WHERE list_price > 100;


--16. Create a view called customer_info that shows customer ID, full name (first + last), email, and city and state combined. Then use this view to find all customers from California (CA).

CREATE VIEW customer_info AS
SELECT 
    customer_id,
    first_name + ' ' + last_name AS full_name,
    email,
    city + ', ' + state AS location
FROM sales.customers;
GO
-- USING
SELECT *
FROM customer_info
WHERE location LIKE '%, CA';

--17. Find all products that cost between $50 and $200. Show product name and price, ordered by price from lowest to highest.

SELECT 
    product_name,
    list_price
FROM production.products
WHERE list_price BETWEEN 50 AND 200
ORDER BY list_price ASC;

--18.Count how many customers live in each state. Show state and customer count, ordered by count from highest to lowest.

SELECT 
    state,
    COUNT(*) AS customer_count
FROM sales.customers
GROUP BY state
ORDER BY customer_count DESC;

--19. Find the most expensive product in each category. Show category name, product name, and price.

SELECT 
    c.category_name,
    p.product_name,
    p.list_price
FROM production.products p
JOIN production.categories c ON p.category_id = c.category_id
WHERE p.list_price = (
    SELECT MAX(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p.category_id
);

--20.Show all stores and their cities, including the total number of orders from each store. Show store name, city, and order count.

SELECT 
    s.store_name,
    s.city,
    COUNT(o.order_id) AS order_count
FROM sales.stores s
LEFT JOIN sales.orders o ON s.store_id = o.store_id
GROUP BY s.store_name, s.city;