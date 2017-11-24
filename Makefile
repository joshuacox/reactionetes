MINIKUBE_WANTUPDATENOTIFICATION=false
MINIKUBE_WANTREPORTERRORPROMPT=false
CHANGE_MINIKUBE_NONE_USER=false
KUBECONFIG=$(HOME)/.kube/config
KUBE_VERSION:
	curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt > KUBE_VERSION

install:
	helm install reactionetes

reqs: /usr/local/bin/minikube /usr/local/bin/kubectl

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	helm install --dry-run --debug reactionetes > $(TMP)/manifest
	less $(TMP)/manifest
	ls -lh $(TMP)/manifest
	@echo "you can find the manifest here:"
	@echo "   $(TMP)/manifest"

autopilot: reqs
	minikube start
	sh ./w8s.sh
	helm init
	sleep 120
	make

/usr/local/bin/minikube:
	$(eval TMP := $(shell mktemp -d --suffix=MINIKUBETMP))
	mkdir $HOME/.kube || true
	touch $HOME/.kube/config
	cd $(TMP) \
	&& curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
	rmdir $(TMP)
	minikube version

/usr/local/bin/kubectl: KUBE_VERSION
	$(eval MY_KUBE_VERSION := $(shell cat KUBE_VERSION))
	echo "kube $(MY_KUBE_VERSION)"
	$(eval TMP := $(shell mktemp -d --suffix=KUBECTLTMP))
	cd $(TMP) \
	&& curl -LO https://storage.googleapis.com/kubernetes-release/release/$(MY_KUBE_VERSION)/bin/linux/amd64/kubectl \
	&& chmod +x kubectl \
 	&& sudo mv -v kubectl /usr/local/bin/
	rmdir $(TMP)
	kubectl version

clean:
	-minikube stop
	-minikube delete
	-sudo rm  -f /usr/local/bin/minikube
	-sudo rm  -f /usr/local/bin/kubectl
	-sudo rm  -f KUBE_VERSION:
