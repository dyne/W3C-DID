#!/bin/bash

# example: ./generate_did_doc_request.sh "zenflows admin test" zenflows.A admin admin/keyring.json

if [[ $# != 4 ]]; then
    echo "Number of argmunt is wrong"
    echo "Corret use: "
    echo "./generate_did_doc_request.sh idenitty method-specific-id signer-method-specific-id path/to/signer/keyring"
elif [[ ! -f $4 ]]; then
    echo "path to signer keyring not valid"
fi

identity=`echo $1 | sed -e 's/ /\_/g'`
echo "{ \"identity\": \"$identity\" }" > /tmp/identity.json
zenroom -k client/v1/did-settings.json \
        -a /tmp/identity.json \
        -z client/v1/generic/create-identity-pubkeys.zen 2>/dev/null >/tmp/id.json
if [[ $? != 0 ]]; then exit 1; fi

keyring=`jq --arg key $identity '.[$key]' /tmp/id.json`
jq --arg key $identity 'del(.[$key])' /tmp/id.json > /tmp/id-pubkeys.json

echo "Your keyring is:"
echo $keyring | jq .
echo ""

tmp=$(mktemp)
jq --arg value $2 '.specific_id = $value' /tmp/id-pubkeys.json > $tmp
jq --arg value $3 '.signer_specific_id = $value' $tmp > /tmp/id-pubkeys.json
jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' /tmp/id-pubkeys.json > $tmp && mv $tmp /tmp/id-pubkeys.json
zenroom -k $4 \
        -a /tmp/id-pubkeys.json \
        -z client/v1/generic/pubkeys-request.zen 2>/dev/null > /tmp/request.json
if [[ $? != 0 ]]; then exit 1; fi


echo "Sending the request to did.dyne.org: "
./restroom-test -s https -h did.dyne.org -p 443 -u v1/sandbox/pubkeys-accept.chain -a /tmp/request.json | jq .