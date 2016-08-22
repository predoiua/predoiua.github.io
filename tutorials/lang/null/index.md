---
layout: post
date:   2016-04-10 13:00:00
categories: language training null
---
* toc
{:toc}

# Null

### SQL

- unknown value. Is a value that we don't know anything about.
- special operator for checking "is null"
- not true or false

~~~pl/sql
select *
from dual
where dummy is not null;

declare
	m_boolean boolean := null;
begin
	if (m_boolean is true or m_boolean is false) then
		raise_application_error(-20000,'null is not true or false');
	end if;
end;
/
~~~

### Java

- un-initialized variable of type Object

~~~java
Object val;
if (null == val) {
   System.out.println("it is")
}
~~~

### Scala


### JS

### Go

### Python

- None. A singleton object of type None
- "is" operator for object comparison

### Bash

### Clojure

- nil. It represents the absence of a value.
 
