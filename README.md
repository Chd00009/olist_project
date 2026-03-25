# olist_project
IENG-331 
Milestone 1
Author: Chris D'Antonio  
Date: March 2026  

---

## Project Overview/Objective

Explore the Olist dataset and write thoughtful, multi-step
SQL analyses that answer real business questions. Everything runs in DuckDB’s CLI.
No Python, no parameterization — just you and SQL.
Explore an unfamiliar dataset, formulate meaningful business questions, and answer
them with well-structured SQL queries in DuckDB. No Python — this milestone is pure
SQL, run from the DuckDB CLI

---

## 1. Data Quality Audit

-- Business Question:
-- How reliable and complete is the Olist dataset, and are there any anomalies 
-- (missing values, orphaned foreign keys, duplicates, or gaps in date coverage) 
-- that could affect downstream analysis?

-- Approach:
-- 1. Row Counts
-- 2. NULL Rate for Key Columns
-- 3. Orphaned Foreign Keys
-- 4. Date Coverage
-- 5. Duplicates

---

## 2. Cohort Retention Analysis

-- Business Question:
-- Which customer cohorts retain the most over 30, 60, and 90 days after their first purchase?

-- Approach:
-- 1. Identify each customer's first purchase date.
-- 2. For each subsequent order, calculate days since the first purchase.
-- 3. Aggregate by cohort (first purchase month) and calculate the % of customers 
--   who placed a second order within 30, 60, and 90 days.
-- 4. Use multiple CTEs to build intermediate tables for clarity and maintainability.

---

## 3. Seller Performance Scorecard

-- Business question: 
-- Which states consistently receive orders faster or slower than estimated delivery times?

-- Approach: 
-- 1. Join orders → customers → geolocation for regional info.
-- 2. Calculate delivery delays per order.
-- 3. Aggregate delays per state and rank states by average delay.

---

## 4. ABC Inventory Classification

-- Business question:
-- Classify products into A/B/C tiers based on revenue contribution (Pareto principle).

-- Approach:
-- 1. Calculate total revenue per product.
-- 2. Compute cumulative revenue and percent of total revenue using window functions.
-- 3. Assign ABC class: A (top 80%), B (next 15%), C (bottom 5%).

---

## 5. Delivery Time Analysis By Geography

-- Business question:
-- Identify regions where deliveries are consistently faster or slower than estimated.

-- Approach:
-- 1. Join orders -> customers -> geolocation for regional info
-- 2. Compute delivery delay (days actual vs estimated)
-- 3. Aggregate by customer_state and optionally customer_city
-- 4. Rank states by average delay to find consistent over/under-delivery regions

---

## Repository Structure

```text
/olist_project
 ├─ olist.duckdb
 ├─ sql/
 │   ├─ query1_data_quality.sql
 │   ├─ query2_customer_retention.sql
 │   ├─ query3_seller_scorecard.sql
 │   ├─ query4_abc_classification.sql
 │   └─ query5_time_analysis.sql
 └─ README.md
