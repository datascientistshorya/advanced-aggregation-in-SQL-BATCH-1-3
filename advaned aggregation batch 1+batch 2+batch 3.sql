-- Batch 1
/*Q1 — Category Performance
Find each product category's:
Total orders
Total revenue
Average order value
Return only categories with at least 2 orders*/

with category_data as(
	select p.category, sum(o.amount) as total_revenue, count(o.order_id) as total_orders
    from products p inner join orders o 
    on p.product_id=o.product_id
    group by p.category
)

select category, total_revenue, total_orders, (total_revenue)/total_orders as AOV
    from category_data
    group by category, total_revenue, total_orders
    having total_orders>=2;

/*Q2 — Customer Revenue Contribution:
Find each customer's:
Customer name
Total spending
Percentage contribution to overall completed-order revenue
Sort by contribution percentage descending.*/

with customer_data as(
	select c.customer_id,c.customer_name, sum(o.amount) as total_spending,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_spending 
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id,c.customer_name
),
benchmark as(
	select sum(completed_spending) total_completed from customer_data
)

select * ,
(completed_spending / total_completed) * 100 AS contribution_percentage
from customer_data 
cross join benchmark
order by contribution_percentage desc;

/*Q3 — City-Level Performance
For each city, calculate:
Number of unique customers
Number of completed orders
Total completed revenue
Average completed order value
Sort by total revenue descending.*/

with city_data as(
	select c.city, count(distinct c.customer_id) as total_customers,
    sum(case when o.status='Completed' then 1 else 0 end) as completed_orders,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue,
    sum(o.amount) as total_revenue
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.city
)
select city, total_customers, completed_orders,completed_revenue,
completed_revenue/completed_orders as Avg_completed_order_revenue,
total_revenue
from city_data
order by total_revenue desc;

/* Q4 — Product Performance vs Category
For every product, show:
Product name
Category
Total completed revenue
Category's total completed revenue
Product's percentage contribution to its category revenue
Sort by category and product contribution descending.*/

WITH product_data AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        SUM(
            CASE 
                WHEN o.status = 'Completed' THEN o.amount
                ELSE 0
            END
        ) AS completed_revenue
    FROM products p
    INNER JOIN orders o 
        ON p.product_id = o.product_id
    GROUP BY 
        p.product_id,
        p.product_name,
        p.category
),

category_data AS (
    SELECT 
        p.category,
        SUM(
            CASE 
                WHEN o.status = 'Completed' THEN o.amount
                ELSE 0
            END
        ) AS category_completed_revenue
    FROM products p
    INNER JOIN orders o 
        ON p.product_id = o.product_id
    GROUP BY p.category
)

SELECT 
    pd.product_name,
    pd.category,
    pd.completed_revenue,
    cd.category_completed_revenue,
    (pd.completed_revenue / cd.category_completed_revenue) * 100 
        AS percent_contribution
FROM product_data pd
INNER JOIN category_data cd
    ON pd.category = cd.category
ORDER BY 
    pd.category,
    percent_contribution DESC;
    
/* Q5 — High-Value Customer Segmentation
Using completed orders only, classify customers into:
Then classify each customer as:
High Completion → completion percentage ≥ 75%
Medium Completion → completion percentage ≥ 25% and < 75%
Low Completion → completion percentage < 25%*/
with customer_data as(
	select c.customer_id,c.customer_name,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue,
    sum(o.amount) as total_spending 
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id,c.customer_name
)
select *,
case 
	when completed_revenue/total_spending*100 >=75 then 'High'
    when completed_revenue/total_spending*100 >= 25 then 'Medium'
    else 'Low'
    end as segement
    from customer_data;
-- Batch 2
/* Q1 — Customer Order Behavior
Find each customer's:
Customer name
Total number of orders
Completed orders
Cancelled orders
Total spending
Completed revenue
Sort by completed revenue descending.*/

with customer_data as(
	select c.customer_id, c.customer_name, count(o.customer_id) as total_orders,
    sum(case when o.status='Completed' then 1 else 0 end) as completed_orders,
    sum(case when o.status='Cancelled' then 1 else 0 end) as cancelled_orders,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue,
    sum(o.amount) as total_spending
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id, c.customer_name
)
    select * from customer_data
    order by completed_revenue desc;
    
/* Q2 — Product Revenue & Order Mix
For every product, calculate:
Product name
Category
Total orders
Completed orders
Cancelled orders
Completed revenue
Cancelled revenue
Sort by completed revenue descending.*/

with product_data as(
	select p.product_id,p.product_name,p.category,
    sum(case when o.status='Completed' then 1 else 0 end) as Completed_orders,
    sum(case when o.status='Cancelled' then 1 else 0 end) as Cancelled_orders,
    sum(case when o.status='Completed' then o.amount else 0 end) as Completed_revenue,
    sum(case when o.status='Cancelled' then o.amount else 0 end) as Cancelled_revenue,
    count(p.product_id) as total_orders
    from products p inner join orders o 
    on p.product_id=o.product_id
    group by p.product_id,p.product_name,p.category
)
    
    select * from product_data
    order by Completed_revenue desc;
    
/*Q3 — Category Completion Rate
For each product category, calculate:
Category
Total orders
Completed orders
Cancelled orders
Total revenue
Completed revenue
Completion rate (%)*/

with category_data as(
	select p.category,
    sum(case when o.status='Completed' then 1 else 0 end) as Completed_orders,
    sum(case when o.status='Cancelled' then 1 else 0 end) as Cancelled_orders,
    sum(case when o.status='Completed' then o.amount else 0 end) as Completed_revenue,
    sum(case when o.status='Cancelled' then o.amount else 0 end) as Cancelled_revenue,
    count(p.product_id) as total_orders
    from products p inner join orders o 
    on p.product_id=o.product_id
    group by p.category
)
    
    select *,
    Completed_orders/total_orders *100 as completion_rate 
    from category_data
    order by completion_rate desc;
    
/*Q4 — Customer Revenue Share

Find each customer's:

Customer name
Total spending
Completed spending
Percentage of their spending that was completed
Classification:
≥ 80%  → Strong
50–79% → Moderate
< 50%  → Weak
Sort by completion percentage descending.*/
with customer_data as(
	select c.customer_id,c.customer_name,
    sum(o.amount) as total_spending,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_spending
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id,c.customer_name
)
select *,
case
	when completed_spending/total_spending*100>=80 then 'Strong'
    when completed_spending/total_spending*100>=50 then 'Moderate'
    else 'weak'
    end as perct_conversion
    from customer_data
    ;

/*Q5 — Product Performance Within Category
For each product, calculate:
Product name
Category
Completed revenue
Category's total completed revenue
Product contribution to category revenue (%)
Then classify each product:
≥ 50% → Dominant
25–49% → Significant
< 25% → Minor
Sort by category and then contribution percentage descending.*/

with product_data as(
 select p.product_id, p.product_name, p.category,
 sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue,
 sum(o.amount) as total_revenue
 from products p inner join orders o 
 on p.product_id=o.product_id
 group by p.product_id, p.product_name, p.category
),
category_data AS (
    SELECT 
        category,
        SUM(completed_revenue) AS category_completed_revenue
    FROM product_data
    GROUP BY category
)
SELECT 
    pd.product_name,
    pd.category,
    pd.completed_revenue,
    cd.category_completed_revenue,
    pd.completed_revenue * 100.0 
        / cd.category_completed_revenue AS contribution_percentage,
    CASE 
        WHEN pd.completed_revenue * 100.0 
             / cd.category_completed_revenue >= 50 
            THEN 'Dominant'
        WHEN pd.completed_revenue * 100.0 
             / cd.category_completed_revenue >= 25 
            THEN 'Significant'
        ELSE 'Minor'
    END AS significance
FROM product_data pd
INNER JOIN category_data cd
    ON pd.category = cd.category
ORDER BY 
    pd.category,
    contribution_percentage DESC;
    
    -- BATCH 3
/* Q1 — Customer Revenue Mix by Product Category
For each customer, calculate their completed revenue from each product category.
Return:
customer_id
customer_name
Electronics_Revenue
Furniture_Revenue
Other_Revenue
Total_Revenue*/

with customer_data as(
	select c.customer_id,c.customer_name,
    sum(case when p.category='Electronics' then o.amount else 0 end) as electronics_revenue,
    sum(case when p.category='Furniture' then o.amount else 0 end) as furniture_revenue,
    sum(case when p.category not in ('Electronics','Furniture') then o.amount else 0 end) as other_revenue,
    sum(o.amount) as total_revenue
    
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    inner join products p 
    on o.product_id=p.product_id
    where o.status='Completed'
    group by c.customer_id,c.customer_name
)
select* from customer_data;

/*Q2 — Product Performance vs Category Average
For every product, calculate:
product_name
category
product's completed revenue
average completed revenue of all products in the same category
difference between product revenue and category average
Show products even if they have zero completed revenue. Sort by category and then revenue descending.*/

with product_data as(
	select p.product_id, p.product_name, p.category,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue
    from products p inner join orders o 
    on p.product_id=o.product_id
    group by p.product_id, p.product_name, p.category
),
category_benchmark AS (
    SELECT
        category,
        AVG(completed_revenue) AS category_avg_revenue
    FROM product_data
    GROUP BY category
)


select *, pd.completed_revenue-cb.category_avg_revenue as revenue_diff
from product_data pd
inner join category_benchmark cb
on pd.category = cb.category
order by pd.category, revenue_diff desc;



/*Q3 — Customer Order Status Mix
For every customer, calculate:
total orders
completed orders
cancelled orders
completion rate
cancellation rate
Include customers who have never placed an order.
Handle customers with zero orders safely.*/

with customer_data as(
	select c.customer_id,c.customer_name,
    sum(case when o.status='Completed' then 1 else 0 end) as completed_orders,
    sum(case when o.status='Cancelled' then 1 else 0 end) as cancelled_orders,
    count(o.order_id) as total_orders
    from customers c left join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id,c.customer_name
)

select *, completed_orders/NULLIF(total_orders,0)*100 as completion_rate,
cancelled_orders/nullif(total_orders,0)*100 as cancelled_rate
from customer_data;

/*Q4 — Customer Revenue vs Overall Average
Find customers whose completed-order revenue is greater than the average completed revenue per customer.
Return:
customer_id
customer_name
completed_revenue
average_customer_revenue*/

with customer_data as(
	select c.customer_id,c.customer_name,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_revenue
    from customers c inner join orders o 
    on c.customer_id =o.customer_id
    group by c.customer_id,c.customer_name
),
benchmark as(
	select avg(completed_revenue) as avg_rev
    from customer_data
)
select * from customer_data cd
cross join benchmark b
where cd.completed_revenue>b.avg_rev;

/*Q5— Product Revenue Contribution
For every product, calculate:
product_name
category
completed_revenue
total_completed_revenue
revenue_contribution_pct
Include products with zero completed revenue.*/

with prod_data as(
	select p.product_id,p.product_name, p.category,
    sum(case when o.status='Completed' then o.amount else 0 end) as completed_rev
    from products p left join orders o 
    on p.product_id=o.product_id
    group by p.product_id,p.product_name, p.category
),
benchmark as(
	select sum(completed_rev) total_rev from prod_data
)
select * ,
nullif(pd.completed_rev,0)/b.total_rev *100 as rev_contribution
from prod_data pd
cross join benchmark b
;