# SQLzoo exercise
select name, population
from world
where population between 1000000 and 1250000

select name
from world
where name like "%a" or name like "%l"

select name
from world
where area > 500000 and population <1000000

select name 
from world
where name like 'u%'

select population 
from world
where name = "United Kingdom"

select name, population
from world
where continent in ("Europe", "Asia")

## Nobel Quiz
select winner
from nobel
where winner like 'c%' and winner like '%n'

select count(*)
from nobel
where yr between 1950 and 1960 and subject = 'chemistry'

select count(distinct yr)
from nobel
where yr not in (select distinct yr from nobel where subject ='medicine')

select count(distinct yr)
from nobel
where yr not in (select distinct yr from nobel 
				where subject in ('physics', 'chemistry'))
                
select yr
from noble
where subject = 'Medicine' and 
	  yr not in (select yr from nobel where subject in ('Peace', 'Literature'))				

# in
select name, region, population, min(area) as min_area
from bbc 
group by region 
##  1. Select the code that shows the name, region and population of the smallest country in each region 
SELECT region, name, population FROM bbc x WHERE population <= ALL (SELECT population FROM bbc y WHERE y.region=x.region AND population>0)


select country, region
from bbc x
where 50000 < ALL(select population 
				from bbc y
				where x.region = y.region)

##5
select name, GDP
from bbc 
where GDP > (select max(GDP) from bbc
			 where region = Africa)
             
## 2. Select the code that shows the countries belonging to regions with all populations over 50000              
SELECT name,region,population FROM bbc x WHERE 50000 < ALL (SELECT population FROM bbc y WHERE x.region=y.region AND y.population>0)

## Sum and count quiz
###1. Select the statement that shows the sum of population of all countries in 'Europe' 
select sum(population)
from bbc
where region = 'Europe'

### 2 
select count(distinct name)
from bbc
where population < 150000
### 5
select avg(population)
from bbc
where name in ('Poland', 'Germany', 'Denmark')
### 6 Select the statement that shows the medium population density of each region 
 SELECT region, SUM(population)/SUM(area) AS density FROM bbc GROUP BY region 
### 7. Select the statement that shows the name and population density of the country with the largest population 
select name, population/area
from bbc
where population = (select max(population) from bbc)

