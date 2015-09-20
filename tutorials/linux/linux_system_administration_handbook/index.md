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

set line editing mode
~~~sh
set -o vi
set -o emacs # default mode
find / -name core 2> /dev/null
# -u for sort = unique
cut -d: -f7 < /etc/passwd | sort -u
# execute second command only if first one succeed
lpr /tmp/t2 && rm /tmp/t2
# execute second command only if first one fail
cp --preserve --recursive /etc/* /spare/backup \
|| echo "Did NOT make backup"
~~~




