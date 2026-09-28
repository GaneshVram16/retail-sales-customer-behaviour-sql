# Project walkthrough

## Problem
Use transactional e-commerce data to answer commercial questions about revenue, customer behaviour, delivery performance and product mix.

## Workflow
1. Generate five related tables.
2. Load them into MySQL.
3. Validate primary/foreign-key relationships.
4. Use joins and aggregations for baseline KPIs.
5. Use CTEs and window functions for customer ranking and repeat-customer analysis.
6. Compare delivery status with review scores.
7. Convert query results into business findings.

## What to explain in a discussion
- Why the data is relational instead of one flat table.
- Difference between an inner join and a left join.
- Why CTEs improve readability.
- How window functions rank customers without collapsing rows.
- Why correlation between late delivery and lower ratings is useful but does not prove causation.

## Limitations
The dataset is synthetic. The project demonstrates SQL and analytical reasoning rather than a real company's performance.
