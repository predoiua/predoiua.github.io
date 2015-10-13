---
layout: post
date:   2015-10-14 21:00:00
categories: java
---
* will be replace by toc
{:toc}

##Map, flatMap

Based on : http://www.brunton-spall.co.uk/post/2011/12/02/map-map-and-flatmap-in-scala/

~~~scala
val l = List(1,2,3,4)
l.map(x=>x*2)
l map ( _ * 2 )

def f(x:Int) = if (x>2) Some(x) else None
l.map(x=>f(x))
//List(None, None, Some(3), Some(4))

l.flatMap(x=>f(x))
//List[Int] = List(3, 4)
~~~

##fold


