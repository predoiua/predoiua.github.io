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
