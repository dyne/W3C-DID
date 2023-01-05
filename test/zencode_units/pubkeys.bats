load ../bats_setup
load ../bats_zencode

@test "Create the controller keyring" {
	zexe client/v1/sandbox/sandbox-keygen.zen client/v1/did-settings.json
	save_tmp_output controller-keyring.json
}

@test "Create a new identity with pubkeys" {
	zexe client/v1/sandbox/create-identity-pubkeys.zen
	save_tmp_output new-id-pubkeys.json
}

@test "Use controller to create a new identity request" {
	jq_insert "timestamp" $(($(date +%s%N)/1000000)) new-id-pubkeys.json
	zexe client/v1/sandbox/pubkeys-request.zen new-id-pubkeys.json controller-keyring.json
	save_tmp_output pubkeys-request.json
}

@test "Api pubkeys: accept (chain)" {
	zexe api/v1/sandbox/pubkeys-create-paths.zen api/v1/sandbox/pubkeys-accept-1-path.keys pubkeys-request.json
	save_tmp_output pubkeys-accept-api-checks.json
}

@test "Api pubkeys: execute (chain)" {
	# add timestamp, signer_data and request_data to data
	jq_insert "accept_timestamp" $(($(date +%s%N)/1000000)) pubkeys-accept-api-checks.json
	signer_path=`jq_extract_raw "signer_path" pubkeys-accept-api-checks.json`
	request_path=`jq_extract_raw "request_path" pubkeys-accept-api-checks.json`
	json_join_two $signer_path pubkeys-accept-api-checks.json
	if [ -f $request_path ]; then
		json_join_two  $request_path pubkeys-accept-api-checks.json
	else
		cat pubkeys-accept-api-checks.json | jq '.request_data={}' > pubkeys-accept-api-checks.json
	fi
	# execute
	zexe api/v1/sandbox/pubkeys-accept-2-checks.zen api/v1/sandbox/pubkeys-store.keys pubkeys-accept-api-checks.json
	save_tmp_output pubkeys-accept-api-execute.json
	# save result
	request_path=`jq_extract_raw "request_path" pubkeys-accept-api-execute.json`
	jq '.result' pubkeys-accept-api-execute.json > $R/$request_path
}

@test "Use controller to create a update request" {
	# timestamp
	jq_insert "timestamp" $(($(date +%s%N)/1000000)) new-id-pubkeys.json
	# modify a user key, e.g. ecdh public key
	new_ecdh=`$ZENROOM_EXECUTABLE -z $R/client/v1/sandbox/create-identity-pubkeys.zen | jq -r '.ecdh_public_key'`
	jq --arg ecdh_public_key $new_ecdh '.ecdh_public_key |= $ecdh_public_key' $BATS_FILE_TMPDIR/new-id-pubkeys.json > $BATS_FILE_TMPDIR/update-id-pubkeys.json
	#execute
	zexe client/v1/sandbox/pubkeys-request.zen update-id-pubkeys.json controller-keyring.json
	save_tmp_output pubkeys-update-request.json
}

@test "Api pubkeys: accept-update (chain)" {
	zexe api/v1/sandbox/pubkeys-create-paths.zen api/v1/sandbox/pubkeys-update-1-path.keys pubkeys-update-request.json
	save_tmp_output pubkeys-update-api-checks.json
}

@test "Api pubkeys: execute-update (chain)" {
	# add timestamp, signer_data and request_data to data
	jq_insert "update_timestamp" $(($(date +%s%N)/1000000)) pubkeys-update-api-checks.json
	signer_path=`jq_extract_raw "signer_path" pubkeys-update-api-checks.json`
	jq_insert_json "signer_data" $signer_path pubkeys-update-api-checks.json
	request_path=`jq_extract_raw "request_path" pubkeys-update-api-checks.json`
	jq_insert_json "request_data" $request_path pubkeys-update-api-checks.json
	# execute
	zexe api/v1/sandbox/pubkeys-update-2-checks.zen api/v1/sandbox/pubkeys-store.keys pubkeys-update-api-checks.json
	save_tmp_output pubkeys-update-api-execute.json
	# save updated result
	jq '.result' $BATS_FILE_TMPDIR/pubkeys-update-api-execute.json > $R/$request_path
}

@test "Use controller to deactivate a did" {
	zexe client/v1/sandbox/pubkeys-deactivate.zen new-id-pubkeys.json controller-keyring.json
	save_tmp_output pubkeys-deactivate-request.json
}

@test "Api pubkeys: accept-deactivate (chain)" {
	zexe api/v1/sandbox/pubkeys-deactivate-1-path.zen api/v1/sandbox/pubkeys-deactivate-1-path.keys pubkeys-deactivate-request.json
	save_tmp_output pubkeys-deactivate-api-checks.json
}

@test "Api pubkeys: execute-deactivate (chain)" {
	# add signer_data and request_data to data
	signer_path=`jq_extract_raw "signer_path" pubkeys-deactivate-api-checks.json`
	jq_insert_json "signer_data" $signer_path pubkeys-deactivate-api-checks.json
	request_path=`jq_extract_raw "request_path" pubkeys-deactivate-api-checks.json`
	jq_insert_json "request_data" $request_path pubkeys-deactivate-api-checks.json
	# execute
	zexe api/v1/sandbox/pubkeys-deactivate-2-checks.zen pubkeys-deactivate-api-checks.json
	save_tmp_output pubkeys-deactivate-api-execute.json
	# save deactivated result
	jq '.request_data' $BATS_FILE_TMPDIR/pubkeys-deactivate-api-execute.json > $R/$request_path
}

@test "Api pubkeys: update a deactivated did document" {
	## controller create the request to update a did document that has been deactivated
	jq_insert "timestamp" $(($(date +%s%N)/1000000)) new-id-pubkeys.json
	# modify ecdh public key
	new_ecdh=`$ZENROOM_EXECUTABLE -z $R/client/v1/sandbox/create-identity-pubkeys.zen | jq -r '.ecdh_public_key'`
	jq --arg ecdh_public_key $new_ecdh '.ecdh_public_key |= $ecdh_public_key' $BATS_FILE_TMPDIR/new-id-pubkeys.json > $BATS_FILE_TMPDIR/update-id-pubkeys.json
	#execute
	zexe client/v1/sandbox/pubkeys-request.zen update-id-pubkeys.json controller-keyring.json
	save_tmp_output pubkeys-update-request.json

	## check ACL and create path
	zexe api/v1/sandbox/pubkeys-create-paths.zen api/v1/sandbox/pubkeys-update-1-path.keys pubkeys-update-request.json
	save_tmp_output pubkeys-update-api-checks.json

	## update
	jq_insert "update_timestamp" $(($(date +%s%N)/1000000)) pubkeys-update-api-checks.json
	signer_path=`jq_extract_raw "signer_path" pubkeys-update-api-checks.json`
	jq_insert_json "signer_data" $signer_path pubkeys-update-api-checks.json
	request_path=`jq_extract_raw "request_path" pubkeys-update-api-checks.json`
	jq_insert_json "request_data" $request_path pubkeys-update-api-checks.json
	# execute
	run $ZENROOM_EXECUTABLE -a $BATS_FILE_TMPDIR/pubkeys-update-api-checks.json \
							-k $R/api/v1/sandbox/pubkeys-store.keys \
							-z $R/api/v1/sandbox/pubkeys-update-2-checks.zen
	assert_failure
}