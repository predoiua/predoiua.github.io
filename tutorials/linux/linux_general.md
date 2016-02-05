---
layout: post
date:   2015-10-27 23:00:00
categories: linux
---
* will be replace by toc
{:toc}

## Enable/disable wireless

~~~bash
rfkill help
rfkill list all
~~~

## Trackpad

~~~bash
xinput
sudo modprobe -r psmouse
sudo modprobe psmouse proto=imps
~~~

