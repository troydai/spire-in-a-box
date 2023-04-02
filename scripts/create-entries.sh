#!/bin/sh

TRUST_DOMAIN=spire-in-a-box.troydai.cc

docker-compose exec spire-server /opt/spire/bin/spire-server entry create \
    -node \
    -spiffeID spiffe://$TRUST_DOMAIN/nodegroup \
    -selector x509pop:subject:cn:agent1.spire-in-a-box.troydai.cc 

# create an entry for the workload container
docker-compose exec spire-server /opt/spire/bin/spire-server entry create \
    -parentID spiffe://$TRUST_DOMAIN/nodegroup \
    -spiffeID spiffe://$TRUST_DOMAIN/workload \
    -selector unix:uid:1000
