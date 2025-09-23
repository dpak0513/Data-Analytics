-- Ecommerce postgreSQL Analysis--

SELECT * FROM ecommerce_data;

/* Droping duplicates */
DELETE FROM ecommerce_data a
USING ecommerce_data b
WHERE a.ctid < b.ctid
  AND a."Order ID" = b."Order ID";


/* Total orders and total revenue by platform */
SELECT 
    "Platform",
    COUNT(*) AS total_orders,
    SUM("Order Value (INR)") AS total_revenue
FROM ecommerce_data
GROUP BY "Platform"
ORDER BY total_revenue DESC;


/* Average order value by platform and product category */
SELECT 
    "Platform",
    "Product Category",
    AVG("Order Value (INR)") AS avg_order_value,
    COUNT(*) AS total_orders
FROM ecommerce_data
GROUP BY "Platform", "Product Category"
ORDER BY "Platform", avg_order_value DESC;


/* Average delivery time and service rating by platform */
SELECT 
    "Platform",
    AVG("Delivery Time (Minutes)") AS avg_delivery_time,
    AVG("Service Rating") AS avg_service_rating
FROM ecommerce_data
GROUP BY "Platform"
ORDER BY avg_delivery_time ASC;


/* Customers with the highest number of 5-star service ratings */
SELECT 
    "Customer ID",
    COUNT(*) AS five_star_count
FROM ecommerce_data
WHERE "Service Rating" = 5
GROUP BY "Customer ID"
ORDER BY five_star_count DESC
LIMIT 10;


/* Top 5 customers by total spending */
SELECT 
    "Customer ID",
    SUM("Order Value (INR)") AS total_spent,
    COUNT(*) AS total_orders
FROM ecommerce_data
GROUP BY "Customer ID"
ORDER BY total_spent DESC
LIMIT 5;


/* Orders above a certain value threshold (premium orders) */
SELECT *
FROM ecommerce_data
WHERE "Order Value (INR)" > 1000
ORDER BY "Order Value (INR)" DESC;


/* Platforms with fastest and slowest deliveries by product category */
SELECT 
    "Product Category",
    "Platform",
    MIN("Delivery Time (Minutes)") AS min_delivery,
    MAX("Delivery Time (Minutes)") AS max_delivery
FROM ecommerce_data
GROUP BY "Product Category", "Platform"
ORDER BY "Product Category", min_delivery ASC;



/* Customers with the fastest average delivery and their satisfaction */
SELECT 
    "Customer ID",
    COUNT(*) AS total_orders,
    AVG("Delivery Time (Minutes)") AS avg_delivery_time,
    AVG("Service Rating") AS avg_service_rating,
    SUM("Order Value (INR)") AS total_spent
FROM ecommerce_data
GROUP BY "Customer ID"
HAVING COUNT(*) > 1
ORDER BY avg_delivery_time ASC
LIMIT 10;



/* Orders with delivery time greater than average */
WITH avg_delivery AS (
    SELECT AVG("Delivery Time (Minutes)") AS avg_time
    FROM ecommerce_data
)
SELECT *
FROM ecommerce_data, avg_delivery
WHERE "Delivery Time (Minutes)" > avg_time;



/* Orders count and average order value by product category */
SELECT 
    "Product Category",
    COUNT(*) AS total_orders,
    AVG("Order Value (INR)") AS avg_order_value
FROM ecommerce_data
GROUP BY "Product Category"
ORDER BY avg_order_value DESC;



/* Repeat customers analysis */
SELECT 
    "Customer ID",
    COUNT(*) AS total_orders,
    SUM("Order Value (INR)") AS total_spent
FROM ecommerce_data
GROUP BY "Customer ID"
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;



/* Platform-wise distribution of service ratings */
SELECT 
    "Platform",
    "Service Rating",
    COUNT(*) AS rating_count,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY "Platform")), 2) AS percentage
FROM ecommerce_data
GROUP BY "Platform", "Service Rating"
ORDER BY "Platform", "Service Rating" DESC;



/* Platform distribution percentage of total orders */
SELECT 
    "Platform",
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ecommerce_data)), 2) AS percentage_orders
FROM ecommerce_data
GROUP BY "Platform";



/* Correlation analysis (in SQL) */
SELECT 
    CORR("Order Value (INR)", "Delivery Time (Minutes)") AS corr_order_delivery,
    CORR("Service Rating", "Delivery Time (Minutes)") AS corr_rating_delivery
FROM ecommerce_data;



/* Outliers in order value (percentiles) */
WITH percentiles AS (
    SELECT
        percentile_cont(0.25) WITHIN GROUP (ORDER BY "Order Value (INR)") AS q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY "Order Value (INR)") AS q3
    FROM ecommerce_data
)
SELECT *
FROM ecommerce_data, percentiles
WHERE "Order Value (INR)" < q1 - 1.5 * (q3 - q1)
   OR "Order Value (INR)" > q3 + 1.5 * (q3 - q1);


/* Delivery time categories for analysis */
SELECT
    CASE 
        WHEN "Delivery Time (Minutes)" <= 30 THEN 'Fast'
        WHEN "Delivery Time (Minutes)" <= 60 THEN 'Moderate'
        ELSE 'Slow'
    END AS delivery_category,
    COUNT(*) AS total_orders,
    AVG("Order Value (INR)") AS avg_order_value,
    AVG("Service Rating") AS avg_service_rating
FROM ecommerce_data
GROUP BY delivery_category
ORDER BY total_orders DESC;


