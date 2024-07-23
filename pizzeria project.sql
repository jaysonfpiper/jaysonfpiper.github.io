-- PIZZA PROJECT
-- Use the  clean data set "pizzaria"
-- Please answer the following
-- Q1 Find the total number of orders
-- Q2 Find the total revenue
-- Q3 Find the total number of pizzas sold
-- Q4 Find the average order value
-- Q5 Find the average pizzas per order
-- Q6 Find how many pizzas sold in each category
-- Q7 Find the total number of pizzas sold grouped by size
-- Q8 Find the top 5 selling pizzas
-- Q9 Find the worst 5 selling pizzas
-- Q10 Find the top 3 busiest days
-- Q11 Find the busiest time of day for orders

 
-- Q1 Find the total number of orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM order_details;

-- Q2 Find the total revenue
SELECT ROUND(SUM(quantity * price),2) AS Total_Revenue
FROM order_details AS o
JOIN pizzas AS p
ON o.pizza_id = p.pizza_id;

-- Q3 Find the total number of pizzas sold
SELECT SUM(quantity) AS Total_Pizzas_Sold
FROM order_details;

-- Q4 Find the average order value
SELECT ROUND(SUM(quantity * price) / COUNT(DISTINCT order_id),2) AS Average_Order_Value
FROM order_details as o
JOIN pizzas AS p
ON o.pizza_id = p.pizza_id;

-- Q5 Find the average pizzas per order
SELECT ROUND(SUM(quantity) / COUNT(DISTINCT order_id),2) AS Averasge_Pizzas_Per_Order
FROM order_details;

-- Q6 Find how many pizzas sold in each category
SELECT SUM(o.quantity), pt.category AS Pizzas_by_Category
FROM order_details AS o
JOIN pizzas AS p
ON o.pizza_id = p.pizza_id
JOIN pizza_types AS pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY category;

-- Q7 Find the total number of pizzas sold grouped by size
SELECT SUM(o.quantity) AS Total_Pizzas_by_Size, p.size
FROM order_details AS o
JOIN pizzas AS p
ON o.pizza_id = p.pizza_id
GROUP BY p.size;

-- Q8 Find the top 5 selling pizzas
SELECT SUM(quantity) AS Number_of_Pizzas, pizza_id AS TOP_5_Pizzas_Sold
FROM order_details
GROUP BY pizza_id
ORDER BY SUM(quantity)DESC
LIMIT 5;

-- Q9 Find the worst 5 selling pizzas
SELECT SUM(quantity) AS Number_of_Pizzas, pizza_id AS Worst_5_Selling_Pizzas
FROM order_details
GROUP BY pizza_id
ORDER BY SUM(quantity)ASC
LIMIT 5;

-- Q10 Find the top 3 busiest days
 SELECT COUNT(DISTINCT od.order_id) AS Total_orders_Received, o.date
FROM order_details AS od
JOIN orders AS o
ON o.order_id = od.order_id
GROUP BY o.date
ORDER BY COUNT(DISTINCT od.order_id)DESC
LIMIT 3;

-- Q11 Find the busiest time of day for orders
SELECT COUNT(DISTINCT od.order_id) AS Total_Orders_Received, time
FROM order_details AS od
JOIN orders AS o
ON o.order_id = od.order_id
GROUP BY time
ORDER BY COUNT(DISTINCT od.order_id)DESC
LIMIT 1;












