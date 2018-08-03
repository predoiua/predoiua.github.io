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

code|Permission| File|Folder|
|4|r|open file| list conent
|2|w|change file content|create/delete files, modify permissions
|1|x|run a program|cd

~~~
chmod 755 /somefile        # absolute mode. replace existing permissions
chmod g+w,o-r somefile     # relative mode. add permision to group, revoke forom others
~~~

#### Managing advanced permissions

#### Understanding Advanced Permissions

- set user ID (SUID) = run program as owner

~~~
ls -l /usr/bin/passwd    # see s instead on x for user
~~~

- set group ID (SGID) = on executable give the user who execute it permission of file group.
       for folder then file created in that folder get this group id ( insted of onwer primary group )

- sticky bit - protect against deletion in folder where multiple users can write.
    When you apply the sticky bit, a user can delete files only if either of the following is true:
    - The user is owner of the file.
    - The user is owner of the directory where the file exists.

~~~
ls -ld /tmp
~~~

#### Applying Advanced Permissions

SUID = 4, SGID = 2, Sticky = 1
~~~
chmod 2755 /somedir
chmod u+s /somefile       # SUID
chmod g+s /somedir        # GUID
chmod +t /somedir         # sticky
~~~



Permission Numeric | Value Relative | Value| On Files| On Directories |
SUID | 4  | u+s | User executes file with permissions of file owner| No meaning|
SGID | 2  | g+s | User executes file with permissions of group owner.| Files created in directory get the same group owner.|
Sticky bit | 1  | +t | No meaning| Prevents users from deleting files from other users |

## Managing ACLs

### Understanding ACLs
- when need permissions for more than 1 user/1 group
- not all tools support it ( tar -> star)

~~~
getfacl -R /directory > file.acl      # backup acl
setfacl --restore=file.acl            # restore acl
~~~

#### Preparing Your File System for ACLs

- use "acl mount" option in the /etc/fstab file so that the file system will be mounted with ACL support by default

#### Changing and Viewing ACL Settings with setfacl and getfacl

~~~
setfacl -m g:sales:rx /dir         # -m = modify. grant read and exec to sales group on /dir
getfacl /dir
~~~

#### Working with Default ACLs

- can enable inheritance by working with default ACL

~~~
setfacl -m d:g:sales:rx /data    # group sales to have read and execute on everything that will ever be created in the /data directory.
~~~