MINIKUBE_WANTUPDATENOTIFICATION=false
MINIKUBE_WANTREPORTERRORPROMPT=false
CHANGE_MINIKUBE_NONE_USER=true
KUBECONFIG=$(HOME)/.kube/config
MY_KUBE_VERSION=v1.8.0

install:
	$(eval TMP := $(shell mktemp -d --suffix=MINIKUBETMP))
	$(eval REACTIONETES_NAME := raucous-reactionetes)
	$(eval MONGO_RELEASE_NAME := massive-mongonetes)
	$(eval REACTIONETES_REPO := reactioncommerce/reaction)
	$(eval REACTIONETES_TAG := latest)
	$(eval REACTIONETES_CLUSTER_DOMAIN := cluster.local)
	$(eval REPLICAS := 1)
	$(eval MONGO_REPLICAS := 3)
	helm install --name $(REACTIONETES_NAME) \
	  --set mongodbName=$(MONGO_RELEASE_NAME) \
		--set replicaCount=$(REPLICAS) \
		--set mongoReplicaCount=$(MONGO_REPLICAS) \
		--set image.tag=$(REACTIONETES_TAG) \
		--set image.repository=$(REACTIONETES_REPO) \
		--set reactioncommerceClusterDomain=$(REACTIONETES_CLUSTER_DOMAIN) \
		./reactioncommerce
	@sh ./w8s/reactioncommerce.w8 $(REACTIONETES_NAME)
	@sh ./w8s/CrashLoopBackOff.w8

mongodefaultinstall:
	$(eval MONGO_RELEASE_NAME := massive-mongonetes)
	$(eval MONGO_PERSISTENCE := false)
	helm install --name $(MONGO_RELEASE_NAME) \
		--set persistence.enabled=$(MONGO{_PERSISTENCE) \
		stable/mongodb
	@sh ./w8s/generic.w8 $(MONGO_RELEASE_NAME)-mongodb

mongoinstall:
	$(eval TMP := $(shell mktemp -d --suffix=MINIKUBETMP))
	$(eval MONGO_RELEASE_NAME := massive-mongonetes)
	$(eval MONGONETES_REPO := mongo)
	$(eval MONGONETES_TAG := 3.4)
	$(eval MONGONETES_CLUSTER_DOMAIN := cluster.local)
	$(eval REPLICAS := 1)
	$(eval MONGO_REPLICAS := 3)
	helm install --name $(MONGO_RELEASE_NAME) \
		--set mongoReplicaCount=$(MONGO_REPLICAS) \
		--set image.tag=$(MONGONETES_TAG) \
		--set image.repository=$(MONGONETES_REPO) \
		--set mongonetesClusterDomain=$(MONGONETES_CLUSTER_DOMAIN) \
		./mongostateful
	@sh ./w8s/mongo.w8 $(MONGO_RELEASE_NAME) $(MONGO_REPLICAS)

apiinstall:
	$(eval MONGO_RELEASE_NAME := massive-mongonetes)
	$(eval REACTION_API_NAME := grape-ape-api)
	helm install --name $(REACTION_API_NAME) \
	  --set mongodbName=$(MONGO_RELEASE_NAME) \
		./reaction-api-base

gyminstall:
	$(eval MONGO_RELEASE_NAME := massive-mongonetes)
	$(eval gymongonasium.mongo_db := gymongonasium)
	$(eval gymongonasium.mongo_port := 27017)
	$(eval gymongonasium.mongo_TIME := 33)
	$(eval gymongonasium.mongo_SLEEP := 5)
	$(eval gymongonasium.mongo_TABLES := 1)
	$(eval gymongonasium.mongo_THREADS := 10)
	$(eval gymongonasium.mongo_TABLE_SIZE := 10000)
	$(eval gymongonasium.mongo_RANGE_SIZE := 100)
	$(eval gymongonasium.mongo_SUM_RANGES := 1)
	helm install --name $(MONGO_RELEASE_NAME)-gymongonasium \
    --set mongodbName=$(MONGO_RELEASE_NAME) \
    --set gymongonasium.mongo_db=$(gymongonasium.mongo_db) \
    --set gymongonasium.mongo_port=$(gymongonasium.mongo_port) \
    --set gymongonasium.mongo_TIME=$(gymongonasium.mongo_TIME) \
    --set gymongonasium.mongo_SLEEP=$(gymongonasium.mongo_SLEEP) \
    --set gymongonasium.mongo_TABLES=$(gymongonasium.mongo_TABLES) \
    --set gymongonasium.mongo_THREADS=$(gymongonasium.mongo_THREADS) \
    --set gymongonasium.mongo_TABLE_SIZE=$(gymongonasium.mongo_TABLE_SIZE) \
    --set gymongonasium.mongo_RANGE_SIZE=$(gymongonasium.mongo_RANGE_SIZE) \
    --set gymongonasium.mongo_SUM_RANGES=$(gymongonasium.mongo_SUM_RANGES) \
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
	$(eval MONGO_REPLICAS := 1)
	$(eval MONGO_RELEASE_NAME := massive-mongonetes)
	$(MAKE) -e mongoinstall
	$(MAKE) -e install

.minikube.made:
	$(eval MINIKUBE_MEMORY := 4096)
	$(eval MINIKUBE_CPU := 4)
	$(eval REACTIONETES_CLUSTER_DOMAIN := cluster.local)
	minikube \
		--kubernetes-version $(MY_KUBE_VERSION) \
		--dns-domain $(REACTIONETES_CLUSTER_DOMAIN) \
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

delete:
	$(eval REACTIONETES_NAME := raucous-reactionetes)
	$(eval MONGO_RELEASE_NAME := massive-mongonetes)
	helm delete --purge $(REACTIONETES_NAME)
	helm delete --purge $(MONGO_RELEASE_NAME)

timeme:
	/usr/bin/time -v ./bootstrap

test: timeme

reqs:
	bash ./check_reqs

# Install this to verify circleCI throught the CLI before commits
.git/hooks/pre-commit:
	cp .circleci/pre-commit .git/hooks/pre-commit

busybox:
	kubectl apply -f busybox/busybox.yaml
	@sh ./w8s/generic.w8 busybox

dnstest: busybox
	$(eval REACTIONETES_NAME := raucous-reactionetes)
	$(eval MONGO_RELEASE_NAME := massive-mongonetes)
	kubectl exec -ti busybox -- nslookup $(MONGO_RELEASE_NAME)-mongodb
	kubectl exec -ti busybox -- nslookup $(REACTIONETES_NAME)-reactioncommerce

ci: autopilot
	$(eval REACTIONETES_NAME := raucous-reactionetes)
	kubectl get ep
	make -e dnstest
	./w8s/webpage.w8 $(REACTIONETES_NAME)
	kubectl get all
	kubectl get ep
	-@ echo 'Memory consumption of all that:'
	free -m
	@sh ./w8s/CrashLoopBackOff.w8
