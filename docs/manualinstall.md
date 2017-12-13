## Manual Installation

### Requirements

[Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) to access your cluster

A running kubernetes stack, perhap using
[minikube](https://github.com/kubernetes/minikube)

with tiller initialized by
[helm](https://helm.sh/)

helm should be able to talk to your k8s cluster
and install freely

#### Windows

On
Windows
[Chocolatey](https://chocolatey.org/)
can simplify installation

#### Mac OS X

On
Macintosh
[homebrew](https://brew.sh/)
can simplify installation

### [helm Install](https://docs.helm.sh/helm/#helm-install)

the helm  [Install](https://docs.helm.sh/helm/#helm-install) command can
be used like this, you will probably want to set the release name of
your running mongo cluster inside of k8s:

```
helm install --set mongodbReleaseName=massive-mongonetes ./reactioncommerce
```

or you can name the release

```
helm install --name my-release-name --set mongodbReleaseName=massive-mongonetes ./reactioncommerce
```

Or using the `--set` option to set some of the values:

```
helm install \
  --name my-release-name \
  --set mongodbReleaseName=massive-mongonetes \
  --set replicaCount=1 \
  --set mongoReplicaCount=10 \
  --set image.repository=joshuacox/mycustom \
  --set image.tag=v1.5.8.2-leahlovise \
  ./reactioncommerce
```
