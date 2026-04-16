/*
SCRIPT: Create Sellers Dimension Table
PURPOSE: Standardizes seller attributes for geographic and performance analysis
*/

CREATE OR REPLACE TABLE `olist-360-e-commerce.analytical_data.dim_sellers` AS

SELECT
  -- Primary Key for linking to the Fact table
  seller_id,

  -- GEOGRAPHIC KEYS: Used for spatial analysis and mapping
  -- Zip code prefix is kept to enable joining with the Geolocation table
  seller_zip_code_prefix,

  -- State-level attribute for high-level regional performance metrics
  -- Used specifically to identify seller distribution across Brazilian states
  seller_state
FROM `olist-360-e-commerce.staged_data.staged_sellers`

/* 
NOTE ON DATA CLEANING: 
Seller City was intentionally excluded due to significant data quality issues 
(3,000+ inconsistent naming variations). Standardizing at the Zip Prefix 
and State level ensures higher data integrity for strategic mapping.
*/