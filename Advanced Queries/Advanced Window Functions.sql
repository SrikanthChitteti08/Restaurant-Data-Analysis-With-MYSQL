USE swiggy;

SELECT * FROM restaurants;

-- 1. List the top 5 cuisines as per the revenue generated by top 5 restaurants of every cuisine
SELECT cuisine, SUM(rating_count * cost) AS revenue
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cuisine ORDER BY cost * rating_count DESC) AS rank
    FROM restaurants
) t 
WHERE t.rank < 6
GROUP BY cuisine
ORDER BY revenue DESC;

-- 2. What is the total revenue generated by top 1% restaurants
SELECT SUM(cost * rating_count) AS revenue 
FROM (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY cost * rating_count DESC) AS rank
    FROM restaurants
) t
WHERE t.rank <= 614;

-- 3. Check the same for top 20% restaurants
SELECT SUM(cost * rating_count) AS revenue 
FROM (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY cost * rating_count DESC) AS rank
    FROM restaurants
) t
WHERE t.rank <= 12280;

-- 4. What % of revenue is generated by top 20% of restaurants with respect to total revenue?
WITH q1 AS (
    SELECT SUM(cost * rating_count) AS top_revenue 
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (ORDER BY cost * rating_count DESC) AS rank
        FROM restaurants
    ) t
    WHERE t.rank <= 12280
),
q2 AS (
    SELECT SUM(cost * rating_count) AS total_revenue FROM restaurants
)
SELECT (top_revenue / total_revenue) * 100 AS revenue_percent 
FROM q1, q2;
