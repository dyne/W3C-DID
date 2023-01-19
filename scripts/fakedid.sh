#!/bin/bash

# script to create a fakedid to populate local did/dyne/sandbox

# runtime checks
command -v zenroom > /dev/null || {
	>&2 echo "Zenroom executable missing"; exit 1
}
[ "$1" == "" ] && { >&2 echo "$0 number_of_fakedid"; exit 1;}
[ $1 -le 0 ] && { >&2 echo "Invalid number, it has to be positive: $1"; exit 1;}

# create a service admin
make service-keyring

# sandbox admin request
rm -f secrets/sandbox-admin-keyring.json
make keyring CONTROLLER=${USER} OUT=secrets/sandbox-admin-keyring.json
make request KEYRING=secrets/sandbox-admin-keyring.json DOMAIN=sandbox_A
make sign KEYRING=secrets/service-keyring.json
make accept-admin REQUEST=signed_did_doc.json

# sandbox ctx admin request
rm -f secrets/sandbox-keyring.json
make keyring CONTROLLER=${USER} OUT=secrets/sandbox-keyring.json
make request KEYRING=secrets/sandbox-keyring.json DOMAIN=sandbox.test_A
make sign KEYRING=secrets/sandbox-admin-keyring.json SIGNER_DOMAIN=sandbox_A
make accept-admin REQUEST=signed_did_doc.json

# sanbox ctx requests
create_request() {
	newdid=`mktemp`
	newreq=`mktemp`
	newsig=`mktemp`
	err=`mktemp`
	rm -f ${newdid}
	make keyring CONTROLLER=${1} OUT=${newdid} 1>/dev/null 2>${err}
	[ "$?" != "0" ] && cat ${err}
	make request KEYRING=${newdid} DOMAIN=sandbox.test OUT=${newreq} 1>/dev/null 2>${err}
	[ "$?" != "0" ] && cat ${err}
	make sign KEYRING=secrets/sandbox-keyring.json REQUEST=${newreq} SIGNER_DOMAIN=sandbox.test_A OUT=${newsig} 1>/dev/null 2>${err}
	[ "$?" != "0" ] && cat ${err}
	make accept-admin REQUEST=${newsig} 2>${err}
	[ "$?" != "0" ] && cat ${err}
	rm -f ${newdid} ${newreq} ${newsig} ${err}
}

export -f create_request

parallel create_request ::: $(seq 1 $1)