# Copyright (c) 2021 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

REPO=fuzzylemma
IMAGE_NAME=tailscale
IMAGE_TAG=v1.22

base:
	@docker build . -f Dockerfile.tailscale -t $(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
	@docker push $(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)


build: base
	@docker build . -f Dockerfile.k8s -t $(REPO)/$(IMAGE_NAME)-subnet-router:$(IMAGE_TAG)

push: build
	@docker push $(REPO)/$(IMAGE_NAME)-subnet-router:$(IMAGE_TAG)


.PHONY: base build push
