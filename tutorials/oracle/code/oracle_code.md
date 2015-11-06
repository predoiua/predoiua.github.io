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

###Using objects

http://stackoverflow.com/questions/1020348/oracle-select-from-record-datatype

~~~sql
create type myobj is object ( 
   id int
  ,name varchar2(10)
);
/

create package mypkg as
      function f return myobj;
end mypkg;
/


create package body mypkg  as
  function f return myobj
  is
  begin
    return myobj(1,'test');
  end f;
end mypkg;
/

select mypkg.f from dual;
/

drop package mypkg;
/

drop type myobj;
/
~~~

###Delete from views

Outer joins can lead to nasty errors. ( Tested in 10 and 11)

~~~sql
drop table x;
create table x(id number);
insert into x values (1);
insert into x values (2);
insert into x values (3);
insert into x values (4);
insert into x values (5);

drop table y;
create table y(id number);
insert into y values (1);
insert into y values (2);

commit;
delete from (
    select x.*
    from x
        left join y on x.id = y.id 
    where x.id is null
);
-- error : ORA-01752: cannot delete from view without exactly one key-preserved table
alter table x add constraint uk_id unique ( id );
-- execute same delete 
-- error : ORA-00600: internal code error

delete from (
    select x.*
    from x
        join y on x.id = y.id 
);
-- rez=>OK

-- we need to delete with something like
delete from x where rowid in (
    select x.rowid
    from x
        left join y on x.id = y.id 
    where y.id is null
);
~~~

###Read sql data from bash

~~~
#!/bin/bash

#exit on error
set -e
#display commands
#set -x
while read -a row
do
        echo "I have:..${row[0]}..${row[1]}..${row[2]}.."
done < <(sqlplus -s scott/tiger << FIN
    set head off;
    set newpage none;
    set feedback off;
    select sysdate s, 'a' a, 'b' from all_objects where rownum < 5;
    exit;
FIN
)
~~~

###Execute sql commands from bash

~~~bash
#!/bin/bash
set -e

function execute_sql() {
    local p_conn=$1
    local p_sql=$3

    p_sql=${p_sql//old_string/new_string}
    p_res=`sqlplus -s ${p_conn} << FIN 2>&1
        set timing on
        ${p_sql}
        exit;
FIN
`
    echo "${p_res}"
}


function process() {
    local p_sql

    p_sql=$(cat<< FIN
        begin execute immediate 'drop table temp'; exception when others then null; end;
        /
        create table temp (
            row_id urowid
          ,code number
        );

        insert into temp( row_id, code )
        select rowid, 123 code
        from emp
        ;
        commit;

        delete from emp@db_link
        where rowid in ( select row_id from temp );

        commit;
FIN
)
    execute_sql "scott/tiger@orcl" "${p_sql}"

}

process
~~~