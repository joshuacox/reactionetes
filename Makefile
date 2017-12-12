# default release names
$(eval REACTIONCOMMERCE_NAME := raucous-reactionetes)
$(eval MONGO_RELEASE_NAME := massive-mongonetes)
$(eval REACTION_API_NAME := grape-ape-api)
# default mongo settings
$(eval MONGO_DB_NAME := reactionetesdb)
$(eval MONGO_REPLICASET := rs0)
$(eval MONGO_PORT := 27017)
$(eval MONGO_REPLICAS := 3)
$(eval MONGONETES_INSTALL_REPO := gcr.io/google_containers/mongodb-install)
$(eval MONGONETES_INSTALL_TAG := 0.3)
$(eval MONGONETES_REPO := mongo)
$(eval MONGONETES_TAG := 3.4)
$(eval MONGO_PERSISTENCE := false)
$(eval MONGO_TLS := false)
$(eval MONGO_AUTH := false)
$(eval MONGO_PERSISTENCE_SIZE := 10Gi)
$(eval MONGO_PERSISTENCE_ACCESSMODE := [ReadWriteOnce])
$(eval MONGO_PERSISTENCE_ANNOTATIONS := {})
$(eval MONGO_PERSISTENCE_STORAGECLASS := 'volume.alpha.kubernetes.io/storage-class: default')
#default reaction settings
$(eval REACTIONCOMMERCE_CLUSTER_DOMAIN := cluster.local)
$(eval REACTION_REPLICAS := 1)
$(eval REACTIONCOMMERCE_REPO := reactioncommerce/reaction)
$(eval REACTIONCOMMERCE_TAG := latest)
# MInikube settings
$(eval MINIKUBE_MEMORY := 11023)
$(eval MINIKUBE_CPU := 8)
$(eval MINIKUBE_WANTUPDATENOTIFICATION := false)
$(eval MINIKUBE_WANTREPORTERRORPROMPT := false)
$(eval CHANGE_MINIKUBE_NONE_USER := true)
$(eval KUBECONFIG := $(HOME)/.kube/config)
$(eval MY_KUBE_VERSION := v1.8.0)
$(eval MINIKUBE_CLUSTER_DOMAIN := cluster.local)
# Gymongonasium settings
$(eval GYMONGO_DB_NAME := gymongonasium)
$(eval GYMONGO_TIME := 33)
$(eval GYMONGO_SLEEP := 5)
$(eval GYMONGO_TABLES := 1)
$(eval GYMONGO_THREADS := 10)
$(eval GYMONGO_TABLE_SIZE := 10000)
$(eval GYMONGO_RANGE_SIZE := 100)
$(eval GYMONGO_SUM_RANGES := 1)

$(eval MONGO_URL := $(shell bash mongo_url $(MONGO_REPLICAS)))

install:
	helm install --name $(REACTIONCOMMERCE_NAME) \
		--set mongodbReleaseName=$(MONGO_RELEASE_NAME) \
		--set mongodbName=$(MONGO_DB_NAME) \
		--set mongodbPort=$(MONGO_PORT) \
		--set replicaCount=$(REACTION_REPLICAS) \
		--set image.tag=$(REACTIONCOMMERCE_TAG) \
    --set mongodbReplicaSet=$(MONGO_REPLICASET) \
		--set image.repository=$(REACTIONCOMMERCE_REPO) \
		--set reactioncommerceClusterDomain=$(REACTIONCOMMERCE_CLUSTER_DOMAIN) \
		./reactioncommerce
	@sh ./w8s/reactioncommerce.w8 $(REACTIONCOMMERCE_NAME)
	@sh ./w8s/CrashLoopBackOff.w8

mongo-replicaset-install:
	helm install --name $(MONGO_RELEASE_NAME) \
		--set persistentVolume.enabled=$(MONGO_PERSISTENCE) \
		stable/mongodb-replicaset
	@sh ./w8s/mongo.w8 $(MONGO_RELEASE_NAME) $(MONGO_REPLICAS)

full-mongo-replicaset-install:
	helm install --name $(MONGO_RELEASE_NAME) \
		--set replicaSet=$(MONGO_REPLICASET) \
		--set replicas=$(MONGO_REPLICAS) \
		--set port=$(MONGO_PORT) \
		--set image.name=$(MONGONETES_REPO) \
		--set image.tag=$(MONGONETES_TAG) \
		--set installImage.name=$(MONGONETES_INSTALL_REPO) \
		--set installImage.tag=$(MONGONETES_INSTALL_TAG) \
		--set persistentVolume.enabled=$(MONGO_PERSISTENCE) \
		--set persistentVolume.storageClass=$(MONGO_PERSISTENCE_STORAGECLASS) \
		--set persistentVolume.accessMode=$(MONGO_PERSISTENCE_ACCESSMODE) \
		--set persistentVolume.size=$(MONGO_PERSISTENCE_SIZE) \
		--set persistentVolume.annotations=$(MONGO_PERSISTENCE_ANNOTATIONS) \
		--set tls.enabled=$(MONGO_TLS) \
		--set tls.cacert=$(MONGO_TLS_CACERT) \
		--set tls.cakey=$(MONGO_TLS_CAKEY) \
		--set auth.enabled=$(MONGO_AUTH) \
		--set auth.key=$(MONGO_AUTH_KEY) \
		--set auth.existingKeySecret=$(MONGO_AUTH_EXISTING_KEY_SECRET) \
		--set auth.adminUser=$(MONGO_AUTH_ADMIN_USER) \
		--set auth.adminPassword=$(MONGO_AUTH_ADMIN_PASSWORD) \
		--set auth.existingAdminSecret=$(MONGO_AUTH_EXISTING_ADMIN_SECRET) \
		stable/mongodb-replicaset
	@sh ./w8s/mongo.w8 $(MONGO_RELEASE_NAME) $(MONGO_REPLICAS)

apiinstall:
	helm install --name $(REACTION_API_NAME) \
		--set mongodbReleaseName=$(MONGO_RELEASE_NAME) \
		--set mongodbName=$(MONGO_DB_NAME) \
		--set mongodbReplicaSet=$(MONGO_REPLICASET) \
		--set mongodbPort=$(MONGO_PORT) \
		--set reactiondbName=$(REACTIONCOMMERCE_NAME) \
		./reaction-api-base

gyminstall:
	helm install --name $(MONGO_RELEASE_NAME)-gymongonasium \
		--set mongodbReleaseName=$(MONGO_RELEASE_NAME) \
		--set mongodbReplicaSet=$(MONGO_REPLICASET) \
		--set mongodbPort=$(MONGO_PORT) \
		--set mongodbName=$(GYMONGO_DB_NAME) \
		--set mongodbTIME=$(GYMONGO_TIME) \
		--set mongodbSLEEP=$(GYMONGO_SLEEP) \
		--set mongodbTABLES=$(GYMONGO_TABLES) \
		--set mongodbTHREADS=$(GYMONGO_THREADS) \
		--set mongodbTABLE_SIZE=$(GYMONGO_TABLE_SIZE) \
		--set mongodbSUM_RANGES=$(GYMONGO_SUM_RANGES) \
		./gymongonasium

linuxreqs: /usr/local/bin/minikube /usr/local/bin/kubectl /usr/local/bin/helm

osxreqs: macminikube mackubectl machelm

windowsreqs:  windowsminikube windowskubectl

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DDEBUGTMP))
	helm install --dry-run --debug reactioncommerce > $(TMP)/manifest
	less $(TMP)/manifest
	ls -lh $(TMP)/manifest
	@echo "you can find the manifest here:"
	@echo "   $(TMP)/manifest"

autopilot: reqs .minikube.made
	@echo 'Autopilot engaged'
	$(MAKE) -e mongo-replicaset-install
	$(MAKE) -e apiinstall
	$(MAKE) -e gyminstall
	$(MAKE) -e install

.minikube.made:
	minikube \
		--kubernetes-version $(MY_KUBE_VERSION) \
		--dns-domain $(MINIKUBE_CLUSTER_DOMAIN) \
		--memory $(MINIKUBE_MEMORY) \
		--cpus $(MINIKUBE_CPU) \
		$(MINIKUBE_OPTS) \
		start
	@sh ./w8s/kubectl.w8
	helm init
	@sh ./w8s/tiller.w8
	@sh ./w8s/kube-dns.w8
	date -I > .minikube.made

/usr/local/bin/helm:
	curl -L https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | sudo bash

installhelm:
	curl -L https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | sudo bash

/usr/local/bin/minikube:
	@echo 'Installing minikube'
	$(eval TMP := $(shell mktemp -d --suffix=MINIKUBETMP))
	mkdir $(HOME)/.kube || true
	touch $(HOME)/.kube/config
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
	-minikube delete
	-@rm .minikube.made

d: delete

hardclean: clean
	rm /usr/local/bin/minikube
	rm /usr/local/bin/kubectl
	rm /usr/local/bin/helm
	rm -Rf ~/.minikkube
	rm -Rf /etc/kubernetes/*

delete:
	helm delete --purge $(REACTIONCOMMERCE_NAME)

fulldelete:
	helm delete --purge $(REACTION_API_NAME)
	helm delete --purge $(MONGO_RELEASE_NAME)-gymongonasium
	helm delete --purge $(REACTIONCOMMERCE_NAME)
	helm delete --purge $(MONGO_RELEASE_NAME)

timeme:
	/usr/bin/time -v ./bootstrap

test: timeme

reqs:
	bash ./check_reqs

# Install this to verify circleCI throught the CLI before commits
.git/hooks/pre-commit:
	cp .circleci/pre-commit .git/hooks/pre-commit

dobusybox:
	kubectl apply -f busybox/busybox.yaml
	@sh ./w8s/generic.w8 busybox

dnstest: dobusybox
	kubectl exec -ti busybox -- nslookup $(MONGO_RELEASE_NAME)-mongodb-replicaset
	kubectl exec -ti busybox -- nslookup $(REACTIONCOMMERCE_NAME)-reactioncommerce

ci: autopilot
	kubectl get ep
	make -e dnstest
	./w8s/webpage.w8 $(REACTIONCOMMERCE_NAME)
	kubectl get all
	kubectl get ep
	-@ echo 'Memory consumption of all that:'
	free -m
	@sh ./w8s/CrashLoopBackOff.w8
