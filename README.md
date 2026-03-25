# olist_project
Milestone 1



Explanation of the Query 1
first_purchase CTE: Determines each customer’s first order and assigns them to a cohort by month.
subsequent_orders CTE: Finds all orders after the first purchase and calculates how many days after the first order they happened.
retention_counts CTE: Aggregates the number of customers in each cohort who made a repeat purchase within 30, 60, and 90 days.
Final SELECT: Converts counts into percentage retention per cohort.
This query chains 3 CTEs, involves multiple joins/aggregations, and answers a clear business question.
