#!/bin/bash
RR_PORT=3000
domain="sandbox"
ctx="test"
[ "$1" != "" ] && domain=$1
[ "$2" != "" ] && ctx=$2

path="sandbox"
[ "$domain" != "sandbox" ] && path="common"

# Test creation
./test/restroom/create.sh ${domain} ${ctx}
[ "$?" = "1" ] && { exit 1; }

# Test update
./test/restroom/update.sh ${domain} ${ctx}
[ "$?" = "1" ] && { exit 1; }

# Test delete
./test/restroom/delete.sh ${domain} ${ctx}
[ "$?" = "1" ] && { exit 1; }

# set a keyring for tests


# Test planetmint broadcast
## switch with the test endpoints
mv api/v1/${path}/pubkeys-broadcast-3-planetmint.keys .
cp test/restroom/planetmint_endpoint.json api/v1/${path}/pubkeys-broadcast-3-planetmint.keys
./test/restroom/broadcast.sh ${domain} ${ctx} "planetmint"
[ "$?" = "1" ] && {
    mv pubkeys-broadcast-3-planetmint.keys api/v1/${path}/
    exit 1
}
mv pubkeys-broadcast-3-planetmint.keys api/v1/${path}/

# Test polygon broadcast
## switch with the test endpoints
mv api/v1/${path}/pubkeys-broadcast-3-polygon.keys .
cp test/restroom/mumbai_endpoint.json api/v1/${path}/pubkeys-broadcast-3-polygon.keys
./test/restroom/broadcast.sh ${domain} ${ctx} "polygon"
[ "$?" = "1" ] && {
    mv pubkeys-broadcast-3-polygon.keys api/v1/${path}/
    exit 1
}
mv pubkeys-broadcast-3-polygon.keys api/v1/${path}/

exit 0
