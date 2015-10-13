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
		System.out.println("initilizing...");
		elems = new ArrayList<>();
		elems.add("test1");
		elems.add("test2");
		elems.add("test3");	
	}

	public TestInitialize(){
		System.out.println("constructor...");
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
