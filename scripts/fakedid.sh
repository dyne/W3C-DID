#!/bin/bash

# script to create a fakedid to populate local did/dyne/sandbox

# runtime checks
command -v zenroom > /dev/null || {
	>&2 echo "Zenroom executable missing"
    exit 1
}
[ "$1" == "" ] && { >&2 echo "$0 number_of_fakedid"; exit 1;}
[ $1 -le 0 ] && { >&2 echo "Invalid number, it has to be positive: $1"; exit 1;}
[ "$(ls -A data/admin)" ] && [ ! -f keyring.json ] && { >&2 echo "Admin is present, but not its keyring"; exit 1;}

# if admin is not present generate an admin
if [ ! "$(ls -A data/admin)" ]; then
	make service-keyring
fi

# accept request
accept() {
	tmpaccept1=`mktemp`
	tmpaccept2=`mktemp`
	tmp=`mktemp`
	zenroom -z -k api/v1/sandbox/pubkeys-accept-1-path.keys \
			-a "$1" \
			api/v1/sandbox/pubkeys-create-paths.zen > ${tmpaccept1}
	cat ${tmpaccept1} | jq --arg value $(($(date +%s%N)/1000000)) '.accept_timestamp = $value' > ${tmpaccept1}
	path="$(jq -r '.signer_path' ${tmpaccept1})"
	jq -s '.[0] * .[1]' $tmpaccept1 $path > ${tmp} && mv ${tmp} ${tmpaccept1}
	zenroom -z -k api/v1/sandbox/pubkeys-store.keys \
			-a ${tmpaccept1} \
			api/v1/sandbox/pubkeys-accept-2-checks.zen > ${tmpaccept2}
	path="$(jq -r '.request_path' ${tmpaccept2})"
	cat ${tmpaccept2} | jq '.result' > $path
	rm -f ${tmpaccept1} ${tmpaccept2}
}

# sandbox admin request
tmpctrlid=`mktemp`
tmpctrlkey=`mktemp`
tmpctrlpk=`mktemp`
tmpctrlreq=`mktemp`

echo "{ \"controller\": \"sandbox_admin\" }" > ${tmpctrlid}
zenroom -z -a ${tmpctrlid} \
		client/v1/generic/create-keyring.zen > ${tmpctrlkey}
zenroom -z -k client/v1/did-settings.json \
		-a ${tmpctrlkey} \
		client/v1/generic/create-identity-pubkeys.zen > ${tmpctrlpk}

tmp=`mktemp`
jq '.specific_id = "sandbox.A"' ${tmpctrlpk} > ${tmp} && mv ${tmp} ${tmpctrlpk}
tmp=`mktemp`
jq '.signer_specific_id = "admin"' ${tmpctrlpk} > ${tmp} && mv ${tmp} ${tmpctrlpk}
cat ${tmpctrlpk} | jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' > ${tmpctrlpk}

zenroom -z -k keyring.json -a ${tmpctrlpk} \
        client/v1/generic/pubkeys-request.zen > ${tmpctrlreq}

rm -f ${tmpctrlpk} ${tmpctrlid}

# sandbox admin accept
accept ${tmpctrlreq}
rm -f ${tmpctrlreq}

# sanbox requests
tmpnewpk=`mktemp`
tmpreq=`mktemp`
tmp=`mktemp`
jq -s '.[0] * .[1]' $tmpctrlkey client/v1/did-settings.json > ${tmp} && mv ${tmp} ${tmpctrlkey}
for i in $(seq $1); do
	zenroom -z client/v1/sandbox/create-identity-pubkeys.zen \
			> ${tmpnewpk} 2>/dev/null
	cat ${tmpnewpk} | jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' > ${tmpnewpk}
	zenroom -z -a ${tmpnewpk} -k ${tmpctrlkey} \
			client/v1/sandbox/pubkeys-request.zen > ${tmpreq}
	accept ${tmpreq}
done
rm -f ${tmpctrlkey} ${tmpnewpk} ${tmpreq}
