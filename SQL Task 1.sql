'''create table'''

CREATE TABLE Superstore (
    Row_ID INT,
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(20),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(150),
    Sales DECIMAL(18, 2),
    Quantity INT,
    Discount DECIMAL(5, 2),
    Profit DECIMAL(18, 2)
);

'''Import Data from Csv'''

SET datestyle = 'MDY';

COPY Superstore FROM 'C:\Users\Pavanyadav\Desktop\Pavan M R_CuvetteDS\Pavan M R_SQL\SQL_Dataset_Cleaned.csv'
DELIMITER ',' CSV HEADER;

-- View the Data 
select *from Superstore;

-- 1.   Data Cleaning And Preprocessing
-- Cast the Order Date to SQL date format
SELECT 
  TO_DATE(Order_Date, 'MM/DD/YYYY') AS order_date
FROM Superstore;

--Cleane the data
DELETE FROM Superstore
WHERE 
  Profit IS NULL OR Profit < 0
  OR Sales IS NULL OR Sales < 0;

 -- Standarize
 -- View cleaned region values
SELECT DISTINCT
  TRIM(LOWER(Region)) AS cleaned_region
FROM Superstore;

UPDATE Superstore
SET Region = INITCAP(TRIM(LOWER(Region)));

-- 2 Sales And Customer Analysis
-- Top 5 most profitable customers.
select Customer_Name,sum(Profit) as "total_pofit"
from Superstore
group by Customer_Name
order by sum(profit) desc
limit 5;

--    Average profit per region.
select Region,round(avg(Profit),2) as "Avg of Progit"
from Superstore
group by Region
order by avg(Profit);

-- Total sales by category and sub-category.
SELECT 
    Category,Sub_Category,
    SUM(Sales) AS total_sales
FROM Superstore
GROUP BY Category,Sub_Category
ORDER BY Category, total_sales DESC;

--   Total sales and quantity sold in each region.
select Region,sum(Sales) as "Total_sales", sum(Quantity) as "Total_quantity"
from Superstore
group by Region
order by sum(sales);

-- 3  Advanced SQL Queries
-- Rank customers by total sales using RANK().
SELECT 
    Customer_Name,
    SUM(Sales) AS total_sales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) AS sales_rank
FROM Superstore
GROUP BY Customer_Name;

--ind the day with the highest total sales.
select Order_Date, sum(Profit) as "total_sales"
from Superstore
group by Order_Date
order by sum(Profit) desc
limit 1;

--   Identify regions where average sales per order is above $500.
select Region, avg(Sales) as "avg sales"
from Superstore
group by Region
having avg(sales) > 500;

--  Create a High_Profit flag where Profit > 1000.
SELECT 
    *,
    CASE 
        WHEN Profit > 1000 THEN 'High'
        ELSE 'Normal'
    END AS High_Profit
FROM Superstore;

-- Compare total profit of “Technology” versus “Furniture” category.
SELECT 
    Category,
    SUM(Profit) AS total_profit
FROM Superstore
WHERE Category IN ('Technology', 'Furniture')
GROUP BY Category;

-- 4  Filtering
--    Filter By Order Date Range: For extract year/month for trend insights.

SELECT *
FROM Superstore
WHERE Order_Date BETWEEN '2016-01-01' AND '2017-12-31';

SELECT 
    EXTRACT(YEAR FROM Order_Date) AS order_year,
    EXTRACT(MONTH FROM Order_Date) AS order_month,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM Superstore
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

SELECT *
FROM Superstore
WHERE EXTRACT(YEAR FROM Order_Date) = 2020;


