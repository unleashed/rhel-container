MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_PATH := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

IMAGE_NAME = scl-base
CONTAINER_NAME ?= $(IMAGE_NAME)-container

EPEL_ENABLE ?= 0

default: info

.PHONY: info
info:
	@echo -e "Variables you should care about:\n\n"\
		"EPEL_ENABLE    = $(IMAGE_NAME)\n" \
		"IMAGE_NAME     = $(IMAGE_NAME)\n" \
		"CONTAINER_NAME = $(CONTAINER_NAME)\n"

.PHONY: build
build:
	docker history -q $(IMAGE_NAME) 2> /dev/null >&2 || \
		$(MAKE) build_image

build_base:
	docker history -q rhel-base 2> /dev/null >&2 || \
		$(MAKE) -C $(PROJECT_PATH)/../rhel-base build_image

.PHONY: build_image
build_image: info build_base
	docker build -t $(IMAGE_NAME) \
		--build-arg EPEL_ENABLE=$(EPEL_ENABLE) $(PROJECT_PATH)

.PHONY: run
run: build
	# Make sure you run setenforce 0 if you run this under SELinux
	# Or use https://github.com/dpw/selinux-dockersock.
	docker start -ai $(CONTAINER_NAME) 2> /dev/null || \
	docker run -it -h $(IMAGE_NAME) --name $(CONTAINER_NAME) \
		$(IMAGE_NAME) /bin/bash

include $(PROJECT_PATH)/../common.mk
