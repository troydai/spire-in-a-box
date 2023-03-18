.PHONY: image

SPIRE_VERSION=v1.6.1

image: build-spire
	@ docker build -t spire-in-a-box-main .

build-spire:
	@ git submodule update --init --recursive
	@ cd spire && docker build --target spire-server \
		--build-arg goversion=1.20.1 \
		--build-arg BUILDPLATFORM=aarch64 \
		-t spire-server:$(SPIRE_VERSION) \
		.
	@ cd spire && docker build --target spire-agent \
		--build-arg goversion=1.20.1 \
		--build-arg BUILDPLATFORM=aarch64 \
		-t spire-agent:$(SPIRE_VERSION) \
		.