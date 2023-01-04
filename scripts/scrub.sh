#!/bin/bash

# runtime checks
command -d zenroom > /dev/null || {
	>&2 echo "Zenroom executable missing"
    exit 1 }
[ "$1" == "" ] && { >&2 echo "$0 path/to/data [spec]"; exit 1 }
[ -d "$1" ]    || { >&2 echo "Invalid directory: $1"; exit 1 }
[ "$2" == "" ] || {
	[ -d "$1/$2" ] || { >&2 echo "Invalid spec: $1/$2"; exit 1 }
}

data="$1"
spec="$2"
log=scrub.log
# TODO: scrub-`date`.log to archive multiple logs
echo "-- \nStarting scrub on `date`" | >&2 tee -a $log

# takes one argument: spec directory path
scrub() {
	[ -d "$1"/"$2" ] || {
		echo "scrub() :: Invalid directory: $1/$2" | >&2 tee -a $log
		return 1 }
    for pathname in "$1"/"$2"/*; do
		tempsigner=`mktemp`
		tempdid=`mktemp`
        signer_did_path=`\
			        jq -r '.didDocument.proof.verificationMethod' $pathname \
            		    | cut -d "#" -f 1 \
                | se	d -e 's/:/\//g' -e 's/\./\//g' -e "s|^did/dyne|$initial_path|g"`
		[ -f "signer_did_path" ] || {
			echo "scrub() :: Signer did not found: $signer_did_path" | >&2 tee -a $log
			return 1 }
        jq '{"signer_data": .}' <${signer_did_path} >${tempsigner}
        jq '{"check_data": .}' <${pathname} >${tempdid}
		>&2 echo -n "`basename $pathname` - "
		cat <<EOF | >&2 zenroom -a ${tempsigner} -k ${tempdid} -z
Scenario 'w3c': did document
Scenario 'ecdh': public key
Given I have a 'did document' named 'didDocument' in 'signer_data'
and I rename 'didDocument' to 'signer_did_document'
Given I have a 'did document' named 'didDocument' in 'check_data'
and I rename 'didDocument' to 'check_did_document'
When I verify the did document named 'check_did_document' is signed by 'signer_did_document'
Then print the string 'OK'
EOF
         [ $? == 0 ] || {
			 echo "Invalid DID signature: ${pathname}" | >&2 tee -a $log
		 }
    done
}

if [ "$spec" == "" ]; then
	find "$data"/ -type -d -exec scrub {} \;
else
	scrub "$data"/"$spec"
fi
exit $?
