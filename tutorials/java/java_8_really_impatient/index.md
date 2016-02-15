---
layout: post
date:   2016-01-30 10:00:00
categories: java
---
* toc
{:toc}

# Java 8 for the really impatient

## 1. Lambda Expressions

- A lambda expression is a block of code with parameters.
- Use a lambda expression whenever you want a block of code executed at a later point in time.
- Lambda expressions can be converted to functional interfaces.
- Lambda expressions can access effectively final variables from the enclosing scope.
- Method and constructor references refer to methods or constructors without invoking them.
- You can now add default and static methods to interfaces that provide concrete implementations.
- You must resolve any conflicts between default methods from multiple interfaces.

### 1.1 Why Lambdas?

### 1.2 The Syntax of Lambda Expressions

~~~java
(String first, String second)-> Integer.compare(first.length(), second.length())
() -> { for (int i = 0; i < 1000; i++) doWork(); }
Comparator<String> comp = (first, second) -> Integer.compare(first.length(), second.length());
~~~

### 1.3 Functional Interfaces

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

Syayic methods.
TemporalAdjusters for something like "the first Tuesday of every month"

~~~java
TemporalAdjuster NEXT_WORKDAY = TemporalAdjusters.ofDateAdjuster(w -> {
	LocalDate result = w; // No cast
	do {
		result = result.plusDays(1);
	} while (result.getDayOfWeek().getValue() >= 6);
	return result;
});
~~~

### 5.4 Local Time

A LocalTime represents a time of day, such as 15:30:00.

~~~java
LocalTime rightNow = LocalTime.now();
LocalTime bedtime = LocalTime.of(22, 30); // or LocalTime.of(22, 30, 0)
~~~

5.5 Zoned Time

Java uses the IANA database
https://www.iana.org/time-zones
Each time zone has an ID, such as America/New_York or Europe/Berlin .

~~~java
ZonedDateTime apollo11launch = ZonedDateTime.of(1969, 7, 16, 9, 32, 0, 0,ZoneId.of("America/New_York"));
ZonedDateTime nextMeeting = meeting.plus(Period.ofDays(7)); // OK
~~~

### 5.6 Formatting and Parsing

The DateTimeFormatter class provides three kinds of formatters to print a date/time value:
- Predefined standard formatters
- Locale-specific formatters
- Formatters with custom patterns

~~~java
DateTimeFormatter formatter = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.LONG);
String formatted = formatter.format(apollo11launch); // July 16, 1969 9:32:00 AM EDT
formatted = formatter.withLocale(Locale.FRENCH).format(apollo11launch); // 16 juillet 1969 09:32:00 EDT
~~~

### 5.7 Interoperating with Legacy Code

Instant class is a close analog to java.util.Date.
ZonedDateTime is a close analog to java.util.GregorianCalendar.

~~~java
//Instant - java.util.Date
Date.from(instant); date.toInstant()
//ZonedDateTime - java.util.GregorianCalenda
GregorianCalendar.from(zonedDateTime); cal.toZonedDateTime()
//DateTimeFormatter - java.text.DateFormat
formatter.toFormat()
//java.util.TimeZone - ZoneId
Timezone.getTimeZone(id); timeZone.toZoneId()
//java.nio.file.attribute.FileTime - Instant
FileTime.from(instant); fileTime.toInstant()
~~~

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