.ONESHELL:

APPNAME := pipeline-tools
IMAGENAME := deniceg/$(APPNAME)

VERSIONTAG := $(shell git describe --tags --abbrev=0)
GITCOMMITHASH := $(shell git log --max-count=1 --pretty="format:%h" HEAD)

image: 
	@echo Creating docker image $(IMAGENAME):$(VERSIONTAG)-$(GITCOMMITHASH)
	docker build --no-cache -t $(IMAGENAME):$(VERSIONTAG)-$(GITCOMMITHASH) .
	docker tag $(IMAGENAME):$(VERSIONTAG)-$(GITCOMMITHASH) $(IMAGENAME):$(VERSIONTAG)
	docker tag $(IMAGENAME):$(VERSIONTAG)-$(GITCOMMITHASH) $(IMAGENAME):latest

publish:
	docker push $(IMAGENAME):$(VERSIONTAG)-$(GITCOMMITHASH)
	docker push $(IMAGENAME):$(VERSIONTAG)
	docker push $(IMAGENAME):latest

