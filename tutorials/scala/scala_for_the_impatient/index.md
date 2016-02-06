---
layout: post
date:   2015-08-23 12:00:00
categories: scala
---
* will be replace by toc
{:toc}

# Scala for the impatient

## 1.The Basics A1

- Augmented classes : StringOps, RichInt, RichDouble ..
- No ++, use val += 1. Reason : Int is immutable
- import math._ same as import math.* in java
- scala.Int = Int, import scala.math._ = import math._ and so on
- many classes have companion singleton objects ( for static method )
- "Hello"(4) = "Hello".apply(4). Used for build objects.

~~~ scala
2.to(10)
2 to 10
2.toString // instead of cast
3+4 // same as 3+(4)
~~~

## 2. Control Structures and Functions A1

- Scala if statement ~= c ?: expression
- Type of

~~~ scala
if ( x>0 ) 1 else "Text"
~~~
is Any

- \:paste -> to paste text in REPL
- a block {} contains expressions an is also an expression
- assignments have type Unit. Unit has a single value ()
- for loop:

~~~ scala
for ( i <- 1 to 10) println(i)
for ( i <- 20 to 10 by -1) println(i)
for ( i <- 1 to 3; j <- 1 to 3 if i != j ) print ( (10*i + j) + " " )
~~~
- function 

~~~ scala
def fac(n: Int) = {
    var r = 1
    for (i<- 1 to n) r *= i
    r
}
fac(3)
def facr(n: Int=3): Int = if (n==1) 1 else n * facr(n-1)
facr()
~~~
- Variable Arguments

~~~ scala
def sum(args: Int*) = {
    var rez = 0; for( a <- args ) rez += a
    rez
}
sum (1,2,3)
def sum1(args: Int*):Int =
    if (args.length == 0)
    0 else
    args.head + sum1(args.tail : _*)
sum1(1,2,3)
~~~
- Procedure

~~~ scala
def proc(s:String) { println("hei")} // No = before {
// same as
def proc1(s:String):Unit = { println("hei")}
~~~
- Lazy
lazy val = evaluated at first usage
val = evaluated as soon as defined
def = evaluated at each usage

~~~ scala
lazy val words = io.Source.fromFile("/usr/share/dict/words").mkString
~~~
- Exception

try { ... } catch { ... } finally { ... }

## 3. Array A1

Key points:

- Array for fixed size, ArrayBuffer for variable size
- no "new" when supply initial values
- () to access elements. Similar with [] in C, Java
- for (elem <- array)
- for (elem <- array if ...) yield .. to transform existing array in a new one
- scala Array = java Array, scala ArrayBuffer = collection.JavaConversions

- Fixed size Array

~~~ scala
var arrgs=new Array[String](3) // will be an Array initialized to nulls, Int initialized to 0
arrgs(1) // null
var a = Array(1,2,3)
for(i<-a) println(i);
~~~

- Variable size Array = Array Buffer

~~~ scala
import collection.mutable.ArrayBuffer
var b = new ArrayBuffer[Int]()
b += 10 // add new element at the end
b += ( 1,2,3)
b ++= Array(1,2,3)
for(elem <- b) println( elem );
for(i <- 0 unil b.size ) println (b(i)); //!!until =  0 until 10 = 0 to 9
~~~

- Transforming array

~~~ scala
var b = Array(2,3,5,6,11)
val result = for(elem <- b if( elem%2 ==0) ) yield elem * 2// same as ..
b.filter( _ % 2 == 0 ).map( 2 * _ ) // same as ..
b filter { _ % 2 == 0 } map { 2 * _ }
~~~

- common algorithms

~~~ scala
Array(1,2,3).sum
(1 to 3).max
b.sortWith( _ < _ )
b.mkString(" and ")
b.mkString("<",",",">")
~~~

## 4. Maps and Tuples A1

Key points:

- need to select mutable or immutable maps
- default is immutable hash map

- constructing a map

~~~ scala
var scores = Map("alice"->10,"bob"->9)
// Muttable
val scores = scala.collection.mutable.Map("alice" -> 10, "bob" -> 3, "bindy" -> 8)
scores("alice") = 22
for ((k,v)<-scores) println( k + ":" + v)
//Java interoperability
import scala.collection.JavaConversions.mapAsScalaMap
val scores: scala.collection.mutable.Map[String, Int] = new java.util.TreeMap[String, Int]
~~~

- tuples

~~~ scala
val t = (1, 3.14, "Fred") // type Tuple3[Int, Double, java.lang.String
t._2
~~~

##5. Classes A1

- fields in classes come with getters and setters
- a field can be replace by custom getter and setter
- use @BeanProperty to generate JavaBeans getXXX/setXXX
- every class has a primary constructor its paramters = fields. It exectues all statements in the body of the class
- Auxiliary constructors = this
- use () at method end for mutator one, skip () for accessor methods

Check java code generated from Scala

~~~ bash
scalac person.scala
javap -private Person
~~~

~~~scala
class Counter { // no public
	private var value = 0 // fields must be initialized
	def increment() { value += 1} // methods are public by default
	def current() = value
}
val myC = new Counter // or new Counter()
myC.increment // or myC.increment()
println(myC.current)
class Person {
	var age = 0
}
var p = new Person
p.age = 21
println (p.age)
p.age_=(22)
println (p.age()) // ?? it is in java class, but I can't call it

class Person{
	private var page=0
	private[this] var value = 0 // only method in this class can use value field
	def age = page
	def age_= (newValue:Int)= page = newValue
}

import scala.beans.BeanProperty
class Person{
	@BeanProperty var name:String =  _
}
class Person(val name: String, val age: Int) { // Primary Constructor
	println("part of Primary Constructor")
	def this(name:String){
		this(name, 0) // call to primary constructor must be first
		println("auxiliary constructor")
	}
}
class Person(val name: String = "", val age: Int = 0) // use this to avoid auxiliary constructors
~~~