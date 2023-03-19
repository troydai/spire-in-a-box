#!/bin/sh

docker-compose exec workload /opt/spire/bin/spire-agent healthcheck

docker-compose exec workload /opt/spire/bin/spire-agent api fetch x509 -output json | jq
