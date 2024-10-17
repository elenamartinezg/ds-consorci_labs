![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | Window Functions

<details>
  <summary>
   <h2>Learning Goals</h2>
  </summary>

  This lab allows you to practice and apply the concepts and techniques taught in class. 

  Upon completion of this lab, you will be able to:
  
- Use window functions to perform complex analytical queries and gain insights into data, including computing rolling calculations, ranking data, and performing aggregations over subsets of data.

  <br>
  <hr> 

</details>

<details>
  <summary>
   <h2>Prerequisites</h2>
  </summary>

Before this starting this lab, you should have learnt about:

- SELECT, FROM, ORDER BY, LIMIT, WHERE, GROUP BY, and HAVING clauses. DISTINCT, AS keywords.
- Built-in SQL functions such as COUNT, MAX, MIN, AVG, ROUND, DATEDIFF, or DATE_FORMAT.
- JOIN to combine data from multiple tables.
- Subqueries, Temporary Tables, Views, CTEs.
- Window Functions: RANK() OVER with PARTITION BY, LAG().
 
  <br>
  <hr> 

</details>


## Introduction

Welcome to the Window Functions lab!

In this lab, you will be working with the [Sakila](https://dev.mysql.com/doc/sakila/en/) database on movie rentals. The goal of this lab is to help you practice and gain proficiency in using window functions in SQL queries.

Window functions are a powerful tool for performing complex data analysis in SQL. They allow you to perform calculations across multiple rows of a result set, without the need for subqueries or self-joins. This can greatly simplify your SQL code and make it easier to understand and maintain.

By the end of this lab, you will have a better understanding of how to use window functions in SQL to perform complex data analysis, assign rankings, and retrieve previous row values. These skills will be useful in a variety of real-world scenarios, such as sales analysis, financial reporting, and trend analysis.

## Challenge 1

This challenge consists of three exercises that will test your ability to use the SQL RANK() function. You will use it to rank films by their length, their length within the rating category, and by the actor or actress who has acted in the greatest number of films.

1. Rank films by their length and create an output table that includes the title, length, and rank columns only. Filter out any rows with null or zero values in the length column.

2. Rank films by length within the rating category and create an output table that includes the title, length, rating and rank columns only. Filter out any rows with null or zero values in the length column.

3. Produce a list that shows for each film in the Sakila database, the actor or actress who has acted in the greatest number of films, as well as the total number of films in which they have acted. *Hint: Use temporary tables, CTEs, or Views when appropiate to simplify your queries.*

## Challenge 2

This challenge involves analyzing customer activity and retention in the Sakila database to gain insight into business performance. 
By analyzing customer behavior over time, businesses can identify trends and make data-driven decisions to improve customer retention and increase revenue.

The goal of this exercise is to perform a comprehensive analysis of customer activity and retention by conducting an analysis on the monthly percentage change in the number of active customers and the number of retained customers. Use the Sakila database and progressively build queries to achieve the desired outcome. 

- Step 1. Retrieve the number of monthly active customers, i.e., the number of unique customers who rented a movie in each month.
- Step 2. Retrieve the number of active users in the previous month.
- Step 3. Calculate the percentage change in the number of active customers between the current and previous month.
- Step 4. Calculate the number of retained customers every month, i.e., customers who rented movies in the current and previous months.
WITH MonthlyActiveCustomers AS (
    SELECT 
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM 
        rental
    GROUP BY 
        rental_month
),
PreviousMonthActive AS (
    SELECT 
        rental_month,
        active_customers,
        LAG(active_customers) OVER (ORDER BY rental_month) AS previous_active_customers
    FROM 
        MonthlyActiveCustomers
),
RetainedCustomers AS (
    SELECT 
        curr.rental_month,
        curr.active_customers,
        prev.previous_active_customers,
        COUNT(DISTINCT curr.customer_id) AS retained_customers
    FROM 
        rental AS curr
    JOIN rental AS prev 
        ON curr.customer_id = prev.customer_id 
        AND DATE_FORMAT(curr.rental_date, '%Y-%m') = curr_month.rental_month
        AND DATE_FORMAT(prev.rental_date, '%Y-%m') = DATE_FORMAT(DATE_SUB(curr_month.rental_month, INTERVAL 1 MONTH), '%Y-%m')
    JOIN MonthlyActiveCustomers AS curr_month 
        ON DATE_FORMAT(curr.rental_date, '%Y-%m') = curr_month.rental_month
    GROUP BY 
        curr_month.rental_month, curr_month.active_customers, prev.previous_active_customers
)
SELECT 
    curr_month.rental_month,
    curr_month.active_customers,
    prev.previous_active_customers,
    (curr_month.active_customers - prev.previous_active_customers) / NULLIF(prev.previous_active_customers, 0) * 100 AS percentage_change,
    COALESCE(retained.retained_customers, 0) AS retained_customers
FROM 
    MonthlyActiveCustomers AS curr_month
LEFT JOIN 
    PreviousMonthActive AS prev ON curr_month.rental_month = prev.rental_month
LEFT JOIN 
    RetainedCustomers AS retained ON curr_month.rental_month = retained.rental_month;

*Hint: Use temporary tables, CTEs, or Views when appropiate to simplify your queries.*

## Requirements

- Fork this repo
- Clone it to your machine


## Getting Started

Complete the challenge in this readme in a `.sql` file.

## Submission

- Upon completion, run the following commands:

```bash
git add .
git commit -m "Solved lab"
git push origin master
```

- Paste the link of your lab in Student Portal.



