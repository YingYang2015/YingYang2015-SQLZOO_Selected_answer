## SQL ZOO, wild card
## Select name

# %A
# A%
# _ single character wildcard
# char_length: coun the number of the characters in a string
# concat
# replace 

# 7. Find the countries that have three or more a in the name
SELECT name FROM world
  WHERE name LIKE '%a%a%a%'
 
# 8. India and Angola have an n as the second character. You can use the underscore as a single character wildcard. 
# Find the countries that have "t" as the second character.

select name from world where name like '_t%'

# 9. Find the countries that have two "o" characters separated by two others.
# e.g. Lesotho and Moldova both have two o characters separated by two other characters. 
SELECT name FROM world
 WHERE name LIKE '%o__o%'
 
# 10. Cuba and Togo have four characters names.
# Find the countries that have exactly four characters. 
select name from world
where char_length(name) = 4

# or 
SELECT name FROM world
 WHERE name like '____'  # 4 _

# 12. The capital of Mexico is Mexico City. Show all the countries where the capital has the country together with the word "City".
# Find the country where the capital is the country plus "City".
select name
from world
where capital = concat(name, ' City')
 
# 13. Find the capital and the name where the capital includes the name of the country. 
select capital, name
from world
where capital like concat('%', name, '%')

# 14. Find the capital and the name where the capital is an extension of name of the country.
# You should include Mexico City as it is longer than Mexico. You should not include Luxembourg as the capital is the same as the country. 
select name, capital
from world
where capital like concat(name, '%') and capital != name

# 15. For Monaco-Ville the name is Monaco and the extension is -Ville.
# Show the name and the extension where the capital is an extension of name of the country.

select name, REPLACE(capital, name, '')
from world
where capital like concat(name, '%') and capital != name