#!/bin/sh

TRUST_DOMAIN=spire-in-a-box.troydai.cc

TOKEN=`docker-compose exec spire-server /opt/spire/bin/spire-server token generate \
    -spiffeID spiffe://$TRUST_DOMAIN/host -output json | jq -r .value`

docker-compose exec -d workload /opt/spire/bin/spire-agent run -joinToken $TOKEN 

docker-compose exec spire-server /opt/spire/bin/spire-server entry create \
    -parentID spiffe://$TRUST_DOMAIN/host \
    -spiffeID spiffe://$TRUST_DOMAIN/workload \
    -selector unix:uid:1000

docker-compose exec spire-server /opt/spire/bin/spire-server entry create \
    -parentID spiffe://$TRUST_DOMAIN/host \
    -spiffeID spiffe://$TRUST_DOMAIN/workload-shadow \
    -selector unix:uid:1000