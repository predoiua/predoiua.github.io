# Docker deep dive

## Docker version

~~~
docker -v                   # version
docker version              # more 
docker info                 # even more
~~~

## Docker server port

~~~
ls -l /var/run/docker.sock         # docker listen to this socket by default
netstat -tlp                       # check there is no docker listening on tcp
service docker stop
docker -H 192.168.56.50:2375 -d &  # start docker with tcp listening
docker info                        # failure as it try to use unix socket
# other machine
export DOCKER_HOST="tcp://192.168.56.50:2375"
docker version                     # for server extract info from docker server
~~~

## Usage examples

~~~
docker run -it centos /bin/bash   # start a centos container
# in container
uname -a                          # show kernel version of host !!
vi /tmp/tempfile
exit
# in host
docker ps -a                         # see all previously run container
ls -l /var/lib/docker/aufs/diff/     # images with all containers
ls -l /var/lib/docker/aufs/diff/sha  # list modification form that container
cat /var/lib/docker/aufs/diff/sha/tmp/tempfile # see the file created in container
# start again containser
docker start sha
docker attach sha
cat /tmp/tempfile                    # the file still exists
~~~

- inside container : CTRL - P - Q = exit, but leave container running

## Layers

~~~
docker images --tree              # see layers in a image
docker history image              # layesr of that images
~~~

## Export a container

~~~ 
docker commit container_sha frigde       # create  fridge image form a container
docker history frigde                    # check it
docker save -o /tmp/fridge.tar fridge    # save image in tar
tar -tf /tmp/fridge.tar                  # list file inside tar
docker load -i /tmp/fridge.tar           # import image on a different machine
~~~

<<<<<<< HEAD
## docker run

~~~
docker run -it ubuntu /bin/bash                      # -i = interactive , -t= terminal

docker run -d ununtu /bin/bash -c "ping -c 8.8.8.8"  # -d detach. will run ping forever
docker inspect container_sha                         # check details about this container
docker attach container_sha
~~~

## multiple processes in docker

- customized to look like real OS : phusion/baseimage

~~~
docker top container_sha        # show id form host os
docker log container_sha
~~~

## volumes

~~~
docker run -it -v /test-vol --name=voltainer ubuntu /bin/bash     # create a vol in container "voltainer"
vi /test-vol/a.txt
# CTRL-P-Q
docker inspect voltainer                                          # to see folder where container was created
docker run -it --volumes-from=voltainer ubuntu /bin/bash          # mount same volume
docker rm -v voltainer                                            # is older.. user docker volume
~~~

## networking

- docker0 = more then interface. is a software switch.
- to check it we need bridge-utile package
- each cotainer add netlink to docker0

~~~
brctl show docker0                               # bridge control
docker run -it ubuntu --name=net1 /bin/bash      # start a container + CTRL + P +Q
ls -l /var/lib/docker/containers/sha             # location of host and resolv.conf for this containers
docker run --dns=8.8.4.4 --name=dnstest ubuntu   # override DNS setting
~~~

- ports
From Dockerfile : EXPOSE 80
~~~
docker run -d -p 5001:80 --name=web1 apache-img      # -d = daemon, 5001 in Linux, 80 in container
docker port web1
~~~

- linking containers
done using container name

~~~
docker run --name=src -d img                                  # start source cotainer
docker run --name=rcvr --link=src:ali-src  ubuntu /bin/bash   # ali-src = alias to source container
env | grep ALI                                                # check network in recipient
cat /etc/hosts
~~~

=======
## Build container

- build is done by daemon, all data are send to daemon before build
- spec file name : Dockerfile

~~~
# comment
FROM ubuntu:15:04
MAINTAINER i@i.com
RUN apt-get update
CMD ["echo","Hello World"]
~~~

~~~
docker build -t hello:0.1 .  # -t tag . = include local folder
~~~
>>>>>>> 88e0e0a3d33c003975f64f1d352445064449e38e
