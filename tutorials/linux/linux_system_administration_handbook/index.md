---
layout: post
date:   2015-09-09 23:00:00
categories: linux administration
---
* toc
{:toc}

#1. Basic Administration

##1.1 where to start

| man section | Content |
|-------------|----------|
| 1 | User-level commands and applications |
| 2 | System calls and kernel error codes |
| 3 | Library calls |
| 4 | Device drivers and network protocols |
| 5 | Standard file formats |
| 6 | Games and demonstrations |
| 7 | Miscellaneous files and documents |
| 8 | System administration commands |
| 9 | Obscure kernel specs and interfaces |

- man manuals are in nroff format
- located in /usr/share/man
- man are dispayed with less

~~~ bash
man -k printf # search for word printf in mans
manpath # display man search path
which gcc
whereis gcc # searches a broader range of system directories and is independent of your shell’s search path.
locate signal.h # consults a precompiled index of the filesystem to locate filenames that match a particular pattern. 
~~~

##1.2 scripting and the shell

###1.2.1 Shell basics

~~~bash
#set line editing mode
set -o vi
set -o emacs # default mode
find / -name core 2>/dev/null
# -u for sort = unique
cut -d: -f7 < /etc/passwd | sort -u
# execute second command only if first one succeed
lpr /tmp/t2 && rm /tmp/t2
# execute second command only if first one fail
cp --preserve --recursive /etc/* /spare/backup \
|| echo "Did NOT make backup"

# -t = separator
# -k = start-stop field. -k3 = starting with 3rd field till the end
# -n = numerical sort. Otherwise 2 > 100
sort -t: -k3,3 -n /etc/group

# /dev/tty = current terminal
find /etc -name pass* 2>/dev/null | tee /dev/tty | wc -l
~~~

###1.2.2 Bash scripting

~~~bash
bash helloworld # execute script in a new instance of bash
source helloworld # existing login shell read and execute the contents of the file
. helloworld # same as before 
~~~

~~~bash
find . -type f -name '*.log ' | grep -v .do-not-touch | while read fname; do
echo mv $fname ${fname/.log/.LOG/}; done | bash -x

#open previous command in editor
fc
~~~


