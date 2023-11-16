#!/bin/env bash

key_path="universal-registrar/test/keyring.json"
rm $key_path

# generate new keys
make -C ../.. keyring CONTROLLER="uniregistrar user test" OUT=$key_path

# generate request
make -C ../.. request DOMAIN=sandbox.uniregistrar OUT=universal-registrar/test/did_doc.json KEYRING=$key_path

# extract only did_document and call it didDocument
cat did_doc.json | jq '.request.did_document' > didDoc.json

curl -X 'POST' -o output.json \
  'http://localhost:3000/create' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "options": {
    "clientSecretMode": true
  },
  "secret": { },
  "didDocument": '"$(cat didDoc.json)"'
}'

zenroom -z -a output.json -k keyring.json sign.zen | tee res.json

curl -X 'POST' \
  'http://localhost:3000/create' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d $(cat res.json)

rm -f did_doc.json didDoc.json output.json res.json
