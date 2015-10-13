
#Oracle Data Pump (expdp)

Use data pump to migrate data from 10g to 11g.

## Check what to export

~~~sql
=========== check users to export ====
select username from all_users;
=========== check data file location ======
SELECT  FILE_NAME FROM DBA_DATA_FILES;
=========== check tablespaces ======
select TABLESPACE_NAME from dba_tablespaces;
=========== tablespace size =========================
select
    df.tablespace_name "Tablespace",
    totalusedspace "Used MB",
    (df.totalspace - tu.totalusedspace) "Free MB",
    df.totalspace "Total MB",
    round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace)) "Pct. Free"
from
    (
    select tablespace_name,
    round(sum(bytes) / 1048576) TotalSpace
    from dba_data_files
    group by tablespace_name
    ) df,
    (
    select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
    from dba_segments
    group by tablespace_name
    ) tu
where df.tablespace_name = tu.tablespace_name ;
============================
~~~

##Export

###1. Configure data pump
~~~bash
#as oracle in bash
mkdir -p /home/oracle/data_pump
#as system in sqlplus
CREATE or REPLACE DIRECTORY data_pump_dir AS '/home/oracle/data_pump';

###2. Create export

I need to create 2 exports: one for tablespace specifications, one for schemas

~~~bash
expdp system/manager \
    full=y \
    content=metadata_only \
    include=tablespace \
    directory=data_pump_dir  \
    dumpfile=tablespace.dmp


# test previous exp
impdp system/manager \
    full=y dumpfile=tablespace.dmp sqlfile=tablespace.sql \
    REMAP_DATAFILE=/home/oracle/oradata/TBL_02.dbf:/home/oracle/oradata/11g/TBL_01.dbf


expdp system/manager \
    CONTENT=ALL \
    schemas=SCH \
    directory=data_pump_dir \
    dumpfile=10g.dmp
~~~~

##Import

~~~sql
CREATE or REPLACE DIRECTORY data_pump_dir AS '/home/oracle/data_pump';
mkdir -p /home/oracle/oradata/11g

DROP TABLESPACE TBL_SCH_DATA INCLUDING CONTENTS AND DATAFILES;

impdp system/manager \
    full=y dumpfile=tablespace.dmp \
    REMAP_DATAFILE=/home/oracle/oradata/TBL_02.dbf:/home/oracle/oradata/11g/TBL_01.dbf

impdp system/manager \
    schemas=SCH \
    directory=data_pump_dir  \
    dumpfile=10g.dmp \
    REMAP_TABLESPACE=TBL_SCH_DATA:TBL_SCH_DATA \
    REMAP_DATAFILE=/home/oracle/oradata/TBL_02.dbf:/home/oracle/oradata/11g/TBL_01.dbf
~~~