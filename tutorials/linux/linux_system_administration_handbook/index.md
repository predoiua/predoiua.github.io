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

* $# = number of command line arguments
* $* = all the supplied arguments
* $0 = name by which script was invoked. It not affect $* or $#

~~~bash
#redirect stdin to read form file pass as first parameter
exec 0<$1
counter=1
while read line; do
	echo "$counter: $line"
	$((counter++))
done
~~~

###1.2.3 Regular expressions


| Symbol   | What it matches or does |
|----------|----------|
|.         | Matches any character |
|[chars]   | Matches any character from a given set |
|[^chars]  | Matches any character not in a given set|
|^         | Matches the beginning of a line |
|$         | Matches the end of a line |
|\w        | Matches any “word” character (same as [A-Za-z0-9_] ) |
|\s        | Matches any whitespace character (same as [ \f\t\n\r] ) |
|\d        | Matches any digit (same as [0-9] ) |

|         | Matches either the element to its left or the one to its right |
|( expr ) | Limits scope, groups elements, allows matches to be captured |

| ?        | Allows zero or one match of the preceding element|
| *        | Allows zero, one, or many matches of the preceding element|
| +        | Allows one or more matches of the preceding element|
| {n}      | Matches exactly n instances of the preceding element |
| {min,}   | Matches at least min instances (note the comma) |
| {min,max}| Matches any number of instances from min to max |



##1.3 Booting and Shutting down

###1.3.1 Bootstrapping

UNIX systems can boot just enough to run a shell on the system console. 
This option is traditionally known as booting to single-user mode, recovery mode, or maintenance mode


A typical bootstrapping process consists of six distinct phases:
* Reading of the boot loader from the master boot record
* Loading and initialization of the kernel
* Device detection and configuration
* Creation of kernel processes
* Administrator intervention (single-user mode only)
* Execution of system startup scripts

##1.9 Periodic Processes

###1.9.1 Schedule Commands

- executed with sh
- at most 1 crontab per user. Default location /var/spool/cron
- crontab command notify cron daemon on crontab change. If manually edit crontab send HUP to cron daemon

###1.9.2 Crontab file format

- minute hour dom month weekday command

Command is not quoted.

Each of the time-related fields may contain
• A star, which matches everything
• A single integer, which matches exactly
• Two integers separated by a dash, matching a range of values
• A range followed by a slash and a step value, e.g., 1-10/2 (Linux only)
• A comma-separated list of integers or ranges, matching any value

###1.9.4 Crontab management

~~~bash
#set filename as your crontab
crontab filename
# list your crontab
crontab -l
# edit exisitn crontab
crontab -e
# load a new crontab for user bi
crontab -u bi crontab.new
~~~

User how can submit crontabs cron.deny and cron.allow in folder /etc.

###1.9.5 LINUX AND VIXIE-CRON EXTENSIONS

Obeys system crontab entries found in /etc/crontab and in the /etc/cron.d directory


##3.19 Sharing System Files

###3.19.1 WHAT TO SHARE

Filename Function
/etc/passwd User account information database
/etc/shadow Holds user account passwords. !! Encryption may vary among UNIX flavors
/etc/group Defines UNIX groups
/etc/hosts Maps between hostnames and IP addresses
/etc/mail/aliases Holds electronic mail aliases
/etc/sudoers Grants privileges for the sudo command
/etc/skel/* Holds default configuration files for new home directories

###3.19.2 COPYING FILES AROUND

- The NFS option
- Push systems vs. pull systems
- rdist: push files
- rsync: transfer files more securely

~~~bash
#to enable edit:
/etc/xinetd.d/rsync
# when no ssh, pass is in file
/etc/rsync.pwd 
# main configuration file
/etc/rsyncd.conf
~~~
