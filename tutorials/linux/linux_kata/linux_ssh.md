---
layout: post
date:   2015-10-31 13:00:00
categories: linux training
---
* toc
{:toc}

#Linux security

##Launch Docker VM

~~~ bash
docker run -it --rm centos:6 /bin/bash
~~~

##How To SSH

~~~ bash
#Install
yum info openssh-server
yum install -y openssh-server openssh-clients

#Configure
vi /etc/ssh/sshd_config
#set UsePAM=no

#Start
#this step will generate RSA & DSA keys. without them next step will fail
service sshd start

#as bi
mkdir .ssh
chmod 0700 .ssh
touch ~/.ssh/authorized_keys
chmod 0640 ~/.ssh/authorized_keys

~~~

Form Linux host:

~~~bash
docker inspect $(docker ps -qa) | grep IPAddress

# generate keys
ssh-keygen -t rsa

#copy pub key on remote machine
cat ~/.ssh/id_rsa.pub | ssh bi@172.17.0.1 "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"

#ssh without passwd
ssh -l bi 172.17.0.1
ssh -i ~/.ssh/id_rsa -l bi 172.17.0.1
~~~
