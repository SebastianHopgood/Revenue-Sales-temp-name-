/*
Query Description:
Calculates the total revenue for each product category and identifies 
the top 5 performers
*/

SELECT
  dp.product_category_name,

  -- Calculates total revenue per category and round for currency formatting
  ROUND(SUM(ofact.price),2) AS total_category_revenue

  -- Join orders_fact and dim_products 
FROM `olist-360-e-commerce.analytical_data.orders_fact` AS ofact
INNER JOIN `olist-360-e-commerce.analytical_data.dim_products` AS dp
  ON ofact.product_id = dp.product_id

-- Sort the data by categories from highest to lowest revenue
GROUP BY dp.product_category_name
ORDER BY total_category_revenue DESC

-- Only show top 5 highest revenue categories
LIMIT 5;
