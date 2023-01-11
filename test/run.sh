#!/bin/bash
RR_PORT=3000
domain=sandbox

# check error functin
check_error() {
    [ "$1" != "0" ] && {
        echo "Something went wrong:" >&2
        cat ${2} >&2
        rm -f ${2}
        exit 1
    }
    rm -f ${2}
}
tmperr=`mktemp`

echo "ADMIN creation"
# can not use make service-keyring, umask fails in github action
# create admin did
tmpctrl=`mktemp`
echo "{\"controller\": \"test_admin\"}" > ${tmpctrl}
zenroom -z -k ${tmpctrl} client/v1/create-keyring.zen >secrets/service-keyring.json 2>${tmperr}
check_error ${?} ${tmperr}
rm -f ${tmpctrl}
zenroom -z -k secrets/service-keyring.json -a client/v1/did-settings.json client/v1/create-identity-pubkeys.zen >${tmpctrl} 2>${tmperr}
check_error ${?} ${tmperr}
cat ${tmpctrl} | jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' > ${tmpctrl}
zenroom -z -a ${tmpctrl} -k secrets/service-keyring.json client/v1/admin/didgen.zen >service-admin-did.json 2>${tmperr}
check_error ${?} ${tmperr}
rm -f ${tmpctrl}
# store admin did
didpath=`jq -r '.didDocument.id' service-admin-did.json`
did=`echo ${didpath} | cut -d: -f4`
mv service-admin-did.json data/dyne/admin/${did}

echo "${domain} SPEC ADMIN creation"
make keyring CONTROLLER=${USER} OUT=secrets/${domain}-keyring.json 1>/dev/null 2>${tmperr}
check_error ${?} ${tmperr}
make request KEYRING=secrets/${domain}-keyring.json DOMAIN=${domain}.A 1>/dev/null 2>${tmperr}
check_error ${?} ${tmperr}
make sign KEYRING=secrets/service-keyring.json OUT=${domain}_signed_did_doc.json 1>/dev/null 2>${tmperr}
check_error ${?} ${tmperr}
make accept-admin REQUEST=${domain}_signed_did_doc.json 1>/dev/null 2>${tmperr}
check_error ${?} ${tmperr}

rm -f secrets/service-keyring.json did_doc.json

echo "CLIENT creation"
echo "- generating keyring"
make keyring CONTROLLER=${domain}_test OUT=secrets/${domain}-client-keyring.json 1>/dev/null 2>${tmperr}
check_error ${?} ${tmperr}

echo "- generating pubkeys and identity"
tmppk=`mktemp`
zenroom -z -k secrets/${domain}-client-keyring.json -a client/v1/did-settings.json client/v1/create-identity-pubkeys.zen > ${tmppk} 2>${tmperr}
check_error ${?} ${tmperr}

echo "- generating request"
tmpreq=`mktemp`
signer="${domain}.A"
tmp=`mktemp` && jq --arg value $domain '.did_spec = $value' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
tmp=`mktemp` && jq --arg value $signer '.signer_did_spec = $value' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
cat ${tmppk} | jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' > ${tmppk}
zenroom -z -a ${tmppk} -k secrets/${domain}-keyring.json client/v1/pubkeys-request-signed.zen > ${tmpreq} 2>${tmperr}
check_error ${?} ${tmperr}

newecdh() {
    tmpkey=`mktemp`
    tmpid=`mktemp` && echo "{\"controller\": \"test\"}" > ${tmpid}
    zenroom -z -a ${tmpid} client/v1/create-keyring.zen >${tmpkey} 2>/dev/null
    zenroom -z -k ${tmpkey} -a client/v1/did-settings.json client/v1/create-identity-pubkeys.zen 2>/dev/null | jq -r '.ecdh_public_key'
    rm -f ${tmpkey}
}

echo "- generating update request"
tmpupd=`mktemp`
cat ${tmppk} | jq --arg value $(($(date +%s%N)/1000000)) '.timestamp |= $value' > ${tmppk}
new_ecdh=`newecdh`
tmp=`mktemp` && jq --arg key $new_ecdh '.ecdh_public_key |= $key' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
zenroom -z -a ${tmppk} -k secrets/${domain}-keyring.json client/v1/pubkeys-request-signed.zen > ${tmpupd} 2>${tmperr}
check_error ${?} ${tmperr}

echo "- generating deactivation request"
tmpdct=`mktemp`
zenroom -z -a ${tmppk} -k secrets/${domain}-keyring.json client/v1/pubkeys-deactivate.zen > ${tmpdct} 2>${tmperr}
check_error ${?} ${tmperr}

rm -f ${tmppk} secrets/${domain}-keyring.json secrets/${domain}-client-keyring.json

# test contract data expected_exitcode
test() {
    tmpres=`mktemp`
    tmperr=`mktemp`
    ./restroom-test -p ${RR_PORT} -u v1/$1 -a $2 > ${tmpres} 2>${tmperr}
    res_status=$?
    #cat ${tmpres}
    [ "${res_status}" != "$3" ] && {
        echo "Request failed with code ${res_status} and error:" >&2
        cat ${tmperr} >&2
        [ "`cat ${tmpres}`" != "" ] && {
            echo "and restroom response:" >&2
            cat ${tmpres} >&2
        }
        exit 1
    }
    rm -f ${tmpres} ${tmperr}
}

echo "SERVER SIDE"
echo "- accept request"
test ${domain}/pubkeys-accept.chain ${tmpreq} 0

echo "- does not accpet the same request twice"
test ${domain}/pubkeys-accept.chain ${tmpreq} 255
rm -f ${tmpreq}

echo "- accept update request"
test ${domain}/pubkeys-update.chain ${tmpupd} 0
rm -f ${tmpupd}

echo "- accept deactivate request"
test ${domain}/pubkeys-deactivate.chain ${tmpdct} 0
rm -f ${tmpdct}