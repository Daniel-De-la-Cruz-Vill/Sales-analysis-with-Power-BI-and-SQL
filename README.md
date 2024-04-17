# **Pizza sales analysis with Power BI and SQL**
In this project, we analyzed data from sales of a pizza store in 2015.  SQL queries were used to calculate KPIs and other important data relating to those sales. Power BI was then used to create a dashboard 
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

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/b9304d2c-8c10-43b2-8c1e-705c4475274f)

### Total orders for each category of pizza
The following SQL query calculates how many pizzas were ordered in total for each category, and then orders them in descending order.

```
-- Total orders by category of pizza
SELECT pizza_category, SUM(Quantity) AS total_orders
FROM PizzaStore.dbo.pizza_sales
GROUP BY pizza_category
ORDER BY SUM(total_price) DESC
```
In Power BI, the following visual was created to illustrate this information.

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/6a1a805a-d0a7-4748-9ca0-e0bafdcb0c76)

### Top and bottom 5 pizzas
Finally, we calculated and created a visualization for the top 5 pizzas by quantity sold, number of orders that contained the pizza, and revenue, respectively. The last query contains a CTE (common table expression) because the total revenue by pizza name had to be calculated first.
```
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
```
The results are illustrated with Power BI visualizations below:

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/0827b592-e746-4b90-aa2e-af1cb64e41e1)

Similarly, the bottom 5 pizzas are obtained with the following queries
```
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
```
The image below shows the Power BI visualization of these values:

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/8894e966-d0ef-49cc-95d9-6fe885715aed)

## Power BI Dashboard

The full dashboard created in Power BI is presented below. It is presented on two pages: one for the trends and totals calculated, and one for the top and bottom 5 pizzas by the selected categories.

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/64c2b818-49eb-4c7f-8995-9d162ef5af1e)

![image](https://github.com/Daniel-De-la-Cruz-Vill/Sales-analysis-with-Power-BI-and-SQL/assets/157164355/7dc2c56f-16eb-420b-8921-27d209850124)


