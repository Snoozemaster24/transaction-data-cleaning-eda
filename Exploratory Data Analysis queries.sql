-- TRANSACTION DATA EXPLORATORY DATA ANALYSIS (EDA)


-- 1. DATASET OVERVIEW

-- Total number of records
SELECT COUNT(*) AS total_rows
FROM dirty_iranian_transactions_dataset.`trx-10k`;

-- Count of missing values in amount column
SELECT COUNT(*) AS missing_amount
FROM dirty_iranian_transactions_dataset.`trx-10k`
WHERE amount IS NULL;


-- 2. STATUS DISTRIBUTION

-- Count and percentage of transaction outcomes
SELECT status,
 COUNT(*) AS total, 
 ROUND(COUNT(*) * 100/ SUM(COUNT(*)) OVER (), 2) AS percentage
FROM dirty_iranian_transactions_dataset.`trx-10k`
GROUP BY status;


-- 3. AMOUNT STATISTICS


-- Basic statistics for transaction amounts

SELECT ROUND(AVG(amount), 2) AS avg_amount,
	   MAX(amount) AS max_amount,
       MIN(amount) AS min_amount
FROM dirty_iranian_transactions_dataset.`trx-10k`
 WHERE amount IS NOT NULL;


-- 4. AMOUNT DISTRIBUTION

-- Grouping transactions into value ranges
SELECT 
  CASE 
    WHEN amount < 100000 THEN '0-100k'
    WHEN amount < 500000 THEN '100k-499k'
    WHEN amount < 1000000 THEN '500k-999k'
    ELSE '1M+'
  END AS amount_range,
  COUNT(*) AS total
FROM dirty_iranian_transactions_dataset.`trx-10k`
WHERE amount IS NOT NULL
GROUP BY amount_range
ORDER BY total DESC;


-- 5. AMOUNT VS TRANSACTION STATUS


-- Analysis of success/failure distribution within each amount range

SELECT status,
  CASE 
    WHEN amount < 100000 THEN '0-100k'
    WHEN amount < 500000 THEN '100k-499k'
    WHEN amount < 1000000 THEN '500k-999k'
    ELSE '1M+'
  END AS range_group,
  COUNT(*) AS total,
  ROUND(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (
      PARTITION BY 
        CASE 
          WHEN amount < 100000 THEN '0-100k'
          WHEN amount < 500000 THEN '100k-499k'
          WHEN amount < 1000000 THEN '500k-999k'
          ELSE '1M+'
        END
    ), 2
  ) AS percentage
FROM dirty_iranian_transactions_dataset.`trx-10k`
GROUP BY status, range_group
ORDER BY range_group;



-- 6. CARD TYPE ANALYSIS


-- Count of transactions by card type and status

SELECT card_type, status, COUNT(*) AS total
FROM dirty_iranian_transactions_dataset.`trx-10k`
GROUP BY card_type, status
ORDER BY card_type;



-- 7. TIME-BASED ANALYSIS

-- Transaction count by hour of day

SELECT HOUR(time) AS hour_of_day, COUNT(*) AS total_transactions
FROM dirty_iranian_transactions_dataset.`trx-10k`
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- Success vs failure by hour

SELECT HOUR(time) AS hour_of_day, status, COUNT(*) AS total
FROM dirty_iranian_transactions_dataset.`trx-10k`
GROUP BY hour_of_day, status
ORDER BY hour_of_day;

-- Percentage distribution within each hour

SELECT hour_of_day, status, COUNT(*) AS total, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY hour_of_day),2) AS percentage
FROM (
		SELECT HOUR(time) AS hour_of_day,status
		FROM dirty_iranian_transactions_dataset.`trx-10k`
	 ) t
GROUP BY hour_of_day, status
ORDER BY hour_of_day;


-- 8. MISSING VALUE ANALYSIS

-- Distribution of missing values by status

SELECT status, COUNT(*) AS total_missing, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM dirty_iranian_transactions_dataset.`trx-10k`
WHERE amount IS NULL
GROUP BY status;

-- Missing values within each status group

SELECT status, COUNT(CASE WHEN amount IS NULL THEN 1 END) * 100.0 / COUNT(*) AS pct_missing_within_status
FROM dirty_iranian_transactions_dataset.`trx-10k`
GROUP BY status;


-- 9. OUTLIER DETECTION


-- Identifying unusually high transactions (potential outliers)

SELECT *
FROM dirty_iranian_transactions_dataset.`trx-10k`
WHERE amount > (SELECT AVG(amount) * 3 
FROM dirty_iranian_transactions_dataset.`trx-10k`);

-- highest value transactions

SELECT *
FROM dirty_iranian_transactions_dataset.`trx-10k`
WHERE amount >= 1000000
ORDER BY amount DESC;



-- 10. SUMMARY CHECKS

-- Total success vs failure counts
SELECT 
  COUNT(*) AS total,
  SUM(CASE WHEN status = 'success' THEN 1 ELSE 0 END) AS success_count,
  SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed_count
FROM dirty_iranian_transactions_dataset.`trx-10k`;