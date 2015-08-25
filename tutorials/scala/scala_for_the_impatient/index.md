---
layout: post
date:   2015-08-23 12:00:00
categories: scala
---
* will be replace by toc
{:toc}

#Scala for the impatient

##1.The Basics A1

- Augmented classes : StringOps, RichInt, RichDouble ..
- No ++, use val += 1. Reason : Int is immutable
- import math._ same as import math.* in java
- scala.Int = Int, import scala.math._ = import math._ and so on
- many classes have companion singleton objects ( for static method )
- "Hello"(4) = "Hello".apply(4). Used for build objects.

~~~ scala
2.to(10)
2 to 10
2.toString // instead of cast2.to(10)
3+4 // same as 3.(4)
~~~

##2. Control Structures and Functions A1

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

