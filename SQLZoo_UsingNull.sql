############################ SQLZOO_Using Null

# COALESCE takes any number of arguments and returns the first value that is not null.

#  COALESCE(x,y,z) = x if x is not NULL
#  COALESCE(x,y,z) = y if x is NULL and y is not NULL
#  COALESCE(x,y,z) = z if x and y are NULL but z is not NULL
#  COALESCE(x,y,z) = NULL if x and y and z are all NULL



# 5. Use COALESCE to print the mobile number.
#    Use the number '07986 444 2266' if there is no number given. 
#    Show teacher name and mobile number or '07986 444 2266'
select name, coalesce(mobile, '07986 444 2266')
from teacher

# 6. Use the COALESCE function and a LEFT JOIN to print 
#    the teacher name and department name. 
#    Use the string 'None' where there is no department. 
select t.name, coalesce(d.name, 'None')
from teacher t left join dept d on t.dept = d.id 


# 7. Use CASE to show the name of each teacher followed by 'Sci' 
#    if the teacher is in dept 1 or 2, show 'Art' 
#    if the teacher's dept is 3 and 'None' otherwise. 

select t.name, 
       case when t.dept in (1,2) then 'Sci'
            when t.dept = 3 then 'Art'
            else 'None' end
from teacher t left join dept d on t.dept = d.id
