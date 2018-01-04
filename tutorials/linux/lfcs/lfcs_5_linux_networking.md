---
layout: post
date:   2018-01-03 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCS: Linux Networking

## ip vs. ifconfig

~~~
ifconfig enp0s3       # interface details. replace by ip addr and ip link
ip addr               #
ip a                  # address
ip r                  # route
ip n                  # neighbour. arp cache
ip netns              # net space
~~~

## Configuring Hostnames

3 type : hostname, DNS domain name, pretty name ( may include chars invalid for domain )
https://www.thegeekdiary.com/centos-rhel-7-how-to-change-set-hostname/
tools:
- hostnamectl ( hostnamectl status, hostnamectl set-hostname )
- nmcli ( nmcli general hostname -> service systemd-hostnamed restart )
- nmtui ( -> set system hostname -> service systemd-hostnamed restart )
- cat /etc/hostname ( require reboot )

~~~
echo $PS1         # is \h option
hostname -f       # see full hostname
uname -n          # node name
hostnamectl       # with systemd
hostname cent7    # set transient hostname
cat /etc/machine-info # see pretty name
~~~

- name resolution

~~~
cat /etc/hosts   # fully qualified name and aliases
yum info avahi   # multi cast DNS (MDNS)
getent hosts     
grep host /etc/nsswitch.conf # resolution order
cat /etc/resolv.conf         # DNS config
dig www.hotnres.ro @8.8.8.8  # resolve ip using specified DNS
~~~
