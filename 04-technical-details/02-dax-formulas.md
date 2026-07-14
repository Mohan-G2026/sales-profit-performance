**DAX formulas for Sales Performance and Profitability Analysis**





1\. Total Sales = SUM(Fact\_Sales\[Sales])



2\. Total Profit = SUM(Fact\_Sales\[Profit])



3\. Profit Margin % = DIVIDE(\[Total Profit], \[Total Sales],0)



4\. Discount Amount = SUMX(

&#x20;   Fact\_Sales,

&#x20;   Fact\_Sales\[Sales] \* Fact\_Sales\[Discount]

)



5\. Weighted Discount % = DIVIDE(\[Discount Amount], SUM(Fact\_Sales\[Sales]))



6\. Category % of Region =

DIVIDE(

&#x20;   SUM(Fact\_Sales\[Sales]),

&#x20;   CALCULATE(

&#x20;       SUM(Fact\_Sales\[Sales]),

&#x20;       ALL(Fact\_Sales),

&#x20;       VALUES(Dim\_Location\[Region])

&#x20;   )

)



7\. Cumulative % =

VAR CurrentRank =

&#x20;   RANKX(ALL(Dim\_Product\[Sub-Category]), \[Total Sales], , DESC)

RETURN

DIVIDE(

&#x20;   CALCULATE(

&#x20;       \[Total Sales],

&#x20;       FILTER(

&#x20;           ALL(Dim\_Product\[Sub-Category]),

&#x20;           RANKX(ALL(Dim\_Product\[Sub-Category]), \[Total Sales], , DESC) <= CurrentRank

&#x20;       )

&#x20;   ),

&#x20;   CALCULATE(\[Total Sales], ALL(Dim\_Product))

)

