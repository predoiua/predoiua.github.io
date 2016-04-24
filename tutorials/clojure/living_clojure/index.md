---
layout: post
date:   2016-04-19 13:00:00
categories: clojure
---
* will be replace by toc
{:toc}

# Chapter 0. Install 

Install lein.
Start repl.

~~~
lein repl
~~~

# Chapter 1. The Structure of Clojure

## Simple values

~~~ lein
; Numerical values
42
1/3
4.0/2 ; invalid
; Math
(/ 1 3)
(/ 1 3.)
(+ 1 1)
;String
"jam"
;Keywords
:jam
; char
\j
;boolean
true
false
nil ; represents the absence of a value
~~~

## Put Your Clojure Data in Collections

All collections are immutable and persistent.
Immutable: the value of the collection does not change
Persistent: collections will do smart creations of new versions of themselves by using structural sharing.

### List

List : the first element of the list, and everything else.

Process lists:
~~~ lein
(first '(:rabbit :pocket-watch  :marmalade :door))
(rest '(:rabbit :pocket-watch  :marmalade :door))
(first (rest (rest '(:rabbit :pocket-watch :marmalade :door))))
; The following => error
(rest (first '(:rabbit :pocket-watch  :marmalade :door)))
~~~

Build lists:

~~~ lein
'(1 2 "jam" :marmalade-jar)
(cons 5 '()) ; same as
(cons 5 nil)
(cons 3 (cons 4 (cons 5 nil)))
~~~

### Vector

Access elements by index.

~~~
[:jar1 1 2 3 :jar2]
(first [:jar1 1 2 3 :jar2])
(rest [:jar1 1 2 3 :jar2])
;get elem with index 2
(nth [:jar1 1 2 3 :jar2] 2)
(last [:rabbit :pocket-watch :marmalade])
~~~

### Collection operations

~~~
(count [1 2 3 4])
; add more elems to collection
; In vector add at the end
(conj [:toast :butter] :jam)
; In list at the begining
; In vector add at the end
(conj '(:toast :butter) :jam)
~~~

### Maps

~~~
{:jam1 "strawberry" :jam2 "blackberry"}
(get {:jam1 "strawberry" :jam2 "blackberry"} :jam2)
; or better
(:jam2 {:jam1 "strawberry" :jam2 "blackberry" :jam3 "marmalade"})
(keys {:jam1 "strawberry" :jam2 "blackberry" :jam3 "marmalade"})
(vals {:jam1 "strawberry" :jam2 "blackberry" :jam3 "marmalade"})
(assoc {:jam1 "red" :jam2 "black"} :jam1 "orange")
(dissoc {:jam1 "strawberry" :jam2 "blackberry"} :jam1)
(merge {:jam1 "red" :jam2 "black"}
       {:jam1 "orange" :jam3 "red"}
       {:jam4 "blue"})
~~~

### Sets

- Collections with no duplicates.
- used for: union, intersection, difference

~~~
#{:red :blue :white :pink}
; this will generate an error
#{:red :blue :white :pink :red}
(clojure.set/union #{:r :b :w} #{:w :p :y})
(clojure.set/difference #{:r :b :w} #{:w :p :y})
~~~

othes collection can be transformed into sets:

~~~
(set [:rabbit :rabbit :watch :door])
(set {:a 1 :b 2 :c 3})
~~~

usage

~~~
(get	#{:rabbit	:door	:watch}	:rabbit)
(get	#{:rabbit	:door	:watch}	:jar)
; same as
(:rabbit	#{:rabbit	:door	:watch})
; same as
(#{	:rabbit	:door	:watch}	:rabbit)
~~~
