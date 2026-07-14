**Sales Performance \& Profitability Insights**





**Project Overview**



This project analyzes sales performance, profitability, and product/category behavior using SQL.

It focuses on identifying high-performing and underperforming business segments, discount impact, and revenue concentration across regions and product categories.







**1. Category-Level Sales \& Profitability Analysis**





**SQL Query:**



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





**Output:**



**category	total\_sales	total\_profit	profit\_margin**

Technology	836154.1	145455.66	17.4

Office Supplies	718735.21	122364.75	17.03

Furniture	741306.5	18421.79	2.49





**Business Insight:**



This query evaluates which product categories generate the highest profit efficiency.

It helps identify categories that are revenue-heavy but may not be profitable, enabling better strategic decisions on pricing and product focus.









**2. Sub-Category Risk Analysis (High Sales, Low Profit)**





**SQL Query:**



SELECT

&#x20;   subcategory,

&#x20;   ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total\_sales,

&#x20;   ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total\_profit,

&#x20;   ROUND(

&#x20;       (SUM(CAST(profit AS DECIMAL(10,2))) /

&#x20;        NULLIF(SUM(CAST(sales AS DECIMAL(10,2))), 0)) \* 100,

&#x20;   2) AS profit\_margin

FROM sales\_data

GROUP BY subcategory

HAVING

&#x20;   SUM(CAST(sales AS DECIMAL(10,2))) >

&#x20;       (SELECT AVG(CAST(sales AS DECIMAL(10,2))) FROM sales\_data)

&#x20;   AND

&#x20;   (SUM(CAST(profit AS DECIMAL(10,2))) /

&#x20;    NULLIF(SUM(CAST(sales AS DECIMAL(10,2))), 0)) < 0.05

ORDER BY profit\_margin;





**Output:**



**subcategory	total\_sales	total\_profit	profit\_margin**

Tables	        206965.68	-17725.59	-8.56

Bookcases	114880.05	-3472.56	-3.02

Supplies	46673.52	-1188.99	-2.55

Machines	189238.68	 3384.73	 1.79





**Business Insight:**



This query identifies subcategories with above-average sales but poor profitability.

These are potential “hidden loss drivers” where pricing, discounting, or operational inefficiencies may exist.







**3. Discount Impact on Sales \& Profit**





**SQL Query:**



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





**Output:**



**discount	total\_sales	total\_profit	profit\_margin**

0	        1087277.56	 320844.68	 29.51

0.1	        54369.3	         9029.21	 16.61

0.15	        27558.59	 1418.98	 5.15

0.2	        764504.86	 90307.47	 11.81

0.3	        102945.39	-10357.28	-10.06

0.32	        14493.45	-2391.16	-16.5

0.4	        116417.83	-23057.08	-19.81

0.45	        5484.98	        -2493.12	-45.45

0.5	        58918.65	-20506.51	-34.8

0.6	        6644.68	        -5944.64	-89.46

0.7	        40620.4	        -40075.46	-98.66

0.8	        16960.12	-30532.89	-180.03





**Business Insight:**



This analysis shows how different discount levels impact profitability.

It helps businesses optimize discount strategies to maximize revenue without eroding margins.







**4. Regional Sales Contribution by Category**





**SQL Query:**



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





**Output:**



**region	category	category\_sales	region\_total\_sales	dependency\_percent**

Central	Technology	170416.29	500782.85	        34.03

Central	Office Supplies	166959.27	500782.85	        33.34

Central	Furniture	163407.29	500782.85	        32.63

East	Office Supplies	205451.48	678435.32	        30.28

East	Furniture	208009.8	678435.32	        30.66

East	Technology	264974.04	678435.32	        39.06

South	Technology	148771.91	391721.9	        37.98

South	Office Supplies	125651.31	391721.9	        32.08

South	Furniture	117298.68	391721.9	        29.94

West	Technology	251991.86	725255.74	        34.75

West	Furniture	252590.73	725255.74	        34.83

West	Office Supplies	220673.15	725255.74	        30.43





**Business Insight:**



This query highlights how much each category contributes to total regional sales.

It helps identify regional dependency on specific product categories and supports diversification strategies.







**5. Top 10 Subcategories by Sales**





**SQL Query:**



SELECT

&#x20;   subcategory,

&#x20;   ROUND(SUM(CAST(sales AS DECIMAL(10,2))), 2) AS total\_sales,

&#x20;   ROUND(SUM(CAST(profit AS DECIMAL(10,2))), 2) AS total\_profit,

&#x20;   ROUND(

&#x20;       (SUM(CAST(profit AS DECIMAL(10,2))) /

&#x20;        SUM(CAST(sales AS DECIMAL(10,2)))) \* 100,

&#x20;   2) AS profit\_margin

FROM sales\_data

GROUP BY subcategory

ORDER BY total\_sales DESC

LIMIT 10;





**Output:**



**subcategory	total\_sales	total\_profit	profit\_margin**

Phones	        330007.1	 44516.25	 13.49

Chairs	        327777.79	 26567.11	 8.11

Storage	        223843.59	 21279.05	 9.51

Tables	        206965.68	-17725.59	-8.56

Binders	        203409.21	 30227.88	 14.86

Machines	189238.68	 3384.73	 1.79

Accessories	167380.31	 41936.78	 25.05

Copiers	        149528.01	 55617.9	 37.2

Bookcases	114880.05	-3472.56	-3.02

Appliances	107532.14	 18138.07	 16.87





**Business Insight:**



This identifies the highest revenue-generating subcategories, helping prioritize inventory planning, marketing focus, and supply chain allocation.







**6. Product Ranking Within Categories**





**SQL Query:**



WITH sales\_cte AS (

&#x20;   SELECT

&#x20;       subcategory,

&#x20;       category,

&#x20;       SUM(CAST(sales AS DECIMAL(10,2))) AS total\_sales

&#x20;   FROM sales\_data

&#x20;   GROUP BY category, subcategory

)



SELECT

&#x20;   subcategory,

&#x20;   category,

&#x20;   ROUND(total\_sales, 2) AS total\_sales,

&#x20;   RANK() OVER (

&#x20;       PARTITION BY category

&#x20;       ORDER BY total\_sales DESC

&#x20;   ) AS sales\_rank

FROM sales\_cte;





**Output:**



**subcategory	category	total\_sales	sales\_rank**

Chairs	        Furniture	327777.79	1

Tables	        Furniture	206965.68	2

Bookcases	Furniture	114880.05	3

Furnishings	Furniture	91682.98	4

Storage	        Office Supplies	223843.59	1

Binders	        Office Supplies	203409.21	2

Appliances	Office Supplies	107532.14	3

Paper	        Office Supplies	78224.18	4

Supplies	Office Supplies	46673.52	5

Art	        Office Supplies	27107.04	6

Envelopes	Office Supplies	16476.38	7

Labels	        Office Supplies	12444.9	        8

Fasteners	Office Supplies	3024.25	        9

Phones	        Technology	330007.1	1

Machines	Technology	189238.68	2

Accessories	Technology	167380.31	3

Copiers	        Technology	149528.01	4





**Business Insight:**



This query ranks subcategories within each category based on sales performance.

It helps identify top-performing products within each business segment for strategic focus.

