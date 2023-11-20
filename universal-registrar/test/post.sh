#!/bin/env bash

key_path="universal-registrar/test/keyring.json"
rm keyring.json

# generate new keys
make -C ../.. keyring CONTROLLER="uniregistrar user test" OUT=$key_path

# generate request
make -C ../.. request DOMAIN=sandbox.uniregistrar OUT=universal-registrar/test/did_doc.json KEYRING=$key_path

# extract only did_document and call it didDocument
cat did_doc.json | jq '.request.did_document' > didDoc.json
rm did_doc.json

call_api() {
    curl -X 'POST' -o output.json \
	 "http://localhost:3000/${1}" \
	 -H 'accept: application/json' \
	 -H 'Content-Type: application/json' \
	 -d '{
		"options": {
			"clientSecretMode": true
		},
		"secret": { },
		"didDocument": '"$(cat didDoc.json)"'
	    }'

    zenroom -z -a output.json -k keyring.json sign.zen > res.json

    curl -X 'POST' \
	 "http://localhost:3000/${1}" \
	 -H 'accept: application/json' \
	 -H 'Content-Type: application/json' \
	 -d $(cat res.json)

    rm -f output.json res.json
}

call_api "create"

sleep 3

# update description
mv didDoc.json oldDidDoc.json
jq '.description = "modified_uniregistrar_user_test"' oldDidDoc.json > didDoc.json
rm oldDidDoc.json

call_api "update"


# (?) action -> getVerificationMethod if eddsa public key is missing
