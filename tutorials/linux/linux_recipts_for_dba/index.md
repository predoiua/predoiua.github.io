---
layout: post
date:   2015-08-09 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# 1. Getting started

## 1.2 Connect to server
-l = user name
-X = tunnel X over ssh

~~~ bash
ssh -l oracle -X -p 22 server1
~~~

## 1.3 Logout

~~~ bash
ctrl-D
logout
exit
~~~~

## 1.4 Check disk space
-h = human readable

~~~ bash
df -h /dev/sda1
~~~

## 1.5 Getting help

~~~ bash
man -f cd # same as whatis cd
man -k cd # search in man for cd word
man 1p cd
man find | col -b >find.txt
ls /bin | xargs whatis | less
whereis echo
~~~

## 1.6 Correcting command line mistakes

~~~ bash
ctrl+_ # undo
ctrl+u  # clear left
ctrl+t # transpose
alt+t
~~~~

## 1.7 Reset screen

~~~ bash
reset
stty sane
~~~

# 2. Shell

## 2.1 Command history

~~~ bash
ctrl-n/p
ctrl-r
set -o vi
~~~

## 2.3 View current env variables

~~~ bash
printenv,env,set,export,echo
PATH, USER, HOME, PWD, SHELL, EDITOR, PS1, SHLVL, DISPLAY
echo $SHELL = echo $0 = ps
~~~~

## 2.5 bash configuration

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

## 2.6 Command prompt

~~~ bash
echo $PS1
PS1='[\u@\h:${ORACLE_SID}]$ '
~~~~

## 2.7 Command schortcut

- alias
- shell function

~~~ bash
alias rm="rm -i"
type rm
unalias rm
#We can check what is a command with :
type cd
~~~~~

## 2.8 Providing input to commands

## 2.9 Redirecting command output

~~~ bash
cat ~/.bashrc 1>out.txt 2>/dev/stdout
#is same as
cat ~/.bashrc 1>out.txt 2>&1
~~~~

## 2.10 Sending output to nowhere

~~~ bash
time dd if=/u01/app/oracle/oradata/XE/system.dbf of=/dev/null
find . -name "alert*.log" 2>/dev/null
exp user/pass full=y file=/dev/null                             # Check data corruption
~~~

## 2.11 Display and capture command output

~~~ bash
ls -lart . | tee out.log
# see http://stackoverflow.com/questions/692000/how-do-i-write-stderr-to-a-file-while-using-tee-with-a-pipe
ls -lart . > >(tee stdout.log) 2> >(tee stderr.log >&2)
~~~

## 2.12 Recording all shell command output

~~~ bash
script update.log
# commands...
exit
~~~

## 2.13 Change login shell

~~~ bash
cat /etc/shells
chsh -s /bin/bash
~~~

## 2.14 Modify command path search

~~~ bash
export PATH=$PATH:~/bin
~~~~

## 2.15 Build-in commands

~~~
type -a pwd
builtin pwd # call build in pwd
command pwd # call external pwd
~~~

## 2.16 Setting backspace key

~~~
stty erase Ctrl+Backspace
stty erase <Backspace>
stty erase ^H
~~~

## 2.17 Long commands

End multiline commands with \
or
CTRL + x e

# 3. Manage processes and users

## 3.1 Listing processes

~~~ bash
# -f = full format
ps -fu oracle # processes for user oracle
~~~

## 3.2 Terminating processes

~~~ bash
# -i = interactive
killall -i sqlplus
~~~

## 3.3 Listing logged on users

~~~ bash
who
w
tty
pinky # light version of finger
~~~

## 3.4 Listing last logon

~~~ bash
last | less
lastb
~~~

## 3.5 Limiting the number of user processes

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

## 3.6 Viewing how long the server has been running

~~~ bash
uptime
# uptime is also the first line of
w
~~~

## 3.7 How long a process has been running

~~~ bash
## check line STIME ( start time ) and TIME (cpu time)
ps -ef
~~~

## 3.8 Display your username

~~~ bash
id
who am i
~~~

## 3.9 Control passwd

~~~bash
passwd oracle
change -M 60 oracle #passwd will be valid for 60 days
change -l oracle #verify 
~~~

## 3.11 sudo

~~~bash
echo "oracle ALL=(ALL) ALL" >> /etc/sudoers
#or
echo "oracle ALL=/usr/sbin/groupadd,/usr/sbin/useradd" >> /etc/sudoers
sudo -l #check what can be run as root
~~~

## 3.12 user/group

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

# 4 Creating and editing files

## 4.1 Creating a file

|Cmd| Description|
|----------|-----|
|vi|Starts editing session in memory.|
|vi <file> | Starts session and opens the specified file. |
|vi <file>*|Open multi files. Navigate :n|
|view <file>|Read only open|
|vi -R <file>|Read only open|
|vi -r <file>|recover file|
|vi +n <file>|Opens file at specified line number n.|
|vi + <file> |Opens file at the last line.|
|vi +/<pattern> <file>|Opens file at first occurrence of specified string pattern|

Useful commands

|Cmd| Description|
|----------|-----|
|:wq|Save and exit|
|ZZ|Save and exit|
|:x|Save and exit|
|:w|Save without exit|
|:w!|Override file protection and save|
|:q|Exit the file|
|:q!|Exit without saving|
|:n|Edit next file|
|:e!|return to previous saved version|

## 4.2 Maneuvering within a file

Navigation commands

|Cmd| Description|
|----------|-----|
|Ctrl+f |(Page Down) |
|Ctrl+b |(Page Up) |
|1G |Go to FIRST line in file.|
|G |Go to LAST line in file.|
|H|Go to top of screen|
|L|Go to bottom of screen|

## 4.3 Copying and pasting

|Cmd| Description|
|----------|-----|
|nyy |Yank(copy) n lines |
|P|paste above the cursor|
|D|Delete to the end of current line|

## 4.4 Manipulating text

|Cmd| Description|
|----------|-----|
|r|Replace char under cursor|
|~|Change case of a char|
|cc|Delete the current line and insert|
|C|(c$)Delete to the end of line and insert|
|R|Type over the chars in current line|
|s|Delete char enter insert mode|
|S|Delete current line and enter insert mode|

## 4.5 Search and replace text

|Cmd| Description|
|----------|-----|
|/<pattern>|Search forward for a string.|
|?<pattern>|Search backward for a string.|
|n|Repeat the search forward.|
|N|Repeat the search backward.|
|f<char>|Search forward for char in current line.|
|F<char>|Search backward for char in current line.|
|;/,    |repeat f search forward or backward|

## 4.6 Insert one file into another

|Cmd| Description|
|----------|-----|
|:r filename||
|:0r filename| place file at the begin of existing file|
|:r !date| insert a command output|

## 4.7 Joining lines

J

## 4.13 Creating shorcuts for commands

|Cmd| Description|
|----------|-----|
|:map t xp||
|:map | print all map definition|
|:unmap t||

## 4.14 Set default editor

~~~sh
export EDITOR=vi
export VISUAL=$EDITOR
~~~

# 5 Managing files and directory

## 5.1 Showing the current working directory

~~~sh
pwd # by default don't follow symbolic link, same as
echo $PWD
~~~

## 5.2 Changing directory

You need exec rigth on a folder on target folder.

~~~sh
cd ~ # same as
cd
cd - # move to previous folder
~~~

## 5.5 Viewing a list of directories

~~~sh
ls -l | grep ^d
ls -p | grep / # -p add / at folder name
ls -F #add an indicator for file type
~~~

## 5.6 Listing files

~~~sh
ls -altr
echo *
~~~

## 5.9 Change file ownership and gropup membership

~~~sh
chown oracle:dba /var/opt/oracle
chgrp -R dba *.sql
~~~

## 5.14 Determining file type

~~~sh
ls -F
~~~

## 5.15 Compare files

~~~sh
sdiff a.sh b.sh
diff a.sh b.sh > d.diff
patch a.sh d.diff
~~~

## 5.17 Copying directories

~~~sh
scp -rp scripts user@host:/home/user/scripts
rsync -ra --progress scripts user@host:/home/user/scripts
~~~

## 5.20 Remove files

~~~sh
ls *.bak
echo !$ # !$ = *.bak from previous command
rm !$ 
~~~

## 5.23 Finding files

~~~sh
find . -name  "alert*.log" 2>/dev/null
~~~

## 5.24 Finding string in files

~~~sh
find . -name *.sql | xargs grep -i "create table"
# -q = quiet
# -l = print filename instead of pattern
find . -name *.sql -exec grep -qil "create table" {} \; -print
~~~

## 5.25 Finding recently modified files

|Find time option|Description|
|----------------|-----------|
| -amin | file accessed more than +n, less than -n, or exactly n minutes ago|
| -atime| -"- days ago|
| -cmin | changed -"- |
| -ctime| changed days|
| -mmin | modified min|
| -mtime| modified days|
| -newer file| modified more recently than file|


~~~sh
# modified in the last 20 minutes
find . -mnin -20
~~~

## 5.26 Finding and removing old files

~~~sh
find . -type f -mtime +30 -exec rm -f {} \;
~~~

## 5.27 Finding the largest file

~~~sh
# -ls = print result in ls format 
# -nrkf = numeric, reverse order, by 7th field
find . -ls | sort -nrk7 | head -5
~~~

## 5.28 Finding files by size

~~~sh
# < 200k
find . -size -200k
~~~

## 5.29 Sorting by file size

~~~sh
ls -alS 
ls -al | sort -rk5 
~~~

## 5.30 Find large folders

~~~sh
# -S = don't include subfolders
# -nr = numeric, reverse
du -S . | sort -nr | hear -5
# -sh = summary, human
du -sh ~
~~~

## 5.31 Truncate on OS file

~~~sh
> x.x
cat /dev/null > x.x
cp /dev/null x.x
~~~

## 5.33 Create a second name for a file

Create a symbolic link.

~~~sh
ln -s file newLink
~~~

# 6 Archiving and Compessing files

## 6-1. Bundling Files Using tar

~~~
# c = create
# v = verbose
# f (file) option directly precedes the name of the tar archive file
tar -cvf prodrel.tar *.sql
# on older vesion
tar -cvf - /oracle/product/10.2 | gzip > orahome.tar.gz
# move to a diff location without creating archive
tar -cvf - scripts | (cd /ora01/backup; tar -xvf -)
~~~

The -f or --file option must come directly before the name of the tar file.
tar one_mandatory_option [other non-mandatory options] [tar file] [other files]

Mandatory tar Options
|Option| Description|
|----------|-----|
|-c, --create|Create a new archive file.|
|-d, --diff, --compare| Compare files stored in one tar file with other files.|
|-r, --append | Append other files to tar file.|
|-t, --list | Display the names of files in tar file. If other files are not listed,then display all files in tar file.|
|-u, --update| Add new or updated files to tar file.|
|-x, --extract, --get| Extract files from the tar file. If other files is not specified,then extract all files from tar file.|
|-A, --catenate, --concatenate| Append a second tar file to a tar file|

## 6-2. Unbundling Files Using tar

~~~
tar -xvf mytar.tar
#you can specify files to extract
tar -xvf mytar.tar script1.sql script2.sql
~~~

## 6-3. Finding Differences in Bundled Files Using tar

~~~
# d = differences
tar -df backup.tar scripts
~~~

## 6-4. Bundling Files Using cpio

~~~
# o (for out or create)
# v (verbose)
ls *.sh | cpio -ov > backup.cpio
#-depth tells the find command to print the directory contents before the directory itself
find . -depth | cpio -ov | gzip > orahome.cpio.gz
~~~

[find or ls command] | cpio -o[other options] > filename

## 6-5. Unbundling Files Using cpio

~~~
# i redirect input from an archive file. 
# d create directories
# m  preserve file modification times
cpio -idvm < linux10g_disk1.cpio
cat linux10g_disk1.cpio | cpio -idvm
~~


# 10 Managing Server Software

## 10-1. Installing Packages

* local RPM database is stored in the /var/lib/rpm directory, and it houses metadata information about installed packages including package prerequisites and file attributes
* RPM package file is composed of compressed archive files and dependency information. The package name or label contains the following attributes:
<name>-<version>-<release>.<architecture>.rpm

~~~
# -i (or --install) = install
# -h  displays hash marks during the installation
# -v provides verbose output that reports the progress of the installation
rpm -ihv screen-4.0.3-1.el5.i386.rpm
~~~

# 10-2. Switching to Oracle’s Unbreakable Linux Network