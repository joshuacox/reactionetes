# reactionetes

Spin up a Kubernetes stack dedicated to Reaction Commerce PDQ

## Requirements

A running kubernetes stack, perhap using
[minikube](https://github.com/kubernetes/minikube)

with tiller initialized by
[helm](https://helm.sh/)

helm should be able to talk to your k8s cluster
and install freely

## Install

```
helm install .
```

## Debug

```
helm install --dry-run --debug . > /tmp/manifest
```

### Makefile

#### install minikube

minikube is updated often, it can't hurt to run this often

```
make minikube
```

#### helm install .

this is the default for this makefile

```
make
```

#### debug

you can also save a debug copy of what manifest file will be generated
using:

```
make debug
```

This will produce output pointing you to the saved manifest file in your
temp directory:

```
make debug
helm install --dry-run --debug . > /tmp/tmp.zZGCOwCCoqDOCKERTMP/manifest
ls -lh /tmp/tmp.zZGCOwCCoqDOCKERTMP/manifest
-rw-r--r-- 1 thoth thoth 5.0K Nov 22 15:44
/tmp/tmp.zZGCOwCCoqDOCKERTMP/manifest
```

notes:

Kubernetes blog [post](http://blog.kubernetes.io/2017/01/running-mongodb-on-kubernetes-with-statefulsets.html) from  January 2017

Mongodb blog [post](https://www.mongodb.com/blog/post/running-mongodb-as-a-microservice-with-docker-and-kubernetes)

KubernetesUpAndRunning examples [repo](https://github.com/kubernetes-up-and-running/examples)
