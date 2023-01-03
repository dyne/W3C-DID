#!/bin/bash

# example ./integrity_check.sh "../data"

if [[ $# != 1 ]]; then
    echo "Number of argmunt is wrong"
    echo "Corret use: "
    echo "./integrity_check.sh path/to/data"
    exit 1
elif [[ ! -d $1 ]]; then
    echo "$1 is not a directory"
    exit 1
fi

if [[ ! -f ./zenroom ]]; then
    echo "Zenroom is missing"
    exit 1
fi

check () {
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            check "$pathname"
        else
            signer_did_path=`\
                jq -r '.didDocument.proof.verificationMethod' $pathname \
                | cut -d "#" -f 1 \
                | sed -e 's/:/\//g' -e 's/\./\//g' -e "s|^did/dyne|$initial_path|g"`
            jq '{"signer_data": .}' <$signer_did_path >/tmp/signer.json
            jq '{"check_data": .}' <$pathname >/tmp/check.json
            ./zenroom -a /tmp/signer.json -k /tmp/check.json -z integrity_check.zen 2>/dev/null 1>/dev/null
            if [[ $? != 0 ]]; then echo -e "\e[0;31mDid document not valid: ${pathname}\e[0m"; fi
        fi
    done
}
initial_path=$1
check $1