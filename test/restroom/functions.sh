#!/bin/bash
RR_PORT=3000

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

# create_admin keyring_file output
create_admin() {
    out=service-admin-did.json
    [ "$2" != "" ] && out=$2 
    tmpctrl=`mktemp`
    tmperr=`mktemp`
    echo "{\"controller\": \"test_admin\"}" > ${tmpctrl}
    zenroom -z -k ${tmpctrl} client/v1/create-keyring.zen >secrets/$1 2>${tmperr}
    check_error ${?} ${tmperr}
    rm -f ${tmpctrl}
    zenroom -z -k secrets/$1 -a client/v1/did-settings.json client/v1/create-identity-pubkeys.zen >${tmpctrl} 2>${tmperr}
    check_error ${?} ${tmperr}
    cat ${tmpctrl} | jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' > ${tmpctrl}
    zenroom -z -a ${tmpctrl} -k secrets/$1 client/v1/admin/didgen.zen >${out} 2>${tmperr}
    check_error ${?} ${tmperr}
    rm -f ${tmpctrl}
    # store admin did
    didpath=`jq -r '.didDocument.id' ${out}`
    did=`echo ${didpath} | cut -d: -f4`
    cp -v ${out} ./data/dyne/admin/${did}
}

# create_request keyring domain signer_keyring signer_domain did_doc
create_request() {
    tmperr=`mktemp`
    out=""
    request=""
    [ "$6" != "" ] && { out="OUT=$6"; request="REQUEST=$6"; }
    make keyring CONTROLLER=${USER} OUT=secrets/${1} 1>/dev/null 2>${tmperr}
    check_error ${?} ${tmperr}
    make request KEYRING=secrets/${1} DOMAIN=${2} ${out} 1>/dev/null 2>${tmperr}
    check_error ${?} ${tmperr}
    make sign KEYRING=secrets/${3} SIGNER_DOMAIN=${4} OUT=${5} ${request} 1>/dev/null 2>${tmperr}
    check_error ${?} ${tmperr}
}

# update_request new_description old_did_doc signer_keyring signer_domain new_did_doc
update_request() {
    tmperr=`mktemp`
    tmp=`mktemp` && jq --arg value ${1} --arg value2 ${4} '.did_document.description |= $value | .signer_did_spec |= $value2 ' ${2} > ${tmp} && mv ${tmp} ${2}
    make sign KEYRING=secrets/${3} SIGNER_DOMAIN=${4} OUT=${5} REQUEST=${2} 1>/dev/null 2>${tmperr}
    check_error ${?} ${tmperr}
}

# deactivate_request keyring domain signer_keyring signer_domain request
delete_request() {
    tmperr=`mktemp`
    tmppk=`mktemp`
    zenroom -z -a client/v1/did-settings.json -k secrets/${1} client/v1/create-identity-pubkeys.zen > ${tmppk} 2>${tmperr}
    check_error ${?} ${tmperr}
    tmp=`mktemp` && jq --arg value $2 '.did_spec = $value' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
    tmp=`mktemp` && jq --arg value $4 '.signer_did_spec = $value' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
    zenroom -z -a ${tmppk} -k secrets/${3} client/v1/pubkeys-deactivate.zen > ${5} 2>${tmperr}
    check_error ${?} ${tmperr}
}

# test contract data expected_exitcode
send_request() {
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