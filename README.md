# Transaction Data Cleaning and Exploratory Data Analysis

## Overview
This project focuses on cleaning and analyzing a transaction dataset containing 10,000 records. The objective was to transform raw, inconsistent data into a reliable format and investigate factors influencing transaction success and failure.

---

## Dataset
The dataset contains transaction-level information including:
- Transaction ID  
- Transaction amount  
- Card type  
- Transaction status  
- Timestamp  

---

## Data Cleaning

The dataset contained several data quality issues that were addressed:

Invalid numerical values such as -1, -5000, and -999999 were identified in the `amount` column. These values did not reflect realistic transactions and were treated as placeholder or error values. They were converted to NULL.

Transactions with an amount of zero were also considered non-meaningful and converted to NULL.

Categorical inconsistencies were resolved by standardizing values in the `status` column (e.g. "SUCCESS", "success", "failed") and correcting errors in the `card_type` column (e.g. "MastCard" to "MasterCard").

Duplicate analysis showed repeated transaction IDs but no full-row duplicates, indicating valid multiple transactions rather than redundant records.

---

## Exploratory Data Analysis

The analysis aimed to identify factors influencing transaction outcomes.

The dataset showed a high failure rate, with 53.66% of transactions failing and 46.34% succeeding.

Transaction amount distribution was heavily skewed toward high values, with a large number of transactions exceeding 100,000 and over 2,000 transactions above 1,000,000. Despite this, failure rates remained consistent across all amount ranges, indicating that transaction size does not significantly influence outcomes.

Card type analysis revealed similar failure rates across all payment methods, suggesting that no specific card type contributes disproportionately to failures.

Time-based analysis showed that transaction outcomes remained consistent across different hours of the day, indicating that time is not a significant factor.

Missing values introduced during cleaning were also analyzed. Their distribution closely matched the overall dataset, indicating that missing data does not influence transaction success or failure.

---

## Key Insight

Transaction failures are consistent across all variables analyzed, including amount, card type, time, and data completeness. This suggests that transaction outcomes are not driven by individual features, but rather reflect a broader systemic issue or uniformly distributed behavior in the dataset.

---

## Tools Used
- SQL (MySQL)

---

## Project Structure

