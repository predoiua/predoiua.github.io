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
yum install xrdp                      # install
yum history info                      # info about last command
yum history undo 7                    # undo transaction 7 ( get from previous cmd )
ls /etc/xrdp                          # config files
~~~

xrdp - SELinux
~~~
getenforce                          # check se status
cd /usr/sbin
ls -Z xrdp*                         # check security context for xrdp
chcon -t bin_t xrdp xrdp-sesman     # change context to bin_t for xpdp and xprd_sesman
~~~
Other
~~~
systemctl start xrdp               # start xrdp
systemctl enable xrdp              # start on boot
netstat -ltn                       # -l=list, -t=tcp, -n=port number
firewall-cmd --add-port=3389/tcp --permanent
firewall-cmd --reload
# for user to connect as - if Mate
echo "mate-session" > ~/.Xclients
chmod a+x ~/.Xclients
~~~



## Virtual Machine Networking

- virbr0 - libvirt default network

### Default network

~~~
ip a                           # default show.
yum install libvirt
ip a                           # same as before
cd /etc/libvirt/qemu/networks
vi default.xml                 # default network definition
systemctl start libvirtd       # start libvirt deamon
ip a s                         # now we have a bridge + nic
brctl show                     # bridge show. logacy command
ls /etc/sysconfig/network-scripts  # no script for virt
~~~

### virsh

~~~
virsh list         # list VM
virsh net-list     # list net
virsh              # open a shell . we can run here cmd like net-list.
net-destroy default  # after that no virt in : ip a
net-start default    # start it again
net-autostart --disable default  # disable auto start for default. this create remove link in autostart folder
~~~

### removing default network

~~~
net-destroy default   # turn it off
cp default.xml ~      # make a copy of default.xml definition folder /etc/libvirt/qemu/networks
net-undefine default  # destory it. will delete definition file
~~~

### creating virtual network

~~~
virsh net-list --all
virsh net-define default.xml    # create using definition from default.xml
virsh net-edit default
cp default.xml hostonly.xml     # start with a template
vi hostonly.xml                 # change name, uid, mac, ip, remove nat
virsh net-define hostonly.xml 
virsh net-start hostonly 
virsh net-autostart hostonly 
~~~

## KVM

~~~
yum install qemu-kvm virt-install virt-manager
lsmod | grep kvm
~~~

### virsh remote

~~~
virsh -c qemu:///system
virsh -c qemu+ssh://root@127.0.0.1/system
~~~

## Create Virtual Machine

### Virt Manager from ISO

~~~
ls /var/lib/libvirt/images    # location for vm hdd images. should add iso imgs here
virt-manager                  # virtual manager - GUI
~~~

### PXE

see Linux Service Management course 
- install sFtp check /var/ftp/pub
tftp, edit network, set selinux

### CLI

yum install virt-install virt-viewer

## Managing virtual machines

~~~
virsh net-edit default  # edit network config
virth net-update default add ip-dhcp-host \
	"<host mac='52:54:00:00:00:01' name='ipa' ip='192.168.122.11' />" \
	--live --config
~~~

## Nice

### Find IP

~~~
# vers 1
virsh net-list
virsh net-info default
virsh net-dhcp-leases default
# vers 2
virsh list
virsh domifaddr centos7.5_vm1
# vers 3
arp -e
virsh list
virsh dumpxml VM_NAME | grep "mac address" | awk -F\' '{ print $2}'
arp -an | grep 52:54:00:ce:8a:c4
~~~

### Change mac

~~~
virsh edit centos7.5_ipa   # edit VM xml config file
virsh destroy centos7.5_ipa # stop VM
 start centos7.5_ipa 
~~~

### Set IP

Edit config of DHCP service to povide static IP

~~~
virsh  dumpxml  $VM_NAME | grep 'mac address'
virsh  net-list
virsh  net-edit  $NETWORK_NAME    # Probably "default"
~~~

Find the <dhcp> section, restrict the dynamic range and add host entries for your VMs

<dhcp>
  <range start='192.168.122.100' end='192.168.122.254'/>
  <host mac='52:54:00:00:00:01' name='ipa' ip='192.168.122.11'/>
  <host mac='52:54:00:00:00:02' name='vm2' ip='192.168.122.12'/>
  <host mac='52:54:00:00:00:03' name='vm3' ip='192.168.122.12'/>
</dhcp>


