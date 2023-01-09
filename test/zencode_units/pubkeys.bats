load ../bats_setup
load ../bats_zencode

@test "Create the controller keyring" {
	mkdir -p data/sandbox/A/
	cat << EOF > $R/data/sandbox/A/8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ
{
   "@context":"https://w3id.org/did-resolution/v1",
   "didDocument":{
      "@context":[
         "https://www.w3.org/ns/did/v1",
         "https://w3id.org/security/suites/ed25519-2018/v1",
         "https://w3id.org/security/suites/secp256k1-2019/v1",
         "https://w3id.org/security/suites/secp256k1-2020/v1",
         "https://dyne.github.io/W3C-DID/specs/ReflowBLS12381.json",
         {
            "description":"https://schema.org/description"
         }
      ],
      "description":"fake sandbox-admin",
      "id":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ",
      "proof": {
         "created": "1671805668826",
         "jws": "eyJhbGciOiJFUzI1NksiLCJiNjQiOnRydWUsImNyaXQiOiJiNjQifQ..0RywWwpi-26gwNhPC4lBcTce80WMDDygtlYu8EzyXa-PZRrG64Bt46z-wp_QXhF-FIbtgf_zfIVHDBeR7sPGGw",
         "proofPurpose": "assertionMethod",
         "type": "EcdsaSecp256k1Signature2019",
         "verificationMethod": "did:dyne:admin:DMMYfDo7VpvKRHoJmiXvEpXrfbW3sCfhUBE4tBeXmNrJ#ecdh_public_key"
       },
      "verificationMethod":[
         {
            "controller":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ",
            "id":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ#ecdh_public_key",
            "publicKeyBase58":"S1bs1YRaGcfeUjAQh3jigvAXuV8bff2AHjERoHaBPKtBLnXLKDcGPrnB4j5bY8ZHVu9fQGkUW5XzDa9bdhGYbjPf",
            "type":"EcdsaSecp256k1VerificationKey2019"
         },
         {
            "controller":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ",
            "id":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ#reflow_public_key",
            "publicKeyBase58":"9kPV92zSUok2Do2RJKx3Zn7ZY9WScvBZoorMQ8FRcoH7m1eo3mAuGJcrSpaw1YrSKeqAhJnpcFdQjLhTBEve3qvwGe7qZsam3kLo85CpTM84TaEnxVyaTZVYxuY4ytmGX2Yz1scayfSdJYASvn9z12VnmC8xM3D1cXMHNDN5zMkLZ29hgq631ssT55UQif6Pj371HUC5g6u2xYQ2mGYiQ6bQt1NWSMJDzzKTr9y7bEMPKq5bDfYEBab6a4fzk6Aqixr1P3",
            "type":"ReflowBLS12381VerificationKey"
         },
         {
            "controller":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ",
            "id":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ#bitcoin_public_key",
            "publicKeyBase58":"rjXTCrGHFMtQhfnPMZz5rak6DDAtavVTrv2AEMXvZSBj",
            "type":"EcdsaSecp256k1VerificationKey2019"
         },
         {
            "controller":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ",
            "id":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ#eddsa_public_key",
            "publicKeyBase58":"8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ",
            "type":"Ed25519VerificationKey2018"
         },
         {
            "blockchainAccountId":"eip155:1:0xd3765bb6f5917d1a91adebadcfad6c248e721294",
            "controller":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ",
            "id":"did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ#ethereum_address",
            "type":"EcdsaSecp256k1RecoveryMethod2020"
         }
      ]
   },
   "didDocumentMetadata":{
      "created":"1671805668826",
      "deactivated": "false"
   }
}
EOF
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
		json_join_two $request_path pubkeys-accept-api-checks.json
	else
		jq_insert "request_data" "{}" pubkeys-accept-api-checks.json
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