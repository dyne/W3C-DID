#!/usr/bin/env bash

# importing restroom
npx -y create-restroom@next --all restroom

# set .env file
echo "CUSTOM_404_MESSAGE=nothing to see here
HTTP_PORT=12001
HTTPS_PORT=443
ZENCODE_DIR=$(pwd)/contracts
FILES_DIR=$(pwd)
CHAIN_EXT=chain
OPENAPI=true
YML_EXT=yml 
HOST=did.dyne.org
RESOLVER_HOST=localhost
RESOLVER_HTTP=12002" > .env

sed -i 's/"name": "restroom",/"name": "W3C-DID",/' restroom/package.json
sed -i 's/"start": "ZENCODE_DIR=contracts node restroom.mjs"/"start": "node restroom.mjs"/' restroom/package.json
