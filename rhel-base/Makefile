MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_PATH := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

IMAGE_NAME = rhel-base
CONTAINER_NAME ?= $(IMAGE_NAME)-container

ON_RHEL_HOST ?=
# Ensure this variable, if used, points to a tar.gz file in the build context
# directory (typically the directory where the Dockerfile lives) or
# a subdirectory, and refers to it with a relative path from the build context
# directory, ie. if it lives in $(PROJECT_PATH), which is the default build
# context directory, then you'd set this to "./entitlements.tar.gz".
ENTITLEMENTS ?=

default: info

.PHONY: info
info:
	@echo -e "Variables you should care about:\n\n"\
		"RHEL_SUB_USER   = $(RHEL_SUB_USER)\n"\
		"RHEL_SUB_PASSWD = ...\n"\
		"ON_RHEL_HOST    = $(ON_RHEL_HOST)\n" \
		"ENTITLEMENTS    = $(ENTITLEMENTS)\n" \
		"IMAGE_NAME      = $(IMAGE_NAME)\n" \
		"CONTAINER_NAME  = $(CONTAINER_NAME)\n"

.PHONY: build
build:
	docker history -q $(IMAGE_NAME) 2> /dev/null >&2 || \
		$(MAKE) build_image

.PHONY: build_image
build_image: info
	docker build -t $(IMAGE_NAME) \
		--build-arg RHEL_SUB_USER=$(RHEL_SUB_USER) \
		--build-arg RHEL_SUB_PASSWD="$(RHEL_SUB_PASSWD)" \
		--build-arg ON_RHEL_HOST=$(ON_RHEL_HOST) \
		--build-arg ENTITLEMENTS=$(ENTITLEMENTS) \
		$(DOCKER_BUILD_EXTRA_PARAMS) \
		$(PROJECT_PATH)

.PHONY: run
run: build
	# Make sure you run setenforce 0 if you run this under SELinux
	# Or use https://github.com/dpw/selinux-dockersock.
	docker start -ai $(CONTAINER_NAME) 2> /dev/null || \
	docker run -it -h $(IMAGE_NAME) --name $(CONTAINER_NAME) \
		$(IMAGE_NAME) /bin/bash

include $(PROJECT_PATH)/../common.mk
