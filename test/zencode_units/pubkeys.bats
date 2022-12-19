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

# TODO: pass path and signer document from shell
#@test "Api pubkeys: execute (chain)" {
#	zenroom -z $R/api/v1/sandbox/pubkeys-accept-2-checks.zen \
#			-k $R/api/v1/sandbox/pubkeys-accept-1-path.keys \
#			-a pubkeys-request.json > pubkeys-accept-api-checks.json
}
