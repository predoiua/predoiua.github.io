---
layout: post
date:   2018-12-27 13:00:00
categories: java
---
* will be replace by toc
{:toc}


# Task
- it's a calculation
- can be a:
Runnable - get nothing, return nothing ( also a functional interface, a lambda )
Callable - produce result, can fail with exception

~~~java
public interface Runnable {
    void run();
}
public interface Callable<V> {
    V call() throws Exception;
}
~~~

can be run in current thread or in a diff thread with java.util.concurent
