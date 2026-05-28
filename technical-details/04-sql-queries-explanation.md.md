Sales Performance \& Profitability Insights





**Project Overview**



This project analyzes sales performance, profitability, and product/category behavior using SQL.

It focuses on identifying high-performing and underperforming business segments, discount impact, and revenue concentration across regions and product categories.







**1. Category-Level Sales \& Profitability Analysis**



SELECT

&#x20;   category,

&#x20;   ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total\_sales,

&#x20;   ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total\_profit,

&#x20;   ROUND(

&#x20;       (SUM(CAST(profit AS DECIMAL(10,2))) /

&#x20;        NULLIF(SUM(CAST(sales AS DECIMAL(10,2))), 0)) \* 100,

&#x20;   2) AS profit\_margin

FROM sales\_data

GROUP BY category

ORDER BY profit\_margin DESC;





**Business Insight:**



This query evaluates which product categories generate the highest profit efficiency.

It helps identify categories that are revenue-heavy but may not be profitable, enabling better strategic decisions on pricing and product focus.







**2. Sub-Category Risk Analysis (High Sales, Low Profit)**



SELECT

&#x20;   sub\_category,

&#x20;   ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total\_sales,

&#x20;   ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total\_profit,

&#x20;   ROUND(

&#x20;       (SUM(CAST(profit AS DECIMAL(10,2))) /

&#x20;        NULLIF(SUM(CAST(sales AS DECIMAL(10,2))), 0)) \* 100,

&#x20;   2) AS profit\_margin

FROM sales\_data

GROUP BY sub\_category

HAVING

&#x20;   SUM(CAST(sales AS DECIMAL(10,2))) >

&#x20;       (SELECT AVG(CAST(sales AS DECIMAL(10,2))) FROM sales\_data)

&#x20;   AND

&#x20;   (SUM(CAST(profit AS DECIMAL(10,2))) /

&#x20;    NULLIF(SUM(CAST(sales AS DECIMAL(10,2))), 0)) < 0.05

ORDER BY profit\_margin;





**Business Insight:**



This query identifies sub-categories with above-average sales but poor profitability.

These are potential “hidden loss drivers” where pricing, discounting, or operational inefficiencies may exist.







**3. Discount Impact on Sales \& Profit**



SELECT

&#x20;   discount,

&#x20;   ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total\_sales,

&#x20;   ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total\_profit,

&#x20;   ROUND(

&#x20;       (SUM(CAST(profit AS DECIMAL(10,2))) /

&#x20;        SUM(CAST(sales AS DECIMAL(10,2)))) \* 100,

&#x20;   2) AS profit\_margin

FROM sales\_data

GROUP BY discount

ORDER BY discount;





**Business Insight:**



This analysis shows how different discount levels impact profitability.

It helps businesses optimize discount strategies to maximize revenue without eroding margins.







**4. Regional Sales Contribution by Category**



SELECT

&#x20;   region,

&#x20;   category,

&#x20;   ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS category\_sales,

&#x20;

&#x20;   ROUND(

&#x20;       SUM(SUM(CAST(sales AS DECIMAL(10,2))))

&#x20;       OVER (PARTITION BY region),

&#x20;   2) AS region\_total\_sales,



&#x20;   ROUND(

&#x20;       (SUM(CAST(sales AS DECIMAL(10,2))) /

&#x20;        SUM(SUM(CAST(sales AS DECIMAL(10,2)))) OVER (PARTITION BY region)) \* 100,

&#x20;   2) AS dependency\_percent

FROM sales\_data

GROUP BY region, category;





**Business Insight:**



This query highlights how much each category contributes to total regional sales.

It helps identify regional dependency on specific product categories and supports diversification strategies.





**5. Top 10 Sub-Categories by Sales**



SELECT

&#x20;   sub\_category,

&#x20;   ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total\_sales,

&#x20;   ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total\_profit,

&#x20;   ROUND(

&#x20;       (SUM(CAST(profit AS DECIMAL(10,2))) /

&#x20;        SUM(CAST(sales AS DECIMAL(10,2)))) \* 100,

&#x20;   2) AS profit\_margin

FROM sales\_data

GROUP BY sub\_category

ORDER BY total\_sales DESC

LIMIT 10;





**Business Insight:**



This identifies the highest revenue-generating sub-categories, helping prioritize inventory planning, marketing focus, and supply chain allocation.









**6. Product Ranking Within Categories**



WITH sales\_cte AS (

&#x20;   SELECT

&#x20;       sub\_category,

&#x20;       category,

&#x20;       SUM(CAST(sales AS DECIMAL(10,2))) AS total\_sales

&#x20;   FROM sales\_data

&#x20;   GROUP BY category, sub\_category

)



SELECT

&#x20;   sub\_category,

&#x20;   category,

&#x20;   ROUND(total\_sales, 2) AS total\_sales,

&#x20;   RANK() OVER (

&#x20;       PARTITION BY category

&#x20;       ORDER BY total\_sales DESC

&#x20;   ) AS sales\_rank

FROM sales\_cte;





**Business Insight:**



This query ranks sub-categories within each category based on sales performance.

It helps identify top-performing products within each business segment for strategic focus.

