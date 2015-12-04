---
layout: post
date:   2015-11-23 14:00:00
categories: oracle
---
* toc
{:toc}

#15. Data Loading and Unloading

Loading:

- SQL*Loader : This is still a predominant method forloading data.
- External tables: permits access to OS as if they were database tables and, in Oracle 10g and above,
even allows for the creation of operating system files as extracts of tables.

Unloading:
- Flat file unload: The flat file unloads will be custom developed implementations.
- Data Pump unload: Data Pump is a binary format proprietary to Oracle and accessible via the Data Pump tool and external tables.

##15.1 SQL*Load

2 operating mode:
- Conventional path: SQLLDR will employ SQL inserts on our behalf to load data.
- Direct path: SQLLDR does not use SQL in this mode; it formats database blocks directly.