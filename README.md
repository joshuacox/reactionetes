# Reactionetes

Spin up a Kubernetes stack dedicated to Reaction Commerce PDQ

## Oneliner Autopilot

The oneliner:
```
curl -L https://git.io/reactionetes | bash
```

That merely performs the
[autopilot](#autopilot)
recipe using the [bootstrap](./bootstrap) file

At the end of which you'll get some notes if everything went
successfully.  Here is some example output:

```
NOTES:
1. Get the ReactionCommerce URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l
"app=reactionetes,release=youngling-beetle" -o
jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:3001 to use your application"
  kubectl port-forward $POD_NAME 3001:3000
```

It should be noted that you can then paste those last three lines
directly into your terminal and you will be able to access the reaction
commerce site once all the pods spin up at:

[127.0.0.1:3001](http://127.0.0.1:3001)

it may take some time depending mainly on your internet connection and
how fast you can download all the necessary images.  The first time
being the worst as you have to download kubectl and minikube, AND all
the docker images to spin up kubernetes.

## Manual Installation

### Requirements

A running kubernetes stack, perhap using
[minikube](https://github.com/kubernetes/minikube)

with tiller initialized by
[helm](https://helm.sh/)

helm should be able to talk to your k8s cluster
and install freely


### Install

```
helm install ./reactionetes
```

## Autopilot

This will install
minikube kubectl,
startup a cluster,
initialize helm,
and finally spin up the reaction cluster

```
make autopilot
```

or it can be done in a one-off sort of manner using the oneliner:
```
curl -L https://git.io/reactionetes | bash
```

or specify your own minikube opts:
```
export MINIKUBE_OPTS=--vm-driver=kvm
curl -L https://git.io/reactionetes | bash
```

## [values.yaml](./reactionetes/values.yaml) Config

You can easily swap out your image by altering these lines:
[image settings](./reactionetes/values.yaml#L5-L7)

And the external host using these lines:
[host setting](./reactionetes/values.yaml#L17-L18)

These values can be overridden on the command line usingi the `--set` and
`--values` flags for helm, more info
[here](https://docs.helm.sh/using_helm/#using-helm)


## Debug

```
helm install --dry-run --debug . > /tmp/manifest
```


## Makefile

#### install minikube

minikube and kubctl are updated often, it can't hurt to run this accordingly

```
make reqs
```


#### helm install .

this is the default for this makefile

```
make
```


#### Debug

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


## branches

The master branch should work fine to test out Reaction on a local
minikube setup.  There will be other branches for other setups
and cloud providers.

#### [gce-ssd](https://github.com/joshuacox/reactionetes/tree/gce-ssd)

This branch will use a SSD GCE persistent disk on the google cloud platform

#### [gce-hdd](https://github.com/joshuacox/reactionetes/tree/gce-hdd)

This branch will use a HDD GCE persistent disk on the google cloud platform


## Notes:

Kubernetes blog [post](http://blog.kubernetes.io/2017/01/running-mongodb-on-kubernetes-with-statefulsets.html) from  January 2017

Mongodb blog [post](https://www.mongodb.com/blog/post/running-mongodb-as-a-microservice-with-docker-and-kubernetes)

KubernetesUpAndRunning examples [repo](https://github.com/kubernetes-up-and-running/examples)


### todo

add aws support

add openebs support

add a production setup that utilizes a pre-existing mongo stack and has
many different reaction deployments

add kadira

add snowplow

add benchmarking

combine all branches using go templating conditionals
