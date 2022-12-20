load ../bats_setup

@test "Create the controller keyring" {
	zenroom -z $R/client/v1/sandbox/sandbox-keygen.zen -a $R/client/v1/did-settings.json \
			> controller-keyring.json
}

@test "Create a new identity with pubkeys" {
	zenroom -z $R/client/v1/sandbox/create-identity-pubkeys.zen > new-id-pubkeys.json
}

@test "Use controller to create a new identity request" {
	tmp=$(mktemp)
	jq --arg timestamp $(($(date +%s%N)/1000000)) '.timestamp = $timestamp' new-id-pubkeys.json > $tmp && mv $tmp new-id-pubkeys.json
	zenroom -z $R/client/v1/sandbox/pubkeys-request.zen \
			-a new-id-pubkeys.json -k controller-keyring.json \
			> pubkeys-request.json
}

@test "Api pubkeys: accept (chain)" {
	zenroom -z $R/api/v1/sandbox/pubkeys-create-paths.zen \
			-k $R/api/v1/sandbox/pubkeys-accept-1-path.keys \
			-a pubkeys-request.json > pubkeys-accept-api-checks.json
}

@test "Api pubkeys: execute (chain)" {
	# add timestamp and signer_data to data
	tmp=$(mktemp)
	signer_path=`jq -r '.signer_path' pubkeys-accept-api-checks.json`
	jq -s '.[0] * .[1]' pubkeys-accept-api-checks.json $R/$signer_path > $tmp
	jq --arg timestamp $(($(date +%s%N)/1000000)) '.accept_timestamp = $timestamp' $tmp > pubkeys-accept-api-checks.json
	rm $tmp
	# execute
	zenroom -z $R/api/v1/sandbox/pubkeys-accept-2-checks.zen \
			-k $R/api/v1/sandbox/pubkeys-store.keys \
			-a pubkeys-accept-api-checks.json > pubkeys-accept-api-execute.json
	# save result
	request_path=`jq -r '.request_path' pubkeys-accept-api-execute.json`
	jq '.result' pubkeys-accept-api-execute.json > $R/$request_path
}

@test "Use controller to create a update request" {
	# timestamp
	tmp=$(mktemp)
	jq --arg timestamp $(($(date +%s%N)/1000000)) '.timestamp = $timestamp' new-id-pubkeys.json > $tmp && mv $tmp new-id-pubkeys.json
	# modify a user key, e.g. ecdh public key
	new_ecdh=`zenroom -z $R/client/v1/sandbox/create-identity-pubkeys.zen | jq -r '.ecdh_public_key'`
	jq --arg ecdh_public_key $new_ecdh '.ecdh_public_key |= $ecdh_public_key' new-id-pubkeys.json > update-id-pubkeys.json
	#execute
	zenroom -z $R/client/v1/sandbox/pubkeys-request.zen \
			-a update-id-pubkeys.json -k controller-keyring.json \
			> pubkeys-update-request.json
}

@test "Api pubkeys: accept-update (chain)" {
	zenroom -z $R/api/v1/sandbox/pubkeys-create-paths.zen \
			-k $R/api/v1/sandbox/pubkeys-update-1-path.keys \
			-a pubkeys-update-request.json > pubkeys-update-api-checks.json
}

@test "Api pubkeys: execute-update (chain)" {
	# add timestamp, signer_data and request_data to data
	tmp=$(mktemp)
	signer_path=`jq -r '.signer_path' pubkeys-update-api-checks.json`
	request_path=`jq -r '.request_path' pubkeys-update-api-checks.json`
	jq '.signer_data = input' pubkeys-update-api-checks.json $R/$signer_path > $tmp
	jq '.request_data = input' $tmp $R/$request_path > pubkeys-update-api-checks.json
	jq --arg timestamp $(($(date +%s%N)/1000000)) '.update_timestamp = $timestamp' pubkeys-update-api-checks.json > $tmp && mv $tmp pubkeys-update-api-checks.json
	# execute
	zenroom -z $R/api/v1/sandbox/pubkeys-update-2-checks.zen \
			-k $R/api/v1/sandbox/pubkeys-store.keys \
			-a pubkeys-update-api-checks.json > pubkeys-update-api-execute.json
	# save updated result
	jq '.result' pubkeys-update-api-checks.json > $R/$request_path
}