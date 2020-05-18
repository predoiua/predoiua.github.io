---
layout: post
date:   2020-02-15 12:00:00
categories: ansible
---
* toc
{:toc}

# Learning Ansible

vim
autocmd FileType yaml setlocal ai ts=2 sw=2 et

On all nodes: 
~~~
useradd ansible
echo password | passwd --stdin ansible
# The first ALL refers to hosts, the second to target users, and the last to allowed commands. 
echo "ansible ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ansible
~~~

On control.example.com: 
~~~
su - ansible; ssh-keygen
ssh-copy-id ansible1.example.com
~~~

## Inventory

Predefined groups : all, ungrouped

~~~
[fileservers]
file1.example.com
file2.example.com

[servers:children]
webservers
~~~

~~~
ansible –i inventory all --list-hosts
ansible -i inventory file --list-hosts
ansible-inventory -i inventory.ini -y --list > inventory.yaml     # convert ini to yaml inventory. -y = yaml or json
# dynamic inventory
ansible-inventory -i inv.ini --list > inv.sh
vi inv.sh 
ansible -i inv.sh -m ping cog
~~~

## ansible.cfg

/etc/ansible/ansible.cfg = defautl

~~~
ansible --version  # find the config file
~~~

## adhoc commands

ansible hosts [-m module] [-a 'module arguments'] [-i inventory]

~~~
ansible all -m setup                 # gather facts
ansible all -m user -a "name=lisa"   # add user lisa
ansible all -m command -a "id lisa"  # check if exists
~~~

## modules

~~~
ansible-doc -l       # list existing modules
ansible all -m ping  # verifies the ability to log in and that Python has been installed
ansible all -m service -a "name=httpd state=started"  # checks if a service is currently running
ansible all -m command -a "/sbin/reboot -t now"       # command: runs any command, but not through a shell
ansible all -m shell -a set                           # shell: runs arbitrary commands through a shell
# raw: runs a command on a remote host without a need for Python
ansible all -m copy -a 'content="hello world" dest=/etc/motd'  #copy: copies a file to the managed host
~~~

## playbook

~~~
- name: deploy vsftpd
  hosts: ansible2.example.com
  tasks:
  - name: install vsftpd
    yum: name=vsftpd
~~~

~~~
ansible-playbook --syntax-check vsftpd.yml
ansible-playbook -C vsftpd.yml               # dry run
~~~

## Variables and facts

A fact is a special type of variable, that refers to a current state of an Ansible managed system
Scope:
    Global scope: this is when a variable is set from inventory or the command line
    Play scope: this is applied when it is set from a play
    Host scope: this is applied when set in inventory or using a host variable inclusion file

~~~
- hosts: all
  vars:
    web_package: httpd
  vars_files:
    - vars/users.ym
~~~

inventory

~~~
[servers]
web1.example.com web_package=httpd
[servers:vars]
web_package=httpd
~~~

include files

~~~
Use ~/myproject/host_vars/web1.example.com to include host specific variables
Use ~/myproject/group_vars/webservers to include host group specific variables
~~~
