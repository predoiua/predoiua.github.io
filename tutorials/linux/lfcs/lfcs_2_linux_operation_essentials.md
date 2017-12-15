---
layout: post
date:   2017-11-24 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCS (Linux Foundation Certified System Administrator) Operation essentials

# 1. Overview

## 1.2 Reading operating system data

~~~
cat /etc/system-release         # sysmbolic link
lsb_release -d                  # -d description
rpm -qf $(which lsb_release)    # -q query -f file 
uname -r                        # -r kernel release
cat /proc/version               #
cat /proc/cmdline               # command + param for kernel boot
lsblk                           # ls block = list disks and partitions
~~~


# 2 Starting and stopping

~~~
mesg y          # enable you to receive messages. mess send by root ignore this flag
write bi        # write a message to bi user terminal
cat << FIN > message
Go home !
FIN
wall < message  # send content of message file to all users
~~~

## 2.1 shutdown

halt     = shutdown proc and CPU
poweroff = halt + stop power

~~~
#legacy
init --help
telnit --help
ls /run/nologin    # prevent non-root to login
~~~

## 2.2 Changing runlevels and setting defaults

~~~
who -r     # show runlevel
runlevel   # show runlevel
systemctl get-default
systemctl isolate multi-user.target
systemctl isolate rescue-mode.target   # single user mode ( no network)
~~~

grub-> edit -> linux16 line add:
systemd.unit=rescue.target

# 3 Boot process

## 3.1 Grub recovery

~~~
vi /etc/default/grub                        # Enable recovery. GRUB_DIABLE_RECOVERY="false"
grub2-mkconfig -o /boot/grub2/grub.cfg      # Generate config -> will have revocery option in grub menu. grub.cfg = main config file
~~~

## 3.2 Reset root passwd

- edit grub linux16 line
- remove "rhgb quiet"
- add "rd.break enforcing=0"

~~~
mount -o remount,rw /sysroot
chroot /sysroot
passwd
exit
mount -o remount,ro /sysroot
exit
restorecon /etc/shadow          # because it was edited outside SELinux
setenforce 1                    # enable enforcing mode in SELinux
~~~

# 4. Managing Grub2

~~~
grub2-install /dev/sda       # re-install 
# grubby = grub2 command line editor
grubby --default-kernel                      # edit grub
grubby --set-default /boot/vmlinuz-3.1....
grubby --info=ALL
grubby --info /boot/vmlinuz-3.1....
grubby --remove-args="rhgb quiet"

# password
vi /etc/grub.d/01_users
	set superusers="bi"
	password bi L1nux

grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-mkpasswd-pbkdf2

	password_pbkdf2 bi grub.pbkdf2.sha512.....
~~~

# 5. Managing Linux Processes


ps -ef    # unix style -f = full
ps aux    # BSD style
ps -e --forest
pstree
ps -F     # extra full


# 6. Process priority

~~~
~~~

# 7. Monitor Linux performance

## 7.1 intro

package : procps-ng

~~~
rpm -ql procps-ng          # -ql = list file in procps-ng
						   # -qc = list configuration form package
						   # -qd = list documentation form package
rpm -qf /usr/bin/top       # from which package is /usr/bin/top                        
~~~

## 7.1 pwdx and pmap

~~~
free -m                    # show free memory in Mega
pgrep sshd                 # proc id for ssh deamon
pmap $$                    # memory map for current proc
pwdx $$                    # pwd for process
~~~

## 7.3 uptime and tload

~~~
who 
w
uptime                 # based on ->
cat /proc/uptime       # sec system is up, idle time
cat /proc/loadavg      # load avg last 1 min, 5 min, 15 min, nr active proc, last proc id
watch -n 4 uptime      # run uptime every 4 sec ( default 2 )
tload                  # same as previous ( but just load avg )
~~~