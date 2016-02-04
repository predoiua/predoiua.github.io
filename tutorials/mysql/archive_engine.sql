create database dw;
use dw;

create table f (
	code char(4)
	,name char(200)
	,id_loc int
	,id_age int
	,id_country int
	,salary decimal(5,2)
) engine=ARCHIVE;

create table d_loc(
	id int
	,code char(4)
	,name char(100)
) engine=ARCHIVE;


select sum(salary) salary
from f
	join d_loc on f.id_loc = d_loc.id
;

show table status like 'f';

