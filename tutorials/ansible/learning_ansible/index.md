---
layout: post
date:   2016-06-06 12:00:00
categories: ansible
---
* toc
{:toc}

# Learning Ansible

## 1. Getting started with Ansible

- Ansible is an orchestration engine in IT
- Ansible primarily runs in the push mode  ( but you can also run Ansible using ansible-pull )
- We'd like to call the machine where we will install Ansible our "command center" (or Ansible workstation ).

### Hello ansible

~~~
ansible --version
ansible servers -m ping -i hosts/dev.ini -u ansible
ansible servers -m shell -a '/bin/echo hello ansible!' -i hosts/dev.ini -u ansible
# ??
# ANSIBLE_HOSTS=hosts/dev.ini
# ansible servers -m shell -a '/bin/echo hello ansible!'
~~~

### The Ansible architecture
