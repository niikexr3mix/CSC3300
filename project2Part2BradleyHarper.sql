-- -- CSC 3300-001, Spring 2021, Project 2 Part 2
-- -- Name: Bradley Harper
-- -- The due date for this project is 03/24/2021 at 11:59pm. The end date for this project is 03/26/2021 at 11:59pm.

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

-- -- 1. Course(s) for which only one section was created in the Spring 2009 semester.

select course_id, count(sec_id) as sectionNum
from section
where semester = 'Spring' and year = 2009 and sec_id < 2
group by course_id;

-- -- 2. Grades given to student(s).

select distinct grade
from takes
where grade IS NOT NULL
order by grade;

-- -- 3. ID(s) of instructor(s) who is\are advisor(s).

select distinct instructor.ID
from instructor natural join advisor
where instructor.ID = advisor.i_id and i_id IS NOT NULL;

-- -- 4. Course section(s) instructor(s) Srinivasan taught in the Fall 2009 semester. We are only interested in course id and sec  id here, cause course section is uniquely identified by the values for course_id, sec_id, semester, year and values for attributes semester, year we already know (these are ’Fall’, 2009 respectively).

select course_id, sec_id
from instructor natural join teaches
where instructor.name = 'Srinivasan' and semester = 'Fall' and year = 2009;

-- -- 5. Instructor(s) who taught course(s) offered by different department they are associated with. Retrieve IDs and names of these instructors only.

select instructor.ID, instructor.name
from ((instructor natural join teaches) join course)
where course.dept_name <> instructor.dept_name and teaches.course_id = course.course_id; -- uhhhh not sure if this worked

-- -- 6. IDs and names of students who don’t have advisors. Hint: What does the tuple e.g. (s_id:1, i_id:null) of the advisor relation mean? Assumption: Value of any foreign key attribute can be null, but value of any primary key attribute can not be null.

Select distinct S.ID, S.name
from student as S join advisor as A on A.s_id <> 'null'
where S.ID not in
(Select A.s_id from advisor A)
order by S.ID;

-- -- 7. Course(s) (course_id(s) and title(s)) that was\were offered in the Spring 2010 semester.

select distinct course_id, title
from course natural join section
where semester = 'Spring' and year = 2010;

-- -- 8. Course(s) that are a prerequisite to some course(s). We are interested in course_id(s) only.

select distinct course.course_id
from course join prereq
where prereq.prereq_id = course.course_id;

-- -- 9. Course(s) with prereqisite(s) from other departments. We are interested in course id(s), title(s) and dept name(s) of a course with its prerequisite’s course_id(s), title(s) and dept_name(s).

select course.course_id, course.title, course.dept_name
from (course as T1) join (course natural join prereq)
where T1.dept_name != course.dept_name and course.course_id != T1.course_id and T1.course_id = prereq.prereq_id;

-- -- 10. Students who received grade A for course CS-190 in the Spring 2009 semester. Retrieve ID(s) of student(s) along with their name(s).

select student.ID, student.name
from student natural join takes
where grade = 'A' and course_id = 'CS-190' and semester = 'Spring' and year = 2009;

-- -- 11. Course section(s) what student(s) enrolled in but no one taught. We are interested in course_id(s), sec_id(s), semester(s), year(s) here.

select takes.course_id, takes.sec_id, takes.semester, takes.year
from (student natural join takes) join (instructor natural join teaches)
where instructor.ID is null; -- how do i say this is null

-- -- 12. Classroom(s) with the smallest capacity. We are interested in building and room number here.

select building, room_number
from classroom
where capacity = (select min(capacity) from classroom);

-- -- 13. Student(s) whose name(s) are the same as name(s) of some instructor(s). We are interested in ID(s) and name(s) of this\those student(s).

select student.ID, student.name
from student join instructor
where student.name = instructor.name;

-- -- 14. Student(s) taught by their advisor. We are interested in ID(s) and name(s) of this\those student(s).

select distinct student.ID, student.name
from (student natural join takes) join advisor join teaches
where advisor.s_id = student.ID and advisor.i_id = teaches.ID and takes.course_id = teaches.course_id and takes.year = teaches.year and takes.semester = teaches.semester and takes.sec_id = teaches.sec_id;

-- -- 15. Student(s) instructor with ID 15151 taught. We are interested in ID(s) and name(s) of this\those student(s).

select student.name, student.ID
from (student natural join takes) join (teaches natural join instructor)
where instructor.ID = 15151 and takes.course_id = teaches.course_id and takes.sec_id = teaches.sec_id;

-- -- 16. Student(s) that got a grade A for both courses: CS-315 and CS-347.

select distinct student.name
from student natural join takes
where (course_id = 'CS-315' or course_id = 'CS-347') and grade = 'A';

-- -- 17. Course section(s) taught by 2 instructors during the same semester and year.

select T.course_id, T.sec_id 
from teaches as T, instructor as I
where T.ID = I.id
group by sec_id, semester, year 
having count(distinct T.ID) = 2;
        
-- -- 18. Course ID(s) and name(s) that were never offered.

select *
from (select course_id, title from course) as C
where (course_id) not in (select course_id from section);

-- -- 19. Building(s) student(s) Brown had classes in the Spring 2010 semester.

select distinct building
from student natural join classroom natural join takes
where student.name = 'Brown' and semester = 'Spring' and year = 2010;

-- -- **** 20. Name(s) and ID()s of student(s) that instructor(s) Gold taught.

select student.name, student.ID
from (student natural join takes) join (teaches natural join instructor)
where instructor.name = 'Gold' and takes.course_id = teaches.course_id and takes.sec_id = teaches.sec_id;
