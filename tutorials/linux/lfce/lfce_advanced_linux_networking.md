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
    - NAT
	- Net 1: 192.168.1.1 - intnet1 -> server1 192.168.1.100  # internal network
	- Net 2: 192.168.2.1 - intnet2 -> server1 192.168.2.200

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

- server0
change from 192.168.2.1/24 to 192.168.2.1/25
~~~
ip addr                         # show ip of all interfaces
cd /etc/sysconfig/network-scripts/
vi ifcfg-Wire..                 # and change prefix
ifdown enp0s9                   # restart interface
ifup enp0s9
~~~

- server1
change from 192.168.2.200/24 to 192.168.2.100/25

- server1 NAT
~~~
ping 4.2.2.2
ping 192.168.1.1
~~~

- server 0 NAT
~~~
firewall-config     # check "Masquarade zone" in "public zone". Option "Runtime to permanent"
~~~

## Internet Protocol - ARP and DNS Fundamentals

Ethernet (level 2):
MAC= Media Access Control
MTU = Maximum Transmission Unit = default 1500 bytes
ARP = Address Resolution Protocol = link level 2 - level 3

- server 1 ARP
~~~
ping -c 1 192.168.1.1         # -c = count
arp -a                        # show arp cache -> see mac and ip relation
ip neighbor                   # same. show arp cache
whireshark &                  #
arp -d 192.168.1.1            # delete arp cache
ping -c 1 192.168.1.1         # ping to rebuild arp cache
                              # check in whireshark packages
ping -c 1 4.2.2.2             # check how is build apr if address is not local -> get arp of router
~~~

- server 1 DNS
~~~
vi /etc/resolv.conf          # DNS config file. add: "nameserver 4.2.2.2"
whireshark &
dig www.pluralsight.com      # get IP of this site
host www.pluralsight.com     # less info that previous command
~~~


## Internet Protocol - Routing Packets

- server 1 - IP Fragment
~~~
wireshark &          # 
# ip package, no fragmentation
ping -c 1 4.2.2.2   # wireshark: IP Version, length, Protocol = ICMP, Source IP, Destination IP
# ip package, with fragmentation
ping -c 1 -s 1472 192.168.1.1      # -c = count -s = size
ping -c 1 -s 1473 192.168.1.1      # will be split. 1473 + headers > 1500 (MTU)
ip addr                            # to check MTU
~~~


- server 1 - TTL time to loop = max router number
traceroute rely on this. First send with TTL 0, then 1 ... at each step record failure response

~~~
traceroute -n 4.2.2.2             # -n = no dns lookup
ping -t 5 -c 1 4.2.2.2            # -t = TTL => failure, as 4.2.2.2 > 5 loops
~~~

- default route

~~~
route -n             # default route = 0.0.0.0 in destination column
~~~

## Internet Protocol - Routing Packets with Linux

- server 2

~~~
ping 192.168.1.1       # ping server 1 - fail. Network is unreachable
ping 4.2.2.2           # same
ip route               # show routing table
route -n               # show routing table ( same as before )
# add route to an specific IP
ip route add 192.168.1.1/32 via 192.168.2.1 dev enp0s3
ping 192.168.1.1       # OK
ping 192.168.1.100     # fails
ip route del 192.168.1.1
ip route add 192.168.1.0/24 via 192.168.2.1 dev enp0s3
ping 192.168.1.1       # OK
ping 192.168.1.100     # OK
# this route is temporary. after network restart will disaper
systemctl restart network
ip route
~~~

add permanent route
~~~
cd /etc/sysconfig/network-scripts
vi route-enp0s3  # add "192.168.1.0/24 via 192.168.2.1 dev enp0s3"
~~~

add default route
~~~
vi ifcfg-enp0s3 # append "GATEWAY=192.168.2.1"
~~~

## Investigating TCP Internals

- server 1 - tcp connect establish
~~~
wget http://192.168.1.1/index.html
ss -ltn -4          # display socket info. -l = list, -t = tcp -n numeric -4 = only IP 4
netstat -an         # -a = all sockets, -n = numeric
~~~

- server 1 - tcp state
~~~
ssh 192.168.1.1           # diff terminal
ss -t                     # status = ESTAB
ssh 192.168.1.10          # diff terminal, invalid server
ss -t                     # status = SYN-SENT
~~~

- sliding windows, congestion

- server 0
~~~
cd /var/www/html/
fallocate -l1G largeFile.bin        # create 1G file
~~~

- server 1
~~~
scp root@192.168.1.1:/var/www/html/largeFile.bin .  # -> check graph in wireshark.
~~~

- server 0 - modify transmission setting
~~~
tc qdisc add dev enp0s3 root netem delay 3000ms loss 5%  # add delays, drop rate
# start scp ~ 11 k/s
tc qdisc del dev enp0s3 root                             # delete it
# scp gets to ~ 60 m/s
~~~


## Troubleshooting Network Issue

~~~
ethtool enp0s3             # physical info aboutinterface
# check firewall configuration
firewall-cmd --list-all
firewall-cmd --permanet --zone=public --add-service=ssh
~~~

## Physical layer

https://linuxconfig.org/how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux
