---
layout: post
date:   2017-10-14 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCS (Linux Foundation Certified System Administrator) Linux essentials

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
~~~o


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
file /etc -type l -maxdepth  1  # search only in /etc for links
df -h /boot                     # see free space on /boot
find /boot -size +2000k -type f # fin files > 2m
find /boot -size +10000k -type f -exec du -h {} \;   # see details about these files
~~~

# 6 vim

	
