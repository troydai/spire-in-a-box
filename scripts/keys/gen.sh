#!/bin/sh

set -e

WORKDIR=`dirname $0`
DATADIR=".data"
ROOTKEY="$DATADIR/root.key"
ROOTCRT="$DATADIR/root.crt"

cd $WORKDIR

echo "Generating keys and certificates"
echo "Working directory `PWD`"

echo "Creating $ROOTKEY ..."
openssl ecparam -out $ROOTKEY -name secp521r1 -genkey -noout

echo "Creating $ROOTCRT ..."
openssl req -x509 -sha256 -new -nodes -key $ROOTKEY -days 3650 -out $ROOTCRT \
	-subj '/CN=spire-in-a-box.troydai.cc/C=US/ST=WA/L=Redmond/O=TDFUND'
