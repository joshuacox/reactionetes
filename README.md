# Reactionetes

Spin up a Kubernetes stack dedicated to Reaction Commerce PDQ

[![Build Status](https://travis-ci.org/joshuacox/reactionetes.svg?branch=master)](https://travis-ci.org/joshuacox/reactionetes)
[![CircleCI](https://circleci.com/gh/joshuacox/reactionetes/tree/master.svg?style=svg)](https://circleci.com/gh/joshuacox/reactionetes/tree/master)
[![Waffle.io - Columns and their card count](https://badge.waffle.io/joshuacox/reactionetes.svg?columns=all)](https://waffle.io/joshuacox/reactionetes)

## TLDR

```
helm install \
  --name my-release-name \
  --set mongodbReleaseName=massive-mongonetes \
  --set replicaCount=1 \
  --set mongoReplicaCount=3 \
  --set image.repository=reactioncommerce/reaction \
  --set image.tag=latest \
  ./reactioncommerce
```

## Oneliner Autopilot

The oneliner:
```
curl -L https://git.io/reactionetes | bash
```

## Exports

Same but export a bunch of env vars beforehand

Warning! Of note the 'none' driver will throw a warning, and should only be used
on a VM that is for testing only. By default it uses the virtualbox
driver, there is also the kvm and kvm2 drivers.

```
export MINIKUBE_CPU=4
export MINIKUBE_MEMORY=4096
export MINIKUBE_OPTS=--vm-driver=none
export REACTIONCOMMERCE_NAME=my-release-name
export MONGO_RELEASE_NAME=massive-mongonetes
export REACTIONCOMMERCE_REPO=reactioncommerce/reaction
export REACTIONCOMMERCE_TAG=latest
export REACTION_REPLICAS=3
export MONGO_REPLICAS=11
curl -L https://git.io/reactionetes | bash
```

## Make

 Or using the makefile:

```
REACTIONCOMMERCE_REPO=reactioncommerce/reaction \
MONGO_RELEASE_NAME=massive-mongonetes \
REACTIONCOMMERCE_NAME=my-release-name \
REACTIONCOMMERCE_TAG=latest \
MINIKUBE_MEMORY=60180 \
MINIKUBE_CPU=32 \
REACTION_REPLICAS=33 \
MONGO_REPLICAS=225 \
make -e autopilot
```

## [Full Docs](./docs/README.md)

Main page [here](./docs/README.md)

#### [autopilot](./docs/autopilot.md)

#### [envvars](./docs/envvars.md)

#### [manualinstall](./docs/manualinstall.md)

#### [values](./docs/values.md)

#### [scaling](./docs/scaling.md)

#### [debug](./docs/debug.md)

#### [branches](./docs/branches.md)

#### [notes](./docs/notes.md)
