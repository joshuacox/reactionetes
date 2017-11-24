MINIKUBE_WANTUPDATENOTIFICATION=false
MINIKUBE_WANTREPORTERRORPROMPT=false
CHANGE_MINIKUBE_NONE_USER=false
KUBECONFIG=$(HOME)/.kube/config
MY_KUBE_VERSION=v1.8.4

install:
	helm install reactionetes

reqs: /usr/local/bin/minikube /usr/local/bin/kubectl

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DDEBUGTMP))
	helm install --dry-run --debug reactionetes > $(TMP)/manifest
	less $(TMP)/manifest
	ls -lh $(TMP)/manifest
	@echo "you can find the manifest here:"
	@echo "   $(TMP)/manifest"

autopilot: reqs
	minikube --kubernetes-version $(MY_KUBE_VERSION) $(MINIKUBE_OPTS) start
	sh ./w8s
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

/usr/local/bin/kubectl:
	echo "kube $(MY_KUBE_VERSION)"
	$(eval TMP := $(shell mktemp -d --suffix=KUBECTLTMP))
	cd $(TMP) \
	&& curl -LO https://storage.googleapis.com/kubernetes-release/release/$(MY_KUBE_VERSION)/bin/linux/amd64/kubectl \
	&& chmod +x kubectl \
 	&& sudo mv -v kubectl /usr/local/bin/
	rmdir $(TMP)

clean:
	-minikube stop
	-minikube delete
	-sudo rm  -f /usr/local/bin/minikube
	-sudo rm  -f /usr/local/bin/kubectl
	-sudo rm  -f KUBE_VERSION:
