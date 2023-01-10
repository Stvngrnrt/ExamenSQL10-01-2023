SELECT * FROM actor;
-- oef 1
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE 'C%' AND
last_name LIKE '%a%';

-- oef 2
SELECT COUNT(*)
FROM (
    SELECT last_name, first_name
    FROM actor
    WHERE last_name LIKE 'C%' AND
    last_name LIKE '%a%') act_start_c_en_met_a;

-- oef 3
SELECT DISTINCT film.title
FROM film_actor JOIN film
ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IN (SELECT actor_id
    FROM actor
    WHERE last_name LIKE 'C%' AND
    last_name LIKE '%a%');

-- oef 4
SELECT actor.last_name, actor.first_name, count (*)
FROM actor JOIN film_actor
ON actor.actor_id = film_actor.actor_id
JOIN film
ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IN (SELECT actor_id
    FROM actor
    WHERE last_name LIKE 'C%' AND
    last_name LIKE '%a%')
GROUP BY actor.last_name, actor.first_name;

-- oef 5
SELECT actor.first_name, actor.last_name, category.name, count(*) as aantal_per_category
FROM actor JOIN film_actor
ON actor.actor_id = film_actor.actor_id
JOIN film_category
ON  film_category.film_id = film_actor.film_id
JOIN category
ON category.category_id = film_category.category_id
WHERE film_actor.actor_id IN (SELECT actor_id
    FROM actor
    WHERE last_name LIKE 'C%' AND
    last_name LIKE '%a%')
GROUP BY actor.first_name, actor.last_name, category.name
HAVING count(*) > 5
ORDER BY count(*) DESC;

-- oef 6
--Deze:
SELECT COUNT (*)
FROM (SELECT DISTINCT film.title
FROM film_actor JOIN film
ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IN (SELECT actor_id
    FROM actor
    WHERE last_name LIKE 'C%' AND
    last_name LIKE '%a%')) as films_waarin_gespeeld;
-- moet gedeeld worden door deze:
SELECT COUNT(*) FROM film;

--> ik vind niet meteen hoe de twee met elkaar te delen

-- oef 7
SELECT film.title, count(*) as films_in_stock
FROM film JOIN inventory
ON inventory.film_id = film.film_id
WHERE film.film_id IN (SELECT DISTINCT film.film_id
FROM film_actor JOIN film
ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IN (SELECT actor_id
    FROM actor
    WHERE last_name LIKE 'C%' AND
    last_name LIKE '%a%'))
GROUP BY film.title
ORDER BY films_in_stock DESC, title;

-- oef 8
SELECT film.title, DATE_PART('year', rental.rental_date) AS year,
DATE_PART('month', rental.rental_date) AS month, count(*)
FROM film JOIN inventory
ON inventory.film_id = film.film_id
JOIN rental
ON rental.inventory_id = inventory.inventory_id
WHERE film.film_id IN (SELECT DISTINCT film.film_id
FROM film_actor JOIN film
ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IN (SELECT actor_id
    FROM actor
    WHERE last_name LIKE 'C%' AND
    last_name LIKE '%a%'))
GROUP BY film.title, year, month;