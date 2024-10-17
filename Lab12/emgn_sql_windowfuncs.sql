-- ## Challenge 1

-- This challenge consists of three exercises that will test your ability to use the SQL RANK() function.
-- You will use it to rank films by their length, their length within the rating category, and by the actor 
-- or actress who has acted in the greatest number of films.
SELECT *
FROM film;

-- 1. Rank films by their length and create an output table that includes the title, length, and rank columns only.
-- Filter out any rows with null or zero values in the length column.
SELECT
    title, 
    length,
    RANK () OVER (
		ORDER BY length
		) AS f_rank 
FROM film f
WHERE length IS NOT NULL AND length > 0;

SELECT * from film;

-- 2. Rank films by length within the rating category and create an output table that includes the title, length,
-- rating and rank columns only. Filter out any rows with null or zero values in the length column.
SELECT
    title, 
    length, 
    rating, 
    RANK() OVER (ORDER BY length) AS f_rank
FROM film
WHERE length IS NOT NULL AND length > 0;

-- 3. Produce a list that shows for each film in the Sakila database, the actor or actress who has acted in the
-- greatest number of films, as well as the total number of films in which they have acted. *Hint: Use temporary
-- tables, CTEs, or Views when appropiate to simplify your queries.*
SELECT first_name, last_name, film_count, rank_f
FROM (
    SELECT 
        a.first_name,
        a.last_name,
        COUNT(f.film_id) AS film_count,
        RANK() OVER (ORDER BY COUNT(f.film_id) DESC) AS rank_f
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    GROUP BY 
        a.actor_id, a.first_name, a.last_name
) AS actor_film_cnt
WHERE rank_f = 1;
    
-- ## Challenge 2

-- This challenge involves analyzing customer activity and retention in the Sakila database to gain insight into
-- business performance. 
-- By analyzing customer behavior over time, businesses can identify trends and make data-driven decisions to 
-- improve customer retention and increase revenue.

-- The goal of this exercise is to perform a comprehensive analysis of customer activity and retention by conducting
-- an analysis on the monthly percentage change in the number of active customers and the number of retained customers.
-- Use the Sakila database and progressively build queries to achieve the desired outcome. 

-- - Step 1. Retrieve the number of monthly active customers, i.e., the number of unique customers who rented a movie in each month.
-- - Step 2. Retrieve the number of active users in the previous month.
-- - Step 3. Calculate the percentage change in the number of active customers between the current and previous month.
-- - Step 4. Calculate the number of retained customers every month, i.e., customers who rented movies in the current
-- and previous months.

WITH MonthlyActiveCustomers AS (
    SELECT 
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        customer_id
    FROM rental
    GROUP BY rental_month, customer_id
),
ActiveCustomerStats AS (
    SELECT 
        rental_month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM MonthlyActiveCustomers
    GROUP BY rental_month
),
RetentionStats AS (
	SELECT 
        rental_month,
        active_customers,
        LAG(active_customers) OVER (ORDER BY rental_month) AS previous_active_customers
    FROM ActiveCustomerStats
)
SELECT 
    rental_month,
    active_customers,
    COALESCE(previous_active_customers, 0) AS previous_active_customers,
    (active_customers - COALESCE(previous_active_customers, 0)) / 
    NULLIF(COALESCE(previous_active_customers, 0), 0) * 100 AS percentage_change
FROM RetentionStats
ORDER BY rental_month;
    
-- *Hint: Use temporary tables, CTEs, or Views when appropiate to simplify your queries.*