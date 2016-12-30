############################# SQLZoo _SUM and COUNT
### What to note:
# 1. CONCAT(a, '%')
# 2. where area between 200000 and 250000
# 3. LENGTH(name)
# 4. Exclusive OR (XOR). Show the countries that are big by area or big by population but not both. 
# 5. CASE when can be used in the order by clause, see question 14  
#    CASE WHEN condition1 THEN value1 
#       WHEN condition2 THEN value2  
#       ELSE def_value 
#      END 
# 6. The expression subject IN ('Chemistry','Physics') can be used as a value - it will be 0 or 1. 
	
############################# Select (World)
# 3. Modify it to show the country and the area for countries with an area between 200,000 and 250,000. 
select name, area
from world
where area between 200000 and 250000

## 
SELECT name,LENGTH(name)
FROM world
WHERE LENGTH(name)=5 AND region='Europe'


# 12. Show the name and the continent - but substitute Eurasia for Europe and Asia; 
#     substitute America - for each country in North America or South America or Caribbean. 
#     Show countries beginning with A or B

select name, 
case 
when continent in ('North America', 'South America', 'Caribbean') then 'America' 
when continent in ('Europe', 'Asia') then 'Eurasia' 
else continent end
from world
where name like 'A%' or name like 'B%'



# 13. Put the continents right...
#     Oceania becomes Australasia
#     Countries in Eurasia and Turkey go to Europe/Asia
#     Caribbean islands starting with 'B' go to North America, other Caribbean islands go to South America
#     Order by country name in ascending order
#     Test your query using the WHERE clause with the following:
#     WHERE tld IN ('.ag','.ba','.bb','.ca','.cn','.nz','.ru','.tr','.uk')

#     Show the name, the original continent and the new continent of all countries.

select name, continent, 
case 
when continent = 'Oceania' then 'Australasia' 
when continent = 'Eurasia' then 'Europe/Asia' 
when name = 'Turkey' then 'Europe/Asia' 
when continent = 'Caribbean' and name like 'B%' then 'North America' 
when continent = 'Caribbean' and name not like 'B%' then 'South America' 
else continent end as continent1
from world
WHERE tld IN ('.ag','.ba','.bb','.ca','.cn','.nz','.ru','.tr','.uk')
order by name

############################# Select (Nobel)
# 14. The expression subject IN ('Chemistry','Physics') can be used as a value - it will be 0 or 1. 
# Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.

select winner, subject
from nobel
where yr = 1984
order by case when subject in ('Chemistry', 'Physics') then 1 else 0 end ASC,
subject, winner

############################# Select in Select 
# find the largest country in the world, by population with this query: 
## You need the condition population>0 in the sub-query as some countries have null for population. 
SELECT name
  FROM world
 WHERE population >= ALL(SELECT population
                           FROM world
                          WHERE population>0)
                                                    
# 6. Which countries have a GDP greater than every country in Europe? 
#    [Give the name only.] (Some countries may have NULL gdp values)                           
                          
select name
from world
where GDP >= ALL(select GDP from world where continent='Europe' and GDP > 0) and continent != 'Europe'                          
                          
                          
# 7. Find the largest country (by area) in each continent, show the continent, the name and the area:                           
select continent, name, area
from world x
where area >= ALL(select area from world y where x.continent = y.continent and area > 0)

# 8. List each continent and the name of the country that comes first alphabetically.
select continent, name
from world x
where name <= ALL(select name from world y where x.continent = y.continent)

# 9.Find the continents where all countries have a population <= 25000000. 
#   Then find the names of the countries associated with these continents. Show name, continent and population. 
select name, continent, population
from world x
where 25000000 >= ALL(select population from world y where x.continent= y.continent and population >0)

# 10. Some countries have populations more than three times that of 
#     any of their neighbours (in the same continent). Give the countries and continents.
select name, continent
from world x
where population > ALL(select population*3 from world y where x.continent = y.continent and x.name != y.name) 

#################### Nested Select Quiz
# 1. Select the code that shows the name, region and population of the smallest country in each region  
select name, region, population
from bbc x
where area <= ALL(select area from bbc y where x.region = y.region and y.population >0 )

# 2. Select the code that shows the countries belonging to regions with all populations over 50000
select name, region, population 
from bbc x
where 50000 < ALL(select population from bbc y where x.region = y.region and y.population > 0) 

# 3. Select the code that shows the countries with a less than a third of the population of the countries around it
select name, region
from bbc x
where population < ALL(select population/3 from bbc y where x.region = y.region and y.population >0 and x.name != y.name)

# 5. Select the code that would show the countries with a greater GDP than any country in Africa 
#    (some countries may have NULL gdp values).
select name, GDP
from bbc
where GDP > ALL(select GDP from bbc where region = 'Africa' and GDP is not NULL)

# or
SELECT name FROM bbc
 WHERE gdp > (SELECT MAX(gdp) FROM bbc WHERE region = 'Africa')

# 6. Select the code that shows the countries with population smaller than Russia but bigger than Denmark 
select name
from bbc
where population < (select population from bbc where name = 'Russia') and
      population > (select population from bbc where name = 'Denmark')

############################# SQLZoo _SUM and COUNT

# 1. Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.

# Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
# Decimal places
# Percent symbol %

select name, CONCAT(round(world.population/T.p*100,0),'%')
from world, (select population p from world where name = 'Germany') as T
where continent = 'Europe'
