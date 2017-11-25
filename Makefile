MINIKUBE_WANTUPDATENOTIFICATION=false
MINIKUBE_WANTREPORTERRORPROMPT=false
CHANGE_MINIKUBE_NONE_USER=false
KUBECONFIG=$(HOME)/.kube/config
MY_KUBE_VERSION=v1.8.0

install:
	helm install ./reactionetes

linuxreqs: /usr/local/bin/minikube /usr/local/bin/kubectl

osxreqs: macminikube mackubectl

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DDEBUGTMP))
	helm install --dry-run --debug reactionetes > $(TMP)/manifest
	less $(TMP)/manifest
	ls -lh $(TMP)/manifest
	@echo "you can find the manifest here:"
	@echo "   $(TMP)/manifest"

autopilot:
	@echo 'Autopilot engaged'
	minikube --kubernetes-version $(MY_KUBE_VERSION) $(MINIKUBE_OPTS) start
	sh ./w8s
	helm init
	sleep 120
	make

/usr/local/bin/minikube:
	@echo 'Installing minikube'
	$(eval TMP := $(shell mktemp -d --suffix=MINIKUBETMP))
	mkdir $HOME/.kube || true
	touch $HOME/.kube/config
	cd $(TMP) \
	&& curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
	rmdir $(TMP)

/usr/local/bin/kubectl:
	@echo 'Installing kubectl'
	$(eval TMP := $(shell mktemp -d --suffix=KUBECTLTMP))
	cd $(TMP) \
	&& curl -LO https://storage.googleapis.com/kubernetes-release/release/$(MY_KUBE_VERSION)/bin/linux/amd64/kubectl \
	&& chmod +x kubectl \
 	&& sudo mv -v kubectl /usr/local/bin/
	rmdir $(TMP)

macminikube:
	@echo 'Installing minikube'
	brew cask install minikube

mackubectl:
	@echo 'Installing kubectl'
	brew install kubectl

clean:
	-minikube stop
	-minikube delete
