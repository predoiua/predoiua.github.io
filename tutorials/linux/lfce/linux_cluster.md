---
layout: post
date:   2017-07-20 13:00:00
categories: linux
---
* will be replace by toc
{:toc}

# Linux High Availability Cluster Management


## Introduction

HA and cluster
https://www.bootstrap-it.com/cluster

Node    = independent VM
Cluster = group of node peers
Server Failure = unresposive node(s)
Failover = task reassignment
Failback = node recovery
Replication = distributed data
Reduncancy = reserved environments
Split Brain = failed communication error state
Fencing = shutting down unresponsive node
Quorum = mumeric requirement for fancing

A = Availability
MTBF = Mean Time Before Failure
MTTR = Mean Time To Repain

A = MTBF / ( MTBF + MTTR )
A = 1000 hours / ( 1000 hours + 1 hour )

## Working with Load Banced Clustes

LVS - the Linux Virtual Sever
LVS + Keepalive
LVS + ldirectord
HAProxy

## Working with Failover cluster

### Pacemaker
pcs - command line

## Working with HA Cluster Storage

DRBD = Distributed Replicated Block Device

~~~
lsblk
~~~

## Working with Clustered File System

OCFS2
GFS2

GlusterFS
AFS( Andrew File System )
CephFS