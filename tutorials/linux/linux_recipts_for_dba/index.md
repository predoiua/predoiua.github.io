---
layout: post
date:   2015-08-09 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# Getting started

##1.2 Connect to server
-l = user name
-X = tunnel X over ssh

~~~ bash
ssh -l oracle -X -p 22 server1
~~~

##1.3 Logout

~~~ bash
ctrl-D
logout
exit
~~~~

##1.4 Check disk space
-h = human readable

~~~ bash
df -h /dev/sda1
~~~

##1.5 Getting help

~~~ bash
man -f cd # same as whatis cp
man -k cd # search in man for cp word
man 1p cd
man find | col -b >find.txt
ls /bin | xargs whatis | less
whereis echo
~~~

##1.6 Correcting command line mistakes

~~~ bash
ctrl+_ # undo
ctrl+u  # clear left
ctrl+t # transpose
alt+t
~~~~

##1.7 Reset screen

~~~ bash
reset
stty sane
~~~

#2. Shell

##2.1 Command history

~~~ bash
ctrl-n/p
ctrl-r
set -o vi
~~~

##2.3 View current env variables

~~~ bash
printenv,env,set,export,echo
PATH, USER, HOME, PWD, SHELL, EDITOR, PS1, SHLVL, DISPLAY
echo $SHELL = echo $0 = ps
~~~~

##2.5 bash configuration

. = source

~~~ bash 
#in ~/.bash_profile
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
# typical entries
# No core files by default
ulimit -S -c 0 > /dev/null 2>&1
# Set OS variables
USER="`id -un`"
LOGNAME=$USER
MAIL="/var/spool/mail/$USER"
HOSTNAME=`/bin/hostname`
~~~

##2.6 Command prompt

~~~ bash
echo $PS1
PS1='[\u@\h:${ORACLE_SID}]$ '
~~~~

##2.7 Command schortcut

- alias
- shell function

~~~ bash
alias rm="rm -i"
type rm
unalias rm
#We can check what is a command with :
type cd
~~~~~

##2.8 Providing input to commands

##2.9 Redirecting command output

~~~ bash
cat ~/.bashrc 1>out.txt 2>/dev/stdout
#is same as
cat ~/.bashrc 1>out.txt 2>&1
~~~~

##2.10 Sending output to nowhere

~~~ bash
time dd if=/u01/app/oracle/oradata/XE/system.dbf of=/dev/null
find . -name "alert*.log" 2>/dev/null
#Chek data corruption
exp user/pass full=y file=/dev/null
~~~

##2.11 Display and capture command output

~~~ bash
ls -lart . | tee out.log
# see http://stackoverflow.com/questions/692000/how-do-i-write-stderr-to-a-file-while-using-tee-with-a-pipe
ls -lart . > >(tee stdout.log) 2> >(tee stderr.log >&2)
~~~

##2.12 Recording all shell command output

~~~ bash
script update.log
# commands...
exit
~~~

##2.13 Change login shell

~~~ bash
cat /etc/shells
chsh -s /bin/bash
~~~

#2.14 Modify command path search

~~~ bash
export PATH=$PATH:~/bin
~~~~

##2.15 Build-in commands

~~~
type -a pwd
builtin pwd # call build in pwd
command pwd # call external pwd
~~~

##2.16 Setting backspace key

~~~
stty erase Ctrl+Backspace
stty erase <Backspace>
stty erase ^H
~~~

##2.17 Long commands
End multiline commands with \
or
CTRL + x e

#3. Manage processes and users

##3.1 Listing processes

~~~ bash
# -f = full format
ps -fu oracle # processes for user oracle
~~~

##3.2 Terminating processes

~~~ bash
# -i = interactive
killall -i sqlplus
~~~

##3.3 Listing logged on users

~~~ bash
who
w
tty
pinky # light version of finger
~~~

##3.4 Listing last logon

~~~ bash
last | less
lastb
~~~

##3.5 Limiting the number of user processes

~~~ bash
useradd test_user
vi /etc/security/limits.conf
..
test_user soft nproc 100
test_user hard nproc 2000
...
#test it. fork bomb
: () { :|:& };:
~~~~

##3.6 Viewing how long the server has been running

~~~ bash
uptime
# uptime is also the first line of
w
~~~

##3.7 How long a process has been running

~~~ bash
## check line STIME ( start time ) and TIME (cpu time)
ps -ef
~~~

##3.8 Dispaly your username

~~~ bash
id
who am i
~~~

##3.9 Control passwd

~~~bash
passwd oracle
change -M 60 oracle #passwd will be valid for 60 days
change -l oracle #verify 
~~~

##3.11 sudo

~~~bash
echo "oracle ALL=(ALL) ALL" >> /etc/sudoers
#or
echo "oracle ALL=/usr/sbin/groupadd,/usr/sbin/useradd" >> /etc/sudoers
sudo -l #check what can be run as root
~~~

#3.12 user/group

~~~ bash
groupadd oinstall
groupadd dba
groupadd test
cat /etc/group
groupdel test
useradd -g ointall -G dba oracle
id oracle
usrdel oracle
~~~

#4 Creating and editing files

