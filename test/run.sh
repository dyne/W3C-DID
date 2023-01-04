#!/bin/bash

echo "CLIENT SIDE"
echo "- generating controller keyring"
./zenroom -z client/v1/sandbox/sandbox-keygen.zen \
		-a client/v1/did-settings.json \
		> /tmp/controller-keyring.json 2>/tmp/controller-keyring-err.json
if [[ $? != 0 ]]; then
  echo "Generating controller keyring failed with error: "
  cat /tmp/controller-keyring-err.json
  exit 1
else
  rm /tmp/controller-keyring-err.json
fi

echo "- generating pubkeys and identity"
./zenroom -z client/v1/sandbox/create-identity-pubkeys.zen \
		> /tmp/new-id-pubkeys.json 2>/tmp/new-id-pubkeys-err.json
if [[ $? != 0 ]]; then
  echo "Generating pubkeys and identity failed with error: "
  cat /tmp/new-id-pubkeys-err.json
  exit 1
else
  rm /tmp/new-id-pubkeys-err.json
fi

echo "- generating request"
jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' /tmp/new-id-pubkeys.json \
        > /tmp/new-id-pubkeys-tmp.json && mv /tmp/new-id-pubkeys-tmp.json /tmp/new-id-pubkeys.json
./zenroom -z client/v1/sandbox/pubkeys-request.zen \
		-a /tmp/new-id-pubkeys.json -k /tmp/controller-keyring.json \
		> /tmp/pubkeys-request.json 2>/tmp/pubkeys-request-err.json
if [[ $? != 0 ]]; then
  echo "Generating request failed with error: "
  cat /tmp/pubkeys-request-err.json
  exit 1
else
  rm /tmp/pubkeys-request-err.json
fi

echo "SERVER SIDE"
echo "- accept request"
curl -s -w "%{stderr}%{http_code}\n" -o /tmp/pubkeys-accept.json -X 'POST' \
  'http://localhost:3000/api/v1/sandbox/pubkeys-accept.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{
  \"data\": $(cat /tmp/pubkeys-request.json),
  \"keys\": {}
}" 2>/tmp/status.json
if [[ `cat /tmp/status.json` != "200" ]]; then
  echo "Accepting requests failed with error: `cat /tmp/status.json`"
  echo "and error:"
  cat /tmp/pubkeys-accept.json
  echo ""
  exit 1
else
  rm /tmp/pubkeys-accept.json /tmp/status.json
fi
