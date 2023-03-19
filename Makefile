.PHONY: image

SPIRE_VERSION=v1.6.1
BUILD_PLATFORM=aarch64

up: image
	@ docker-compose up

down:
	@ docker-compose down

image: build-spire
	@ docker build --target spire-main 	-t spire-in-a-box-main .
	@ docker build --target workload 	-t spire-in-a-box-workload .

build-spire:
	@ git submodule update --init --recursive
	@ cd spire && docker build --target builder \
		--build-arg goversion=1.20.1 \
		--build-arg BUILDPLATFORM=$(BUILD_PLATFORM) \
		-t spire-builder:$(SPIRE_VERSION) \
		.

join-token:
	@ docker-compose exec spire-server /opt/spire/bin/spire-server token generate \
		-spiffeID spiffe://spire-in-a-box.troydai.cc/agent