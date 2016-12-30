# sql zoo, create database

create database if not exists students;


# CREATE student

#You need to create a table with these columns: matric_no, first_name, last_name, date_of_birth

 #   The primary key is matric_no. Matric numbers are exactly 8 characters.
 #   Use up to 50 characters for names.
 #   There is a specific data type for dates.
create table student(
matric_no char(8) PRIMARY KEY NOT NULL, 
first_name varchar(50) not null,
last_name varchar(50) not null,
date_of_birth date
);

# Add some students to the database

# Add the following students:

#    Daniel Radcliffe, matric 40001010 DoB 1989-07-23
#    Emma Watson, matric 40001011 DoB 1990-04-15
#    Rupert Grint, matric 40001012 DoB 1988-10-24
insert into student values('40001010', 'Daniel', 'Radcliffe', '1989-07-23');
insert into student values('');


#CREATE module

#A module has the following columns

#    module_code (primary key, 8 characters)
#    module_title (up to 50 characters)
#    level (integer)
#    credits (integer default value is 20)
create table if not exists module(
module_code char(8) primary key not null,
module_title varchar(50) not null,
level int,
credits int not null default 20
);

# Add some modules
# Add the following modules, they are all 20 credits - the first two digits let you know the level:

#    HUF07101, Herbology
#    SLY07102, Defense Against the Dark Arts
#    HUF08102, History of Magic

insert into module(module_code, module_title, level) values('HUF07101', 'Herbology', 7);

# CREATE registration

#The registration table has three columns matric_no, module_code, result - the matric_no and module_code types should match the tables you have just created. Result should be a number with one decimal place.

#Make sure you include a composite primary key and two foreign keys. 

create table if not exists registration(
matric_no char(8),
module_code char(8),
result DECIMAL(4,1),
primary key (matric_no, module_code),
foreign key (matric_no) references student(matric_no),
foreign key (module_code) references module(module_code)
);

# Add some data

#    Daniel got 90 in Defence Against the Dark Arts, 40 in Herbology and does not yet have a mark for History of Magic
#    Emma got 99 in Defence Against the Dark Arts, did not take Herbology and has no mark for History of Magic
#    Ron got 20 in Defence Against the Dark Arts, 20 in Herbology and is not registered for History of Magic
insert into registration values('40001010', 'HUF07101', 40);
insert into registration values('40001010','HUF08102',null);
# etc

# Run some queries

# Produce the results for SLY07102. For each student show the surname, firstname, result and 'F' 'P' or 'M'

#    F for a mark of 39 or less
#    P for a mark between 40 and 69
#    M for a mark of 70 or more

select case when result <= 39 then F
			when result >= 70 then M
            else P end
from student s join registration r on s.matric_no = r.matric_no
where module_code = 'SLY07102'
 
