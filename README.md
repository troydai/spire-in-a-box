Demonstrate a simple spire setup in a local docker-compose environment.

# Brief
- This example bootstraps a spire server and agent in a local docker-compose environment.
- The spire agent joins the server by x509pop node attestation.
- The key target in the Makefile generates self-signed certificates and private keys for both x509 pop node attestation and server upstream authority.

# Usage
- Run `make up` to start the docker-compose. It will execute the key target to generate new keys and certificates.
- Run `scripts/create-entries.sh` to register workload entries
- Run `scripts/agent-test.sh` to fetch X.509 and JWT SVID.