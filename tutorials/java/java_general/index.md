---
layout: post
date:   2015-09-27 13:00:00
categories: java
---
* will be replace by toc
{:toc}

##Auto Import

For convenience, the Java compiler automatically imports three entire packages for each source file:

* (1) the package with no name, 
* (2) the java.lang package, and 
* (3) the current package (the package for the current file)...


##Non Static initializer

~~~ java
package vv10.test;
import java.util.ArrayList;

public class TestInitialize {
	private ArrayList<String> elems;

	{
		System.out.println("1.initilizing...");
		elems = new ArrayList<>();
		elems.add("test1");
		elems.add("test2");
		elems.add("test3");
	}

	public TestInitialize(){
		System.out.println("2.constructor...");
		for(String e : elems) {
			System.out.println(e);
		}
	}
	public static void main(String[] args){
		new TestInitialize();
	}
} 
~~~

run it with

~~~ sh
mkdir -p vv10/test
vi vv10/test/TestInitialize.java
javac vv10/test/TestInitialize.java
java vv10.test.TestInitialize
~~~

###Build a list

~~~java
{% raw  %}

//with an anonymous inner class
ArrayList<String> list1 = new ArrayList<String>() {{
    add(1);
    add(2);
    add(3);
}};

List<String> list1 = Arrays.asList(1,2,3);
{% endraw %}
~~~


###IntSteam

~~~java
import java.util.*;
import java.util.stream.IntStream;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class TestStream{
    public static void main(String[] args){
		int[] values = {3,10,6};
		IntStream.of(values)
			.filter(nr -> nr % 2 == 0)
			.forEach(value -> System.out.printf(" %d :",value));

		String[] strings ={"Red", "orange", "Yellow", "green", "Blue", "indigo", "Violet"};
		Stream<String> ss = Arrays.stream(strings);
		List<String> ls = ss
			.map(String::toUpperCase)
			.collect(Collectors.toList());
		System.out.printf("strings in uppercase: %s%n", ls);    }
}
~~~


###Enable java net debug

~~~bash
java  -Djavax.net.debug=all  ...
~~~