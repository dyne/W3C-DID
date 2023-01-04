#!/bin/bash

# runtime checks
command -v zenroom > /dev/null || {
	>&2 echo "Zenroom executable missing"
    exit 1
}
[ "$1" == "" ] && { >&2 echo "$0 path/to/data [spec]"; exit 1;}
[ -d "$1" ]    || { >&2 echo "Invalid directory: $1"; exit 1;}
[ "$2" == "" ] || {
	[ -d "$1/$2" ] || { >&2 echo "Invalid spec: $1/$2"; exit 1;}
}

data="$1"
spec="$2"
log=scrub.log
zlog=zenroom.log
# TODO: scrub-`date`.log to archive multiple logs
echo -e "-- \nStarting scrub on `date`" | >&2 tee -a $log

# takes one argument: spec directory path
scrub() {
	[ -d "$1" ] || {
		echo "scrub() :: Invalid directory: $1" | >&2 tee -a $log
		return 1
	}
	spec=`basename "$1"`
	# skip global admin
	[ "$spec" == "admin" ] && return 1
    for pathname in "$1"/* ; do
		# one level specs only
		[ -d "$pathname" ] && continue
		parent=`dirname $1`
		did=`basename $pathname`
		# >&2 echo "pathname: $pathname"
		# >&2 echo "parent: $parent"
		tempsigner=`mktemp`
		tempdid=`mktemp`
        signer_did_path=`\
		  jq -r '.didDocument.proof.verificationMethod' $pathname \
          | cut -d "#" -f 1 \
          | sed -e 's/:/\//g' -e 's/\./\//g' -e "s|^did/dyne|$parent|g"`
		signer_did=`basename $signer_did_path`
		# >&2 echo "signer did path: $signer_did_path"
		[ -f "$signer_did_path" ] || {
			echo "scrub(`basename $1`) :: Did: $did" | >&2 tee -a $log
			echo "scrub(`basename $1`) :: Signer not found: $signer_did" | >&2 tee -a $log
			return 1;}
        jq '{"signer_data": .}' <${signer_did_path} >${tempsigner}
        jq '{"check_data": .}' <${pathname} >${tempdid}
		echo -n "check :: $did" | >&2 tee -a $log
		zlog=`mktemp`
		cat <<EOF | zenroom -a ${tempsigner} -k ${tempdid} -z 1>/dev/null 2>$zlog
Scenario 'w3c': did document
Scenario 'ecdh': public key
Given I have a 'did document' named 'didDocument' in 'signer_data'
and I rename 'didDocument' to 'signer_did_document'
Given I have a 'did document' named 'didDocument' in 'check_data'
and I rename 'didDocument' to 'check_did_document'
When I verify the did document named 'check_did_document' is signed by 'signer_did_document'
Then print the string 'OK'
EOF
        if [ $? == 0 ]; then
			echo " :: OK sign by :: $signer_did" | >&2 tee -a $log
		else
			echo
			echo "Invalid DID signature: ${did} A: $signer_did" | >&2 tee -a $log
			tail $zlog
		fi
		rm -f ${tempsigner} ${tempdid} ${zres} ${zlog}
    done
}

if [ "$spec" == "" ]; then
	for dir in "$data"/*; do
		[ -d "$dir" ] || continue
		scrub $dir
	done
else
	scrub "$data"/"$spec"
fi
exit $?
