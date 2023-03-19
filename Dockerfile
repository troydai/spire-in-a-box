FROM spire-builder:v1.6.1 as builder

FROM alpine:3.17 as spire-base

WORKDIR /opt/spire
CMD []

RUN apk add --no-cache ca-certificates

FROM spire-base as spire-main

ENTRYPOINT [ "/opt/spire/bin/spire-server", "run" ]

COPY --from=builder /spireserverroot /
COPY --from=builder /spire/bin/static/spire-server bin/
COPY ./config/server.conf conf/server/server.conf
COPY spire/conf/server/dummy_upstream_ca.crt conf/server/
COPY spire/conf/server/dummy_upstream_ca.key conf/server/

FROM golang:1.20.1-alpine3.17 as workload

RUN go install github.com/mccutchen/go-httpbin/v2/cmd/go-httpbin@latest

USER 1000

WORKDIR /opt/spire
COPY --from=builder /spire/bin/static/spire-agent bin/
COPY ./config/agent.conf conf/agent/agent.conf
COPY spire/conf/agent/dummy_root_ca.crt conf/agent/

EXPOSE 8080

CMD ["go-httpbin"]
