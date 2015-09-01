
Oracle Data Pump (expdp)
======================
Use data pump to migrate data from 10g to 11g.

0. Check what to export
=========== check users to export ====
select username from all_users;
=========== check data file location ======
SELECT  FILE_NAME FROM DBA_DATA_FILES
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


Start Oracle 10g
1. Configure data pump
mkdir -p /home/oracle/data_pump
CREATE or REPLACE DIRECTORY data_pump_dir AS '/home/oracle/data_pump';

2. Create export
I need to create 2 exports: one for tablespace specifications, one for schemas

expdp system/manager \
    full=y \
    content=metadata_only \
    include=tablespace \
    directory=data_pump_dir  \
    dumpfile=tablespace.dmp 

    include=tablespace :"IN ('TBL_WAVE60_DATA', 'TBL_WAVE60_INDX')" \

# test previous exp
impdp system/manager \
    full=y dumpfile=tablespace.dmp sqlfile=tablespace.sql \
    REMAP_DATAFILE=/home/oracle/oradata/kds/TBL_wave60_data_02.dbf:/home/oracle/oradata/11g/kds/TBL_wave60_data_01.dbf


expdp system/manager \
    CONTENT=ALL \
    schemas=WAVE60 \
    directory=data_pump_dir \
    dumpfile=10g.dmp 


Start Oracle 11g
CREATE or REPLACE DIRECTORY data_pump_dir AS '/home/oracle/data_pump';
mkdir -p /home/oracle/oradata/11g/kds

impdp system/manager \
    full=y dumpfile=tablespace.dmp \
    REMAP_DATAFILE=/home/oracle/oradata/kds/TBL_wave60_data_02.dbf:/home/oracle/oradata/11g/kds/TBL_wave60_data_01.dbf

impdp system/manager \
    schemas=WAVE60 \
    directory=data_pump_dir  \
    dumpfile=10g.dmp \
    REMAP_TABLESPACE=TBL_WAVE60_DATA:TBL_WAVE60_DATA \
    REMAP_DATAFILE=/home/oracle/oradata/kds/TBL_wave60_data_02.dbf:/home/oracle/oradata/11g/kds/TBL_wave60_data_01.dbf



