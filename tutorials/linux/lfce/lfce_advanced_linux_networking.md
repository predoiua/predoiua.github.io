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

|7 - Application  | App data  | actual app  | Process   = Web Browser
|6 - Presentation | App data  | traslation  | Code      = Web Page
|5 - Session      | App data  | app lvl     | Socket    = HTTP Get
|4 - Transport    | Segment   | segment,deli| Port      = TCP + 0xab..
|3 - Network      | Packet    | adrs, route | Router    = IP + TCP + 0xab..
|2 - Data link    | Frame     | encoding    | Ethernet  = Frame + IP + TCP + 0xab.. + Frame 
|1 - Physical     | bits      | Actual wire | NIC,modem = 10101..

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
ifdown enp0s9                   # restart interface -> nmcli dev disconnect
ifup enp0s9                     #   -> nmcli con up

vi ifcfg-eth2                # and change prefix. eth2, enp0s9
#PREFIX=25
ifdown eth2                   # restart interface eth2, enp0s9
ifup eth2
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
ethtool enp0s3             # physical info about interface
# check firewall configuration
firewall-cmd --list-all
firewall-cmd --permanet --zone=public --add-service=ssh
~~~

## Physical layer

https://linuxconfig.org/how-to-detect-whether-a-physical-cable-is-connected-to-network-card-slot-on-linux

~~~
cat /sys/class/net/eth0/carrier  # 1 = is connected
cat /sys/class/net/eth0/operstate  # up or down
~~~

~~~
ifconfig eth1 up
ip link set eth1 down

ip addr add 192.168.50.5 dev eth1
ip addr del 192.168.50.5/24 dev eth1
ip route show
~~~

# ip COMMAND CHEAT SHEET

## IP QUERIES

### addr
Display IP Addresses and property information(abbreviation of address)

ip addr               # Show information for all addresses
ip addr show dev em1  # Display information only for device em

### link
Manage and display the state of all network interfaces

ip link                # Show information for all interface
ip link show dev em1   # Display information only for device em
ip -s link             # Display interface statistics

### route 
Display and alter the routing table

ip route             # List all of the route entries in the kernel

### maddr
Manage and display multicast IP addresses

ip maddr                # Display multicast information for all devices
ip maddr show dev em1   # Display multicast information for device em1


### neigh
Show neighbour objects; also known as the ARPtable for IPv4

ip neigh                 # Display neighbour objects
ip neigh show dev em1    # Show the ARP cache for device em1

### help 
Display a list of commands and arguments for each subcommand

ip help           # Display ip commands and arguments
ip addr help      # Display address commands and arguments
ip link help      # Display link commands and arguments
ip neigh help     # Display neighbour commands and arguments


## MULTICAST ADDRESSING

maddr add                                  # Add a static link-layer multicast address
ip maddr add 33:33:00:00:00:01 dev em1     # Add mutlicast address 33:33:00:00:00:01 to em1

maddr del                                  # Delete a multicast address
ip maddr del 33:33:00:00:00:01 dev em1     # Delete address 33:33:00:00:00:01 from em1

## MODIFYING ADDRESS AND LINK PROPERTIES

addr add                                   # Add an address
ip addr add 192.168.1.1/24 dev em1         # Add address 192.168.1.1 with netmask 24 to device em

addr del                                   # Delete an address
ip addr del 192.168.1.1/24 dev em1         # Remove address 192.168.1.1/24 from device em1

link set                                   # Alter the status of the interface
ip link set em1 up                         # Bring em1 online
ip link set em1 down                       # Bring em1 offline
ip link set em1 mtu 9000                   # Set the MTU on em1 to 9000
ip link set em1 promisc on                 # Enable promiscuous mode for em1

## ADJUSTING AND VIEWING ROUTES

route add                                     # Add an entry to the routing table
ip route add default via 192.168.1.1 dev em1  # Add a default route (for all addresses) via the local gateway 192.168.1.1 that can be reached on device em1
ip route add 192.168.1.0/24 via 192.168.1.1   # Add a route to 192.168.1.0/24 via the gateway at 192.168.1.1
ip route add 192.168.1.0/24 dev em1           # Add a route to 192.168.1.0/24 that can be reached on device em1

route replace                                 # Replace, or add if not defined, a route
ip route replace 192.168.1.0/24 dev em1       # Replace the defined route for 192.168.1.0/24 to use device em1

route get                                     # Display the route an address will take
ip route get 192.168.1.5                      # Display the route taken for IP 192.168.1.5


## MANAGING THE ARP TABLE

neigh add                                              # Add an entry to the ARP Table
ip neigh add 192.168.1.1 lladdr 1:2:3:4:5:6 dev em1    # Add address 192.168.1.1 with MAC 1:2:3:4:5:6 to em1

neigh del                                              # Invalidate an entry
ip neigh del 192.168.1.1 dev em1                       # Invalidate the entry for 192.168.1.1 on em1

neigh replace                                           # Replace, or adds if not defined, an entry to the ARP table
ip neigh replace 192.168.1.1 lladdr 1:2:3:4:5:6 dev em1 # Replace the entry for address 192.168.1.1 to use MAC 1:2:3:4:5:6 on em1

## USEFUL NETWORKING COMMANDS (NOT NECESSARILY PROVIDED FROM IPROUTE)

arping                         # Send ARP request to a neighbour host
arping -I eth0 192.168.1.1     # Send ARP request to 192.168.1.1 via interface eth0
arping -D -I eth0 192.168.1.1  # Check for duplicate MAC addresses at 192.168.1.1 on eth0

ethtool                        # Query or control network driver and hardware settings
ethtool -g eth0                # Display ring buffer for eth0
ethtool -i eth0                # Display driver information for eth0
ethtool -p eth0                # Identify eth0 by sight, typically by causing LEDs to blink on the network port
ethtool -S eth0                # Display network and driver statistics for eth0

ss                             # Display socket statistics. The below options can be combined
ss -a                          # Show all sockets (listening and non-listening)
ss -e                          # Show detailed socket information
ss -o                          # Show timer information
ss -n                          # Do not resolve addresses
ss -p                          # Show process using the socket


arp -a
ip neigh

arp -v 
ip -s neigh


arp -s 192.168.1.1 1:2:3:4:5:6 
ip neigh add 192.168.1.1 lladdr 1:2:3:4:5:6 dev eth1

arp -i eth1 -d 192.168.1.1
ip neigh del 192.168.1.1 dev eth1

ifconfig -a 
ip addr

ifconfig eth0 down 
ip link set eth0 down

ifconfig eth0 up
ip link set eth0 up

ifconfig eth0 192.168.1.1
ip addr add 192.168.1.1/24 dev eth0

ifconfig eth0 netmask 255.255.255.0
ip addr add 192.168.1.1/24 dev eth0

ifconfig eth0 mtu 9000
ip link set eth0 mtu 9000

ifconfig eth0:0 192.168.1.2
ip addr add 192.168.1.2/24 dev eth0

netstat
ss

netstat -neopa
ss -neopa

netstat -g
ip maddr

route
ip route

route add -net 192.168.1.0 netmask 255.255.255.0 dev eth0
ip route add 192.168.1.0/24 dev eth0

route add default gw 192.168.1.1
ip route add default via 192.168.1.1
