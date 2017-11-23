install:
	helm install .

reqs: minikube kubectl

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	helm install --dry-run --debug . > $(TMP)/manifest
	ls -lh $(TMP)/manifest

minikube:
	$(eval TMP := $(shell mktemp -d --suffix=MINIKUBETMP))
	cd $(TMP)
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
	cd
	rmdir $(TMP)
	minikube version

kubectl:
	$(eval TMP := $(shell mktemp -d --suffix=KUBECTLTMP))
	cd $(TMP)
	curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl
	cd
	rmdir $(TMP)
