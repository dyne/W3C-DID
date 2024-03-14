#!/bin/env bash

# path to keyring
key_path="universal-registrar/test/keyring.json"

# Used when testing on uniregistrar.io, may break testing of dockerimage
method="?method=dyne"

# Set endpoint to uni-registrar
# user "http://localhost:3000/1.0/" to test in localhost
endpoint="https://uniregistrar.io/1.0/"


call_api() {
    curl -X 'POST' -o output.json \
	 "${endpoint}${1}${method}" \
	 -H 'accept: application/json' \
	 -H 'Content-Type: application/json' \
	 -d '{
		"options": {
			"clientSecretMode": true
		},
		"secret": { },
		"'"${2}"'": '"$(cat didDoc.json)"'
	    }'

    zenroom -z -a output.json -k keyring.json sign.zen > res.json

    curl -X 'POST' \
	 "${endpoint}${1}${method}" \
	 -H 'accept: application/json' \
	 -H 'Content-Type: application/json' \
	 -d '{
		"options": {
			"clientSecretMode": true
		},
		"jobId": '"$(cat res.json | jq '.jobId')"',
		"secret": '"$(cat res.json | jq '.secret')"'
	    }'

    rm -f output.json res.json
}

# generate new keys
rm keyring.json
make -C ../.. keyring CONTROLLER="uniregistrar user test" OUT=$key_path

# generate request
make -C ../.. request DOMAIN=sandbox.uniregistrar OUT=universal-registrar/test/did_doc.json KEYRING=$key_path

# create did document
cat did_doc.json | jq '.request.did_document' > didDoc.json
rm did_doc.json
call_api "create" "didDocument"

# update description
mv didDoc.json oldDidDoc.json
jq '.description = "modified_uniregistrar_user_test"' oldDidDoc.json > didDoc.json
rm oldDidDoc.json
call_api "update" "didDocument"

# deactivate did
mv didDoc.json oldDidDoc.json
jq '.id' oldDidDoc.json > didDoc.json
rm oldDidDoc.json
call_api "deactivate" "did"

rm didDoc.json

