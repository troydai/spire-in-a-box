#!/bin/sh

set -e

WORKDIR=`dirname $0`
DATADIR=".data"
ROOTKEY="$DATADIR/root.key"
ROOTCRT="$DATADIR/root.crt"

cd $WORKDIR

echo "Generating keys and certificates"
echo "Working directory `PWD`"

mkdir -p .data

# Root CA private key
echo "Creating $ROOTKEY ..."
openssl ecparam -out $ROOTKEY -name secp521r1 -genkey -noout

# Root CA self-signed certificate
echo "Creating $ROOTCRT ..."
openssl req -x509 -sha256 -new -nodes -key $ROOTKEY -days 3650 -out $ROOTCRT \
	-subj '/CN=spire-in-a-box.troydai.cc/C=US/ST=WA/L=Redmond/O=TDFUND'

# Root CA for agent
openssl ecparam -out $DATADIR/agents.key -name secp521r1 -genkey -noout
openssl req -x509 -sha256 -new -nodes -key $DATADIR/agents.key -days 3650 -out $DATADIR/agents.crt \
	-subj '/CN=agents.ca'

echo "Create cert and key for agent node attestation ..."
for i in `seq 3`; do
	AGENT_PATH="$DATADIR/agent$i"
	AGENT_KEY=$AGENT_PATH/agent.key
	AGENT_CSR=$AGENT_PATH/agent.csr
	AGENT_CRT=$AGENT_PATH/agent.crt
	AGENT_SRL=$AGENT_PATH/agent.srl

	mkdir -p $AGENT_PATH

	openssl ecparam -out $AGENT_KEY -name secp521r1 -genkey -noout
	openssl req -new -sha256 -key $AGENT_KEY \
		-subj '/CN=agent1.spire-in-a-box.troydai.cc/C=US/ST=WA/L=Redmond/O=TDFUND' \
		-out $AGENT_CSR
	openssl x509 -req  -days 500 -sha256 \
		-in $AGENT_CSR -extfile agent.ext \
		-CA $DATADIR/agents.crt -CAkey $DATADIR/agents.key -CAcreateserial \
		-out $AGENT_CRT -CAserial $AGENT_SRL
done
