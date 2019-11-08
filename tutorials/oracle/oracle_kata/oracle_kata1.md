---
layout: post
date:   2016-08-24 13:00:00
categories: oracle training
---
* toc
{:toc}

# Administration

## Drop user

~~~ sql
shutdown immediate;
startup restrict;
drop user REPORTING cascade;

shutdown immediate;
startup;
~~~

## Drop tablespace

~~~
select tablespace_name from dba_tablespaces
alter tablespace REPORTING_DATA offline;
drop tablespace REPORTING_DATA including contents;
~~~


# sqlplus

~~~ sqlplus
host
host clear
select username from all_users;

define
define _editor = "vi"
column username format a25
set pagesize 0
clear columns

SET MARKUP HTML ON SPOOL ON
spool a.html
/
SET MARKUP HTML OFF SPOOL OFF
~~~