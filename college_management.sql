create database college_management;
use college_management;

create table student (student_id int primary key auto_increment,student_name varchar(100) not null,email varchar(100) unique not null,
age int check (age >= 18),city varchar(100) default 'visakhapatnam'
);
insert into student (student_name, email, age, city) values
('kavya', 'kavya@gmail.com', 22, 'visakhapatnam'),
('huvi', 'huvi@gmail.com', 23, 'hyderabad'),
('kumar', 'kumar@gmail.com', 24, 'vijayawada'),
('sai', 'sai@gmail.com', 21, 'guntur'),
('bhavani', 'bhavani@gmail.com', 25, 'visakhapatnam'),
('rani', 'rani@gmail.com', 22, 'hyderabad'),
('kalyani', 'kalyani@gmail.com', 23, 'nellore'),
('srinu', 'srinu@gmail.com', 26, 'tirupati'),
('geethu', 'geethu@gmail.com', 21, 'guntur'),
('akhil', 'akhil@gmail.com', 24, 'vijayawada');
select * from student;
desc student;

create table course (course_id int primary key auto_increment,course_name varchar(100) unique not null,fee decimal(10,2) not null check (fee > 0),
duration_months int check (duration_months > 0)
);
insert into course (course_name, fee, duration_months) values
('sql', 5000, 2),
('python', 7000, 3),
('excel', 3000, 1),
('power bi', 6000, 2),
('data analytics', 12000, 4),
('machine learning', 15000, 5),
('statistics', 8000, 3),
('tableau', 5500, 2),
('r programming', 6500, 3),
('data science', 18000, 6);
select * from course;
desc course;

create table enrollment (enrollment_id int primary key auto_increment,student_id int not null,course_id int not null,enrollment_date date not null,
status varchar(20) default 'active'check (status in ('active', 'completed', 'cancelled')),unique (student_id, course_id),
foreign key (student_id) references student(student_id)
on update cascade on delete cascade,
foreign key (course_id) references course(course_id)
on update cascade on delete cascade
);
insert into enrollment
(student_id, course_id, enrollment_date, status) values
(1, 1, '2026-01-10', 'active'),
(1, 2, '2026-01-12', 'completed'),
(2, 1, '2026-01-15', 'active'),
(2, 3, '2026-01-18', 'active'),
(3, 4, '2026-02-01', 'completed'),
(4, 5, '2026-02-05', 'active'),
(5, 6, '2026-02-10', 'active'),
(6, 7, '2026-02-15', 'cancelled'),
(7, 8, '2026-03-01', 'completed'),
(8, 9, '2026-03-05', 'active');
select * from enrollment;
desc enrollment;
show tables;

-- create
insert into student (student_name, email, age, city) values ('priya', 'priya@gmail.com', 22, 'hyderabad');
-- read
select * from student;
-- update
update student set city = 'chennai'where student_id = 10;
-- delete
delete from student where student_id = 11;

-- transaction
start transaction;
-- first update
update student set city = 'chennai' where student_id = 1;
-- create savepoint
savepoint s1;
-- second update
update student set city = 'visakhapatnam' where student_id = 2;
-- create another savepoint
savepoint s2;
-- third update
update student set city = 'pune' where student_id = 3;
-- rollback to s2
rollback to s2;
-- rollback to s1
rollback to s1;
-- commit remaining changes
commit;
-- verify records
select * from student;

-- crete view
create view student_details as select student_id, student_name, email, age, city from student;
select * from student_details;

-- crete another view
create view student_course_details as select s.student_name,c.course_name,c.fee,e.enrollment_date,e.status from student s
join enrollment e on s.student_id = e.student_id
join course c on e.course_id = c.course_id;
select * from student_course_details;

-- create index
create index idx_student_city on student(city);
select * from student where city = 'hyderabad';
show index from student;

create index idx_enrollment_status on enrollment(status);
select * from enrollment where status = 'active';
show index from enrollment;

select count(*) as total_students from student;
select sum(fee) as total_course_fees from course;
select avg(fee) as average_course_fee from course;
select max(fee) as highest_course_fee from course;
select min(fee) as lowest_course_fee from course;

select city as name from student union select course_name as name from course;

select city as location from student where age >= 23 union select city as location from student where age <= 22;

select max(fee) as second_highest_fee from course where fee < (select max(fee) from course);

select city as name from student union all select course_name as name from course;

select city, count(*) as total_students from student group by city;

select status, count(*) as total_enrollments from enrollment group by status;

select c.course_name, count(e.student_id) as total_students from course c left join enrollment e on c.course_id = e.course_id
group by c.course_id, c.course_name;

select e.status, avg(c.fee) as average_course_fee from enrollment e join course c on e.course_id = c.course_id group by e.status;

select city, avg(age) as average_age from student group by city;

select course_id, course_name, fee from course;

select c.course_name, count(e.enrollment_id) as total_enrollments,c.fee * count(e.enrollment_id) as total_fee_value from course c
join enrollment e on c.course_id = e.course_id
group by c.course_id, c.course_name, c.fee;

select city, count(*) as total_students from student group by city having count(*) >=2;

select s.student_name, c.course_name, e.status from student s inner join enrollment e on s.student_id = e.student_id 
inner join course c on e.course_id = c.course_id;

select s.student_name, e.course_id, e.status from student s left join enrollment e on s.student_id = e.student_id;

select c.course_name, e.student_id, e.status from enrollment e right join course c on e.course_id = c.course_id;

select s.student_name, c.course_name from student s cross join course c;

select city, count(*) as total_students from student group by city order by total_students desc;

select c.course_name, count(e.enrollment_id) as total_students  from course c join enrollment e on c.course_id = e.course_id
group by c.course_id, c.course_name
having count(e.enrollment_id) >=2
order by total_students desc;

select status, count(*) as total_enrollments from enrollment group by status having count(*) > 1 order by total_enrollments desc;

select s.student_name,c.course_name,c.fee,e.status,e.enrollment_date from enrollment e
join student s on e.student_id = s.student_id
join course c on e.course_id = c.course_id
where e.status = 'active'
order by e.enrollment_date desc;

select s.student_name, count(e.course_id) as total_courses from student s
join enrollment e on s.student_id = e.student_id
group by s.student_id, s.student_name having count(e.course_id) > 1
order by total_courses desc;

select c.course_name, count(e.enrollment_id) as total_enrollments from course c left join enrollment e on c.course_id = e.course_id
group by c.course_id, c.course_name
order by total_enrollments desc;

select s.student_name,count(e.enrollment_id) as total_courses from student s
left join enrollment e on s.student_id = e.student_id
group by s.student_id, s.student_name;

select course_name, fee from course where fee > 7000;

select s.student_id, s.student_name from student s where not exists (select 1 from enrollment e where e.student_id = s.student_id
);

select course_name, fee, duration_months from course where fee = ( select max(fee) from course);

select student_id, student_name, city from student order by student_name asc;

select course_name, fee from course where fee > (select avg(fee)from course);

select course_name, fee from course where fee between 5000 and 10000;

select student_name, email from student where student_name like 'k%';

select student_name from student where student_name like '%i';

select student_name, age from student where age between 22 and 24;

select student_name, city from student where city in ('hyderabad', 'guntur');

select max(fee) as third_highest_fee from course where fee < (select max(fee) from course where fee < (select max(fee) from course)
);

select enrollment_id, student_id, course_id, enrollment_date from enrollment order by enrollment_date desc, enrollment_id desc limit 1;

select count(distinct city) as total_cities from student;

select course_name, fee from course where course_id in (select course_id from enrollment group by course_id
having count(distinct student_id) >= 2
);

select c.course_name from course c where not exists (select 1 from enrollment e where e.course_id = c.course_id
);

select course_name, duration_months from course where duration_months < (select duration_months from course where fee = (select max(fee) from course)
);

select student_name, city from student s where exists (select 1 from enrollment e where e.student_id = s.student_id and e.status = 'completed'
);
select s.student_name from student s join enrollment e on s.student_id = e.student_id
join course c on e.course_id = c.course_id
where c.course_name in ('sql', 'python')
group by s.student_id, s.student_name
having count(distinct c.course_name) = 2;
