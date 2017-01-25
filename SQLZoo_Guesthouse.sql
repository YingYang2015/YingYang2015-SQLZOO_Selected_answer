# sqlZoo
# guest house questions

# note: 
# question 7: using left join
# q8: group by, coalesce
# q9: date

# q11: using > in the first name


#1. Guest 1183. Give the booking_date and the number of nights for guest 1183.
select first_name, last_name, booking_date, nights
from booking join guest on guest_id = id
where guest_id = 1183

#2. When do they get here? List the arrival time and the first and last names for all guests due to arrive on 2016-11-05, order the output by time of arrival.
select arrival_time, first_name, last_name
from booking join guest on guest_id = id
where booking_date = '2016-11-05'
order by arrival_time

#3. Look up daily rates. Give the daily rate that should be paid for bookings with ids 5152, 5165, 5154 and 5295. Include booking id, room type, number of occupants and the amount.
select booking_id, room_type_requested, occupants, amount
from booking join rate on room_type_requested = room_type and occupants = occupancy
where booking_id in (5152, 5165, 5154, 5295)

#4. Who’s in 101? Find who is staying in room 101 on 2016-12-03, include first name, last name and address. 
select first_name, last_name, address
from guest join booking on guest_id = id
where room_no = 101 and booking_date = '2016-12-03'

#5. How many bookings, how many nights? For guests 1185 and 1270 show the number of bookings made and the total number nights. Your output should include the guest id and the total number of bookings and the total number of nights. 
select guest_id, count(booking_id), sum(nights)
from booking
where guest_id in (1185, 1270)
group by guest_id


#6. Ruth Cadbury. Show the total amount payable by guest Ruth Cadbury for her room bookings. You should JOIN to the rate table using room_type_requested and occupants. 
select sum(amount*nights)
from booking join rate on room_type_requested = room_type and occupants = occupancy
where booking_id in (select booking_id
from booking join guest on guest_id = id
where first_name = 'Ruth' and last_name = 'Cadbury')

#7.Including Extras. Calculate the total bill for booking 5128 including extras.
select (b.nights*r.amount) + e.amount
from booking b join rate r on b.room_type_requested = r.room_type and b.occupants = r.occupancy 
     left join (select booking_id, sum(amount) as amount from extra group by booking_id) e on b.booking_id = e.booking_id
where b.booking_id = 5128

#8. Edinburgh Residents. For every guest who has the word “Edinburgh” in their address show the total number of nights booked. Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and number of nights. Order by last name then first name. 
select first_name, last_name, address, coalesce(sum(nights), 0)
from booking right join guest on guest_id = id
where address like '%Edinburgh%'
group by last_name, first_name, address
order by last_name, first_name

#9. Show the number of people arriving. For each day of the week beginning 2016-11-25 show the number of people who are arriving that day. 
select booking_date, count(occupants)
from booking
where booking_date between '2016-11-25' and '2016-11-25' + interval 6 day
group by booking_date

#10. How many guests? Show the number of guests in the hotel on the night of 2016-11-21. Include all those who checked in that day or before but not those who have check out on that day or before. 
select sum(occupants)
from booking
where (booking_date + interval nights day > '2016-11-21' and booking_date < '2016-11-21') 
     or booking_date = '2016-11-21'
     
#11. Coincidence. Have two guests with the same surname ever stayed in the hotel on the evening? Show the last name and both first names. Do not include duplicates. 
select distinct a.last_name, a.first_name, b.first_name
from (select * from booking join guest on guest_id = id) as a,
     (select * from booking join guest on guest_id = id) as b
where (a.last_name = b.last_name and a.first_name > b.first_name 
	  and a.booking_date + interval a.nights day > b.booking_date and a.booking_date < b.booking_date) 
   or (a.last_name = b.last_name and a.first_name > b.first_name and a.booking_date = b.booking_date)
order by a.last_name;

#12. Check out per floor. The first digit of the room number indicates the floor – e.g. room 201 is on the 2nd floor. For each day of the week beginning 2016-11-14 show how many guests are checking out that day by floor number. Columns should be day (Monday, Tuesday ...), floor 1, floor 2, floor 3.
select checkout_date, sum(1st), sum(2nd), sum(3rd)
from (
select (booking_date + interval nights day) as checkout_date, case when floor(room_no/100) = 1 then 1 else 0 end as 1st, 
case when floor(room_no/100) = 2 then 1 else 0 end as 2nd,
case when floor(room_no/100) = 3 then 1 else 0 end as 3rd
from booking
where (booking_date + interval nights day) between '2016-11-14' and ('2016-11-14' + interval 6 day)) as T
group by checkout_date;

#13. Who is in 207? Who is in room 207 during the week beginning 21st Nov. Be sure to list those days when the room is empty. Show the date and the last name. You may find the table calendar useful for this query. 
select i, TT.last_name
from calendar c left join (
select i as date, last_name
from calendar, (select booking_date, (booking_date + interval nights day) as checkout_date, room_no, last_name
from booking left join guest on guest_id = id
where ((booking_date + interval nights day) > '2016-11-21' and booking_date <= ('2016-11-21'+ interval 6 day)) and room_no = 207) as T
where i >= booking_date and i < checkout_date) as TT on c.i = TT.date
where c.i between '2016-11-21' and ('2016-11-21'+ interval 6 day)


# 15. Gross income by week. Money is collected from guests when they leave. For each Thursday in November show the total amount of money collected from the previous Friday to that day, inclusive. 

select CT.i, sum(TT.gross_income)
from
	(select i, week(i) as week
	from calendar 
	where weekday(i) = 3 and month(i) in (11,12) and year(i) = 2016) as CT 
		left join 
	(select T.checkout_date, amount + coalesce(extra_amount,0) as gross_income, 
			case when weekday in (5, 6) then week + 1 else week end as new_week, weekday 
	from 
		(select (b.booking_date + interval b.nights day) as checkout_date, 
				sum(b.nights*ra.amount) as amount, 
				week(b.booking_date + interval b.nights day) as week, 
				weekday(b.booking_date + interval b.nights day) + 1 as weekday
		from booking b 
			join rate ra 
			on (b.room_type_requested = ra.room_type and b.occupants = ra.occupancy)
		where month(b.booking_date + interval b.nights day) in (11,12) 
		group by checkout_date, week, weekday) as T
			left join 
			(select sum(e.amount) as extra_amount, 
					(booking_date + interval nights day) as checkout_date
			from booking b 
				join extra e 
				on b.booking_id = e.booking_id
			group by checkout_date) as ET 
			on T.checkout_date = ET.checkout_date) as TT 
		on CT.week = TT.new_week
group by CT.week