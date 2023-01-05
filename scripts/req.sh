#!/bin/bash

# example: ./req.sh ifacer.A "{\"ifacer_id\":{}}"
command -v zenroom > /dev/null || {
	>&2 echo "Zenroom executable missing"; exit 1
}
[ "$1" == "" ] && { >&2 echo "$0 spec [extras]"; exit 1;}
#[ "$2" != "" ] && [ -f $2 ] || { >&2 echo "extra argument is not a path"; exit 1;}

# different specs can have different did-settings
case $1 in
    ifacer*)
        did_settings=client/v1/ifacer/did-settings.json
        contracts=client/v1/ifacer
    ;;
    *)
        did_settings=client/v1/did-settings.json
        contracts=clinet/v1/generic
    ;;
esac

# generate pks
tmppk=`mktemp`
zenroom -z -k keyring.json -a ${did_settings} \
        client/v1/generic/create-identity-pubkeys.zen > ${tmppk}

# set did_spec and extras if present
tmp=`mktemp` && jq --arg value $1 '.did_spec = $value' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
if [ "$2" != "" ]; then
    tmpextras=`mktemp`
    tmp=`mktemp`
    echo $2 > ${tmpextras}
    jq -s '.[0] * .[1]' ${tmppk} ${tmpextras} > ${tmp} && mv ${tmp} ${tmppk}
    rm -f ${tmpextras}
fi
cat ${tmppk} | jq .

# create did doc
zenroom -z -a ${tmppk} \
		${contracts}/pubkeys-request.zen > did_doc.json