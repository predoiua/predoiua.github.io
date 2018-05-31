---
layout: post
date:   2018-05-31 18:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCE: Essential Tools

Understanding and Using Essential Tools for Enterprise Linux 7

## Command execution in bash

### useful cmds

~~~
w             # who long
uptime        # since when is up, load average
lastlog       # when login and what
last
lspci         # see device pci
lscpu         # view cup info
lsusb
uname -a      # show os info
date
wc -l largeFile
help          # commands in bash
~~~

### variable, aliases, startup files

System startup scripts:
/etc/profile, /etc/bashrc, /etc/profile.d

Per user startup scripts:
~/.bash_profile, ~/.bashrc, ~/.bash_logout

~~~
env                 # all current variables for the system
printenv HOME       # print just a variable
echo $HOME          # content of a variable
HI=Hello            # create variables
HI2="Hello world"   # local variable, available just in currect shell
echo $HI2
export HI           # environment variables, available also in subprocesses
ps --forest         # see process hierarchy

alias               # list all aliases
alias lt='ls -lat'  # create an alias
unalias lt          # delete alias

vi ~/.bash_profile
~~~


