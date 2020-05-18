---
layout: post
date:   2020-04-12 12:00:00
categories: bi
---
* will be replace by toc
{:toc}

# Ansible for Kubernetes


~~~
minikube delete
minikube start --cpus 4 --memory 4g
eval $(minikube docker-env)              # configure to connect to minikube docker
source <(kubectl completion bash)        # bash completion for kubectl
~~~

Deploy
~~~
kubectl create deployment hello-go --image=hello-go   # deploy a new container
kubectl get deployment hello-go                       # check it's status
kubectl describe pods                                 # check what is going on
kubectl edit deployment hello-go                      # manually edit it
kubectl expose deployment hello-go --type=LoadBalancer --port=8180     # expose it to outside world
minikube service hello-go                             # simulate external connection

kubectl delete service hello-go      # cleanup
kubectl delete deployment hello-go 
docker rmi hello-go
~~~

