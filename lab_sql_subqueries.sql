use sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(film_id) from inventory as film_copies
WHERE film_id =(SELECT film_id FROM film
				WHERE title = "Hunchback Impossible");

-- List all films whose length is longer than the average of all the films.

SELECT title as films_longer_than_average 
FROM  film 
WHERE length > (SELECT avg(length) from film);

-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name 
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
WHERE film_id = (select film_id from film 
				where title = "Alone Trip");

-- Identify all movies categorized as family films.

SELECT title as family_films
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
WHERE category_id = (select category_id from category 
					where name = "Family");

SELECT * from customer; 
SELECT * from country; 
SELECT * from address; 
SELECT * from city; 

-- Get name and email from customers from Canada using subqueries. Do the same with joins.
--  Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys,
-- that will help you get the relevant information.
SELECT first_name, last_name, email 
FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
WHERE country = "Canada";

-- another solution 

SELECT first_name, last_name, email 
FROM customer 
WHERE address_id in (select address_id from address 
					WHERE city_id in (select city_id from city 
									where country_id in (select country_id from country
														where country ="Canada")));
 -- Which are films starred by the most prolific actor
 
 SELECT first_name, last_name 
 FROM actor 
 JOIN film_actor ON actor.actor_id = film_actor.actor_id 
 JOIN film ON film.film_id = film_actor.film_id 
 WHERE actor.actor_id = (SELECT actor_id 
						FROM film_actor 
                        JOIN film ON film.film_id = film_actor.film_id 
                        GROUP BY film_actor.actor_id 
                        ORDER BY COUNT(film.film_id) DESC
                        LIMIT 1);
 
-- Films rented by most profitable customer.


SELECT * FROM customer; 
select * from payment;

SELECT first_name, last_name 
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE c.customer_id = (select customer_id from payment 
					group by customer_id 
					order by  sum(amount)
                    limit 1);

										
-- Customers who spent more than the average payments.
SELECT first_name, last_name 
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id 
HAVING SUM(p.amount) > (select avg(amount)from payment);

