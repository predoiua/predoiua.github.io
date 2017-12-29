---
layout: post
date:   2017-12-16 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCS (Linux Foundation Certified System Administrator) Linux Virtualization Management

## Introduction to Linux Virtualization Management

- KVM and libvirt

~~~
grep -E '(vmx|svm)' /proc/cpuinfo    # -E = extended regexp. Check virtualization support
ntpq - p                             # check time servers
~~~

## Installing XRDP

~~~
yum list epel-release                 # check if is install
yum list xrdp
~~~

xrdp - SELinux
~~~
getenforce
cd /usr/sbin
ls -Z xrdp*
chcon -t bin_t xrdp xrdp-sesman
systemctl start xrdp               # start xrdp
netstat -ltn                       # -l=list, -t=tcp, -n=port number
~~~

## Virtual Machine Networking

- virbr0 - libvirt default network