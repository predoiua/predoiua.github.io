---
layout: post
date:   2017-13-23 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCE: Network and Host Security


## Network Configuration Review

- Server 0 -> VirtualBox: NAT -> Bridge

~~~
systemcrl restart nerwork
ip addr                                     # check new addr
                                            # enp0s3 : 192.168.0.110/24
                                            # enp0s8 : 192.168.1.1/24
                                            # enp0s9 : 192.168.2.1/25
more /etc/syscofig/network-scripts/ifcfg-*  # enp0s3 -> bootproto="dhcp", 
                                            # Wired conf 1-> IPADDR = .1.1 PREFIX = 24
                                            # Wired conf 1-> IPADDR = .2.1 PREFIX = 25
ping 192.168.1.100                          # test conn to serv 1
ping 192.168.2.100                          # test conn to serv 2
ping 4.2.2.2                                # test internet access
more /etc/resolv.conf                       # nameserver = 192.168.0.1
ping www.pluralsight.com                    # check if DNS is working
more /etc/hosts                             # 192.168.1.1 server0.psdemo.local
                                            # 192.168.1.100 server1.psdemo.local
                                            # 192.168.1.200 server2.psdemo.local
firewall-cmd --permanent --change-interface=enp0s3 --zone=external
firewall-cmd --permanent --change-interface=enp0s8 --zone=internal
firewall-cmd --permanent --change-interface=enp0s9 --zone=internal

firewall-cmd --permanent --zone=external --add-masquerade

firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -s 192.168.1.0/24 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -s 192.168.2.0/25 -j ACCEPT

systemctl reload firewalld

~~~

- Server 1

~~~
ping 192.168.1.1                                 # check serv 0 access
ping 192.168.2.100                               # check serv 2 access
ping 4.2.2.2                                     # check internet access
more /etc/sysconfig/network-scripts/ifcfg-enp0s3 # IPADDR=192.168.1.1
                                                 # PREFIX=24
                                                 # GATEWAY=192.168.1.1
~~~


## Linux Security Concepts and Architectures

- Host based security
	Logging, Firewalls, TCP Wrappers, SSH
- Network based security
	Firewall, Remote Access

### Firewall Architectures
- Filtered Host
- Screeened Subnet
- DMZ

### Logging
- rsyslog - Rocket Fast System Log Processing
- can centalize logs to Server 1

- Server 1
- enable to reveice logs

~~~
rpmquery --all | grep syslog        # find package that provides syslog
systemctl status rsyslog            # check status
vi /etc/rsyslog.conf                # MODULE = enable tcp
                                    # RULES = some kind of router to destination
systemctl restart rsyslog
sudo firewall-cmd --permananet --add-port 514/tcp  # configure firewall to allow logs
sudo firewall-cmd --reload
sudo semanage port -a -t syslogd_port_t -p tcp 514 # se linux to allow logs
sudo tail -f /var/log/messages      # monitor log messages
~~~


- Server 2
- 
~~~
vi /etc/rsyslog.conf                # last line @@ = over tcp. set server1.psdemo.local:514
systemctl restart rsyslog
logger "test msg"                   # generate log message
~~~

