#!/bin/bash

path_to_data='../data'

check () {
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            check "$pathname"
        else
            signer_did_path=`\
                jq -r '.didDocument.proof.verificationMethod' $pathname \
                | cut -d "#" -f 1 \
                | sed -e 's/:/\//g' -e 's/\./\//g' -e "s|^did/dyne|$path_to_data|g"`
            jq '{"signer_data": .}' <$signer_did_path >/tmp/signer.json
            jq '{"check_data": .}' <$pathname >/tmp/check.json
            zenroom -a /tmp/signer.json -k /tmp/check.json -z integrity_check.zen 2>/dev/null 1>/dev/null
            if [[ $? != 0 ]]; then echo -e "\e[0;31mDid document not valid: ${pathname}\e[0m"; fi
        fi
    done
}

check $path_to_data