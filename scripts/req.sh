#!/bin/bash

# example: ./req.sh ifacer.A
command -v zenroom > /dev/null || {
	>&2 echo "Zenroom executable missing"; exit 1
}

keyring=secrets/keyring.json
[ "$1" = "" ] && { >&2 echo "$0 spec"; exit 1;}
[ "$2" = "" ] || keyring="$2"

contracts="client/v1/$3"

# different specs can have different did-settings
case $1 in
    ifacer*)
        did_settings=client/v1/ifacer/did-settings.json
    ;;
    sandbox.genericissuer*)
        did_settings=client/v1/issuer/did-settings.json
    ;;
    *)
        did_settings=client/v1/did-settings.json
    ;;
esac

# generate pks
tmppk=`mktemp`
zenroom -z -k "$keyring" \
        ${contracts}create-identity-pubkeys.zen > ${tmppk}

# set did_spec and extras if present
tmp=`mktemp` &&
	jq --arg value $1 '.did_spec = $value' ${tmppk} > ${tmp} &&
	mv ${tmp} ${tmppk}

# create did doc
zenroom -z -a ${tmppk} -k ${did_settings} \
		${contracts}pubkeys-request-unsigned.zen

rm -f ${tmppk}
