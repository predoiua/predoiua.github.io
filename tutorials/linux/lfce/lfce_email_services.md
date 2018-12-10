---
layout: post
date:   2018-12-09 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# LFCE: Linux Service Management - Advanced Email Sevices

## Email System Architecture

### MUA - Mail User Agent (MUA)

- client user applications
- mail, pine, Mozilla Thunderbird

### MSA - Mail Submission Agent (MSA)

- Receive message being sent
- Determines next hop for delivery

### MTA - Mail Transfer Agent (MTA)

- Routes the message closer to the recipient
- Generally crosses administrative boundaries
- Connection oriented and reliable
- Postfix, Sendmail

### MDA - Mail Delivery Agent (MDA)

- Delivers the message to the user’s mailbox
- Copies from the server spool into the user’s mailbox

## Server Side Components

MTA and MSA ( Often on the same server )
Simple Mail Transfer Protocol - SMTP
SMTP - tcp/25
SMTP/S - tcp/465
SMTP/S - tcp/587

## Client Side Components

Mail User Agent (MUA)
Mail gets queued into a mail queue
Delivered into the users mailbox

- Local mailbox
- POP : Post Office Protocol
- IMAP : Internet Message Access Protocol

POP - tcp/110
POP/S - tcp/995
IMAP - tcp/143
IMAP/S - tcp/993

## Implementing

~~~
yum install postfix     # is already included in "Minimal Install"
systemctl status postfix
ps -aux | grep postfix           # 3 proc. master, pickup, qmgr
sudo netstat -plant | grep :25   # listen only on localnet
cd /etc/postfix
postconf -n                      # command to work with conf. -n = list current values
postconf -d                      # list all default values
postconf -d myhostname           # default val for this param
postconf -e myhostname=smtm.vv10 # set a new val for param myhostname
postfix reload                   # activate new parameters
~~~

send email
~~~
yum install mailx
mail user_demo
# ... diet
less /var/log/maillog
# as user_demo
mail 
~~~