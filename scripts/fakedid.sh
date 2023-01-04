#!/bin/bash

# script to create a fakedid to populate local did/dyne/sandbox

tmpctrl=`mktemp`
tmpnewpk=`mktemp`
tmpreq=`mktemp`

zenroom -z client/v1/sandbox/sandbox-keygen.zen \
		-a client/v1/did-settings.json \
		> ${tmpctrl}
zenroom -z client/v1/sandbox/create-identity-pubkeys.zen \
		> ${tmpnewpk} 2>/dev/null
@jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' ${tmpnewpk} > ${tmpnewpk}_tmp && mv ${tmpnewpk}_tmp ${tmpnewpk}
zenroom -z client/v1/sandbox/pubkeys-request.zen \
		-a ${tmpnewpk} -k ${tmpctrl} \
		> ${tmpreq} 2>/dev/null
#zenroom -z api/v1/sandbox/pubkeys-accept.chain -a ${tmpreq} | jq .

rm -f ${tmpctrl} ${tmpnewpk} ${tmpreq}
