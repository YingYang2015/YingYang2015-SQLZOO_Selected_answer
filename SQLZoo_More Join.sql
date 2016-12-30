####################### More JOIN operations
### Note:
# 1. count/max/min.. can be used in the having clause
# 2. where - group by - having (order)


####################### Movie Database ##################################################3
# 1. List the films where the yr is 1962 [Show id, title] 
SELECT id, title
 FROM movie
 WHERE yr=1962
 
# 2. Give year of 'Citizen Kane'. 
select yr
from movie
where title = 'Citizen Kane'

# 3.List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year. 
select id, title, yr
from movie
where title like '%Star Trek%'
order by yr

# 4. What are the titles of the films with id 11768, 11955, 21191 
select title
from movie
where id in (11768, 11955, 21191 )

# 5. What id number does the actress 'Glenn Close' have? 
select id
from actor
where name = 'Glenn Close'

# 6. What is the id of the film 'Casablanca' 
select id
from movie
where title = 'Casablanca' 


#7. Obtain the cast list for 'Casablanca'. what is a cast list?

select name 
from actor
where id in ( select actorid
from movie join casting
on id = movieid
where title = 'Casablanca' )

# or 
select name 
from actor join casting on (id = actorid)
where movieid = (select id from movie where title = 'Casablanca')

# 8. Obtain the cast list for the film 'Alien' 
select name
from casting join actor
on actorid = id
where movieid = (select id from movie where title = 'Alien') 

# 9. List the films in which 'Harrison Ford' has appeared 
select title
from movie
where id in (select movieid
from actor join casting
on id = actorid
where name = 'Harrison Ford')

# 10. List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role] 
select title
from movie
where id in (select movieid
from actor join casting
on id = actorid
where name = 'Harrison Ford' and ord != 1)

# 11. List the films together with the leading star for all 1962 films. 
select title, name
from (select title, actorid 
from movie join casting
on id = movieid
where ord = 1 and yr = 1962) T join actor
on T.actorid = id

# or 
select title, name
from movie join casting on movie.id = movieid
           join actor on actorid = actor.id
where ord = 1 and yr = 1962


# 12. Which were the busiest years for 'John Travolta', 
#     show the year and the number of movies he made each 
#     year for any year in which he made more than 2 movies. 

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor  ON actorid=actor.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 WHERE name='John Travolta'
 GROUP BY yr) AS t
)
# or
select yr, numMovie
from (select yr, count(*) as numMovie
from actor a join casting on a.id = actorid
             join movie m on m.id = movieid
where name = 'John Travolta'
group by yr) as T
where numMovie > 2

# 13.List the film title and the leading actor for all of the films 'Julie Andrews' played in. 
select title, name
from (select title, actorid
      from movie join casting
      on id = movieid
      where id in (select movieid
                   from casting join actor
                   on actorid = id
                   where name = 'Julie Andrews') 
            and ord = 1) T join actor 
on actorid = id

# OR
select title, name
from movie m join casting on m.id = movieid
             join actor a on a.id = actorid
where ord = 1 and 
	m.id in (select movieid
	from casting join actor a on a.id = actorid
	where name = 'Julie Andrews')


# 14. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
select name
from casting join actor on actorid = id
where ord = 1
group by name
having count(*) >= 30
order by name

# 15. List the films released in the year 1978 ordered by the number of actors in the cast, then by title. 
select title, count(*)
from movie join casting on id = movieid
where yr = 1978
group by title
order by count(*) DESC, title

# 16. List all the people who have worked with 'Art Garfunkel'. 

select distinct name
from actor join casting on id = actorid
where movieid in (select movieid
					from actor a join casting on a.id = actorid
					where name = 'Art Garfunkel')  
	  and name != 'Art Garfunkel'


#3. Select the statement that shows the list of actors called 'John' by order of number of movies in which they acted 
select actor.id, count(actorid)
from actor join casting on id = actorid
where name like 'John%'
group by actorid
order by count(actorid) DESC

# 5. Select the statement that lists all the actors that starred in movies directed by Ridley Scott who has id 351 
select a.name
from movie m join casting on m.id = movieid
		   join actor a on actorid = a.id
where director = 351 and ord = 1


