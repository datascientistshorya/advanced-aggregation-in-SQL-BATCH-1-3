# SQL Advanced Aggregation — Business Analysis Practice

# Author Shorya Dev Bisht
https://www.linkedin.com/in/shorya-bisht-a20144349/

## Overview

This repository documents my hands-on practice with advanced SQL aggregation techniques using a synthetic e-commerce dataset.

The project focuses on transforming transactional order data into meaningful business insights across customers, products, categories, cities, revenue, order behavior, and customer segmentation.

Rather than treating SQL as only a querying language, this project applies SQL from a business-analyst perspective: defining the right metric, aggregating data at the correct business level, benchmarking performance, calculating contribution and completion rates, and handling edge cases such as zero denominators.

---

## Objectives

The primary objectives of this phase were to:

* Strengthen advanced aggregation skills in MySQL.
* Analyze customer, product, category, and city-level performance.
* Apply conditional aggregation to business metrics.
* Calculate revenue contribution and completion rates.
* Compare entities against business and category benchmarks.
* Build customer and product performance classifications.
* Practice CTE-based analytical query design.
* Handle division-by-zero scenarios safely.
* Develop a structured approach to translating business questions into SQL.
* Improve SQL reasoning rather than relying on memorized query patterns.

---

## Dataset

The project uses a synthetic online-store dataset containing three relational tables:

### `customers`

| Column          | Description                |
| --------------- | -------------------------- |
| `customer_id`   | Unique customer identifier |
| `customer_name` | Customer name              |
| `city`          | Customer city              |

### `orders`

| Column        | Description             |
| ------------- | ----------------------- |
| `order_id`    | Unique order identifier |
| `customer_id` | Customer reference      |
| `product_id`  | Product reference       |
| `amount`      | Order amount            |
| `status`      | Order status            |
| `order_date`  | Order date              |

### `products`

| Column         | Description               |
| -------------- | ------------------------- |
| `product_id`   | Unique product identifier |
| `product_name` | Product name              |
| `category`     | Product category          |
| `price`        | Product price             |

Relationships:

```text
customers
    |
    | customer_id
    v
orders
    |
    | product_id
    v
products
```

---

# Phase 6 — Advanced Aggregation

This phase contains 3 completed practice batches with 5 business-oriented SQL problems per batch.

Total completed questions: **15**

---

## Batch 1 — Aggregation & Business Metrics

### Q1 — Category Performance

Analyzed each product category using:

* Total orders
* Total revenue
* Average Order Value (AOV)
* Minimum order threshold using `HAVING`

### Q2 — Customer Revenue Contribution

Calculated:

* Customer spending
* Completed spending
* Contribution to overall completed revenue
* Revenue-based sorting

### Q3 — City-Level Performance

Analyzed cities using:

* Unique customers
* Completed orders
* Completed revenue
* Average completed order value
* Revenue-based ranking through sorting

### Q4 — Product Performance vs Category

Compared individual product performance against category-level revenue using:

* Product-level aggregation
* Category-level aggregation
* CTEs
* Revenue contribution percentages
* Multi-level aggregation

### Q5 — High-Value Customer Segmentation

Classified customers according to their completed-spending percentage:

* High Completion: >= 75%
* Medium Completion: 25% to <75%
* Low Completion: <25%

Techniques included conditional aggregation and `CASE`.

---

# Batch 2 — Comparative Analysis & Segmentation

### Q1 — Customer Order Behavior

Built customer-level metrics including:

* Total orders
* Completed orders
* Cancelled orders
* Total spending
* Completed revenue

### Q2 — Product Revenue & Order Mix

Analyzed product-level:

* Total orders
* Completed orders
* Cancelled orders
* Completed revenue
* Cancelled revenue

### Q3 — Category Completion Rate

Calculated category-level:

* Total orders
* Completed orders
* Cancelled orders
* Total revenue
* Completed revenue
* Completion rate

### Q4 — Customer Revenue Share

Measured the percentage of each customer's spending represented by completed orders and classified customers into:

* Strong
* Moderate
* Weak

### Q5 — Product Performance Within Category

Calculated each product's contribution to its category's completed revenue and classified products as:

* Dominant
* Significant
* Minor

This exercise reinforced the concept of calculating a benchmark at the same aggregation level as the business question.

---

# Batch 3 — Advanced Benchmarking & Revenue Analysis

### Q1 — Customer Revenue Mix by Product Category

Calculated customer-level completed revenue across:

* Electronics
* Furniture
* Other categories
* Total revenue

This exercise focused on conditional aggregation and product-category analysis.

### Q2 — Product Performance vs Category Average

Compared every product's completed revenue against the average completed revenue of products within its category.

Key techniques:

* CTEs
* Product-level aggregation
* Category-level benchmarking
* `AVG()`
* Difference calculations
* `LEFT JOIN` considerations for zero-order products

### Q3 — Customer Order Status Mix

Calculated:

* Total orders
* Completed orders
* Cancelled orders
* Completion rate
* Cancellation rate

Customers with no orders were retained using `LEFT JOIN`.

Safe division was implemented using:

```sql
NULLIF(denominator, 0)
```

### Q4 — Customer Revenue vs Overall Average

Identified customers whose completed revenue exceeded the average completed revenue per customer.

This reinforced an important analytical principle:

> The benchmark must be calculated at the same business level as the metric being compared.

### Q5 — Product Revenue Contribution

Calculated each product's contribution to overall completed revenue.

The exercise included:

* Product-level completed revenue
* Overall completed revenue
* Revenue contribution percentage
* Products with zero completed revenue

---

# Core SQL Techniques Practiced

## 1. Conditional Aggregation

Used extensively for calculating business metrics based on order status and product category.

```sql
SUM(
    CASE
        WHEN status = 'Completed'
        THEN amount
        ELSE 0
    END
)
```

This technique allows multiple business metrics to be generated from the same dataset.

---

## 2. `GROUP BY`

Applied aggregation at different analytical levels:

* Customer
* Product
* Category
* City

Choosing the correct grouping level was a major focus of this phase.

---

## 3. `HAVING`

Used to filter aggregated results after grouping.

Example:

```sql
HAVING total_orders >= 2
```

---

## 4. Common Table Expressions

CTEs were used to break complex analytical problems into logical stages.

Typical structure:

```sql
WITH customer_data AS (
    ...
),
benchmark AS (
    ...
)
SELECT ...
FROM customer_data;
```

This improved readability and made multi-level aggregation easier to reason about.

---

## 5. Multi-Level Aggregation

Several problems required aggregation at one level followed by another aggregation.

For example:

```text
Orders
   |
   v
Customer Revenue
   |
   v
Average Customer Revenue
   |
   v
Compare Customers Against Benchmark
```

This is particularly important in business analytics because the definition of an "average" depends on the unit of analysis.

---

## 6. Conditional Business Segmentation

`CASE` was used to convert numerical metrics into business categories.

Example:

```sql
CASE
    WHEN completion_rate >= 75 THEN 'High'
    WHEN completion_rate >= 25 THEN 'Medium'
    ELSE 'Low'
END
```

---

## 7. Revenue Contribution Analysis

Revenue contribution was calculated to understand how much each entity contributes to a larger business total.

```sql
revenue / total_revenue * 100
```

This was applied at customer, product, and category levels.

---

## 8. Safe Division

Business metrics such as conversion, completion, cancellation, and contribution rates can encounter zero denominators.

The project therefore introduced:

```sql
NULLIF(denominator, 0)
```

For example:

```sql
completed_orders
/
NULLIF(total_orders, 0)
* 100
```

This prevents division-by-zero errors.

---

## 9. Join Strategy

Different join types were selected according to the business requirement.

### `INNER JOIN`

Used when only records with matching transactional data were required.

### `LEFT JOIN`

Used when entities with no transactions needed to remain in the result.

For example, retaining products with zero completed revenue.

---

# Analytical Principles Learned

This phase reinforced several principles that go beyond SQL syntax.

### Metric definitions matter

"Average revenue" can mean very different things:

* Average order value
* Average customer revenue
* Average product revenue
* Average category revenue

The correct SQL depends on the business definition.

### Benchmark at the correct level

If the question asks:

> Customers above average customer revenue

the calculation should be:

```text
Orders
→ Customer Revenue
→ Average Customer Revenue
→ Customer Comparison
```

not simply:

```text
Average Order Amount
```

### Aggregation level determines the insight

The same transaction table can answer very different questions depending on whether the data is grouped by:

```text
Customer
Product
Category
City
```

Understanding the intended business entity is therefore essential before writing the query.

---

# Skills Demonstrated

* MySQL
* Advanced `GROUP BY`
* Aggregate functions
* `SUM()`
* `COUNT()`
* `COUNT(DISTINCT)`
* `AVG()`
* Conditional aggregation
* `CASE`
* `HAVING`
* `INNER JOIN`
* `LEFT JOIN`
* `CROSS JOIN`
* CTEs
* Multi-level aggregation
* Business benchmarking
* Revenue contribution analysis
* Customer segmentation
* Safe division with `NULLIF()`
* Business-oriented SQL reasoning

---

# Phase 6 Outcome

The completion of this phase strengthened my ability to move from:

```text
Raw Transactions
       ↓
SQL Aggregation
       ↓
Business Metrics
       ↓
Benchmarking
       ↓
Segmentation
       ↓
Business Insight
```

The emphasis throughout the phase was not simply on producing a correct query, but on understanding **what should be aggregated, at what level, against which benchmark, and why the resulting metric matters**.

---

# Author Shorya Dev Bisht
https://www.linkedin.com/in/shorya-bisht-a20144349/
