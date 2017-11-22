install:
	helm install .

debug:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	helm install --dry-run --debug . > $(TMP)/manifest
	ls -lh $(TMP)/manifest
