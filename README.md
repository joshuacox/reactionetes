# reactionetes
Spin up a Kubernetes stack dedicated to Reaction Commerce PDQ

### Requirements

A running kubernetes stack with tiller initialized by
[helm](https://helm.sh/)

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

http://blog.kubernetes.io/2017/01/running-mongodb-on-kubernetes-with-statefulsets.html
https://www.mongodb.com/blog/post/running-mongodb-as-a-microservice-with-docker-and-kubernetes
https://github.com/kubernetes-up-and-running/examples
