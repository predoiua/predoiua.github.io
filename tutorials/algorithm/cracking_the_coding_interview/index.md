---
layout: post
date:   2015-09-06 12:00:00
categories: algorithm
---
* will be replace by toc
{:toc}

#Questions

##Data Structures

###Arrays and Strings

####1.1 Implement an algorithm to determine if a string has all unique characters.

~~~ bash
#!/bin/bash

unique_nr_char=`echo $1 | grep -o . | sort | uniq | wc -l`
nr_char=`echo $1 | grep -o . | wc -l`
if [[ $unique_nr_char == $nr_char ]]; then
	echo "All chars are unique"
else
	echo "There are multiple characters"
fi
~~~

##Aditional Review Questions

###Moderate

####19.1 Write a function to swap a number in place without temporary variables.

~~~ scala
def test(){
	var a = 3
	var b = 4
	def swap() {
		a = a^b
		b = a^b
		a = a^b
	}
	println ( a + "," + b)
	swap()
	println ( a + "," + b)
}
test
~~~