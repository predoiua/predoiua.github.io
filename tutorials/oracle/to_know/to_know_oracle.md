---
layout: post
date:   2015-10-13 22:00:00
categories: oracle
---
* toc
{:toc}

#To Know

##Server administration

###Automatically start Oracle 10g on CentOS 5

~~~bash
1. vi /etc/oratab. At the end should be Y
2. vi $ORACLE_HOME/bin/dbstart
line 78 set ORACLE_HOME_LISTNER=$ORACLE_HOME
3.
> /etc/rc.d/init.d/oracle

echo '#!/bin/bash
# chkconfig: 345 99 10
# description: Oracle auto start-stop script.
case "$1" in
  start)
        su - oracle -c dbstart >> /var/log/oracle
        su - oracle -c "lsnrctl start" >> /var/log/oracle
        ;;
  stop)
        su - oracle -c "lsnrctl stop" >> /var/log/oracle
        su - oracle -c dbshut >> /var/log/oracle
        ;;
  restart)
        su - oracle -c dbshut >> /var/log/oracle
        su - oracle -c dbstart >> /var/log/oracle
        su - oracle -c "lsnrctl stop" >> /var/log/oracle
        su - oracle -c "lsnrctl start" >> /var/log/oracle
        ;;
  *)
        echo "Usage: oracle {start|stop|restart}"
        exit 1
esac
'>> /etc/rc.d/init.d/oracle

chmod 750 /etc/rc.d/init.d/oracle

#chkconfig --add oracle
chkconfig --level 2345 oracle on
chkconfig --list oracle
~~~

###Import data with DB pump but change data file location

Tablespaces have to be moved in a distinct step.
I was unable to create both users and tablespaces in same step.

~~~bash
...
remap_datafile=\"/tmp/test01.dbf\":\"/home/oracle/oradata_11g/test01.dbf\"
...
~~~
http://www.dba-oracle.com/t_rman_173_impdp_remap.htm


###Check if an user is connected in Oracle

~~~sql
select s.sid, s.serial#, s.status, p.spid 
from v$session s, v$process p 
where s.username = 'myuser' 
and p.addr (+) = s.paddr;
~~~

###Create DB link

~~~sql
DROP PUBLIC DATABASE LINK remote; 
CREATE PUBLIC DATABASE LINK remote CONNECT TO scott IDENTIFIED BY tiger USING 'remote'; 
~~~

###Modify column data type

~~~sql
alter table table_name
modify ( 
   column_name    varchar2(30)
);
~~~

##SQL

###Order : asc = default order

~~~ sql
select * from DBA_DB_LINKS order by CREATED;
--- same as
select * from DBA_DB_LINKS order by CREATED ASC;
~~~

###Operations over DB link restriction

- no DML

