#!/bin/sh

# this script starts a spire agent on the workload container with a join token

TRUST_DOMAIN=spire-in-a-box.troydai.cc

# execute token generate command on the spire server container
# TOKEN=`docker-compose exec spire-server /opt/spire/bin/spire-server token generate \
#     -spiffeID spiffe://$TRUST_DOMAIN/host -output json | jq -r .value`

# start the spire agent on the workload container with the generated token
docker-compose exec -d workload /opt/spire/bin/spire-agent run # -joinToken $TOKEN 

# create an entry for the workload container
docker-compose exec spire-server /opt/spire/bin/spire-server entry create \
    -parentID spiffe://$TRUST_DOMAIN/host \
    -spiffeID spiffe://$TRUST_DOMAIN/workload \
    -selector unix:uid:1000

# create a second entry for the workload container
docker-compose exec spire-server /opt/spire/bin/spire-server entry create \
    -parentID spiffe://$TRUST_DOMAIN/host \
    -spiffeID spiffe://$TRUST_DOMAIN/workload-shadow \
    -selector unix:uid:1000
