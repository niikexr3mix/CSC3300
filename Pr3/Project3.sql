use university;

FLUSH privileges;
create user 'brown'@'localhost' identified by 'brown123';


grant select on department to 'brown'@'localhost';
grant select on course to 'brown'@'localhost';
grant insert on course to 'brown'@'localhost';
grant delete on course to 'brown'@'localhost';
grant update (title) on course to 'brown'@'localhost';

grant select on prereq to 'brown'@'localhost';
grant insert on prereq to 'brown'@'localhost';
grant insert on prereq to 'brown'@'localhost';