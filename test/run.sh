#!/bin/bash

echo "CLIENT SIDE"
echo "- generating controller keyring"
./zenroom -z client/v1/sandbox/sandbox-keygen.zen \
		-a client/v1/did-settings.json \
		> /tmp/controller-keyring.json 2>/dev/null
if [[ $? != 0 ]]; then exit 1; fi

echo "- generating pubkeys and identity"
./zenroom -z client/v1/sandbox/create-identity-pubkeys.zen \
		> /tmp/new-id-pubkeys.json 2>/dev/null
if [[ $? != 0 ]]; then exit 1; fi

echo "- generating request"
jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' /tmp/new-id-pubkeys.json \
        > /tmp/new-id-pubkeys-tmp.json && mv /tmp/new-id-pubkeys-tmp.json /tmp/new-id-pubkeys.json
./zenroom -z client/v1/sandbox/pubkeys-request.zen \
		-a /tmp/new-id-pubkeys.json -k /tmp/controller-keyring.json \
		> /tmp/pubkeys-request.json 2>/dev/null
if [[ $? != 0 ]]; then exit 1; fi

echo "SERVER SIDE"
echo "- accept request"
curl -X 'POST' \
  'http://localhost:3000/api/v1/sandbox/pubkeys-accept.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{
  \"data\": $(cat /tmp/pubkeys-request.json),
  \"keys\": {}
}"
if [[ $? != 0 ]]; then exit 1; fi