#!/usr/bin/env bash

if [[ ! -f contracts/keyring.json ]]; then
    echo "Keyring not found, one is being produced..."
    # download Zenroom
    wget -q https://sdk.dyne.org/view/zenroom/job/zenroom-static-amd64/lastSuccessfulBuild/artifact/src/zenroom -O zenroom
    chmod +x zenroom
    # create the keyring
    cat<<EOF > create_key.zen
Scenario ecdh
Scenario eddsa
Scenario ethereum

Given I am 'Issuer'
When I create the ecdh key
When I create the eddsa key
When I create the ethereum key    
Then print my 'keyring'
EOF
    ./zenroom -z create_key.zen 2>/dev/null > contracts/keyring.json
    echo "Keyring created"
    rm -f zenroom create_key.zen
fi

# start the controller
cd restroom
echo "Creating Controller DID document"
pm2 start yarn --name did --time -- start 1>/dev/null
# wait for the server to be up
sleep 3

# create the Controller DID-document, save it on redis
# and produce a fabchain transacrtion with the mpack
# of the document and a timestamp
curl -X 'POST' \
  'http://localhost:12001/api/W3C-DID-Controller-create-DID-document.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {},
  "keys": {}
}'

# stop it
pm2 stop did 1>/dev/null
pm2 delete did 1>/dev/null
