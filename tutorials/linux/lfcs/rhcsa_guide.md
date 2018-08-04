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

### Managing ACLs

#### Understanding ACLs
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

#### Setting Default Permissions with umask


|Value |Applied to Files| Applied to Directories
|0| Read and write | Everything
|1| Read and write | Read and write|
|2| Read| Read and execute |
|3| Read| Read|
|4| Write| Write and execute|
|5| Write| Write|
|6| Nothing| Execute|
|7| Nothing| Nothing|


File : start with 666 and substract umask
Direcotry : start with 777 and substract umask

To set it for all users:
Ceate a shell script with the name umask.sh in the /etc/profile.d directory and specify the umask/

To set if only for some users:
Cchange the umask settings in a file with the name .profile, which is created in the home folder

For root set to 027, whereas normal users work with the default umask 022.


#### Working with User Extended Attributes


# RHCSA

## 25. Configuring External Authentication and Authorization

###  Foundation Topics

#### Understanding Remote Authentication

A centralized identity management system provides two services at least:
- Account information - typically LDAP is used for this
- Authentication information - encrypted password stored in LDAP or advanced authentication protocol Kerberos


|Service| Used for|Description|
|LDAP|Account Information and Authentication| Generic network service used for authentication. Implemented in products such as Active Directory and IPA server. |
|NIS |Account information and authentication|Legacy UNIX method to provide centralized account information and authentication.|
|NIS+|Account information and authentication|An update on the legacy NIS service that was mentioned previously.|
|Kerberos|Authentication|Protocol developed for secure authentication of users and services.|
|/etc/passwd|Account information|Default file that contains account information.|
|/etc/shadow|Authentication|Default file that contains authentication information.|


On RHEL 7, three services are generally involved in setting up centralized account information and authentication:
- LDAP - was started as a protocol to get information from hierarchical directory server
- Kerberos: a service that can be used for authorization, on top of an LDAP directory server.
- Identity management - IdM was developed to provide an easy solution to set up
an LDAP/Kerberos server. It also includes a DNS and NTP time server. 

#### Understanding Kerberos Basics

#### Understanding Kerberos Authentication

- Instead of passwords, tickets are sent over the network, and these tickets are encrypted with the user password.
- tickets are issued by a central key server Key Distribution Center (KDC)
KDC (Key Distribution Center) knows the passwords of all users and servers
- realm = a group of hosts =ithat use the same KDC to get tickets; Something like Windows domain or an LDAP suffix.
Kerberos realm name = DNS domain of the Kerberos site written in all caps
For hosts residing in example.com, the realm name is EXAMPLE.COM.
-Applications running on hosts can also use Kerberos for secure access. Such a host is referred to as an application server.


When a user logs in, the user (locally) enters his password. The login program then converts the user name to a Kerberos principal name. The login program then sends the request to the KDC authentication service, which answers with a ticket granting ticket(TGT) for that principal.

Upon receiving the login request, the KDC generates a secret session key that is used as the ticket granting ticket (TGT). It keeps one copy and encrypts a second copy with the user password used as the encryption key. The encrypted copy is sent back to the login program.

Upon receiving the encrypted copy, the login program attempts to decrypt it with the password that the user has entered. If this succeeds, the user is authenticated and has a current TGT. Based on that current TGT, the user can authenticate on Kerberos-enabled network services as well. Because the TGT at that moment is current, the user does not need to enter the password again, which really makes Kerberos an SSO system.


#### Understanding Kerberos Principals

identify the participants = principals are used by users and by network services.
Principal names have the form primary/instance@REALM

nfs/server1.example.com@EXAMPLE.COM
- nfs is the primary.
- server1.example.com is the name of the host the principal belongs to
- EXAMPLE.COM refers to the realm the principal belongs to.

in usernames, the instance part is normally omitted; eg. lisa@EXAMPLE.COM
Services usually store their password in the keytab file ( /etc/krb5.keytab)

~~~
strings /etc/krb5.keytab
~~~

#### Configuring LDAP Authentication with Kerberos Authorization

authconfig, authconfig-tui, authconfig-gtk 

These utilities write in the following files:
-  /etc/ldap.conf: Contains the configuration of the LDAP client. which LDAP server should be used
- /etc/krb5.conf: Contains Kerberos-specific information.
- /etc/sssd/sssd.conf: Contains information used by the system security services daemon (sssd)
- /etc/nslcd.conf: Depending on the packages that are installed on your server, the nslcd service might be used for retrieving and caching user information as an alternative to the sssd.conf configuration file.
- /etc/nsswitch.conf: Indicates which service should be contacted to retrieve authentication and authorization related information. It contains lines like passwd: files sss that specify that the local configuration files should be used first, after which the sssd service should be used.
- /etc/pam.d/*
- /etc/openldap/cacerts - Stores the root certificate authorities
- /etc/sysconfig/authconfig - Contains variables that specify how the authcon- fig utilities should do their work.

#### Using nslcd or sssd as the Authentication Backend Service

- make sure sssd packages are installed before you start using the authconfig utilities.
- Make sure the sssd service is running before using the authconfig utilities.
-  If using authconfig, set up LDAP authentication without Kerberos authorization first, and then open the utility again and configure Kerberos if required
- Make sure that the file /etc/sysconfig/authconfig contains
 USESSSD=yes
 FORCELEGACY=no 
 USESSSDAUTH=yes

#### Setting Up External Authentication

~~~
ping ipa.vv10.com     # IPA server
yum install -y sssd sssd-tools nss-pam-ldapd
mkdir /etc/openldap/cacerts 
scp ipa.vv10.com:/root/cacert.p12 /etc/openldap/cacerts   # Copy the certificate from the IPA server to your local server
vim /etc/sysconfig/authconfig # check for:
		# USESSSDAUTH=yes
		# USESSSD=yes
		# FORCELEGACY=no
authconfig-tui               # run it as root
		# User Information -> select Cache Information, Use LDAP,
		# Authentication -> select Use LDAP Authentication.
		# LDAP Settings screen, select Use TLS 
		# Server: ipa.vv10.com
		# Base DN: dc=vv10,dc=com
vi /etc/sssd/sssd.conf 
		# ldap_tls_reqcert = never
systemctl restart sssd
su - lisa
~~~







