################################## self join
#### 10 is hard


# 5. Execute the self join shown and observe that b.stop gives all the places 
#    you can get to from Craiglockhart, without changing routes. 
#    Change the query so that it shows the services from Craiglockhart to London Road. 
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company = b.company AND a.num = b.num)
WHERE a.stop = (select id from stops where name = 'Craiglockhart') and 
	  b.stop = (select id from stops where name = 'London Road')
      
# 6. The query shown is similar to the previous one, however by joining two copies 
#    of the stops table we can refer to stops by name rather than by number. 
#    Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 
#    If you are tired of these places try 'Fairmilehead' against 'Tollcross' 
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' and stopb.name = 'London Road'


# 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') 
select distinct r1.company, r1.num
from route r1 join route r2 on (r1.company = r2.company and r1.num = r2.num)
where r1.stop = 115 and r2.stop = 137

# 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' 
select distinct r1.company, r1.num
from route r1 join route r2 on (r1.company = r2.company and r1.num = r2.num)
where r1.stop = (select id from stops where name = 'Craiglockhart') and r2.stop = (select id from stops where name = 'Tollcross')


# 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
#    including 'Craiglockhart' itself, offered by the LRT company. 
#    Include the company and bus no. of the relevant services. 
select stops.name, r2.company, r2.num
from route r1 join route r2 on (r1.company = r2.company and r1.num = r2.num) 
join stops on r2.stop = stops.id
where r1.company = 'LRT' and r1.stop = (select id from stops where name = 'Craiglockhart')


# 10. Find the routes involving two buses that can go from Craiglockhart to Sighthill.
#     Show the bus no. and company for the first bus, the name of the stop for the transfer,
#     and the bus no. and company for the second bus.
#     Hint
#     Self-join twice to find buses that visit Craiglockhart and Sighthill, 
#     then join those on matching stops.
select distinct num1, company1, name, num4, company4
from 
(select r1.num as num1, r1.company as company1, r1.stop as stop1, r2.num as num2, r2.company as company2, r2.stop as stop2
from route r1 join route r2 on 
    (r1.company = r2.company and r1.num = r2.num)
where r1.stop = (select id from stops where name = 'Craiglockhart')) as T1 join
(select r3.num as num3, r3.company as company3, r3.stop as stop3, r4.num as num4, r4.company as company4, r4.stop as stop4
from route r3 join route r4 on 
    (r3.company = r4.company and r3.num = r4.num)
where r4.stop = (select id from stops where name = 'Sighthill')) as T2 on T1.stop2 = T2.stop3
join stops on stop2 = id

################################ Quiz ###################################################
# 1. Select the code that would show it is possible to get from Craiglockhart to Haymarket
select 
from stops a join route b on a.id = b.stop
	 join route c on (b.num = c.num and b.company = c.company)
     join stops d on c.stop = d.id
where a.name = 'Craiglockhart' and d.name = 'Haymarket'

# 2. Select the code that shows the stops that are on route.num '2A' 
#    which can be reached with one bus from Haymarket?
select r2.stop
from route r1 join route r2 where (r1.num = r2.num and r1.company = r2.company)
     join stops s1 on s1.id = r1.stop
     join stops s2 on s2.id = r2.stop
where r1.num = '2A' and s2.name = 'Haymarket'
# or
SELECT S2.id, S2.name, R2.company, R2.num
  FROM stops S1, stops S2, route R1, route R2
 WHERE S1.name='Haymarket' AND S1.id=R1.stop
   AND R1.company=R2.company AND R1.num=R2.num
   AND R2.stop=S2.id AND R2.num='2A'
   
# 3. Select the code that shows the services available from Tollcross? 
SELECT a.company, a.num, stopa.name, stopb.name
  FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
 WHERE stopa.name='Tollcross'
 