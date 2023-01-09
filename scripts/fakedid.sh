#!/bin/bash

# script to create a fakedid to populate local did/dyne/sandbox

# runtime checks
command -v zenroom > /dev/null || {
	>&2 echo "Zenroom executable missing"; exit 1
}
[ "$1" == "" ] && { >&2 echo "$0 number_of_fakedid"; exit 1;}
[ $1 -le 0 ] && { >&2 echo "Invalid number, it has to be positive: $1"; exit 1;}

# sandbox admin request
make keyring CONTROLLER=${USER} OUT=secrets/sandbox-keyring.json
make request KEYRING=secrets/sandbox-keyring.json DOMAIN=sandbox.A
make sign KEYRING=secrets/service-keyring.json
make accept-admin

# sanbox DID requests
newdid=`mktemp`
newreq=`mktemp`
newsig=`mktemp`
for i in $(seq $1); do
	rm -f ${newdid} ${newreq} ${newsig}
	make keyring CONTROLLER=${1} OUT=${newdid}
	make request KEYRING=${newdid} DOMAIN=sandbox OUT=${newreq}
	make sign KEYRING=${newdid} REQUEST=${newreq} OUT=${newsig}
	make accept-admin REQUEST=${newsig}
done
