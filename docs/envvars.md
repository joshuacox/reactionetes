# ENV VARS

there are a few environment variable you can set beforehand as well like
this:

```
export MINIKUBE_CPU=24
export MINIKUBE_MEMORY=49480
export MINIKUBE_OPTS=--vm-driver=virtualbox
export REACTIONCOMMERCE_NAME=my-release-name
export MONGO_RELEASE_NAME=massive-mongonetes
export REACTIONCOMMERCE_REPO=reactioncommerce/reaction
export REACTIONCOMMERCE_TAG=latest
export REACTION_REPLICAS=33
export MONGO_REPLICAS=108
curl -L https://git.io/reactionetes | bash
```

Or you can find out more variables to set if you look at the top of the Makefile you can see various
sections like these:

# default release names

```
$(eval REACTIONCOMMERCE_NAME := raucous-reactionetes)
$(eval MONGO_RELEASE_NAME := massive-mongonetes)
$(eval REACTION_API_NAME := grape-ape-api)
```

# default mongo settings

```
$(eval MONGO_DB_NAME := reactionetesdb)
$(eval MONGO_REPLICASET := rs0)
$(eval MONGO_PORT := 27017)
$(eval MONGO_REPLICAS := 3)
$(eval MONGONETES_INSTALL_REPO := gcr.io/google_containers/mongodb-install)
$(eval MONGONETES_INSTALL_TAG := 0.5)
$(eval MONGONETES_REPO := mongo)
$(eval MONGONETES_TAG := 3.4)
$(eval MONGO_PERSISTENCE := false)
$(eval MONGO_TLS := false)
$(eval MONGO_AUTH := false)
$(eval MONGO_PERSISTENCE_SIZE := 10Gi)
$(eval MONGO_PERSISTENCE_ACCESSMODE := [ReadWriteOnce])
$(eval MONGO_PERSISTENCE_ANNOTATIONS := {})
$(eval MONGO_PERSISTENCE_STORAGECLASS := 'volume.alpha.kubernetes.io/storage-class: default')
```

#default reaction settings

```
$(eval REACTIONCOMMERCE_CLUSTER_DOMAIN := cluster.local)
$(eval REACTION_REPLICAS := 1)
$(eval REACTIONCOMMERCE_REPO := reactioncommerce/reaction)
$(eval REACTIONCOMMERCE_TAG := latest)
```

# MInikube settings

```
$(eval MINIKUBE_MEMORY := 11023)
$(eval MINIKUBE_CPU := 8)
$(eval MINIKUBE_WANTUPDATENOTIFICATION := false)
$(eval MINIKUBE_WANTREPORTERRORPROMPT := false)
$(eval CHANGE_MINIKUBE_NONE_USER := true)
$(eval KUBECONFIG := $(HOME)/.kube/config)
$(eval MY_KUBE_VERSION := v1.8.0)
$(eval MINIKUBE_CLUSTER_DOMAIN := cluster.local)
```

# Gymongonasium settings

```
$(eval GYMONGO_DB_NAME := gymongonasium)
$(eval GYMONGO_TIME := 33)
$(eval GYMONGO_SLEEP := 5)
$(eval GYMONGO_TABLES := 1)
$(eval GYMONGO_THREADS := 10)
$(eval GYMONGO_TABLE_SIZE := 10000)
$(eval GYMONGO_RANGE_SIZE := 100)
$(eval GYMONGO_SUM_RANGES := 1)
```
