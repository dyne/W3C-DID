load ../bats_setup

@test "Create the controller keyring" {
	zenroom -z $R/client/sandbox-keygen.zen -a $R/client/did-settings.json \
			> controller-keyring.json
}

@test "Create a new identity with pubkeys" {
	zenroom -z $R/client/create-identity-pubkeys.zen > new-id-pubkeys.json
	>&3 jq < new-id-pubkeys.json
}

@test "Use controller to create a new identity request" {
	zenroom -z $R/client/pubkeys-request.zen \
			-a new-id-pubkeys.json -k controller-keyring.json \
			> pubkeys-request.json
	>&3 jq < pubkeys-request.json

}
