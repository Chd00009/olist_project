# Milestone 1 Grade

| Criterion | Score | Max |
|-----------|------:|----:|
| Data Quality Audit | 3 | 3 |
| Query Depth & Correctness | 3 | 3 |
| Business Reasoning & README | 2 | 3 |
| Git Practices | 2 | 3 |
| Code Walkthrough | 3 | 3 |
| **Total** | **13** | **15** |

## Data Quality Audit (3/3)

`query1_data_quality.sql` is a thorough, systematic audit organized into five clearly labeled sections, each using a CTE: (1) row counts across all 9 tables, (2) NULL rates on key columns using `COUNT(*) FILTER (WHERE ...)`, (3) orphaned foreign key checks across orders→customers, order_items→orders, and order_payments→orders via LEFT JOIN anti-patterns, (4) date range coverage for `order_purchase_timestamp`, and (5) duplicate detection on `customer_id`. All sections execute cleanly and cover the major data integrity concerns.

## Query Depth & Correctness (3/3)

All four analysis queries execute without errors against the instructor's database.

- **query2_customer_retention.sql**: 3 CTEs (`first_purchase`, `subsequent_orders`, `retention_counts`). Uses `DATE_TRUNC`, `DATEDIFF`, `MIN` aggregation, `COUNT(DISTINCT CASE WHEN ...)` for multi-window retention rates. Returns 0 rows because Olist customers almost never place a second order — correct behavior, not a query defect.
- **query3_seller_scorecard.sql**: 3 CTEs (`order_locations`, `delivery_times`, `region_summary`). Uses multi-table JOIN with `USING`, `DATEDIFF`, aggregation, and `RANK() OVER (ORDER BY ...)` window function.
- **query4_abc_classification.sql**: 3 CTEs (`product_revenue`, `revenue_cumsum`, `product_classification`). Uses `SUM() OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING)` for cumulative revenue, `SUM() OVER ()` for grand total, and a `CASE` expression for Pareto-based A/B/C tier assignment.
- **query5_time_analysis.sql**: 3 CTEs (`order_locations`, `delivery_times`, `region_summary`). Uses `RANK() OVER (PARTITION BY customer_state ORDER BY avg_delay DESC)` for within-state city ranking, extending the state-level analysis of query3 to city granularity.

All queries use joins, aggregation, and window functions. Multiple queries hit the 3-CTE threshold.

## Business Reasoning & README (2/3)

Business questions are specific and meaningful: cohort retention windows, ABC inventory classification, and geographic delivery performance are all operationally relevant. The approach sections in each file and in the README are clear and accurate. However, the README essentially duplicates the SQL file headers verbatim — there are no findings (e.g., "retention is near zero, suggesting one-time buyer behavior"), no discussion of limitations (e.g., the geolocation join fans out rows due to duplicate zip codes), and no alternatives considered. The narrative stops at "here is what the queries do" rather than "here is what we learned."

## Git Practices (2/3)

37 commits with a clear progression: initial commit → file creation → iterative updates → rename/reorganization pass → final README update. The history shows genuine incremental development. Commit messages are generic web-editor defaults ("Create X.sql", "Update X.sql", "Rename X to Y") with no semantic content about what changed or why. The delete-and-recreate cycle mid-history (commits 421043c–ba182a6) suggests some reorganization confusion, but the overall structure is logical.
