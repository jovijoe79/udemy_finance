	-- DATA CLEANING

SELECT *
FROM udemy_output_all_finance_accounting;

CREATE TABLE `udemy_output_all_finance_accounting_staging` (
  `id` int DEFAULT NULL,
  `title` text,
  `url` text,
  `is_paid` text,
  `num_subscribers` int DEFAULT NULL,
  `avg_rating` double DEFAULT NULL,
  `avg_rating_recent` double DEFAULT NULL,
  `rating` double DEFAULT NULL,
  `num_reviews` int DEFAULT NULL,
  `is_wishlisted` text,
  `num_published_lectures` int DEFAULT NULL,
  `num_published_practice_tests` int DEFAULT NULL,
  `created` text,
  `published_time` text,
  `discount_price_amount` int DEFAULT NULL,
  `discount_price_currency` text,
  `discount_price_price_string` text,
  `price_detail_amount` int DEFAULT NULL,
  `price_detail_currency` text,
  `price_detail_price_string` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO udemy_output_all_finance_accounting_staging
SELECT *
FROM udemy_output_all_finance_accounting;

SELECT *
FROM udemy_output_all_finance_accounting_staging;

WITH CTE AS
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY id, title, url, is_paid, num_subscribers, avg_rating, avg_rating_recent, rating, num_reviews, 
is_wishlisted, num_published_lectures, num_published_practice_tests, created, published_time, discount_price_amount, discount_price_currency, 
discount_price_price_string, price_detail_amount, price_detail_currency, price_detail_price_string) AS row_num
FROM udemy_output_all_finance_accounting_staging
)
SELECT *
FROM CTE
WHERE row_num > 1;

SELECT *
FROM udemy_output_all_finance_accounting_staging;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN url;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN is_paid;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN is_wishlisted;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN avg_rating;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN avg_rating_recent;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN num_published_lectures;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN num_published_practice_tests;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN discount_price_currency;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN discount_price_price_string;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN price_detail_currency;

ALTER TABLE udemy_output_all_finance_accounting_staging
DROP COLUMN price_detail_price_string;

SELECT *
FROM udemy_output_all_finance_accounting_staging;

SELECT *
FROM udemy_output_all_finance_accounting_staging
WHERE price_detail_amount IS NULL;

-- EXPLORATORY ANALYSIS
-- 1) CREATE A NEW COL TO GET MONEY_SAVED
-- 2) CREATE ANOTHER COL FOR CONDITIONS BASED ON MONEY_SAVED
-- 3) Round rating to 2dp
-- 1)
CREATE TABLE `udemy_output_all_finance_accounting_staging_2` (
  `id` int DEFAULT NULL,
  `title` text,
  `num_subscribers` int DEFAULT NULL,
  `rating` double DEFAULT NULL,
  `num_reviews` int DEFAULT NULL,
  `created` text,
  `published_time` text,
  `discount_price_amount` int DEFAULT NULL,
  `price_detail_amount` int DEFAULT NULL,
  `Money_Saved` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO udemy_output_all_finance_accounting_staging_2
SELECT *, (price_detail_amount - discount_price_amount)
FROM udemy_output_all_finance_accounting_staging;

SELECT *
FROM udemy_output_all_finance_accounting_staging_2;

-- 2)
CREATE TABLE `udemy_output_all_finance_accounting_staging_3` (
  `id` int DEFAULT NULL,
  `title` text,
  `num_subscribers` int DEFAULT NULL,
  `rating` double DEFAULT NULL,
  `num_reviews` int DEFAULT NULL,
  `created` text,
  `published_time` text,
  `discount_price_amount` int DEFAULT NULL,
  `price_detail_amount` int DEFAULT NULL,
  `Money_Saved` int DEFAULT NULL,
  `Money_Saved_Strength` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO udemy_output_all_finance_accounting_staging_3
SELECT *, 
CASE
	WHEN Money_Saved < 2000 THEN 'Poor'
    WHEN Money_Saved BETWEEN 2000 AND 4000 THEN 'Low'
    WHEN Money_Saved BETWEEN 4000 AND 6000 THEN 'Fair'
    WHEN Money_Saved BETWEEN 6000 AND 8000 THEN 'Good'
    ELSE 'Strong'
END AS Money_Saved_Strength
FROM udemy_output_all_finance_accounting_staging_2;

SELECT *
FROM udemy_output_all_finance_accounting_staging_3;

-- 3) 
WITH CTE_2 AS 
(
SELECT *, ROUND(rating, 2) AS ratings
FROM udemy_output_all_finance_accounting_staging_3
)
UPDATE udemy_output_all_finance_accounting_staging_3
JOIN CTE_2
	ON udemy_output_all_finance_accounting_staging_3.id = CTE_2.id
SET udemy_output_all_finance_accounting_staging_3.rating = CTE_2.ratings;



