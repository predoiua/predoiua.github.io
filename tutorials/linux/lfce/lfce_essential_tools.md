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

### process

Prority : -20 (highest) to 19 (lowest)
Signalls: 1=HUP, 2=INT, 3=QUIT, 6=ABRT, 9=KILL, 14=ALRM, 15=TERM 
kill -l to see all signals

~~~
ps           # default user process
ps -U root   # proc of user root
ps -e        # all system processes
ps -l        # long format (status, niceness, pid, parent pid, ..)
top          # use L to search for process
./loop.sh    # in a separate terminal
kill -9 pid
yum install psmisc # for killall
killall loop.sh
pkill loop.sh      # better
nice --1 ./loop.sh  # start with higher priority ( -1 )
~~~

### Switch users

~~~
sudo visudo
~~~

## Managing files

Standard linux structure.
/media = CDROM
/var = for variable data ( mail, logs )
/etc = configuration 
/bin = link to /usr/bin
Virtual 
/dev , /proc

~~~
ls /proc
ps             # use this command to correlate with info from /proc
ls /proc/{pid} # info about this process
more /proc/{pid}/io # about proc io
more /proc/{pid}/cpu 
ls /root        # root's home. anaconda.conf file
more /var/log/messages
~~~
