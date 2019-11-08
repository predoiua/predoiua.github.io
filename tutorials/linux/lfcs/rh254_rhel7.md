{:toc}

# RH254

## 1. Controlling services and daemons

systemd manage units ( objects )
- .service = system service
- .socket = IPC socket
- .path = delay activation of service until a specific file system change occurs. eg. for printing system


~~~
systemctl -t  help              # list unit types
systemctl status  sshd.service  # name.type. type default = service
systemctl                       # list units
systemctl --type=service        # list only service units

systemctl status rngd.service   # check status, or
systemctl is-active sshd
shstemctl is-enabled sshd
systemctl list-units --all      # include inactive units
systemctl --failed --type=service # list failed services

systemctl stop firewalld
systemctl start firewalld
systemctl reload firewalld
systemctl status firewalld

systemctl list-dependencies firewalld

systemctl mask network         # mask it to  prevent and admin starting it by mistake

~~~

Controlling the boot process pg 26

Targets
- graphical.target - multi users, graph+text login
- multi-user.target - multi users, text login
- rescue.target - sulogin prompt, basic system initialization
- emergency.tartet - sulogin prompt. initramfs pivot complete and system root mounted on / read-only

Add to grub systemd.unit=rescue.target

~~~
ps -p 1             # check if has systemd
ps -up 1
systemctl list-dependencies graphical.target | grep target
systemctl list-units --type=target --all
systemctl list-unit-files --type=target
systemctl isolate multi-target
systemctl get-default
systemctl set-default graphical.target
~~~

recover pass
- grub linux16 line add "rd.break"

~~~
mount -oremount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel          # se linux is not started. make sure passwd will have correct context
~~~

~~~
systemctl enable debug-shell.service # a root shell will be spawned on tty9
~~~

## 2. Managing IPv6 networking

Configuration of network interfaces is managed by NetworkManager daemon.
- device = network interace
- connection - collection of settings that can be configured for a device
- only one connection is active for one device at a time.
- persistent confoguration saved in /etc/sysconfig/network-scripts/ifcfg-name

~~~
nmcli dev status       # status of all network devices
ip link                # show dev
nmcli con show         # list all connections
ip addr show           # display current configuration of net interface
~~~

~~~
nmcli dev dis device   # deactivate net interface
nmcli dev down name    # usually don't work as NetworkManager will restart it

nmcli con show static-eth0    # show connection details
nmcli con mod  static-eth0 ipv4.addresses "192.0.2.2/24 192.0.2.254"  # set ip + gw
nmcli con mod  static-eth0 +ipv4.dns 192.0.2.1                        # add dns server addr
~~~
