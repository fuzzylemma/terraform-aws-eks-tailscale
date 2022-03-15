# Copyright (c) 2021 Tailscale Inc & AUTHORS All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

REPO=fuzzylemma
IMAGE_NAME=tailscale
IMAGE_TAG=latest

build:
	@docker build . -t $(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)

push: build
	@docker push $(REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
