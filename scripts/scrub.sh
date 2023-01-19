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
export log=scrub.log
zlog=zenroom.log
# TODO: scrub-`date`.log to archive multiple logs
echo -e "-- \nStarting scrub on `date`" | >&2 tee -a $log

# takes one argument: spec directory path
scrub() {
	# one level specs only
	[ -d "$1" ] && return 0
	did=`basename $1`
	[ "$did" = "null" ] && return 0
	dir=`dirname $1`;
	spec=`basename $dir`
	parent=`dirname $dir`
	tempsigner=`mktemp`
	tempdid=`mktemp`
    signer_did_path=`\
		  jq -r '.didDocument.proof.verificationMethod' $1 \
          | cut -d "#" -f 1 \
          | sed -e 's/:/\//g' -e 's/\_/\//g' -e "s|^did/dyne|$parent|g"`
	signer_did=`basename $signer_did_path`
	# >&2 echo "signer did path: $signer_did_path"
	[ -f "$signer_did_path" ] || {
		slog="scrub($spec) :: Did: $did\n"
		slog+="scrub($spec) :: Signer not found: $signer_did"
		echo -e $slog | >&2 tee -a $log
		return 1;}
    jq '{"signer_data": .}' <${signer_did_path} >${tempsigner}
    jq '{"check_data": .}' <${1} >${tempdid}
	slog="check :: $did"
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
		slog+=" :: OK sign by :: $signer_did"
		echo -e $slog | >&2 tee -a $log
	else
		slog+="\nInvalid DID signature: ${did} A: $signer_did"
		echo -e $slog | >&2 tee -a $log
		tail $zlog
	fi
	rm -f ${tempsigner} ${tempdid} ${zres} ${zlog}
}

export -f scrub

if [ "$spec" == "" ]; then
	for dir in "$data"/*; do
		[ -d "$dir" ] || {
			echo "scrub() :: Invalid directory: $dir" | >&2 tee -a $log
			continue
		}
		spec=`basename "$dir"`
		# skip global admin
		[ "$spec" == "admin" ] && continue
		parallel scrub {} ::: "$dir"/*
		# for i in "$dir"/*; do
		# 	scrub "$i"
		# done
	done
else
	[ -d "$data/$spec" ] || {
		echo "scrub() :: Invalid directory: $data/$spec" | >&2 tee -a $log
		exit 1
	}
	parallel scrub {} ::: "$data/$spec"/*
fi
exit $?
