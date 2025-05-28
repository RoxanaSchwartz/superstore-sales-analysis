-- BigQuery SQL Analysis
-- This section contains SQL queries executed in BigQuery to analyze the Superstore dataset.
-- The queries replicate Python KPIs (Total Sales, Average Order Value, Sales Share by Category/Region, Top-Sub-Categories)
-- and extend the analysis with seasonal patterns and customer purchase frequency.
-- Results are exported as CSV files for use in Looker Studio, ensuring no direct connection to BigQuery for privacy.
-- The table `superstore_cleaned` uses column names with underscores (e.g., `Order_ID`, `Sub_Category`) for clean SQL syntax.

-- 1. Total Sales
-- Calculates the sum of all sales across the dataset.
-- Expected result: ~$2,252,607.41 (based on Python analysis).

SELECT SUM(Sales) AS Total_Sales
FROM `superstore-461111.superstore_analysis.superstore_cleaned`;

-- 2. Average Order Value (AOV)
-- Computes the average sales per unique order by dividing total sales by the number of distinct orders.
-- Expected result: ~$458.22.

SELECT SUM(Sales) / COUNT(DISTINCT Order_ID) AS Average_Order_Value
FROM `superstore-461111.superstore_analysis.superstore_cleaned`;

-- 3. Sales Share by Category
-- Aggregates sales by category and calculates the percentage share of total sales for each category.
-- Expected result: Technology (~36.66%), Furniture (~32.12%), Office Supplies (~31.22%).

SELECT
  Category,
  SUM(Sales) AS Total_Sales,
  ROUND((SUM(Sales) / (SELECT SUM(Sales) FROM `superstore-461111.superstore_analysis.superstore_cleaned`)) * 100, 2) AS Sales_Share_Percent
FROM `superstore-461111.superstore_analysis.superstore_cleaned`
GROUP BY Category
ORDER BY Total_Sales DESC;

-- 4. Sales Share by Region
-- Aggregates sales by region and calculates the percentage share of total sales for each region.
-- Expected result: West (~31.53%), East (~29.33%), Central (~21.87%), South (~17.28%).

SELECT
  Region,
  SUM(Sales) AS Total_Sales,
  ROUND((SUM(Sales) / (SELECT SUM(Sales) FROM `superstore-461111.superstore_analysis.superstore_cleaned`)) * 100, 2) AS Sales_Share_Percent
FROM `superstore-461111.superstore_analysis.superstore_cleaned`
GROUP BY Region
ORDER BY Total_Sales DESC;

-- 5. Top 5 Sub-Categories by Sales
-- Identifies the top 5 sub-categories with the highest total sales.
-- Expected result: Phones (~$326,488), Chairs (~$322,108), Storage, Tables, Binders.

SELECT
  Sub_Category,
  SUM(Sales) AS Total_Sales
FROM `superstore-461111.superstore_analysis.superstore_cleaned`
GROUP BY Sub_Category
ORDER BY Total_Sales DESC
LIMIT 5;

-- 6. Seasonal Patterns by Month and Sub-Category
-- Analyzes sales by month and sub-category to identify seasonal trends.
-- Results are sorted by month and sales to highlight top-performing sub-categories each month.

SELECT
  Month,
  Sub_Category,
  SUM(Sales) AS Total_Sales
FROM `superstore-461111.superstore_analysis.superstore_cleaned`
GROUP BY Month, Sub_Category
ORDER BY Month, Total_Sales DESC;

-- 7. Top 5 Products in Phones and Chairs
-- Focuses on the Phones and Chairs sub-categories, listing the top 5 products by sales.
-- Helps identify high-value products in key sub-categories.

SELECT
  Sub_Category,
  Product_Name,
  SUM(Sales) AS Total_Sales
FROM `superstore-461111.superstore_analysis.superstore_cleaned`
WHERE Sub_Category IN ('Phones', 'Chairs')
GROUP BY Sub_Category, Product_Name
ORDER BY Sub_Category, Total_Sales DESC
LIMIT 5;

-- 8. Customer Purchase Frequency by Segment
-- Analyzes customer behavior by segment, showing the top 10 customers by total sales and their order frequency.
-- Useful for identifying loyal or high-value customers.

SELECT
  Segment,
  Customer_ID,
  COUNT(DISTINCT Order_ID) AS Order_Count,
  SUM(Sales) AS Total_Sales
FROM `superstore-461111.superstore_analysis.superstore_cleaned`
GROUP BY Segment, Customer_ID
ORDER BY Total_Sales DESC
LIMIT 10;