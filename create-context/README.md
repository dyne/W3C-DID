# API SPECIFICATION

## How to create new context APIs (for dyne developer)
In order to create a new context you should have access to:
* The sandbox context admin keyring and controller (the file generated from `make keyring CONTROLLER=<controller_name>`)
* The new context that will be created

With this information:
* Create a new folder `ZENCODE_DIR/sandbox.<new_context>` and copy all genric contracts in there.
* Add to the file `ZENCODE_DIR/sandbox.<new_context>/1_create_request.keys` the following fields:
    * **signer_did_spec** with value `sandbox.<new_context>_A`;
    * **did_spec** with value `sandbox.<new_context>`;
    * all the contents of the file generated for the new admin (*i.e.* controller and keyring);

Suppose we are generating new context APIs for the **test** context, then the file contained in `ZENCODE_DIR/sandbox.test/1_create_request.keys` will look like:
```json
{
    "controller":"sandbox_test_admin",
    "sandbox_test_admin":{
        "keyring":{
            "bitcoin":"L4NdUcEoPrmkyaJ2jCiytG7usrxn7CVxn9B7pMXXgxJGLr74NoxS",
            "ecdh":"nsb/5NYCUxFFvOOkJ14Yha+MEwhJKskVYfn6ab0IZMc=",
            "eddsa":"6VK3BaNmwawRkkKizNbvMv1oEVZhxvcUZomPRWacyfrV",
            "ethereum":"3f622cda0ce91d9d9ea1ea37547062906c3c4d4e1c95e29436ffadcc460e3d7a",
            "reflow":"V9CwKTHc84/d2RquAyGeoNOl0Fs2MDgUsWI+YFDe38I="}
        },
    "signer_did_spec":"sandbox.test_A",
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
    "did_spec":"sandbox.test"
}
```

## User APIs
The user will have three different APIs:
* `api/sandbox.<context>/create_keys_pks` that given nothing in input will return a freshly new generated keyring and the relative public keys.
It can be called through a GET request as following 
```bash
curl -X 'GET' \
    'https://sandbox.did.dyne.org/api/sandbox.<context>/create_keys_pks' \
    -H 'accept: application/json'
```
and it will return something like:
```json
{
  "bitcoin_public_key": "28Md2g5yjVajVB2boFp857CHCWJ16zRL9VufWMZZymubX",
  "ecdh_public_key": "S6r4avRR7h55bepcx6zGUinzu96kEyfgYNoq3kvC4SNx5su6DLCQM4Bsw75ZgqCTfZbQKoxGVhtR7iyMWFzSaG6e",
  "eddsa_public_key": "3XbZ2Hxm5R1o5h3ezqMBTstJy499Er1ktuEgqKnVqNSD",
  "ethereum_address": "3a2715d27c00b3540763ae52464115f5000649fc",
  "keyring": {
    "bitcoin": "L33ieoWzizfTDmtiaRur65f8DeRrNd6v2WSzJzP6s2PrBy2SW5gw",
    "ecdh": "ID62SBKUuFH7HEkKiLhFcuE0vkqN2/QBd0fo493gTEQ=",
    "eddsa": "BKC78hTTnHyqho2mNRbERLhoHfHdti5gS84YfqXeZcZy",
    "ethereum": "d18c79274a32f24af39467e3acce8455a7acfd1266ae12c78c0e157f1cdd7294",
    "reflow": "Nd1whNUa2905/NpmogY1E/OMlCLsoxQdHvLz3WoG4RU="
  },
  "reflow_public_key": "2MAL63aZtoPdK4iM5oYPEJPb17GnMYJaU7bRLJuVEdssuzpZtaPWsECxBvLcbmYdfnBZZxLL7UrkrkNHNbEZhvfGcQntZ6rHJviJMCWHfELfMfEjps9SeBPGpz9t64P1Rt6RYV5G4CXfeBXK8gToQRpoXo9MGpoagT6ovGMMhWdUNoSX63o9vfdstWzqLk8c1V4fLDW6T2e5re6pyTiD5KbfMNmuapGjso6Gp4koeA6AoyEic9m8AXeR976qTHznLtcnb1"
}
```
store the keyring in a safe place and keep a copy of the public key for the next API.
* `api/sandbox.<context>/create_sandbox_did.chain` that given in input a set of public keys and a string that defines it identities will craft a DID document and send it to did.dyne.org server to be stored and resolved later. It can be used through a POST request as following
```bash
curl -X 'POST' \
  'https://sandbox.did.dyne.org/api/sandbox.<context>/create_sandbox_test_did.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {
  "bitcoin_public_key": "28Md2g5yjVajVB2boFp857CHCWJ16zRL9VufWMZZymubX",
  "ecdh_public_key": "S6r4avRR7h55bepcx6zGUinzu96kEyfgYNoq3kvC4SNx5su6DLCQM4Bsw75ZgqCTfZbQKoxGVhtR7iyMWFzSaG6e",
  "eddsa_public_key": "3XbZ2Hxm5R1o5h3ezqMBTstJy499Er1ktuEgqKnVqNSD",
  "ethereum_address": "3a2715d27c00b3540763ae52464115f5000649fc",
  "reflow_public_key": "2MAL63aZtoPdK4iM5oYPEJPb17GnMYJaU7bRLJuVEdssuzpZtaPWsECxBvLcbmYdfnBZZxLL7UrkrkNHNbEZhvfGcQntZ6rHJviJMCWHfELfMfEjps9SeBPGpz9t64P1Rt6RYV5G4CXfeBXK8gToQRpoXo9MGpoagT6ovGMMhWdUNoSX63o9vfdstWzqLk8c1V4fLDW6T2e5re6pyTiD5KbfMNmuapGjso6Gp4koeA6AoyEic9m8AXeR976qTHznLtcnb1",
  "identity": "test for demo purpose"
},
  "keys": {}
}'
```
that will return something like:
```json
{
  "DID": "did:dyne:sandbox.test:3XbZ2Hxm5R1o5h3ezqMBTstJy499Er1ktuEgqKnVqNSD",
  "DID_show_explorer": "https://explorer.did.dyne.org/details/did:dyne:sandbox.test:3XbZ2Hxm5R1o5h3ezqMBTstJy499Er1ktuEgqKnVqNSD",
  "resolve_DID": "https://did.dyne.org/dids/did:dyne:sandbox.test:3XbZ2Hxm5R1o5h3ezqMBTstJy499Er1ktuEgqKnVqNSD"
}
```
* `api/sandbox.<context>/delete_sandbox_did.chain` that given in input a DID will deactivate it. It can be called with a POST request as following:
```bash
TODO
```
