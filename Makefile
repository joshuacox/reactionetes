install:
	helm install .

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	helm install --dry-run --debug . > $(TMP)/manifest
	ls -lh $(TMP)/manifest

minikube:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	cd $(TMP)
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
	cd
	rmdir $(TMP)
	minikube version
