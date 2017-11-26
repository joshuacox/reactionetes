MINIKUBE_WANTUPDATENOTIFICATION=false
MINIKUBE_WANTREPORTERRORPROMPT=false
CHANGE_MINIKUBE_NONE_USER=false
KUBECONFIG=$(HOME)/.kube/config
MY_KUBE_VERSION=v1.8.0
PREFIX=$(HOME)/.kube/bin

install:
	$(PREFIX)/helm install ./reactionetes

linuxreqs: $(PREFIX)/minikube $(PREFIX)/kubectl $(PREFIX)/helm dotfiles

osxreqs: macminikube mackubectl machelm

windowsreqs: windowsminikube windowskubectl

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DDEBUGTMP))
	$(PREFIX)/helm install --dry-run --debug reactionetes > $(TMP)/manifest
	less $(TMP)/manifest
	ls -lh $(TMP)/manifest
	@echo "you can find the manifest here:"
	@echo "   $(TMP)/manifest"

autopilot:
	@echo 'Autopilot engaged'
	$(PREFIX)/minikube --kubernetes-version $(MY_KUBE_VERSION) $(MINIKUBE_OPTS) start
	sh ./w8s
	$(PREFIX)/helm init
	sleep 120
	make

$(PREFIX)/helm:
	$(eval TMP := $(shell mktemp -d --suffix=HELMTMP))
	curl -Lo $(TMP)/helmget https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
	HELM_INSTALL_DIR="$(PREFIX)" bash $(TMP)/helmget

$(PREFIX)/minikube:
	@echo 'Installing minikube'
	$(eval TMP := $(shell mktemp -d --suffix=MINIKUBETMP))
	mkdir -p $(HOME)/.kube/bin || true
	touch $(HOME)/.kube/config
	curl -Lo $(TMP)/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	chmod +x $(TMP)/minikube
	sudo mv $(TMP)/minikube $(PREFIX)/minikube
	rmdir $(TMP)

$(PREFIX)/kubectl:
	@echo 'Installing kubectl'
	$(eval TMP := $(shell mktemp -d --suffix=KUBECTLTMP))
	curl -Lo $(TMP)/kubectl https://storage.googleapis.com/kubernetes-release/release/$(MY_KUBE_VERSION)/bin/linux/amd64/kubectl
	chmod +x $(TMP)/kubectl
	sudo mv $(TMP)/kubectl $(PREFIX)/kubectl
	rmdir $(TMP)

macminikube:
	@echo 'Installing minikube'
	brew cask install minikube

mackubectl:
	@echo 'Installing kubectl'
	brew install kubectl

machelm:
	@echo 'Installing kubectl'
	brew install kubernetes-helm

windowsminikube:
	@echo 'Installing minikube'
	choco install minikube

windowskubectl:
	@echo 'Installing kubectl'
	choco install kubernetes-cli

clean:
	-minikube stop
	-minikube delete

timeme:
	/usr/bin/time -v ./bootstrap

dotfiles:
	bash dotfiles.bash
