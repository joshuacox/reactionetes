# Reactionetes Makefile
# Install location
$(eval R8S_DIR := $(HOME)/.r8s)
$(eval R8S_BIN := $(R8S_DIR)/bin)

# Namespaces
$(eval REACTIONCOMMERCE_NAMESPACE := r8s)
$(eval MONITORING_NAMESPACE := monitoring)

# Release Names
$(eval REACTIONCOMMERCE_NAME := raucous-reactionetes)
$(eval MONGO_RELEASE_NAME := massive-mongonetes)
$(eval REACTION_API_NAME := grape-ape-api)
$(eval GYMONGONASIUM_NAME := ginormous-gymongonasium)
$(eval PROMETHEUS_NAME := pyromaniac-prometheus)

# Reaction Commerce settings
$(eval REACTIONCOMMERCE_REPO := reactioncommerce/reaction)
$(eval REACTIONCOMMERCE_TAG := latest)
$(eval REACTION_REPLICAS := 1)
$(eval REACTIONCOMMERCE_CLUSTER_DOMAIN := cluster.local)

# Mongo settings
$(eval MONGO_DB_NAME := reactionetesdb)
$(eval MONGO_REPLICASET := rs0)
$(eval MONGO_REPLICAS := 3)
$(eval MONGO_PORT := 27017)
$(eval MONGO_TLS := false)
$(eval MONGO_AUTH := false)
$(eval MONGO_PERSISTENCE := false)
$(eval MONGO_PERSISTENCE_SIZE := 10Gi)
$(eval MONGO_PERSISTENCE_ANNOTATIONS := {})
$(eval MONGO_PERSISTENCE_ACCESSMODE := [ReadWriteOnce])
$(eval MONGO_PERSISTENCE_STORAGECLASS := 'volume.alpha.kubernetes.io/storage-class: default')
$(eval MONGONETES_INSTALL_REPO := gcr.io/google_containers/mongodb-install)
$(eval MONGONETES_INSTALL_TAG := 0.5)
$(eval MONGONETES_REPO := mongo)
$(eval MONGONETES_TAG := 3.4)

# Minikube settings
$(eval MINIKUBE_CPU := 2)
$(eval MINIKUBE_MEMORY := 3333)
$(eval MINIKUBE_DRIVER := virtualbox)
$(eval MY_KUBE_VERSION := v1.8.0)
$(eval CHANGE_MINIKUBE_NONE_USER := true)
$(eval KUBECONFIG := $(HOME)/.kube/config)
$(eval MINIKUBE_WANTREPORTERRORPROMPT := false)
$(eval MINIKUBE_WANTUPDATENOTIFICATION := false)
$(eval MINIKUBE_CLUSTER_DOMAIN := cluster.local)

# Gymongonasium settings
$(eval GYMONGO_DB_NAME := gymongonasium)
$(eval GYMONGO_TIME := 33)
$(eval GYMONGO_SLEEP := 5)
$(eval GYMONGO_TABLES := 1)
$(eval GYMONGO_THREADS := 10)
$(eval GYMONGO_SUM_RANGES := 1)
$(eval GYMONGO_RANGE_SIZE := 100)
$(eval GYMONGO_TABLE_SIZE := 10000)

# Prometheus settings
$(eval PROMETHEUS_ALERTMANAGER_ENABLED := true)
$(eval PROMETHEUS_ALERTMANAGER_NAME := pyralertmanager)
$(eval PROMETHEUS_ALERTMANAGER_REPLICAS := 3)
$(eval PROMETHEUS_ALERTMANAGER_PERSISTENTVOLUME_ENABLED := true)
$(eval PROMETHEUS_ALERTMANAGER_PERSISTENTVOLUME_EXISTINGCLAIM := "")
$(eval PROMETHEUS_ALERTMANAGER_PERSISTENTVOLUME_MOUNTPATH := /data)
$(eval PROMETHEUS_ALERTMANAGER_PERSISTENTVOLUME_SIZE := 2Gi)
#$(eval PROMETHEUS_ALERTMANAGER_PERSISTENTVOLUME_STORAGECLASS := "")
$(eval PROMETHEUS_ALERTMANAGER_PERSISTENTVOLUME_SUBPATH := "")

# Helm settings
$(eval HELM_INSTALL_DIR := "$(R8S_BIN)")

# Default
default: .reactioncommerce.rn

# Named Releases
## Reaction Commerce
reactioncommerce: .reactioncommerce.rn

.reactioncommerce.rn: .r8s.ns
	helm install --name $(REACTIONCOMMERCE_NAME) \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		--set mongodbReleaseName=$(MONGO_RELEASE_NAME) \
		--set mongodbName=$(MONGO_DB_NAME) \
		--set mongodbPort=$(MONGO_PORT) \
		--set mongodbReplicaSet=$(MONGO_REPLICASET) \
		--set replicaCount=$(REACTION_REPLICAS) \
		--set image.tag=$(REACTIONCOMMERCE_TAG) \
		--set mongodbReplicaSet=$(MONGO_REPLICASET) \
		--set image.repository=$(REACTIONCOMMERCE_REPO) \
		--set reactioncommerceClusterDomain=$(REACTIONCOMMERCE_CLUSTER_DOMAIN) \
		./reactioncommerce
	@echo $(REACTIONCOMMERCE_NAME) > .reactioncommerce.rn
	@sh ./w8s/reactioncommerce.w8 $(REACTIONCOMMERCE_NAME)
	@sh ./w8s/CrashLoopBackOff.w8

### Reaction Commerce API base
.reaction-api-base.rn:
	helm install --name $(REACTION_API_NAME) \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		--set mongodbPort=$(MONGO_PORT) \
		--set mongodbName=$(MONGO_DB_NAME) \
		--set mongodbReplicaSet=$(MONGO_REPLICASET) \
		--set reactiondbName=$(REACTIONCOMMERCE_NAME) \
		--set mongodbReleaseName=$(MONGO_RELEASE_NAME) \
		./reaction-api-base
	@echo $(REACTION_API_NAME) > .reaction-api-base.rn

## Mongo
mongo-replicaset: .mongo-replicaset.rn

#.mongo-replicaset.rn: .r8s.ns mongo-promexport
.mongo-replicaset.rn: .r8s.ns mongo-official
	@echo $(MONGO_RELEASE_NAME) > .mongo-replicaset.rn
	@sh ./w8s/mongo.w8 $(MONGO_RELEASE_NAME) $(MONGO_REPLICAS)

mongo-official:
	helm install --name $(MONGO_RELEASE_NAME) \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		--set replicaSet=$(MONGO_REPLICASET) \
		--set replicas=$(MONGO_REPLICAS) \
		--set port=$(MONGO_PORT) \
		--set tls.enabled=$(MONGO_TLS) \
		--set tls.cakey=$(MONGO_TLS_CAKEY) \
		--set tls.cacert=$(MONGO_TLS_CACERT) \
		--set auth.enabled=$(MONGO_AUTH) \
		--set auth.key=$(MONGO_AUTH_KEY) \
		--set image.tag=$(MONGONETES_TAG) \
		--set image.name=$(MONGONETES_REPO) \
		--set installImage.tag=$(MONGONETES_INSTALL_TAG) \
		--set installImage.name=$(MONGONETES_INSTALL_REPO) \
		--set auth.adminUser=$(MONGO_AUTH_ADMIN_USER) \
		--set auth.adminPassword=$(MONGO_AUTH_ADMIN_PASSWORD) \
		--set auth.existingKeySecret=$(MONGO_AUTH_EXISTING_KEY_SECRET) \
		--set auth.existingAdminSecret=$(MONGO_AUTH_EXISTING_ADMIN_SECRET) \
		--set persistentVolume.enabled=$(MONGO_PERSISTENCE) \
		--set persistentVolume.size=$(MONGO_PERSISTENCE_SIZE) \
		--set persistentVolume.accessMode=$(MONGO_PERSISTENCE_ACCESSMODE) \
		--set persistentVolume.annotations=$(MONGO_PERSISTENCE_ANNOTATIONS) \
		--set persistentVolume.storageClass=$(MONGO_PERSISTENCE_STORAGECLASS) \
		stable/mongodb-replicaset

mongo-promexport:
	git submodule update --init
	helm install --name $(MONGO_RELEASE_NAME) \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		--set replicaSet=$(MONGO_REPLICASET) \
		--set replicas=$(MONGO_REPLICAS) \
		--set port=$(MONGO_PORT) \
		--set tls.enabled=$(MONGO_TLS) \
		--set tls.cakey=$(MONGO_TLS_CAKEY) \
		--set tls.cacert=$(MONGO_TLS_CACERT) \
		--set auth.enabled=$(MONGO_AUTH) \
		--set auth.key=$(MONGO_AUTH_KEY) \
		--set image.tag=$(MONGONETES_TAG) \
		--set image.name=$(MONGONETES_REPO) \
		--set installImage.tag=$(MONGONETES_INSTALL_TAG) \
		--set installImage.name=$(MONGONETES_INSTALL_REPO) \
		--set auth.adminUser=$(MONGO_AUTH_ADMIN_USER) \
		--set auth.adminPassword=$(MONGO_AUTH_ADMIN_PASSWORD) \
		--set auth.existingKeySecret=$(MONGO_AUTH_EXISTING_KEY_SECRET) \
		--set auth.existingAdminSecret=$(MONGO_AUTH_EXISTING_ADMIN_SECRET) \
		--set persistentVolume.enabled=$(MONGO_PERSISTENCE) \
		--set persistentVolume.size=$(MONGO_PERSISTENCE_SIZE) \
		--set persistentVolume.accessMode=$(MONGO_PERSISTENCE_ACCESSMODE) \
		--set persistentVolume.annotations=$(MONGO_PERSISTENCE_ANNOTATIONS) \
		--set persistentVolume.storageClass=$(MONGO_PERSISTENCE_STORAGECLASS) \
		submodules/charts/stable/mongodb-replicaset

## Gymongonasium
gymongonasium: .gymongonasium.rn

.gymongonasium.rn:
	helm install --name $(GYMONGONASIUM_NAME) \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		--set mongodbName=$(GYMONGO_DB_NAME) \
		--set mongodbPort=$(MONGO_PORT) \
		--set mongodbTIME=$(GYMONGO_TIME) \
		--set mongodbSLEEP=$(GYMONGO_SLEEP) \
		--set mongodbTABLES=$(GYMONGO_TABLES) \
		--set mongodbTHREADS=$(GYMONGO_THREADS) \
		--set mongodbReplicaSet=$(MONGO_REPLICASET) \
		--set mongodbTABLE_SIZE=$(GYMONGO_TABLE_SIZE) \
		--set mongodbSUM_RANGES=$(GYMONGO_SUM_RANGES) \
		--set mongodbReleaseName=$(MONGO_RELEASE_NAME) \
		./gymongonasium
	-@echo $(GYMONGONASIUM_NAME) > .gymongonasium.rn

## Monitoring
monitoring: .monitoring.ns .prometheus.rn

view-monitoring:
		kubectl \
			--namespace=$(MONITORING_NAMESPACE) \
			get pods

### Prometheus
prometheus: .prometheus.rn view-monitoring

# https://itnext.io/kubernetes-monitoring-with-prometheus-in-15-minutes-8e54d1de2e13
.prometheus.rn: .monitoring.ns
	helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
	git submodule update --init
	cd submodules/prometheus-operator \
		&& kubectl apply -f scripts/minikube-rbac.yaml \
		&& helm install --name prometheus-operator \
			--set rbacEnable=true \
			--namespace=$(MONITORING_NAMESPACE) \
			helm/prometheus-operator \
		&& helm install --name prometheus \
			--set serviceMonitorsSelector.app=prometheus \
			--set ruleSelector.app=prometheus \
			--namespace=$(MONITORING_NAMESPACE) \
			helm/prometheus \
		&& helm install --name alertmanager \
			--namespace=$(MONITORING_NAMESPACE) \
			helm/alertmanager \
		&& helm install --name grafana \
			--namespace=$(MONITORING_NAMESPACE) \
			helm/grafana
	cd submodules/prometheus-operator/helm/kube-prometheus \
		&& helm dep update
	cd submodules/prometheus-operator \
		&& helm install --name kube-prometheus \
			--namespace=$(MONITORING_NAMESPACE) \
			helm/kube-prometheus
	@sh ./w8s/generic.w8 prometheus-operator $(MONITORING_NAMESPACE)
	@sh ./w8s/generic.w8 alertmanager-kube-prometheus $(MONITORING_NAMESPACE)
	@sh ./w8s/generic.w8 kube-prometheus-exporter-kube-state $(MONITORING_NAMESPACE)
	@sh ./w8s/generic.w8 kube-prometheus-exporter-node $(MONITORING_NAMESPACE)
	@sh ./w8s/generic.w8 kube-prometheus-grafana $(MONITORING_NAMESPACE)
	@sh ./w8s/generic.w8 prometheus-kube-prometheus $(MONITORING_NAMESPACE)
	-@echo $(PROMETHEUS_NAME) > .prometheus.rn

# Namespaces
.monitoring.ns:
	kubectl create ns monitoring
	date -I > .monitoring.ns

.r8s.ns:
	kubectl create ns $(REACTIONCOMMERCE_NAMESPACE)
	date -I > .r8s.ns

# Requirements
linuxreqs: $(R8S_BIN) run_dotfiles minikube kubectl helm nsenter

osxreqs: macminikube mackubectl machelm macnsenter

windowsreqs:  windowsminikube windowskubectl osxnsenter

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DDEBUGTMP))
	helm install --dry-run --debug reactioncommerce > $(TMP)/manifest
	less $(TMP)/manifest
	ls -lh $(TMP)/manifest
	@echo "you can find the manifest here:"
	@echo "   $(TMP)/manifest"

autopilot: reqs .minikube.made
	@echo 'Autopilot engaged'
	$(MAKE) -e .mongo-replicaset.rn
	$(MAKE) -e .reactioncommerce.rn

extras:
	$(MAKE) -e .reaction-api-base.rn
	$(MAKE) -e .gymongonasium.rn
	$(MAKE) -e .prometheus.rn

.minikube.made:
	minikube \
		--kubernetes-version $(MY_KUBE_VERSION) \
		--dns-domain $(MINIKUBE_CLUSTER_DOMAIN) \
		--memory $(MINIKUBE_MEMORY) \
		--cpus $(MINIKUBE_CPU) \
		--vm-driver=$(MINIKUBE_DRIVER) \
		$(MINIKUBE_OPTS) \
		start
	@sh ./w8s/kubectl.w8
	helm init
	@sh ./w8s/tiller.w8
	@sh ./w8s/kube-dns.w8
	date -I > .minikube.made

helm: $(R8S_BIN)
	@scripts/r8snstaller helm

$(R8S_BIN)/helm: SHELL:=/bin/bash
$(R8S_BIN)/helm:
	@echo 'Installing helm'
	$(eval TMP := $(shell mktemp -d --suffix=HELMTMP))
	curl -Lo $(TMP)/helmget --silent https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get
	HELM_INSTALL_DIR=$(HELM_INSTALL_DIR) \
	sudo -E bash -l $(TMP)/helmget
	rm $(TMP)/helmget
	rmdir $(TMP)

minikube: $(R8S_BIN)
	@scripts/r8snstaller minikube

$(R8S_BIN)/minikube:
	@echo 'Installing minikube'
	$(eval TMP := $(shell mktemp -d --suffix=MINIKUBETMP))
	mkdir $(HOME)/.kube || true
	touch $(HOME)/.kube/config
	cd $(TMP) \
	&& curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube $(R8S_BIN)/
	rmdir $(TMP)

kubectl: $(R8S_BIN)
	@scripts/r8snstaller kubectl

$(R8S_BIN)/kubectl:
	@echo 'Installing kubectl'
	$(eval TMP := $(shell mktemp -d --suffix=KUBECTLTMP))
	cd $(TMP) \
	&& curl -LO https://storage.googleapis.com/kubernetes-release/release/$(MY_KUBE_VERSION)/bin/linux/amd64/kubectl \
	&& chmod +x kubectl \
	&& sudo mv -v kubectl $(R8S_BIN)/
	rmdir $(TMP)

macminikube:
	@echo 'Installing minikube'
	brew cask install minikube

mackubectl:
	@echo 'Installing kubectl'
	brew install kubectl

machelm:
	@echo 'Installing helm'
	brew install kubernetes-helm

macnsenter:
	@echo 'Installing nsenter'
	brew install kubernetes-nsenter

windowsminikube:
	@echo 'Installing minikube'
	choco install minikube

windowskubectl:
	@echo 'Installing kubectl'
	choco install kubernetes-cli

windowshelm:
	@echo 'Installing helm'
	choco install helm

windowsnsenter:
	@echo 'Installing nsenter'
	choco install nsenter

clean:
	-minikube delete
	-@rm -f .minikube.made
	-@rm -f .reactioncommerce.rn
	-@rm -f .mongo-replicaset.rn
	-@rm -f .gymongonasium.rn
	-@rm -f .reaction-api-base.rn
	-@rm -f .prometheus.rn
	-@rm -f .r8s.ns
	-@rm -f .monitoring.ns

d: delete

hardclean: clean
	rm $(R8S_BIN)/minikube
	rm $(R8S_BIN)/kubectl
	rm $(R8S_BIN)/helm
	rm -Rf ~/.minikkube
	rm -Rf /etc/kubernetes/*

delete:
	helm delete --purge $(REACTIONCOMMERCE_NAME)
	-@rm -f .reactioncommerce.rn

fulldelete:
	helm delete --purge $(REACTION_API_NAME)
	-@rm -f .reaction-api-base.rn
	helm delete --purge $(MONGO_RELEASE_NAME)-gymongonasium
	-@rm -f .gymongonasium.rn
	helm delete --purge $(REACTIONCOMMERCE_NAME)
	-@rm -f .reactioncommerce.rn
	helm delete --purge $(MONGO_RELEASE_NAME)
	-@rm -f .mongo-replicaset.rn

timeme:
	/usr/bin/time -v ./bootstrap

test: timeme

reqs:
	bash ./check_reqs

# Install this to verify circleCI throught the CLI before commits
.git/hooks/pre-commit:
	cp .circleci/pre-commit .git/hooks/pre-commit

dobusybox:
	kubectl apply -n $(REACTIONCOMMERCE_NAMESPACE) -f busybox/busybox.yaml
	@sh ./w8s/generic.w8 busybox $(REACTIONCOMMERCE_NAMESPACE)

dnstest: dobusybox
	kubectl exec -ti busybox \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		-- nslookup $(MONGO_RELEASE_NAME)-mongodb-replicaset
	kubectl exec -ti busybox \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		-- nslookup $(REACTIONCOMMERCE_NAME)-reactioncommerce

ci: autopilot extended_tests

extended_tests:
	kubectl \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		get ep
	make -e dnstest
	./w8s/webpage.w8 $(REACTIONCOMMERCE_NAME)
	kubectl \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		get all
	kubectl \
		--namespace=$(REACTIONCOMMERCE_NAMESPACE) \
		get ep
	-@ echo 'Memory consumption of all that:'
	free -m

rancher:
	minikube ssh "docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:preview"
	@echo 'Go to 8080 on your VM to see your rancher server, and go to http://rancher.com/docs/rancher/v2.0/en/quick-start-guide/#import-k8s to see how to import your cluster into the rancher'

nsenter: $(R8S_BIN)
	@scripts/r8snstaller nsenter

$(R8S_BIN)/nsenter: $(R8S_BIN)
	.ci/ubuntu-compile-nsenter.sh
	sudo cp .tmp/util-linux-2.30.2/nsenter $(R8S_BIN)/

run_dotfiles:
	@scripts/dotfiles

$(R8S_BIN):
	mkdir -p $(R8S_BIN)
