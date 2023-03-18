.PHONY: image

SPIRE_VERSION=v1.6.1

image:
	@ docker build --build-arg SPIRE_VERSION=$(SPIRE_VERSION) --target spire-server -t spire-server:$(SPIRE_VERSION) .