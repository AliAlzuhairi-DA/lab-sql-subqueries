# 1:How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT film_id
from film 
where title = "Hunchback Impossible";

SELECT 
    COUNT(*)
FROM
    inventory
WHERE
    film_id = (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible');


#  2:List all films whose length is longer than the average of all the films.

SELECT length, film_id, title
from film
where length > (SELECT avg(length) from film)
order by length desc;

#  3:Use subqueries to display all actors who appear in the film Alone Trip.

SELECT
    actor.actor_id,
    actor.first_name,
    actor.last_name
FROM
    actor
WHERE
    actor.actor_id IN (
        SELECT
            film_actor.actor_id
        FROM
            film_actor
        JOIN
            film ON film_actor.film_id = film.film_id
        WHERE
            film.title = 'Alone Trip'
    );


# 4:Sales have been lagging among young families, and you wish to target all family movies
# for a promotion. Identify all movies categorized as family films


SELECT c.name, f.title, fc.film_id
FROM category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
where c.name = 'Family'
order by c.name;


# 5:Get name and email from customers from Canada using subqueries.
 # Do the same with joins. Note that to create a join, you will have to identify the
 # correct tables with their primary keys and foreign keys, that will help you get
 # the relevant information


SELECT 
    first_name, last_name, email
FROM
    customer
WHERE
    address_id IN (SELECT 
            address_id
        FROM
            address
        WHERE
            city_id IN (SELECT 
                    city_id
                FROM
                    city
                WHERE
                    country_id IN (SELECT 
                            country_id
                        FROM
                            country
                        WHERE
                            country = 'Canada')));


SELECT c.first_name, c.last_name, c.email, co.country
FROM customer c
join address a on c.address_id = a.address_id
join city y on a.city_id = y.city_id
join country co on y.country_id = co.country_id
where co.country = 'Canada';


# 6:Which are films starred by the most prolific actor? Most prolific actor is defined
#  as the actor that has acted in the most number of films. First you will have to find
# the most prolific actor and then use that actor_id to find the different films that 
# he/she starred.


SELECT actor_id, count(film_id) as film_count
from film_actor
 group by actor_id
 order by film_count desc;
 
 SELECT 
    actor_id, MAX(film_count) AS max_films
FROM
    (SELECT 
        actor_id, COUNT(film_id) AS film_count
    FROM
        film_actor
    GROUP BY actor_id
    ORDER BY film_count DESC) AS actor_films
GROUP BY actor_id;

SELECT 
    actor.actor_id, actor.first_name, actor.last_name, max_films
FROM
    actor
        JOIN
    (SELECT 
        actor_id, MAX(film_count) AS max_films
    FROM
        (SELECT 
        actor_id, COUNT(film_id) AS film_count
    FROM
        film_actor
    GROUP BY actor_id) AS actor_films
    GROUP BY actor_id) AS most_prolific_actor ON actor.actor_id = most_prolific_actor.actor_id
ORDER BY max_films DESC;


SELECT
    film.title
FROM
    film_actor
JOIN
    film ON film_actor.film_id = film.film_id
WHERE
    film_actor.actor_id = '107';
    
    
#  7:Films rented by most profitable customer. You can use the customer table and payment 
#  table to find the most profitable customer ie the customer that has made the largest 
#  sum of payments

SELECT customer_id, sum(amount) as amount_count
from payment
group by customer_id
order by amount_count  desc
limit 1;
    
    
SELECT 
    c.first_name, c.last_name, c.customer_id
FROM
    customer c
        JOIN
    (SELECT 
        customer_id, SUM(amount) AS amount_count
    FROM
        payment
    GROUP BY customer_id
    ORDER BY amount_count DESC
    LIMIT 1) AS top_customer ON c.customer_id = top_customer.customer_id;


#  8:Get the client_id and the total_amount_spent of those clients who spent more than the 
#  average of the total_amount spent by each client.

SELECT customer_id, avg(amount) as total_amount_spent
from payment
group by customer_id
order by total_amount_spent desc;

select customer_id, total_amount_spent
from(SELECT customer_id, avg(amount) as total_amount_spent
from payment
group by customer_id) as subquery
where total_amount_spent > (SELECT AVG(amount) from payment)
order by total_amount_spent desc;



