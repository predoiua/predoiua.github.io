---
layout: post
date:   2015-09-29 20:00:00
categories: ruby
---
* will be replace by toc
{:toc}


##Process command line arguments

~~~ruby
ARGV.each do |a|
    puts "Argument : #{a}"
end
~~~

##Stdin

~~~ruby
$stdin.each do |a|
    puts a
end
~~~

