MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_PATH := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

default: build

.PHONY: build
build: rhel

.PHONY: rhel
rhel:
	$(MAKE) -C rhel-base build

.PHONY: scl
scl:
	$(MAKE) -C scl-base build

.PHONY: run
run: run-rhel

.PHONY: run-rhel
run-rhel:
	$(MAKE) -C rhel-base run

.PHONY: run-scl
run-scl:
	$(MAKE) -C scl-base run

.PHONY: implode
implode:
	$(MAKE) -C rhel-base implode
