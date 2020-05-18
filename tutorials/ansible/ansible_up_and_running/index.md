---
layout: post
date:   2015-12-01 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# Ansible up and running

## 1. Introduction

Do on targer server
~~~bash
useradd ansible
vi /etc/suboers
vi /usr/sbin/policy-rc.d
#ssh-copy-id -i ~/.ssh/id_rsa.pub ansible@172.17.0.1
~~~

~~~bash
# -i = server definitions
# -m = module
# -vvv = verbose
ansible testserver -i hosts -m ping -vvv
# -a = arguments to module
# -s = as root
ansible testserver -i hosts -s -a "tail /var/log/dmesg"
ansible testserver -i hosts -s -m apt -a name=nginx
ansible testserver -i hosts -s -m service -a "name=nginx state=restarted"
~~~

##2. Playbooks: A Beginning

~~~bash
ansible webservers -i hosts/docker.ini -m ping
ansible-playbook -i hosts/docker.ini web-notls.yml
~~~
