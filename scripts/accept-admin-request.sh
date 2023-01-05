#!/bin/sh

didpath=`jq -r '.didDocument.id' ${1}`
did=`echo ${didpath} | cut -d: -f4`
spec=`echo ${didpath} | cut -d: -f3`
[ "$spec" = "admin" ] && {
	>&2 echo "WARNING: Adding a self-signed global admin"
	[ -r data/admin/$did ] && {
		>&2 echo "Cannot overwrite: admin/${did}"
		exit 1
	}
	mv -v ${1} data/admin/${did}
	exit 0
}

[ -r data/${spec}/A/${did} ] && {
		>&2 echo "Cannot overwrite: spec/A/${did}"
		exit 1
}

# TODO: check global admin signature
mv -v ${1} data/${spec}/A/${did}
