---
layout: post
date:   2015-09-08 15:00:00
categories: linux training
---
* toc
{:toc}

# Linux networking

## DHCP Client

Check if/how DHCP is configured on Debian

~~~ bash
#Check existing interfaces and if they have dhcp
cat /etc/network/interfaces
#Check details : IP, lease time...
ls -lrt /var/lib/dhcp/
cat /var/lib/dhcp/dhclient.eth0.leases
~~~


