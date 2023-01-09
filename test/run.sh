#!/bin/bash
RR_PORT=3000
zenroom_res="^==== Zenroom result ===="

# add sandbox admin did doc for test purpose
mkdir -p data/sanbox/A/
cat << EOF > data/sanbox/A/8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ
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

echo "SANDBOX CLIENT SIDE"
echo "- generating controller keyring"
tmpctrlkey=`mktemp`
tmpctrlkey_err=`mktemp`
./zenroom -z -a client/v1/did-settings.json \
    client/v1/sandbox/sandbox-keygen.zen \
    > ${tmpctrlkey} 2>${tmpctrlkey_err}
[ "$?" != "0" ] && {
    echo "Generating controller keyring failed with error: "
    cat ${tmpctrlkey_err}
    exit 1
}
rm -f ${tmpctrlkey_err}

echo "- generating pubkeys and identity"
tmppk=`mktemp`
tmppk_err=`mktemp`
    ./zenroom -z client/v1/sandbox/create-identity-pubkeys.zen \
    > ${tmppk} 2>${tmppk_err}
[ "$?" != "0" ] && {
    echo "Generating pubkeys and identity failed with error: "
    cat ${tmppk_err}
    exit 1
}
rm -f ${tmppk_err}

echo "- generating request"
tmpreq=`mktemp`
tmpreq_err=`mktemp`
tmp=`mktemp` && jq --arg value $(($(date +%s%N)/1000000)) '.timestamp = $value' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
./zenroom -z -a ${tmppk} -k ${tmpctrlkey} \
    client/v1/sandbox/pubkeys-request.zen \
    > ${tmpreq} 2>${tmpreq_err}
[ "$?" != "0" ] && {
    echo "Generating request failed with error: "
    cat ${tmpreq_err}
    exit 1
}
rm -f ${tmpreq_err}


echo "- generating update request"
tmpupd=`mktemp`
tmpupd_err=`mktemp`
tmp=`mktemp` && jq --arg value $(($(date +%s%N)/1000000)) '.timestamp |= $value' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
new_ecdh=`./zenroom -z client/v1/sandbox/create-identity-pubkeys.zen 2>/dev/null | jq -r '.ecdh_public_key'`
tmp=`mktemp` && jq --arg key $new_ecdh '.ecdh_public_key |= $key' ${tmppk} > ${tmp} && mv ${tmp} ${tmppk}
./zenroom -z -a ${tmppk} -k ${tmpctrlkey} \
    client/v1/sandbox/pubkeys-request.zen \
    > ${tmpupd} 2>${tmpupd_err}
[ "$?" != "0" ] && {
    echo "Generating update request failed with error: "
    cat ${tmpupd_err}
    exit 1
}
rm -f ${tmpupd_err}

echo "- generating deactivation request"
tmpdct=`mktemp`
tmpdct_err=`mktemp`
./zenroom -z -a ${tmppk} -k ${tmpctrlkey} \
    client/v1/sandbox/pubkeys-deactivate.zen \
    > ${tmpdct} 2>${tmpdct_err}
[ "$?" != "0" ] && {
    echo "Generating deactivation request failed with error: "
    cat ${tmpdct_err}
    exit 1
}
rm -f ${tmpdct_err}

rm -f ${tmppk} ${tmpctrlkey}

echo "SERVER SIDE"
echo "- accept request"
tmpres=`mktemp`
./restroom-test -p ${RR_PORT} -u v1/sandbox/pubkeys-accept.chain -a ${tmpreq} > ${tmpres} 2>/dev/null
[ ! -z "$(grep "$zenroom_res" "$tmpres")" ] && {
    echo "Accepting request failed with error:" >&2
    cat ${tmpres} >&2
    exit 1
}
rm -f ${tmpres}

echo "- does not accpet the same request twice"
tmpres_fail=`mktemp`
./restroom-test -p ${RR_PORT} -u v1/sandbox/pubkeys-accept.chain -a ${tmpreq} > ${tmpres_fail} 2>/dev/null
[ -z "$(grep "$zenroom_res" "$tmpres_fail")" ] && {
    echo "Accepting request succeeded, but it should not. Response:" >&2
    cat ${tmpres_fail} >&2
    exit 1
}
rm -f ${tmpres_fail} ${tmpreq}

echo "- accept update request"
tmpupd_res=`mktemp`
./restroom-test -p ${RR_PORT} -u v1/sandbox/pubkeys-update.chain -a ${tmpupd} > ${tmpupd_res} 2>/dev/null
[ ! -z "$(grep "$zenroom_res" "$tmpupd_res")" ] && {
    echo "Accepting update request failed with error:" >&2
    cat ${tmpupd_res} >&2
    exit 1
}
rm -f ${tmpupd_res} ${tmpupd}

echo "- accept deactivate request"
tmpdct_res=`mktemp`
./restroom-test -p ${RR_PORT} -u v1/sandbox/pubkeys-deactivate.chain -a ${tmpdct} > ${tmpdct_res} 2>/dev/null
[ ! -z "$(grep "$zenroom_res" "$tmpdct_res")" ] && {
    echo "Accepting deactivate request failed with error:" >&2
    cat ${tmpdct_res} >&2
    exit 1
}
rm -f ${tmpdct_res} ${tmpdct}