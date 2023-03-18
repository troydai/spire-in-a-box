FROM golang:1.20-alpine3.17 as builder

ARG SPIRE_VERSION=v1.6.1
RUN apk add git

WORKDIR /workspace
RUN git clone --depth=1 --branch=${SPIRE_VERSION} https://github.com/spiffe/spire.git

WORKDIR /workspace/spire
RUN go mod download
RUN go build -o /workspace/target/spire/${SPIRE_VERSION}/spire-server /workspace/spire/cmd/spire-server/main.go

FROM alpine:3.17 as spire-server

ARG SPIRE_VERSION=v1.6.1

COPY --from=builder /workspace/target/spire/${SPIRE_VERSION}/spire-server /usr/local/bin/spire-server

