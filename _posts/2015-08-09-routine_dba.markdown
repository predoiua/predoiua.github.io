---
layout: post
title:  "Linux extract from Linux Recipes for Oracle DBAs"
date:   2015-08-09 13:00:00
categories: linux
---
1. Getting started
===================
1.2
ssh -l oracle -p 22 server1
1.3
ctrl-D
logout
exit
1.4
df -f /dev/sda1
1.5
man -f cd
man 1p cd
man find | col -b >find.txt
ls /bin | xargs whatis | less
whereis echo
1.6
ctrl+_
ctrl+u
ctrl+t
alt+t
2. Shell
=========
2.1 Command history
ctrl-n/p
ctrl-r
set -o vi
2.3
printenv,env,set,export,echo
PATH, USER, HOME, PWD, SHELL, EDITOR, PS1, SHLVL, DISPLAY
echo $SHELL = echo $0 = ps
2.5
in ~/.bash_profile
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

