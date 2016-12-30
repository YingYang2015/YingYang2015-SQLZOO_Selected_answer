## SQLZOO_NSS

# Question 8
select institution, sum(sample), sum(case when subject = '(8) Computer Science' then sample else 0 end) 
from nss
where question = 'Q01' and institution like '%Manchester%' 
group by institution

# or
select T1.institution, total, cs
from
(select institution, sum(sample) as cs
from nss
where question = 'Q01' and institution like '%Manchester%' and subject = '(8) Computer Science'
group by institution) T1 join (
select institution, sum(sample) as total
from nss
where question = 'Q01' and institution like '%Manchester%' 
group by institution) T2 on T1.institution = T2.institution