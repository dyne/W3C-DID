#!/bin/sh

didpath=`jq -r '.didDocument.id' ${1}`
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

adminlvl=`echo ${adminspec} | cut -d. -f2`
spec=`echo ${adminspec} | cut -d. -f1`

# TODO: check global admin signature

[ "$adminlvl" = "A" ] && {
	[ -r data/dyne/${spec}/A/${did} ] && {
		>&2 echo "Cannot overwrite: spec/A/${did}"
		exit 1
	}
	mv -v ${1} data/dyne/${spec}/A/${did}
	exit 0
}

>&2 echo "Unsupported spec: ${spec}"
exit 1
