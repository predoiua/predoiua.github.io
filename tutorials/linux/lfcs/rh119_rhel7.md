---
layout: post
date: 2018-07-26 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# RH119

## General

~~~
LANG=fr_FR.utf8 date         # exec cmd with locale
localectl                    # get locale. control keyboard layout
                             # insert unicode CTRL+SHIFT+u 20ac ( euro )
~~~

## 1. Local and remote logins

Glossary : shell, prompt, command, option, argument, physical console, virtual console, terminal.
CTRL+ALT+Fx = go to virtual console x

~~~
usermod -aG cognos bi     # add bi to cognos group
usermod -L bi             # lock user bi
~~~

### SSH key-based authentication

Permissions should be 600 on private key and 644 on pub key.

~~~
ssh-keygen                                      # result ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub
ssh-agent                                       # used to handle passwd protected keys
ssh-copy-id -i ~/.ssh/id_rsa.pub root@desktopY  # copy public key on destination machine
~~~

## 2. File system navigation

Terms:
- static = is content that remains unchanged until explicitly edited or reconfigured
- dynamic or variable = is content typically modified or appended by active processes
- persistent = is content, particularly configuration settings that remain after a reboot
- runtime = is process of system specific content or attributes cleared during reboot

/usr = software, shared libraries
/usr/bin = user commands
/usr/sbin = system administration commands
/usr/local = locally customized software
/etc = configuration files specific to this system
/var = variable data specific to this system. persistent. ( eg. db, cache, printer spooled, website)
/run = runtime data for processes started since last boot. created at reboot
/home = regular users store their personal data and config files
/tmp = world writable space for temp files. Files older than 10 days are deleted automatically.
/boot = files needed in order to start the boot process
/dev = special device files used by system to access hardware

~~~
cp file1 file2 file3 dir  # cp files
mv file1 file2 file3 dir  # mv files
rm -f file1 file2 file3   # rm files
mkfir -p par1/par2/dir    # create dir
cp -r dir1 dir2 dir3 dir4  # cp direcotry
mv dir1 dir2 dir3 dir4     # mv dir
rm -rf dir1 dir2 dir3      # rm recursive, no confirmation

hard link:
touch file1
ln file1 file2
ls -il             # same inode, link count (2)

~~~

## 3. Users and groups

## What is user

Every program runs as a particular user. Every file is owned by a particular user. Access to files a restricted by user.

~~~
id                  # info 
~~~