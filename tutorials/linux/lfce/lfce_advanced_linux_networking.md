---
layout: post
date:   2017-13-23 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCE: Advanced Linux Networking

## Lab setup

lab :
- server0
	- Net 1: 192.168.1.1 - intnet1 -> server1 192.168.1.100
	- Net 2: 192.168.2.1 - intnet1 -> server1 192.168.2.200

- server 0
~~~
nmtui                     # adress: 192.168.1.1/24
systemctl restart network 
ip addr
~~~

- server 1
~~~
nmtui                     # adress: 192.168.1.100/24 + gw: 192.168.1.1
~~~

- server 2
~~~
nmtui                     # adress: 192.168.2.200/24
~~~

## Net topology and OSI

- server0

~~~
yum install httpd
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
echo "Hello world" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd
wget http://192.168.1.1/index.html
~~~

- server1
~~~
yum install tcpdump wireshark wireshark-gnome
tcpdump                                         # term 1
ping -c 1 192.168.1.1                           # term 2
wget http://192.168.1.1/index.html              
~~~

## IP - addressing and subnetting

