-- -- CSC 3300-001, Spring 2021, Project 2 Part 1
-- -- The due date for this project is 03/10/2021 at 11:59pm. The end date for this project is 03/12/2021 at 11:59pm.
-- -- Name:

-- -- Table List:
-- -- advisor(s_ID, i_ID)
-- -- classroom(building, room_number, capacity)
-- -- course(course_id, title, dept_name, credits)
-- -- department(dept_name, building, budget)
-- -- instructor(id, name, dept_name, salary)
-- -- prereq(course_id, prereq_id)
-- -- section(course_id, sec_id, semester, year, building, room_number, time_slot_id)
-- -- student(ID, name, dept_name, tot_cred)
-- -- takes(ID, course_id, sec_id, semester, year, grade)
-- -- teaches(ID, course_id, sec_id, semester, year)
-- -- time_slot(time_slot_id, day, start_hr, start_min, end_hr, end_min)

-- -- 1. Courses (IDs) and the number of sections that were created for them in the Spring 2009 semester.
select course_id, count(sec_id) as sectionNum
from section
where semester = 'Spring' and year = 2009 
group by course_id;


-- -- 2. Capacity of each building.
-- -- Example. Assume that at some univesity there are only 2 buildings: Bruner Hall and Foundation Hall. There are 2 classrooms in BH with total capacity of 50 and 3 classrooms in FH with total capacity of 70. In that case, the query should return the relation with 2 tuples: Brunner Hall | 50 and Foundation Hall | 70.
select building, sum(capacity) as capacity
from classroom
group by building;


-- -- 3. Schedule of course sections in Taylor room 3128 in the Fall 2009 semester ordered by day and then start time. 
-- -- The first column of the returned table should include info about a day, second one - info about start time, third one - info about end time, and the last two columns - info about course id and section id respectively. 
-- -- Sample tuple that could appear in the result: M | 8:00 | 8:50 | 3300 | 001.

select time_slot.day, concat(time_slot.start_hr,':', time_slot.start_min), concat(time_slot.end_hr, ':', time_slot.end_min), section.course_id, section.sec_id
from section natural join time_slot
where section.semester = 'Fall' and section.year = 2009 and section.building = 'Taylor' and section.room_number = 3128
order by FIELD(time_slot.day, 'M','T','W','R','F'), time_slot.start_hr, time_slot.start_min
;
-- -- 4. Courses (IDs and titles) with their prerequisites (IDs and titles).
select c.course_id, c.title, p.prereq_id, c1.title
from course as c
inner join prereq as p
on c.course_id = p.course_id
inner join course as c1 
on c1.course_id = p.prereq_id;


-- -- 5. Instructors (IDs and names) and the number of students they taught. Ignore instructors who were never assigned to teach any course section.

select instructor.ID, instructor.name, count(takes.ID) as numStudents
from instructor natural join teaches
join takes
where takes.course_id = teaches.course_id
and takes.year = teaches.year
and takes.semester = teaches.semester
group by instructor.ID, instructor.name;


-- -- 6. The biggest number of different teachers that taught some course.
select max(numTeachers)
from 
	(select course_id, count(ID) as numTeachers
	from teaches
	group by course_id) as t1;

-- -- 7. Students (IDs and names) along with info about courses (course_ids) they took more than 1 time.
select studentID, total, name, classInfo.courseID
from ((select count(course_id) as total, ID as studentID, course_id as courseID from takes as studentTakes
group by studentID, course_id) as classInfo natural join student as studentInfo)
where studentID = ID and total > 1
group by studentID, total, name, classInfo.courseID;

-- -- 8. Advisors (their IDs and names) of the Computer Science department along with info about students (their IDs and names) they advise. 
-- Returned data should be ordered in a specific way.
-- -- The first few tuples should show all students of a specific advisor. The next few tuples should show all students of some other advisor etc. Sample tuples that could appear in the result: 12121 | Korth | 101 | Green, 12121 | Korth | 103 | Brown, 12121 | Korth | 207 | Snow, 15151 | Silberschatz | 423 | Brandt. It is the case then, that at the top of the table we can see info about students advised by 12121 Korth, later on, we can see info about students advised by 15151 Silberschatz.

select instructor.ID, instructor.name, student.ID, student.name
from instructor, advisor, student
where advisor.i_id = instructor.ID and advisor.s_id = student.ID and instructor.dept_name = 'Comp. Sci.'
order by instructor.ID, instructor.name;

-- -- 9. Credit hours each instructor taught in the Fall semester 2009. Ignore instructors who didn't teach in that semester.

select teaches.ID, sum(credits) as numCredits
from teaches natural join course
where semester = 'Fall' and year = 2009 and teaches.course_id = course.course_id
group by teaches.ID;

-- -- 10. Ids of courses that have prerequisites.
select course_id
from prereq;

