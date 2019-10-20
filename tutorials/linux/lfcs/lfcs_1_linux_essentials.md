---
layout: post
date:   2017-10-14 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCS (Linux Foundation Certified System Administrator) Linux essentials

Learning the Essentials of CentOS Enterprise Linux 7 Administration

# 1. Overview

~~~
cat /etc/system-release   # Centos 7.2
wc -l !$                  # -l = long !$ = last argument
date --date "40 days"     # date after 40 days
date --date "40 days ago" # date 40 days ago
cal -3                    # show previous, current and next month
cal 7 1971                # cal for 1971.07 month
tty                       # filename of terminal
ls -l $(tty)              # $() = execute cmd and put output in it's place
mesg n                    # don't allow others to write at my terminal. We can notice it in w permition of tty
~~~

## 1.1 Install

~~~
ip a s                    # ip address show
nmcli conn show           # Network Manager command line tool
nmcli conn up xxx         # start connection 
sed -i s/ONBOOT=no/ONBOOT=yes/ /etc/sysconfig/network/network-scripts/ifcfg-... # !!! is ONBOOT="yes" check that a network card start at boot
yum update                # check for latest package 
...                       # Install MATE
systemct set-default graphical.target # set "run level" to graphical
~~~

## 1.2 Command line

Physical tty, Local Pseudo tty, Remote Pseudo tty

# 2. Install CentOS 7

~~~
yum grouplist hidden              # list available groups
yum groupinfo "Development Tools" # list packages available in these groups
~~~

## Installing Extra Software for VBoxAdditions

~~~
yum install redhat-lsb-core net-tools epel-release kernel-headers kernel-devel
yum groupinstall "Development Tools"
yum update
reboot
~~~

## Install GUI


~~~
find / -name "*.target"                   # target = systemd replacement for runlevel
ls -l /etc/systemd/system/default.target
~~~

~~~
yum install epel-release                            # contains MATE and Cynamon Desktop
yum --enablerepo=epel-testing install atril atril-caja # Only for CenoOS 7.5 - some packages are broken
yum groupinstall "X Window system" "MATE Desktop"
systemctl set-default graphical.target              # set default target to graphical
systemctl isolate graphical.target                  # start default target
~~~

# 4. Command line

## 4.1 Login / terminal

Graphical Display Manager = GUI Login
Ctrl + + = increase font size

~~~
tty     # get my terminal
who     # who is logged in + terminal  ( pts/0 = pseudo term, :0 = graph, tty2  = physical term)
~~~

## 4.2 List files

~~~
type ls # check if is alias
ls -d   # directory ( instead of dir content )
ls -i   # show i-node
ls -a   # all
ls -lrt # long, reverse order by time
ls -F   # show file type ( folders end in / )
cp -R   # recursive
mkdir -pm777 # full path, m = with mask ( not using umask )
~~~

## 4.2 File types

~~~
ls -ls /etc     # folder, ( second val is nr nof hard links to it)
ls -l $(tty)    # char device
lsblk            # list block devices ( disks and partitions )
ls -la /dev/sda   # one of them
ls -l /dev/sda[12]  # 1 or 2
ls -l /etc/system-release    # symbolic link
rpm -qf /usr/bin/lsb_release # which package installed this file 
~~~


## 4.3 Working with files

~~~
cp -i /etc/hosts .    # copy in local folder, interativ ( only for overwrite )
mv                    # move or rename
rm -i                  # remove interactive
~~~

## 4.3 Working with directory

~~~
mkdir -p test/sales    # mk all path
rmdir                  # folder must be empty
rm -rf                 # recusive force
touch one/file{1..5}   # create file1 .. file5
cp -R one two          # copy recursive 
tree                   # see folder hierarchy
mkdir -m 777 d1        # create with mask
~~~

## 4.4 Working with links

dir hard link count = 2 (itself and .) + nr of subdirs
hard links can't cross file system boundary.

~~~
ls -ldi /etc            # details about etc 
ls -ldi /etc/.          # check that is the same 
echo hello > f1
ln f1 f2                # hard link
ln -s f1 f3             # symbolic link
ls -li  f{1..3}         # list all of them
~~~

# 5. Reading files

## 5.1 Reading from files

~~~
echo $SSH_CONNECTION       # check if we are over ssh. show source and dest ip and port
cat /etc/hosts /etc/hostname  # both content are concatenated
wc -l /etc/services           # nr of lines in services file
less !$                       #  search with: /http backward ?mux, n = next, q = quit
head -n 3 /etc/services       # first 3 lines ( default 10 )
tail -n 3 /etc/services        # last 3
~~~

## 5.2 regex and grep

~~~
yum list install        # all installed packages
yum list install   | grep kernel
yum list install   | grep ^kernel   # line that begin wiht kernel
sudo yum install ntp         # network time protocol
cat /etc/ntp.conf
cp !$ .                      # make a copy
grep ^server ntp.conf
type grep                   # check if is alias
grep '\bserver\b' ntp.conf   # surrounded by space
yum install words            # install a dictionary
grep -E  'ion$' /usr/share/words                    # -E enhance search
grep -E  '^po..ute$' /usr/share/words 
grep -E '[aeiou]{5}' !$         # words with 5 vowel in row  
~~~

## 5.3 edit with sed

~~~
sed '/^#/d ; /^$/d'  ntp.conf    # delete empty lines and comments
~~~


## 5.4 comparing files

~~~
cp ntp.conf ntp.new
echo new >> ntp.new
diff ntp.conf ntp.new
rpm -V ntp              # verify ntp package
md5sum /usr/bin/passwd   # for binary use md5sum to compare
~~~

## 5.5 find files

~~~
find /usr/share/doc -name  '*.pdf'     # -print is default action
find /usr/share/doc -name  '*.pdf'  -exec cp {} . \; # copy result in current folder
find -name '*.pdf'  -delete                          # delete them. if no folder -> current folder
find /etc -type l -maxdepth  1  # search only in /etc for links
df -h /boot                     # see free space on /boot
find /boot -size +2000k -type f # fin files > 2m
find /boot -size +10000k -type f -exec du -h {} \;   # see details about these files
~~~

# 6 vim

~~~
touch newfile
> newfile1       # same as previous
touch newfile    # change modificatino time
stat newfile     # many details about this file
~~~

.vimrc
set showmode nonumber nohlsearch
set ai ts=4 expandtab                         # auto indent, tab spaces = 4
abbr _sh #!/bin/bash
nmap <C-N>: set invnumber <CR>

:e! = revert to last save version
g~~ = change line case
gUU = put line un upper case
d$ = delete to eol
dG = delete to eof
:r file = insert file content

# 7 piping and redirection

## 7.1 redirect STDOUT

~~~
> file               # create file
> newfile            # overwrite file content
df -h > file1        # write command output to file
df -h 1> file1       # explicitly specify STDOUT (1>)
df -h 1>> file1      # append
~~~

## 7.2 noclobber

~~~
set -o                # check shell options
set -o noclobber      # set noclobber on
set -o | grep noclobber
date +%F > file1     # failure to overwrite file1
date +%F >| file1    # force to overwrite
~~~

## 7.3 redirect STDERR

~~~
ls /etcw > err               # error is sent to stdout
ls /etcw 2>| err             # now we have the error in err file
find /etc -fype l 2> /dev/null
find /etc -fype l &> /err.txt  # redirect stdout and std err
~~~

## 7.3 read STDIN

~~~
mail                     # check mail
df -hlT > diskfree       # human, show type, long
mail -s "Desk Free" predoiua < disckfree  # send a mail to predoiua. diskfree file as mail content
~~~

## 7.4 HERE documents

~~~
cat > mynewfile <<END
this is a little file
created from script
END

cat mynewfile
~~~

## 7.5 pipeline

~~~
ls | wc -l
head -n1 /etc/passwd
cut -f7 -d: /etc/passwd | sort | uniq  # all shell used
~~~

## 7.6 named pipe

~~~
ls -l $(tty)        # check a char device
mkfifo mypipe
ls -l !$            # start with p = type pipe
ls > mypipe         # in one terminal
wc -l < mypipe      # in other terminal
~~~

## 7.7 tee

view on screen and redirect to file

~~~
ls > f89
ls | tee f89    # go both in file and screen
sudo echo '127.0.0.1 bob'  >> /etc/hosts       # fail, as only command is run as root the redirect as current user
echo '127.0.0.1 bob'  | sudo tee -a /etc/hosts  # the correct way
~~~

# 8 Archiving files


## 8.1 tar

~~~
tar -cf doc.tar  /usr/share/doc                      # -c = --create. Archive docs
tar --list --file=doc.tar
tar -lf  doc.tar                                     # same as before
tar -evf doc.tar                                     # extract in current folder
tar -cvt my0.tar -g my.snar test                     # archive incremental folder test
tar -cvt my1.tar -g my.snar test                     # will contain only delta
rm test       # dezaster
tar -xvf my0.tar -g /dev/null
tar -xvf my1.tar -g /dev/null
~~~

## 8.2 archive

~~~
gzip tux.tar       # file was removod and new file tux.tar.gz
file tux.tar.gz
gunzip tux.tar.gz

bzip2 tux.tar     # better compression tux.tar.bz2
bunzip2 tux.tar.bz2

time tar -cvf tux.tar $HOME
time tar -cvzf tux.tar.gz $HOME    # include compression. gz
time tar -cvjf tux.tar.bz2 $HOME    # bz2
~~~



