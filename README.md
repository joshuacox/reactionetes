# reactionetes
Spin up a Kubernetes stack dedicated to Reaction Commerce PDQ

### Requirements

A running kubernetes stack, perhap using
[minikube](https://github.com/kubernetes/minikube)

with tiller initialized by
[helm](https://helm.sh/)

helm should be able to talk to your k8s cluster
and install freely

### Install

```
helm install .
```

or using the Makefile:

```
make
```

### Debug

```
make debug
```

or manually:

```
helm install --dry-run --debug . > /tmp/manifest
```

notes:

Kubernetes blog [post](http://blog.kubernetes.io/2017/01/running-mongodb-on-kubernetes-with-statefulsets.html) from  January 2017 

Mongodb blog [post](https://www.mongodb.com/blog/post/running-mongodb-as-a-microservice-with-docker-and-kubernetes)

KubernetesUpAndRunning examples [repo](https://github.com/kubernetes-up-and-running/examples)
