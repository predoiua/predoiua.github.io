---
layout: post
date:   2015-11-30 13:00:00
categories: oracle
---
* will be replace by toc
{:toc}

# Expert Oracle Database Architecture

## 3. Files

The files associated with an instance are:

- Parameter files: These files tell the Oracle instance where to find the control files, and they also specify certain initialization parameters that define how big certain memory structures are, and so on. 
- Trace files: These are diagnostic files created by a server process, generally in response to some exceptional error condition.
- Alert files: These are similar to trace files, but they contain information about “expected” events.

The files that make up the database are:

- Data files: These are for the database; they hold your tables, indexes, and all other data segment types.
- Temp files: These are used for disk-based sorts and temporary storage.
- Control files: These tell you where the data files, temp files, and redo log files are, as well as other relevant metadata about their state. They also contain backup information maintained by RMAN (Recovery Manager, the backup and recovery tool).
- Redo log files: These are your transaction logs.
- Password files: These are used to authenticate users performing administrative activities over the network.

Optional file types that are used by Oracle to facilitate faster backup and faster recovery operations. These two new files are:

- Change-tracking file: This file facilitates a true incremental backup of Oracle data. It does not have to be located in the Flash Recovery Area, but as it relates purely to database backup and recovery.
- Flashback log files: These files store “before images” of database blocks in order to facilitate the new FLASHBACK DATABASE command


Files commonly associated with the database, such as:

- Dump (DMP) files: These files are generated by the Export database utility and consumed by the Import database utility.
- Data Pump files: These files are generated by the Oracle Data Pump Export process and consumed by the Data Pump Import process. This file format may also be created and consumed by external tables.
- Flat files: These are plain old files you can view in a text editor. You normally use these for loading data into the database.

### 3.13 Data Pump Files

They are cross-platform (portable) binary files that contain metadata (not stored in CREATE/ALTER statements, but rather in XML) and possibly data.


## 15. Data Loading and Unloading

Loading :

- SQL*Loader
- External tables

Unloading :

- Flat file unload
- Data Pump unload : Data Pump tool and external tables

### 15.1 SQL*Loader

Conventional path ( with SQL insert ) or Direct path

~~~bash
od -c -w10 -v demo1.cfg
sqlldr userid=/ control=demo1.ctl
~~~

~~~
LOAD DATA
INFILE *
INTO TABLE DEPT
REPLACE
FIELDS TERMINATED BY ','
(
	DEPTNO,
	DNAME "upper(:dname)",
	LOC "upper(:loc)",
	LAST_UPDATED date 'dd/mm/yyyy',
	ENTIRE_LINE ":deptno||:dname||:loc||:last_updated"
)
BEGINDATA
10,Sales,Virginia,1/5/2000
20,Accounting,Virginia,21/6/1999
~~~

### 15.2 External Tables

~~~bash
sqlldr / demo1.ctl external_table=generate_only
vi demo1.log
~~~

### 15.3 Flat File Unload

Oracle don't provide a tool for this. Write your own pl/sql program.

### 15.4 Data Pump Unload

~~~sql
create or replace directory tmp as '/tmp';

create table all_objects_unload
	organization external
	( 
		type oracle_datapump
		default directory TMP
		location( 'allobjects.dat' )
	)
as
	select *
	from all_objects
	where rownum<10;

#on origin server
select dbms_metadata.get_ddl( 'TABLE', 'ALL_OBJECTS_UNLOAD' ) from dual;

cp /tmp/allobjects.dat /tmp/aa.dat

strings /tmp/allobjects.dat | head

#on dest server
CREATE TABLE aa
(
	"OWNER" VARCHAR2(30),
	"OBJECT_NAME" VARCHAR2(30),
	"SUBOBJECT_NAME" VARCHAR2(30),
	"OBJECT_ID" NUMBER,
	"DATA_OBJECT_ID" NUMBER,
	"OBJECT_TYPE" VARCHAR2(19),
	"CREATED" DATE,
	"LAST_DDL_TIME" DATE,
	"TIMESTAMP" VARCHAR2(19),
	"STATUS" VARCHAR2(7),
	"TEMPORARY" VARCHAR2(1),
	"GENERATED" VARCHAR2(1),
	"SECONDARY" VARCHAR2(1)
)
ORGANIZATION EXTERNAL
( 
	TYPE ORACLE_DATAPUMP
	DEFAULT DIRECTORY "TMP"
	LOCATION
	( 'aa.dat')
)
~~~