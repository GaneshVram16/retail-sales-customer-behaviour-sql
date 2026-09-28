# Retail Sales & Customer Behaviour Analysis — SQL

A portfolio project built to answer realistic e-commerce business questions with **MySQL 8+**.

## Business questions
- How is revenue trending month by month?
- Which product categories contribute the most revenue?
- Which customer segments have the highest order value?
- How much do late deliveries affect customer reviews?
- What share of customers place repeat orders?
- Which channels and products perform best?

## Dataset
Synthetic but realistic e-commerce data generated specifically for this project.

- 8,000 customers
- 120 products
- 30,000 orders
- 68,435 order-line records
- 2025 transaction period

Synthetic data is used so the repository is fully reproducible and contains no private customer information.

## SQL skills demonstrated
`JOIN`, `GROUP BY`, `CASE`, CTEs, subqueries, aggregations, window functions, ranking, date grouping and KPI calculations.

## Selected findings
- Total simulated revenue: **₹180,387,073**
- Highest-revenue category: **Electronics** (50.4% of revenue)
- Late-delivery rate: **44.2%**
- Average review score for on-time orders: **3.96/5**
- Average review score for late orders: **2.63/5**
- Repeat-customer rate among purchasing customers: **91.3%**

## Repository structure
```text
sql/01_schema.sql
sql/02_analysis_queries.sql
generate_data.py
sample_data/
outputs/
README.md
```

## How to run
1. Run `generate_data.py` to create the synthetic CSV tables.
2. Create a MySQL database using `sql/01_schema.sql`.
3. Import the generated CSV files into the corresponding tables.
4. Run `sql/02_analysis_queries.sql` in MySQL Workbench.

## Portfolio note
The dataset is synthetic. The analysis, queries, metrics and findings are original work created for this portfolio.