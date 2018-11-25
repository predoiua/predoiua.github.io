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
shstemctl is-enables sshd
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

