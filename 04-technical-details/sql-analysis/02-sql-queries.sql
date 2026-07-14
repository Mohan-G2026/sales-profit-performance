SELECT 
    category,
    ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total_sales,
    ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total_profit,
    ROUND(
        (SUM(CAST(profit AS DECIMAL(10,2))) /
         NULLIF(SUM(CAST(sales AS DECIMAL(10,2))), 0)) * 100,
    2) AS profit_margin
FROM sales_data
GROUP BY category
ORDER BY profit_margin DESC;


SELECT 
    sub_category,
    ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total_sales,
    ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total_profit,
    ROUND(
        (SUM(CAST(profit AS DECIMAL(10,2))) /
         NULLIF(SUM(CAST(sales AS DECIMAL(10,2))), 0)) * 100,
    2) AS profit_margin
FROM sales_data
GROUP BY sub_category
HAVING 
    SUM(CAST(sales AS DECIMAL(10,2))) > 
        (SELECT AVG(CAST(sales AS DECIMAL(10,2))) FROM sales_data)
    AND 
    (SUM(CAST(profit AS DECIMAL(10,2))) /
     NULLIF(SUM(CAST(sales AS DECIMAL(10,2))), 0)) < 0.05
ORDER BY profit_margin;


SELECT 
    discount,
    ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total_sales,
    ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total_profit,
    ROUND(
        (SUM(CAST(profit AS DECIMAL(10,2))) /
         SUM(CAST(sales AS DECIMAL(10,2)))) * 100,
    2) AS profit_margin
FROM sales_data
GROUP BY discount
ORDER BY discount;


SELECT 
    region, 
    category,
    ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS category_sales,
    
    ROUND(
        SUM(SUM(CAST(sales AS DECIMAL(10,2)))) 
        OVER (PARTITION BY region),
    2) AS region_total_sales,

    ROUND(
        (SUM(CAST(sales AS DECIMAL(10,2))) /
         SUM(SUM(CAST(sales AS DECIMAL(10,2)))) OVER (PARTITION BY region)) * 100,
    2) AS dependency_percent
FROM sales_data
GROUP BY region, category;


SELECT 
    sub_category,
    ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total_sales,
    ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total_profit,
    ROUND(
        (SUM(CAST(profit AS DECIMAL(10,2))) /
         SUM(CAST(sales AS DECIMAL(10,2)))) * 100,
    2) AS profit_margin
FROM sales_data
GROUP BY sub_category
ORDER BY total_sales DESC
LIMIT 10;


WITH sales_cte AS (
    SELECT 
        sub_category,
        category,
        SUM(CAST(sales AS DECIMAL(10,2))) AS total_sales
    FROM sales_data
    GROUP BY category, sub_category
)

SELECT 
    sub_category,
    category,
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER (
        PARTITION BY category 
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM sales_cte;
	