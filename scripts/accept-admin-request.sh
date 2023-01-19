#!/bin/sh

didpath=`jq -r '.did_document.id' ${1}`
[ "$didpath" = "null" ] && didpath=`jq -r '.didDocument.id' ${1}`
[ "$didpath" = "null" ] && {
	>&2 echo "Cannot parse DID path in: ${1}"
	exit 1
}

did=`echo ${didpath} | cut -d: -f4`
adminspec=`echo ${didpath} | cut -d: -f3`
[ "$adminspec" = "admin" ] && {
	>&2 echo "WARNING: Adding a self-signed global admin"
	# TODO: ask for confirmation to proceed (yes/no)
	[ -r data/dyne/admin/$did ] && {
		>&2 echo "Cannot overwrite: admin/${did}"
		exit 1
	}
	mv -v ${1} data/dyne/admin/${did}
	exit 0
}
# >&2 echo "Admin specific domain: ${adminspec}"
adminlvl=`echo ${adminspec} | cut -d_ -f2`
domain=`echo ${adminspec} | cut -d_ -f1`
spec=`echo ${domain} | cut -d. -f1`

# check signature and create proof and metadata
tmp_out1=`mktemp`
zenroom -z -k api/v1/${spec}/pubkeys-accept-1-path.keys -a ${1} \
		api/v1/${spec}/pubkeys-create-paths.zen > ${tmp_out1}
[ "$?" != 0 ] && exit 1
signerpath=`jq -r '.signer_path' ${tmp_out1}`
cat ${tmp_out1} | jq --arg value $(($(date +%s%N)/1000000)) '.accept_timestamp = $value' > ${tmp_out1}
tmp=`mktemp` && jq '.request_data = {}' ${tmp_out1} > ${tmp} && mv ${tmp} ${tmp_out1}
tmp=`mktemp` && jq -s '.[0] * .[1]' $tmp_out1 $signerpath > ${tmp} && mv ${tmp} ${tmp_out1}
zenroom -z -k api/v1/${spec}/pubkeys-store.keys -a ${tmp_out1} \
		api/v1/${spec}/pubkeys-accept-2-checks.zen | jq -r '.result' > ${1}
[ "$?" != 0 ] && exit 1

if [ "$adminlvl" = "A" ]; then
	[ -r data/dyne/${domain}/A/${did} ] && {
		>&2 echo "Cannot overwrite: ${domain}/A/${did}"
		exit 1
	}
	mkdir -p data/dyne/${domain}/A/
	mv -v ${1} data/dyne/${domain}/A/${did}
	exit 0
else
	[ -r data/dyne/${domain}/${did} ] && {
		>&2 echo "Cannot overwrite: ${domain}/${did}"
		exit 1
	}
	mkdir -p data/dyne/${domain}
	mv -v ${1} data/dyne/${domain}/${did}
	exit 0
fi


>&2 echo "Unsupported spec: ${adminspec}"
exit 1
