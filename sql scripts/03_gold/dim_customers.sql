/*
SCRIPT: Create Customers Dimension Table
PURPOSE: Standardizes customer attributes for demographic and logistics analysis
*/

CREATE OR REPLACE TABLE `olist-360-e-commerce.analytical_data.dim_customers` AS

SELECT
  -- Primary Key: Unique ID per order/transaction
  customer_id,

  -- NATURAL KEY: Represents a unique physical customer across multiple orders
  -- Essential for calculating retention rates and Customer Lifetime Value (CLV)
  customer_unique_id,

  -- GEOGRAPHIC KEYS:
  -- Zip prefix used as the join key for spatial analysis with the Geolocation table
  customer_zip_code_prefix,

  -- City and State attributes for regional logistics and market-share reporting
  customer_city,
  customer_state
FROM `olist-360-e-commerce.staged_data.staged_customers`

/* 
NOTE ON DATA LAYERING: 
This table is promoted from 'Staged' to 'Analytical' to serve as a 
verified, production-ready dimension in the Star Schema. It provides the 
necessary location data to solve Logistics and Strategy SMART questions
*/