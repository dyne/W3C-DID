#!/bin/bash
RR_PORT=3000
domain=sandbox
ctx=test
[ "$1" != "" ] && domain=$1
[ "$2" != "" ] && ctx=$2

# Test creation
./test/restroom/create.sh ${domain} ${ctx}

# Test update
./test/restroom/update.sh ${domain} ${ctx}

# Test delete
./test/restroom/delete.sh ${domain} ${ctx}