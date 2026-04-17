/*
SCRIPT: Create Products Dimension Table
PURPOSE: Normalizes product data and translates categories from Portuguese to English
*/

CREATE OR REPLACE TABLE `olist-360-e-commerce.analytical_data.dim_products` AS

SELECT
  -- Unique identifier for joining with the Fact table
  sp.product_id AS product_id,
  /*
  -- DATA TRANSFORMATION: Language Translation
  -- Uses COALESCE to prioritize English translations while falling back to 
  the original Portuguese category name if a translation is unavailable
  -- This ensures zero data loss while improving readability for English-speaking stakeholders
  */
  COALESCE(nt.product_category_name_english, sp.product_category_name) AS product_category_name

FROM `olist-360-e-commerce.staged_data.staged_products` AS sp

-- Joins the translation lookup table using the Portuguese category name as the common key
LEFT JOIN `olist-360-e-commerce.staged_data.staged_category_name_translation` AS nt
  ON sp.product_category_name = nt.product_category_name_portuguese

/* 
NOTE ON DATA PRUNING: 
To optimize table performance and focus on stakeholder requirements, 
several non-essential columns were removed, including:
- Metadata (Product name/description length, photo quantity)
- Physical Dimensions (Weight, length, height, width)
This ensures a lean dimension table optimized for category-level sales analysis.
*/