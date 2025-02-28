## MySQL Restaurant Data Analysis

### **Project Overview :**

  This project focuses on analyzing restaurant data using MySQL. The dataset contains information about restaurants, including their name, location, ratings, cuisine type, and cost. The goal is to gain insights into restaurant trends and customer preferences.

## **Dataset Details :**

  The dataset used in this project consists of the following columns:

• **id:** Unique identifier for each restaurant

• **name:** Name of the restaurant

• **city:** Location of the restaurant

• **rating:** Average customer rating (out of 5)

• **rating_count:** Number of reviews received

• **cuisine:** Type of cuisine served

• **cost:** Approximate cost for two people

• **link:** URL to the restaurant’s online page

## **Project Objectives**

• Store and manage restaurant data in a MySQL database

• Perform data cleaning and transformation

• Execute SQL queries to analyze trends

• Generate insights on factors affecting ratings and pricing

• Identify top-rated and budget-friendly restaurants

## **SQL Queries & Analysis**

• The project includes various SQL queries to analyze:

• Average ratings per cuisine type

• Most popular restaurant locations

• Distribution of restaurant costs

• Top-rated restaurants in each category

## MySQL for Data Analytics: Queries & Insights :

### 1. List the top 5 cuisines as per the revenue generated by top 5 restaurants of every cuisine?

    SELECT cuisine, SUM(rating_count * cost) AS 'revenue' 
    FROM (  
      SELECT *, cost * rating_count, 
             ROW_NUMBER() OVER(PARTITION BY cuisine ORDER BY cost * rating_count DESC) AS 'rank'
      FROM restaurants) t 
    WHERE t.rank < 6
    GROUP BY cuisine
    ORDER BY revenue DESC;

### 2. What is the city having Biryani as the most popular cuisine?

    SELECT city, AVG(cost), COUNT(*) AS 'restaurants' 
        FROM restaurants
    WHERE cuisine = 'Biryani'
        GROUP BY city
    ORDER BY restaurants DESC;

### 3. Which city has generated maximum revenue all over India?

    SELECT city, SUM(rating_count * cost) AS 'revenue' 
        FROM restaurants
    GROUP BY city 
        ORDER BY SUM(rating_count * cost) DESC 
    LIMIT 10;

### 4. Find top 5 restaurants of every cuisine as per their revenue?

    SELECT * 
    FROM (
        SELECT *, 
               cost * rating_count AS 'revenue', 
               ROW_NUMBER() OVER(PARTITION BY cuisine ORDER BY rating_count * cost DESC) AS 'rank' 
        FROM restaurants
    ) t
    WHERE t.rank < 6;

### 5. Which restaurant of Delhi has generated the most revenue?

    SELECT * 
    FROM restaurants 
        WHERE city = 'Delhi' 
    AND cost * rating_count = (
        SELECT MAX(cost * rating_count) 
    FROM restaurants 
        WHERE city = 'Delhi'
    );

### 6. Which restaurant of Abohar is visited by the least number of people?

    SELECT * 
    FROM restaurants 
        WHERE city = 'Abohar' 
    AND rating_count = (
        SELECT MIN(rating_count) 
    FROM restaurants 
        WHERE city = 'Abohar'
    );

### 7. Which restaurant of more than the average cost of a restaurant in Delhi has generated the most revenue?

    SELECT * 
    FROM restaurants 
        WHERE rating_count * cost = (
    SELECT MAX(rating_count * cost) 
        FROM restaurants 
    WHERE city = 'Delhi'
    ) 
    AND cost > (
        SELECT AVG(cost) 
    FROM restaurants 
        WHERE city = 'Delhi'
    ) 
    AND city = 'Delhi';

### 8. List top 10 unique restaurants with unique names only throughout the dataset as per maximum revenue generated

    SELECT * 
        FROM restaurants
    GROUP BY name 
        HAVING COUNT(name) = 1
    ORDER BY revenue DESC 
        LIMIT 10;

### 9. What % of revenue is generated by the top 20% of restaurants with respect to total revenue?

    WITH 
        q1 AS (
              SELECT SUM(cost * rating_count) AS 'top_revenue' 
              FROM (
                  SELECT *, cost * rating_count, ROW_NUMBER() OVER(ORDER BY cost * rating_count DESC) AS 'rank'
                  FROM restaurants
              ) t
              WHERE t.rank <= 12280
                ),
        q2 AS (
              SELECT SUM(cost * rating_count) AS 'total_revenue' 
              FROM restaurants
                )    
          SELECT (top_revenue / total_revenue) * 100 AS 'revenue %' 
          FROM q1, q2;
