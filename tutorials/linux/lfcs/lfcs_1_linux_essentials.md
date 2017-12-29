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

1.1 Install

~~~
ip a s                    # ip address show
nmcli conn show           # Network Manager command line tool
nmcli conn up xxx         # start connection 
sed -i s/ONBOOT=no/ONBOOT=yes/ /etc/sysconfig/network/network-scripts/ifcfg-... # !!! is ONBOOT="yes" check that a network card start at boot
yum update                # check for latest package 
...                       # Install MATE
systemct set-default graphical.target # set "run level" to graphical
~~~

1.2 Command line

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

# 3. Command line

ls -l   # long
ls -i   # show i-node
ls -a   # all
ls -lrt # long, reverse order by time
ls -F   # show file type ( folders end in / )
cp -R   # recursive
mkdir -pm # full path, m = with mask ( not using umask )

# 4. Reading files
