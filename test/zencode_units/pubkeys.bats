load ../bats_setup

@test "Create the controller keyring" {
	zenroom -z $R/client/v1/sandbox/sandbox-keygen.zen -a $R/client/v1/did-settings.json \
			> controller-keyring.json
}

@test "Create a new identity with pubkeys" {
	zenroom -z $R/client/v1/sandbox/create-identity-pubkeys.zen > new-id-pubkeys.json
	# >&3 jq < new-id-pubkeys.json
}

@test "Use controller to create a new identity request" {
	zenroom -z $R/client/v1/sandbox/pubkeys-request.zen \
			-a new-id-pubkeys.json -k controller-keyring.json \
			> pubkeys-request.json
	# >&3 jq < pubkeys-request.json
}

@test "Api pubkeys: accept (chain)" {
	zenroom -z $R/api/v1/sandbox/pubkeys-create-paths.zen \
			-k $R/api/v1/sandbox/pubkeys-accept-1-path.keys \
			-a pubkeys-request.json > pubkeys-accept-api-checks.json
	# >&3 jq < pubkeys-accept-api-checks.json
}

@test "Api pubkeys: execute (chain)" {
	tmp=$(mktemp)
	signer_path=`jq -r '.signer_path' pubkeys-accept-api-checks.json`
	jq -s '.[0] * .[1]' pubkeys-accept-api-checks.json $R/$signer_path > $tmp
	jq --arg timestamp $(($(date +%s%N)/1000000)) '.timestamp = $timestamp' $tmp > pubkeys-accept-api-checks.json
	rm $tmp
	zenroom -z $R/api/v1/sandbox/pubkeys-accept-2-checks.zen \
			-k $R/api/v1/sandbox/pubkeys-accept-2-checks.keys \
			-a pubkeys-accept-api-checks.json > pubkeys-accept-api-execute.json
	>&3 jq < pubkeys-accept-api-execute.json
}
