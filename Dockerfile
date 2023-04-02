FROM alpine:3.17 as keygen

RUN apk add --no-cache openssl

WORKDIR /workspace
COPY scripts/keys/ ./
RUN rm -rf .data && mkdir .data && ./gen.sh

FROM spire-builder:v1.6.1 as builder

FROM alpine:3.17 as spire-base

WORKDIR /opt/spire
CMD []

RUN apk add --no-cache ca-certificates

FROM spire-base as spire-main

ENTRYPOINT [ "/opt/spire/bin/spire-server", "run" ]

COPY --from=builder /spireserverroot /
COPY --from=builder /spire/bin/static/spire-server bin/
COPY --from=keygen /workspace/.data/agents.crt conf/server/agents.crt
COPY --from=keygen /workspace/.data/root.crt conf/server/root_ca.crt
COPY --from=keygen /workspace/.data/root.key conf/server/root_ca.key
COPY ./config/server.conf conf/server/server.conf

FROM golang:1.20.1-alpine3.17 as workload

WORKDIR /opt/spire
COPY --from=builder /spire/bin/static/spire-agent bin/
COPY --from=keygen /workspace/.data/root.crt conf/agent/root_ca.crt
COPY --from=keygen /workspace/.data/agent1/agent.key conf/agent/agent.key
COPY --from=keygen /workspace/.data/agent1/agent.crt conf/agent/agent.crt
COPY ./config/agent.conf conf/agent/agent.conf

EXPOSE 8080

CMD ["/opt/spire/bin/spire-agent", "run"]
