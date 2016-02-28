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

- functional interface = interface with a single abstract method
- conversion to a functional interface is the only thing that you can do with a lambda expression in Java

### 1.4 Method References

~~~
button.setOnAction(event -> System.out.println(event));
button.setOnAction(System.out::println);
(x, y) -> x.compareToIgnoreCase(y)
~~~

method reference
- object :: instanceMethod
- Class :: staticMethod
- Class :: instanceMethod
- super::method

### 1.5 Constructor References

- like method references, method = new

~~~
List<String> labels = Arrays.asList("one", "two", "three");
Stream<Button> stream = labels.stream().map(Button::new);
List<Button> buttons = stream.collect(Collectors.toList());
Button[] buttons = stream.toArray(Button[]::new);
~~~

### 1.6 Variable Scope

Lambda:
1. A block of code
2. Parameters
3. Values for the free variables, that is, the variables that are not parameters and not defined inside the code

Obs: params in the following code are captured by lamba, and exists after method return = closure

~~~
public static void repeatMessage(String text, int count) {
	Runnable r = () -> {
		for (int i = 0; i < count; i++) {
			System.out.println(text);
			Thread.yield();
		}
	};
	new Thread(r).start();
}
~~~

### 1.7 Default Methods

default methods = interface methods with concrete implementations
Method resolving rules:
- Superclasses win. If a superclass provides a concrete method, default methods with the same name and parameter types are simply ignored.
- Interfaces clash. If a superinterface provides a default method, and another interface supplies a method with the same name and parameter types (default or not), then you must resolve the conflict by overriding that method

~~~java8
list.forEach(System.out::println);

interface Person {
	long getId();
	default String getName() { 
		return "John Q. Public"; 
	}
}
~~~

### 1.8 Static Methods in Interfaces


Up to now, it has been common to place static methods in companion classes.
You find pairs of interfaces and utility classes such as Collection / Collections or Path / Paths in the standard library.

~~~java8 
public inerface Path {
	public static Path get(String first, String... more) {
		return FileSystems.getDefault().getPath(first, more);
	}
}
Comparator.comparing(Person::name)
~~~

## 2.The Stream API


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

## 8.Miscellaneous Goodies

### 8.1 Strings

~~~java
String joined = String.join("/", "usr", "local", "bin"); // vs String.split
~~~

### 8.2 Number Classes

Reductor funtion : 
- min, max, sum in Short , Integer , Long , Float , and Double.
- logicalAnd , logicalOr , and logicalXor in Boolean

Integer types now support unsigned arithmetic.
Byte.toUnsignedInt(b)

The primary reason to use unsigned numbers is if you work with file formats or network protocols that require them.

### 8.3 New Mathematical Functions

The Math class provides several methods for “exact” arithmetic that throw an exception when a result overflows.
Work with int/long numbers.
( add | subtract | multiply | increment | decrement | negate )Exact

~~~java
Math.multiplyExact(100000, 100000)
~~~

floorMod and floorDiv to deal with negative %.

~~~java
((position + adjustment) % 12 + 12) % 12
~~~

### 8.4 Collections

- support for stream

### 8.4.1 Methods Added to Collection Classes

- removeIf opposite of filter
- List interface has a replaceAll which is an in-place equivalent of map

- Iterable forEach
- Collection removeIf
- List replaceAll, sort
- Map forEach, replace, replaceAll, remove(key, value) (removes only if key mapped to value), putIfAbsent, compute, computeIf(Absent|Present), merge
- Iterator forEachRemaining
- BitSet stream

### 8.4.2 Comparators

~~~
Arrays.sort(people, Comparator.comparing(Person::getName));
Arrays.sort(people,Comparator.comparing(Person::getLastName).thenComparing(Person::getFirstName));
Arrays.sort(people, Comparator.comparingInt(p -> p.getName().length()));
~~~

### 8.4.3 The Collections Class

Checked collection that throw exception if you try to add wrong type.
emptySorted ( Set | Map )

~~~
CheckedQueue(new LinkedList<Path>, Path.class)
~~~

### 8.5 Working with Files

### 8.5.1 Streams of Lines

~~~
try (Stream<String> lines = Files.lines(path)) {
	Optional<String> passwordEntry = lines.filter(s -> s.contains("password")).findFirst();
}
try (Stream<String> filteredLines = Files.lines(path).onClose(() -> System.out.println("Closing")).filter(s -> s.contains("password"))) { 
}
try (BufferedReader reader= new BufferedReader(new InputStreamReader(url.openStream()))) {
	Stream<String> lines = reader.lines();
}
~~~

### 8.5.2 Streams of Directory Entries

Since reading a directory involves a system resource that needs to be closed, you should use a try block:

~~~
try (Stream<Path> entries = Files.list(pathToDirectory)) {
}
try (Stream<Path> entries = Files.walk(pathToRoot)) {
	// Contains all descendants, visited in depth-first order
}
~~~

### 8.5.3 Base64 Encoding

The Base64 encoding uses 64 characters to encode six bits of information:
- 26 uppercase letters A . . . Z
- 26 lowercase letters a . . . z
- 10 digits 0 . . . 9
- 2 symbols, + and / (basic) or - and _ (URL- and filename-safe variant

MIME standard used for email requires a "\r\n" line break every 76 characters.

~~~java
Base64.Encoder encoder = Base64.getEncoder();
String original = username + ":" + password;
String encoded = encoder.encodeToString(original.getBytes(StandardCharsets.UTF_8));
~~~

Wrap an output stream.

~~~
Path originalPath = ..., encodedPath = ...;
Base64.Encoder encoder = Base64.getMimeEncoder();
try (OutputStream output = Files.newOutputStream(encodedPath)) {
	Files.copy(originalPath, encoder.wrap(output));
}
~~~

### 8.6 Annotations