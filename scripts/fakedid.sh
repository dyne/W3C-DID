#!/bin/bash

# script to create a fakedid to populate local did/dyne/sandbox

# runtime checks
command -v zenroom > /dev/null || {
	>&2 echo "Zenroom executable missing"; exit 1
}
[ "$1" == "" ] && { >&2 echo "$0 number_of_fakedid"; exit 1;}
[ $1 -le 0 ] && { >&2 echo "Invalid number, it has to be positive: $1"; exit 1;}

# generate a new admin
make service-keyring
mkdir -p data/dyne/sandbox/A/

error() {
	[ "$?" != "0" ] && { >&2 echo "Error found in contract: $1"; cat $2; exit 1; }
}

# accept request
accept() {
	tmpaccept1=`mktemp`
	tmperr1=`mktemp`
	tmpaccept2=`mktemp`
	tmperr2=`mktemp`
	zenroom -z -k api/v1/sandbox/pubkeys-accept-1-path.keys \
			-a "$1" \
			api/v1/sandbox/pubkeys-create-paths.zen >${tmpaccept1} 2>${tmperr1}
	error "pubkeys-create-paths.zen" ${tmperr1}
	cat ${tmpaccept1} | jq --arg value $(($(date +%s%N)/1000000)) '.accept_timestamp = $value' > ${tmpaccept1}
	path="$(jq -r '.signer_path' ${tmpaccept1})"
	tmp=`mktemp` && jq -s '.[0] * .[1]' $tmpaccept1 $path > ${tmp} && mv ${tmp} ${tmpaccept1}
	tmp=`mktemp` && jq '.request_data = {}' ${tmpaccept1} > ${tmp} && mv ${tmp} ${tmpaccept1}
	zenroom -z -k api/v1/sandbox/pubkeys-store.keys \
			-a ${tmpaccept1} \
			api/v1/sandbox/pubkeys-accept-2-checks.zen >${tmpaccept2} 2>${tmperr2}
	error "pubkeys-accept-2-checks.zen" ${tmperr2}
	path="$(jq -r '.request_path' ${tmpaccept2})"
	cat ${tmpaccept2} | jq '.result' > $path
	echo $path
	rm -f ${tmpaccept1} ${tmperr1} ${tmpaccept2} ${tmperr2}
}

# sandbox admin request
make keyring
make request DOMAIN=sandbox.A
make sign REQUEST=did_doc.json

# sandbox admin accept
accept signed_did_doc.json

# sanbox requests
tmpnewpk=`mktemp`
tmpreq=`mktemp`
tmperr=`mktemp`
tmpset=`mktemp`
jq -s '.[0] * .[1]' keyring.json client/v1/did-settings.json > ${tmpset}
for i in $(seq $1); do
	zenroom -z client/v1/sandbox/create-identity-pubkeys.zen > ${tmpnewpk} 2>${tmperr}
	error "create-identity-pubkeys.zen" ${tmperr}
	rm -f ${tmperr}
	cat ${tmpnewpk} | jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' > ${tmpnewpk}
	zenroom -z -a ${tmpnewpk} -k ${tmpset} client/v1/sandbox/pubkeys-request.zen > ${tmpreq} 2>${tmperr}
	error "pubkeys-request.zen" ${tmperr}
	accept ${tmpreq}
	rm -f ${tmpnewpk} ${tmperr} ${tmpreq}
done
rm -f ${tmpset}
