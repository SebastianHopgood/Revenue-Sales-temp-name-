/*
SCRIPT: Create Date Dimension Table (Calendar Table)
PURPOSE: Generates a continuous calendar to support time-series analysis and MoM growth
*/

CREATE OR REPLACE TABLE `olist-360-e-commerce.analytical_data.dim_date` AS

SELECT
  -- Primary Key: Clean date format to join with Fact table timestamps
  date AS date_key,
  -- Time Attributes: Extracted for granular filtering (Year, Quarter, Month, Day)
  EXTRACT(YEAR FROM date) AS year,
  -- YEAR-MONTH STRING: Essential for calculating Month-over-Month (MoM) growth 
  -- and creating clean chronological labels for dashboard visualizations
  FORMAT_DATE('%Y-%m', date) AS year_month,

  EXTRACT(QUARTER FROM date) AS quarter,
  FORMAT_DATE('%b', date) AS month_abv,  -- Abbreviated name (e.g., Jan, Feb)
  EXTRACT(MONTH FROM date) AS month_number, -- Used for logical sorting
  EXTRACT(DAY FROM date) AS day,

  -- WEEKDAY LOGIC:
  FORMAT_DATE('%A', date) AS day_of_week_name,

  -- CUSTOM BUSINESS LOGIC: Monday-Start Week
  -- Shifts BigQuery's default Sunday-start (1) to a Monday-start (1) 
  -- to align with standard business reporting cycles
  1 + MOD(EXTRACT(DAYOFWEEK FROM date) + 5, 7) AS day_of_week_number_starting_monday,

  -- BOOLEAN FLAG: Weekend vs. Weekday
  -- Facilitates analysis of customer behavior and delivery performance 
  -- differences between business days and weekends
  CASE WHEN EXTRACT(DAYOFWEEK FROM date) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend

FROM
  -- Generates a continuous range to account for days with zero sales volume
  UNNEST(GENERATE_DATE_ARRAY('2016-01-01', '2018-12-31', INTERVAL 1 DAY)) AS date

/* 
NOTE ON ANALYTICAL VALUE: 
A dedicated Date Dimension is superior to raw timestamps as it allows for 
complex time intelligence (like Year-to-Date or MoM) without the high 
computational cost of repeated formatting within analysis queries
*/