SELECT *
FROM PizzaStore.dbo.pizza_sales

-----------------------------------------------------------------------------------------------------------
--KPIs:

--Total Revenue: 817k$
SELECT SUM(total_price) AS Total_Revenue
FROM PizzaStore.dbo.pizza_sales

--Average order price: 38$
SELECT SUM(total_price) / COUNT(DISTINCT(order_id)) AS Average_order_price
FROM PizzaStore.dbo.pizza_sales

--Total pizzas sold: 49k
SELECT SUM(quantity) AS total_pizzas_sold
FROM PizzaStore.dbo.pizza_sales

--Total orders 21k
SELECT COUNT(DISTINCT(order_id)) AS total_orders
FROM PizzaStore.dbo.pizza_sales

--Average Pizzas per order: more than 2 pizzas
SELECT CAST(SUM(quantity) /  COUNT(DISTINCT(order_id)) AS DECIMAL(9,2)) AS Average_pizzas_per_order
FROM  PizzaStore.dbo.pizza_sales

-----------------------------------------------------------------------------------------------------------
--Time trends

--Number of orders each day
SELECT DATENAME(DW, order_date) AS order_day, COUNT(DISTINCT(order_id)) AS Total_orders
FROM PizzaStore.dbo.pizza_sales
GROUP BY DATENAME(DW, order_date)
ORDER BY COUNT(DISTINCT(order_id)) DESC

--Number of orders each month
SELECT DATENAME(Month, order_date) AS order_month, COUNT(DISTINCT(order_id)) AS Total_orders
FROM PizzaStore.dbo.pizza_sales
GROUP BY DATENAME(Month, order_date)
ORDER BY COUNT(DISTINCT(order_id)) DESC

-----------------------------------------------------------------------------------------------------------
--Percentage of sales by categories

--%Revenue by type of pizza
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(8,2)) AS total_revenue, 
CAST(SUM(total_price)*100/ (SELECT SUM(total_price) FROM PizzaStore.dbo.pizza_sales) AS DECIMAL(4,2)) AS Percentage
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_category
ORDER BY SUM(total_price) DESC

--%Revenue by size of pizza
SELECT pizza_category, pizza_size, CAST(SUM(total_price) AS DECIMAL(8,2)) AS Revenue_by_size, 
CAST(SUM(total_price)*100 / (SELECT SUM(total_price) FROM PizzaStore.dbo.pizza_sales) AS DECiMAL (4,2)) AS Percentage
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_size, pizza_category
ORDER BY SUM(total_price) DESC

-- Total orders by category of pizza
SELECT pizza_category, SUM(Quantity) AS total_orders
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_category
ORDER BY SUM(total_price) DESC

-----------------------------------------------------------------------------------------------------------
--Top and Bottom 5 pizzas by quantity sold, revenue, and presence in orders

--Top 5 Pizzas by quantity sold
SELECT TOP 5 pizza_name, SUM(Quantity) AS total_units_sold
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY SUM(Quantity) DESC

--Top 5 pizzas by orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT(order_id)) number_of_orders
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY number_of_orders DESC

--Top 5 pizzas by revenue
WITH a as (
SELECT pizza_name, pizza_size, unit_price, 
SUM(quantity) number_of_pizzas_sold, SUM(quantity)*unit_price revenue
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_name, pizza_size, unit_price)

SELECT TOP 5 pizza_name, SUM(revenue) total_revenue
FROM a
GROUP BY pizza_name
ORDER BY total_revenue DESC

--Bottom 5 Pizzas by quantity sold
SELECT TOP 5 pizza_name, SUM(Quantity) AS total_units_sold
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY SUM(Quantity) ASC

--Bottom 5 pizzas by orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT(order_id)) number_of_orders
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_name
ORDER BY number_of_orders ASC

--Bottom 5 pizzas by revenue
WITH a as (
SELECT pizza_name, pizza_size, unit_price, 
SUM(quantity) number_of_pizzas_sold, SUM(quantity)*unit_price revenue
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_name, pizza_size, unit_price)

SELECT TOP 5 pizza_name, SUM(revenue) total_revenue
FROM a
GROUP BY pizza_name
ORDER BY total_revenue ASC