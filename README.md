# **Pizza sales analysis with Power BI and SQL**
In this project, we analyzed data from sales of a pizza store in 2015.  SQL queries were used to calculate KPIs and other important data relating to those sales, and then Power BI was used to create a dashboard 
to visualize those values. The data-related questions answered in this project are the following:

1. What are the total revenue, average order cost, average number of pizzas per order,  total orders, and total pizzas sold?
2. How many pizzas were ordered each day of the week and month?
3. What are the percentages of revenue by category and size of pizza?
4. What are the total orders for each category of pizza?
5. What are the top and bottom 5 types of pizza by revenue, orders, and quantity sold?

## SQL Queries
The image below shows some of the rows contained in the table that we will be working on. As we can observe, the dataset consists of historical data on pizza sales carried out in 2015. We have information such 
as the date of the order, the size of the pizza, the number of pizzas ordered, the category of pizza, etc.

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/b20bb13d-7a5e-4d84-99aa-33b8f9264a93)

### KPIs
The KPIs that we are interested in consist of those mentioned in the first question in the first section, namely the total revenue, average order cost, average number of pizzas per order, total orders, and total pizzas sold. We can obtain these values with the following sequel queries:
```
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
```
Executing those queries, we obtain the following values (the image below is part of the Power BI dashboard that was created):

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/32e1e7a6-5cca-4c49-8a53-5b13fbe6af92)

### Number of pizzas ordered each day of the week and each month
In SQL, we can get this information with the following queries:
```
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
```
The values obtained were then visualized in Power BI:

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/d4e1514f-8def-4e91-a997-6912e72b3a82)

### Percentages of revenue by type and size
The following SQL queries calculate the percentage of the total revenue that corresponds to each category and size of pizza
```
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
```
We visualized this in Power BI with the following pie charts:

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/ae72ccc9-cfcd-4de7-9f0b-0608debac323)

## Power BI Dashboard
