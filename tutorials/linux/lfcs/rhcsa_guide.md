---
layout: post
date:   2018-08-02 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# RHCSA

## 7. Configurating permissions

### Foundation

#### Managing file ownership

2 owners : an user and a group

~~~
ls -l                # show ownership
find / -user bi      # find files own by user bi
find / -group bi     # find files own by gropu bi
chown who what       # change user/group ownership
chown -R bi:bi /home/bi 
chown :bi file       # or .bi instead of :bi
groups bi            # get user primary group (first in list). or cat /etc/passwd
newgrp bi2           # user bi can set new primary group until session ends
~~~

#### Managing basic permissions

- no rights inheritance
- read on directory = list content of that directory. To read a file you need permission on folder
- write on file, doesn't grant right to delete or modify permissions. Need write on directory to create files or change permissions on files.
- execute will never be set by default. On folder it allows cd in it.
Permission File      Folder
r|open file| list conent
w|change file content|create/delete files, modify permissions
x|run a program|cd
