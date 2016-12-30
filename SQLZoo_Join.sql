use sqlzoo;

drop table if exists game;
create table game (id int, mdate text, stadium text, team1 text, team2 text);
insert into game values (1001, '2012-06-08', 'National Stadium, Warsaw', 'POL', 'GRE');
insert into game values (1002, '2012-06-08', 'Stadion Miejski(Wroclaw)', 'RUS', 'CZE');
insert into game values (1003, '2012-06-12', 'Stadion Miejski(Wroclaw)', 'GRE', 'CZE');
insert into game values (1004, '2012-06-12', 'National Stadium, Warsaw', 'POL', 'RUS');
select * from game;

drop table if exists goal;
create table goal (matchid int, teamid text, player text, gtime int);
insert into goal values(1001, 'POL', 'Robert', 17);
insert into goal values(1001, 'POL', 'Tim', 82);
insert into goal values(1001, 'GRE', 'Dimitris', 51);
insert into goal values(1001, 'GRE', 'Dom', 51);
insert into goal values(1002, 'RUS', 'Alan', 15);
insert into goal values(1002, 'RUS', 'Roman', 82);
insert into goal values(1002, 'CZE', 'Michal', 82);
insert into goal values(1002, 'CZE', 'Andy', 82);
insert into goal values(1003, 'CZE', 'Michal', 82);
insert into goal values(1003, 'CZE', 'Andy', 82);
insert into goal values(1003, 'GRE', 'Dimitris', 51);
insert into goal values(1003, 'GRE', 'Dom', 51);
insert into goal values(1004, 'POL', 'Robert', 17);
insert into goal values(1004, 'POL', 'Tim', 82);
insert into goal values(1004, 'RUS', 'Alan', 15);
insert into goal values(1004, 'RUS', 'Roman', 82);





drop table if exists eteam;
create table eteam (id text, teamname text, coach text);
insert into eteam values('POL', 'Poland', 'Franciszek');
insert into eteam values('RUS', 'Russia', 'Alan');
insert into eteam values('RUS', 'Russia', 'Roman');
insert into eteam values('CZE', 'Czech', 'Michal');
insert into eteam values('GRE', 'Greece', 'Fernando');
insert into eteam values('POL', 'Poland', 'Tim');
insert into eteam values('GRE', 'Greece', 'Dom');
insert into eteam values('CZE', 'Czech', 'Andy');

select *
from goal g1 join game g2
on g2.id = g1.matchid;

select *
from game join goal
on id = matchid

########################## The join operation
########################## UEFA EURO 2012  Database
#### note: 1. variables in select and group by should be the same (9)
####       2. if there are two variables in the select when count, these two variables have to be both in group by (11, 12)




# 1 Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
select matchid, player
from goal
where teamid = "GER"

# 2. Show id, stadium, team1, team2 for just game 1012
select id, stadium, team1, team2
from game
where id = 1012

# 3. Modify it to show the player, teamid, stadium and mdate and for every German goal.
SELECT player, teamid, stadium, mdate
FROM game JOIN goal ON (id=matchid)
where teamid = 'GER'

# 4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
select team1, team2, player
from game join goal on (id = matchid)
where player like "Mario%"

# 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
FROM goal join eteam on (teamid = id)
WHERE gtime<=10

# 6. List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
select g.mdate, e.teamname
from game g join eteam e on (g.team1 = e.id)
where e.coach = 'Fernando Santos' 

# 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
select player
from game join goal on (matchid = id)
where stadium = 'National Stadium, Warsaw'

# 8. Instead show the name of all players who scored a goal against Germany.
select distinct player
from game join goal on (id = matchid)
where (team1 != 'GER' and team2 = 'GER' and team1 = teamid)
   or (team1 = 'GER' and team2 != 'GER' and team2 = teamid)

# 9. Show teamname and the total number of goals scored.
	#### note: teamname has to be in group by and select (variables in select and group by should be the same) 
select teamname, count(gtime)
from goal join eteam on (teamid = id)
group by teamname

# 10. Show the stadium and the number of goals scored in each stadium. 
select stadium, count(gtime)
from game join goal on (matchid = id)
group by stadium



# 11. For every match involving 'POL', show the matchid, date and the number of goals scored.
select matchid, mdate, count(*)
from goal join (select id, mdate
from game
where team1 = 'POL' or team2 = 'POL') T on matchid = id
group by matchid

#### note: if there are two variables in the select when count, these two variables have to be both in group by (11, 12)
# or 
select matchid, mdate, count(*)
from goal join game on matchid = id
where team1 = 'POL' or team2 = 'POL' 
group by matchid, mdate

#12 For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
select id, mdate, count
from (select matchid, count(matchid) as count
from goal
where teamid = 'GER'
group by matchid) T join game on matchid = id  

# or
select matchid, mdate, count(*)
from goal join game on id = matchid
where teamid = 'GER'
group by matchid, mdate


# 13. List every match with the goals scored by each team as shown. 
#    This will use "CASE WHEN" which has not been explained in any previous exercises.
#### note that we have to use left join, because if no one scores in the match, there is no record in goal table

select mdate, team1, sum(score1), team2, sum(score2)
from  (select mdate, team1,
       case when teamid = team1 then 1 else 0 end score1,
       team2,
       case when teamid = team2 then 1 else 0 end score2 
       from game left join goal on id = matchid) T
group by mdate, team1, team2
order by mdate, team1, team2



############### Quiz
#Games and teams /Join
# 1. 
select g2.stadium
from goal g1 join game g2
on g2.id = g1.matchid
where g1.player = "Dimitris"
#2
select g.matchid, g.teamid, g.player, g.gtime, e.teamname, e.coach
from goal g join eteam e
on g.teamid = e.id

#3 shows players, their team and the amount of goals they scored against Greece(GRE). 
SELECT player, teamid, COUNT(*)
FROM game JOIN goal ON matchid = id
WHERE (team1 = 'GRE' OR team2 = 'GRE') AND teamid != 'GRE'
GROUP BY player, teamid;

#5  show the player and their team for those who have scored against Poland(POL) in National Stadium, Warsaw. 
select distinct player, teamid
from game join goal on matchid = id
where (team1 = 'POL' or team2 = 'POL') and teamid != 'POL' and stadium = 'National Stadium, Warsaw'

#6 shows the player, their team and the time they scored, 
# for players who have played in Stadion Miejski (Wroclaw) but not against Italy(ITA). 
SELECT DISTINCT player, teamid, gtime, team1, team2, stadium
  FROM game JOIN goal ON matchid = id
 WHERE stadium = 'Stadion Miejski(Wroclaw)'
   AND (( teamid = team2 AND team1 != 'ITA') OR ( teamid = team1 AND team2 != 'ITA'))

