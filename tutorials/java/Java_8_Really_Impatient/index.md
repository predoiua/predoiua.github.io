---
layout: post
date:   2016-01-30 10:00:00
categories: mysql
---
* toc
{:toc}

# Java 8 for the really impatient

## 5.The New Date and Time API

- All java.time objects are immutable.
- An Instant is a point on the time line (similar to a Date ).
- In Java time, each day has exactly 86,400 seconds (i.e., no leap seconds).
- A Duration is the difference between two instants.
- LocalDateTime has no time zone information.
- TemporalAdjuster methods handle common calendar computations, such as finding the first Tuesday of a month.
- ZonedDateTime is a point in time in a given time zone (similar to GregorianCalendar) .
- Use a Period , not a Duration , when advancing zoned time, in order to account for daylight savings time changes.
- Use DateTimeFormatter to format and parse dates and times.

### 5.1 The Time Line

The Java Date and Time API specification requires that Java uses a time scale that
- Has 86,400 seconds per day
- Exactly matches the official time at noon each day
- Closely matches it elsewhere, in a precisely defined way

The Instant and Duration classes are immutable, and all methods, such as multipliedBy or minus, return a new instance.

~~~java
Instant.MIN;// 1 bilion years ago
Instant.MAX;// 1 bilion years in future
Instant.now();// current instant
Duration timeElapsed = Duration.between(start, end);
~~~

### 5.2 Local Dates

Kinds of human time in the new Java API:
- local date/time
- zoned time

Zoned date/time =a precise instant on the time line eg.July 16, 1969, 09:32:00 EDT
LocalDate = months starts form 1. ( unlike util.Date where first month = 0)
For calculation use LocalDate or Instant.
Period = LocalDate difference.

~~~java
LocalDate today = LocalDate.now(); // Today’s date
LocalDate birthday = LocalDate.of(1903, 6, 14);
birthday = LocalDate.of(1903, Month.JUNE, 14);

LocalDate programmersDay = LocalDate.of(2014, 1, 1).plusDays(255); //255 day's of the the year
LocalDate.of(2016, 1, 31).plusMonths(1) ==  LocalDate.of(2016, 2, 28)
~~~

### 5.3 Date Adjusters

TemporalAdjusters for something like "the first Tuesday of every month"


## 7.The Nashorn JavaScript Engine

- Nashorn is the successor to the Rhino JavaScript interpreter
- You can run JavaScript through the jjs interpreter, or from Java via the scripting API.

### 7.1 Running Nashorn from the Command Line

Call command line interpretor

~~~bash
jjp
rlwrap jjs
~~~

~~~js
var input = new java.util.Scanner(new java.net.URL('http://horstmann.com').openStream())
input.useDelimiter('$')
var contents = input.next()
~~~