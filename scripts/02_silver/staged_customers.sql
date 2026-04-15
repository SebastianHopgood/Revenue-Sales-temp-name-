/* 
Logic Overview:
  - Data Refinement: Standardize raw e-commerce data into a cleaned Silver-layer table.
  - Primary Keys: Standardize IDs (LOWER/TRIM) to ensure 100% join compatibility across tables.
  - String Normalization: Apply consistent casing (UPPER for states, INITCAP for cities) and 
    remove special character noise to improve dashboard readability.
  - Schema Enforcement: Use SAFE_CAST to strictly define data types (STRING, INT64) 
    and handle potential raw data corruption.
  - Deduplication: Ensure record uniqueness to prevent inflated customer metrics.
*/

CREATE OR REPLACE TABLE `olist-360-e-commerce.staged_data.staged_customers` AS

SELECT
  -- IDs are are converted to STRING, stripped of unnecessary spacing, and forced-lowered to prevent case-sensitivity issues during joins
  SAFE_CAST(LOWER(TRIM(customer_id)) AS STRING) AS customer_id,

  -- Customer duplicate IDs are converted to STRING, stripped of unnecessary spacing, and forced-lowered to prevent case-sensitivity issues during joins
  SAFE_CAST(LOWER(TRIM(customer_unique_id)) AS STRING) AS customer_unique_id,

  -- Zip codes are converted to INT64; note that leading zeros will be dropped
  SAFE_CAST(customer_zip_code_prefix AS INT64) AS customer_zip_code_prefix,

  -- Customer cities are converted to STRING, cleanned of any special characters, stripped of unnecessary spacing, and formatted as title casing (INITCAP)
  SAFE_CAST(INITCAP(REGEXP_REPLACE(TRIM(customer_city), r'[^\p{L}\s]', '')) AS STRING) AS customer_city,

  -- Customer states are converted to STRING, stripped of unnecessary spacing, and formatted as uppercase (e.g. NY)
  SAFE_CAST(UPPER(TRIM(customer_state)) AS STRING) AS customer_state
FROM `olist-360-e-commerce.raw_data.raw_olist_customers`

