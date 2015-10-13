---
layout: post
date:   2015-10-07 21:00:00
categories: oracle
---
* will be replace by toc
{:toc}

#Getting started

##ORA-01410 – Invalid rowid

Run in 1st sqlplus session:

~~~ SQL
create table x as select 'a' dummy from all_objects where rownum < 100;


begin
for m in (SELECT * FROM x)
loop
    dbms_output.put_line(m.dummy);
    sys.dbms_lock.sleep(2);
end loop;
end;
/
~~~

Run in 2nd sqlplus session:

~~~ SQL
truncate table x;
insert into x values ( 'b' );
commit;
~~~~
