#!/bin/bash
RR_PORT=3000
domain="sandbox"
ctx="test"
[ "$1" != "" ] && domain=$1
[ "$2" != "" ] && ctx=$2

# Test creation
./test/restroom/create.sh ${domain} ${ctx}
[ "$?" = "1" ] && { exit 1; }

# Test update
./test/restroom/update.sh ${domain} ${ctx}
[ "$?" = "1" ] && { exit 1; }

# Test delete
./test/restroom/delete.sh ${domain} ${ctx}
[ "$?" = "1" ] && { exit 1; }

# switch with the test endpoints
## planetmint
mv api/v1/common/pubkeys-broadcast-3-planetmint.keys .
cp test/restroom/planetmint_endpoint.json api/v1/common/pubkeys-broadcast-3-planetmint.keys

## evm
if [[ "$domain" == "sandbox" ]]; then
    blockchain="ganache"
    keys_path="api/v1/sandbox/pubkeys-broadcast-3-ganache.keys"
else
    blockchain="polygon"
    keys_path="api/v1/${domain}/pubkeys-broadcast-3-polygon.keys"
fi
echo $keys_path
mv ${keys_path} evm.keys
cp test/restroom/ganache_endpoint.json ${keys_path}

# Test planetmint broadcast
./test/restroom/broadcast.sh ${domain} ${ctx} "planetmint"
[ "$?" = "1" ] && {
    mv pubkeys-broadcast-3-planetmint.keys api/v1/common/
    mv evm.keys ${keys_path}
    exit 1
}
mv pubkeys-broadcast-3-planetmint.keys api/v1/common/

# Test polygon broadcast
./test/restroom/broadcast.sh ${domain} ${ctx} ${blockchain}
[ "$?" = "1" ] && {
    mv evm.keys ${keys_path}
    exit 1
}
mv evm.keys ${keys_path}

exit 0
