---
layout: post
date:   2016-01-30 10:00:00
categories: mysql
---
* toc
{:toc}

#Mysql

##Docker

Start Mysql Image

~~~bash
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=pass -d mysql
~~~

Connect to it

~~~bash
docker run -it --link some-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
~~~

##Test engine

~~~
show engines;
~~~


