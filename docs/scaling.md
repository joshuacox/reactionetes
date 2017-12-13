## Scaling

`helm list` will give you the RELEASE-NAME if you did not specify it,
once you have this you can scale your deployment:

```
kubectl scale --replicas=3 deployment/RELEASE-NAME-reactionetes
```

or you can specify a larger scale on `helm install`

```
helm install --name my-release-name --set replicaCount=30 --set mongoReplicaCount=100 --set mongodbReleaseName=massive-mongonetes ./reactioncommerce
```

or even as environment variables before calling make:

```
REACTIONCOMMERCE_REPO=reactioncommerce/reaction \
MONGO_RELEASE_NAME=massive-mongonetes \
REACTIONCOMMERCE_NAME=my-release-name \
REACTIONCOMMERCE_TAG=latest \
MINIKUBE_MEMORY=60180 \
MINIKUBE_CPU=32 \
REACTION_REPLICAS=33 \
MONGO_REPLICAS=225 \
make -e
```
