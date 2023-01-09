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
adminlvl=`echo ${adminspec} | cut -d. -f2`
spec=`echo ${adminspec} | cut -d. -f1`

[ "$spec" = "sandbox" ] || {
	# TODO: check global admin signature
	>&2 echo "Specific domain: $spec"
}

if [ "$adminlvl" = "A" ]; then
	[ -r data/dyne/${spec}/A/${did} ] && {
		>&2 echo "Cannot overwrite: $spec/A/${did}"
		exit 1
	}
	mkdir -p data/dyne/${spec}/A/
	mv -v ${1} data/dyne/${spec}/A/${did}
	exit 0
else
	[ -r data/dyne/${spec}/${did} ] && {
		>&2 echo "Cannot overwrite: $spec/${did}"
		exit 1
	}
	mkdir -p data/dyne/${spec}
	mv -v ${1} data/dyne/${spec}/${did}
	exit 0
fi


>&2 echo "Unsupported spec: ${spec}"
exit 1
