# W3C-DID
Dyne.org's W3C-DID implementation

The first focus for the Dyne.org's DID method was to register [Zenswarm Oracles](https://github.com/dyne/zenswarm) identities, in a way that is both machine and human readable. We haven’t been able to use the standard specs to record public keys, since we found the existing standards incomplete or incompatible. We also have been unable to find a standard to record a Dilithium2 (quantum-proof) and Schnorr public keys, that we created according to the best practices we are aware of.
The DID and the DID Document are produced and resolved by our [Controller](https://did.dyne.org/docs/), who also notarizes the DID Document on [fabchain.net](https://www.fabchain.net/).

The content of DID document includes: 
* All the API endpoints of each Oracle, as an array “serviceEndpoint”. 
* The “Country” and the “State”
* Public keys for:
  * Secp256k1 ECDSA, widely used for single signatures
  * ED25519 EDDSA widely used for single signatures
  * BLS381 “Reflow”, for multisignature
  * BLS381 “Schnorr”, currently only for single signatures
  * Dilithium2, for quantum-proof signatures
  * The ethereum address owned by the Oracle, in a string named “blockchainAccountId”, following the eip155 formatting standard 
* The DID whose document contains the txId on our Ethereum-based “Fabchain” where the DID was stored, stored in the string “alsoKnownAs”
* The JWS signature of the DID Document operated by the [Controller](https://did.dyne.org/docs/) inside the "proof"

Below an example Oracle's W3C-DID Document following our specification:


```json
{
   "@context":[
      "https://www.w3.org/ns/did/v1",
      "https://dyne.github.io/W3C-DID/specs/EcdsaSecp256k1_b64.json",
      "https://dyne.github.io/W3C-DID/specs/ReflowBLS12381_b64.json",
      "https://dyne.github.io/W3C-DID/specs/SchnorrBLS12381_b64.json",
      "https://dyne.github.io/W3C-DID/specs/Dilithium2_b64.json",
      "https://w3id.org/security/suites/secp256k1-2020/v1",
      "https://w3id.org/security/suites/ed25519-2018/v1",
      {
         "Country":"https://schema.org/Country",
         "State":"https://schema.org/State",
         "description":"https://schema.org/description",
         "url":"https://schema.org/url"
      }
   ],
   "Country":"DE",
   "State":"NONE",
   "alsoKnownAs":"did:dyne:fabchain:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm",
   "description":"oracle-v.3",
   "id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm",
   "proof":{
      "created":"1661515482543",
      "jws":"eyJhbGciOiJFUzI1NksiLCJiNjQiOnRydWUsImNyaXQiOiJiNjQifQ..zr0p3-5bwCt0wIHFvOSRG_Nahnhqa8vvVAEbfVem8ak4SaKXwS-W6ylLvS9RUjOOAwNLFCL51a32q3wiazfAHw",
      "proofPurpose":"assertionMethod",
      "type":"EcdsaSecp256k1Signature2019",
      "verificationMethod":"did:dyne:controller:7mz5RPAgbgHZtEBiVDy2gFaZMdPDTZsqJjLGuf8YXW1M#key_ecdsa1"
   },
   "service":[
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-announce",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-announce",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#ethereum-to-ethereum-notarization.chain",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/ethereum-to-ethereum-notarization.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-get-identity",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-get-identity",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-http-post",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-http-post",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-key-issuance.chain",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-key-issuance.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-ping",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-ping",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#sawroom-to-ethereum-notarization.chain",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/sawroom-to-ethereum-notarization.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-get-timestamp",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-get-timestamp",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-update",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-update",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-get-signed-timestamp",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-get-signed-timestamp",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-sign-dilithium",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-sign-dilithium",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-sign-ecdsa",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-sign-ecdsa",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-sign-eddsa",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-sign-eddsa",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-sign-schnorr",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-sign-schnorr",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-dilithium-signature-verification-on-planetmint.chain",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-dilithium-signature-verification-on-planetmint.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-execute-zencode-planetmint.chain",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-execute-zencode-planetmint.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-post-6-rand-oracles.chain",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-post-6-rand-oracles.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-read-from-fabric",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-read-from-fabric",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-write-on-fabric",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-write-on-fabric",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-read-from-ethereum",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-read-from-ethereum",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-write-on-ethereum.chain",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-write-on-ethereum.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-read-from-planetmint",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-read-from-planetmint",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-write-on-planetmint",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-write-on-planetmint",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-verify-dilithium",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-verify-dilithium",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-verify-ecdsa",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-verify-ecdsa",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-verify-eddsa",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-verify-eddsa",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-verify-schnorr",
         "serviceEndpoint":"https://swarm0.dyne.org:20000/api/zenswarm-oracle-verify-schnorr",
         "type":"LinkedDomains"
      }
   ],
   "url":"https://swarm0.dyne.org",
   "verificationMethod":[
      {
         "controller":"did:dyne:controller:7mz5RPAgbgHZtEBiVDy2gFaZMdPDTZsqJjLGuf8YXW1M",
         "id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm#key_ecdsa1",
         "publicKeyBase64":"BPBzcycFZM372vaEX/KduShm/CxHQXjuZWO1H6SIzg1E5gzcr8TVjHftUJeYPcgxOl3WxXkwfirBIN2yI+9C+hk=",
         "type":"EcdsaSecp256k1VerificationKey_b64"
      },
      {
         "controller":"did:dyne:controller:7mz5RPAgbgHZtEBiVDy2gFaZMdPDTZsqJjLGuf8YXW1M",
         "id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm#key_reflow1",
         "publicKeyBase64":"AeR8j3KeG13eLvVXDczywjV5AdoDSEW4ljObVBX9EoRMMXD6+F0nhNDPKiLdaQgrEYIQEsIZw3oWbWRZnBUSQYehV9qAcoRien3ZtCMmBYvtI1raldG2OxOOJ1YbiaqKGOJqxMm+j+IrWE/MyfAxjzYwrNSuyl3mksrOnRZE/E18pygiJx1eaecjhWhjXB4PEphvktjCYFuWV3fR6AfpgU47aOYWkb06DJVJ7tdcfi43xTWTU8QMZ7zK7QtKbjI0",
         "type":"ReflowBLS12381VerificationKey_b64"
      },
      {
         "controller":"did:dyne:controller:7mz5RPAgbgHZtEBiVDy2gFaZMdPDTZsqJjLGuf8YXW1M",
         "id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm#key_schnorr1",
         "publicKeyBase64":"Ao9A72UhXsv/k3MQgqIag0Nkbj7T5IQfFYlmBEWLb9IVdhGhveI/WZZtqK3+Nmbz",
         "type":"SchnorrBLS12381VerificationKey_b64"
      },
      {
         "controller":"did:dyne:controller:7mz5RPAgbgHZtEBiVDy2gFaZMdPDTZsqJjLGuf8YXW1M",
         "id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm#key_dilithium1",
         "publicKeyBase64":"Jb0bSmIk094l2eIP3aMxxIJxNGUHR+/RkSGpjBN+5CBtXfJ8+z08TlQpdWXPmj6be9i5kzoSOIAvvirD53aqqNpf9AGIwU4x41+v2YxIxnMOnIn7Yb5sU+ifmLowJmOZRyc5ATDyxLE8w/u9toLyYc//lGhOYwmXaXdf8b/Fz2ziII8li4Jr++C3SF4I9DXrvJKJaikjIRmi99TsOUjnHKyLeizH6R/h3GSBiyoUjj0PxEcKPdKJJAsaE5zPK6M02botSJh7qffi0F+4v6HppDgZWYBrjp+DdwcrWEerWdXPyieoTz7ddawnb4v1CzT4N1acswZYIzl0E37EIHymogQhM1IIU58wlij82Ui2TcwDT1e3mw/Ys4MIMPYiBDSb6WixvGGApwH/Sgagd/Z6NZlOoJQOwbsEGHntKribloQUSZ72IhXHfb+PFCVTuU2bOa4O1LKQe3iW673+jDLHCKJ/Y/qqBCyqSpc4HlP4Lr7tBlJcrKuvg4sY3ThYfq4DbOS0sWvlplEgDISXh3Tz0FY7HSHYes7LZwuLiGEqScnU/Jhp9/FAZmhn4vy2bjjYxyRbPOrksxdLJQtUvO8/pMHxLbM3egAiOdqPwJcLOLSTHvn19YGlUaThsWwBCnO2OeVlXXJXrvpttBizS8UFVUqbyHFMC82pdobO+4C+ihDRFzLoZ0YIevHvqoZ4h0fZPRuSP2e0/S7kAQMLy//1yUI7PGLx7s/Y17XE8Lm9Eofky07LVvSbGtlZKS2O5huqjklH/0wo11tf+qBS6VAK9NFVh0RyBP9jyW19bEP9+zkeEAfyjzbFI7lIQ6oGl/d0KfQ3qkScySO3XqKJrCTrOnVd3XBvEYbfH6HomzIEvL/Uko7GrW9CLHY0IsmXa36F91BcKHEWC+T99x1tgGTqm2iw2D0iRIz7JMJBhjbO5jwMN/GFKztxQNBpiCFLdkpWt2JK6dx6bOBy8WBBRC+/OZ6ckUj5pZR2lbdaknbn/GSNtc5MvkweZcMjVQtRG1XK0vsEH9PqnUAb3RXcqeR2Xb+nc+7sjAHohesW8Z0huUkYD2E5ZzvGz4wqMh/PLN/XON/IHc7g0PneLNR3SltkIp7KjDX9TijEqwy27yPhNxZ2k9KRZdyQgNU1YkJVV41LCodOv1wEUlEykTmD47eoeWaQTtiXXLbVDkyvlEIMrT9cswQf4RtrqR47YXY63uumIZH2pwZ/+BsFnQfWNx18EZtntIWY8VhQU9ul4I+66TZlxbrfP/cuQ3sCVfV6Vi7loKC8KRm59seK46oHRdAX2iKJdcexbPGtvwiiUQ+5FknEMqT9VJANEnO9XI4kinJ9orpYKwi6VUIWXf2r1OBVBeJP8g4zPHtwXxUQMyZou8ZwEc3JN5XdtT9dXrw5Enm6n4cAUHvTmgrUlAZFzDCzdQG7xljpexxUZIQcICVkmXA7KMwz7ux7LcwYdXYcpcZ7gCejpmtVjPq2pQX6J/yFqrq1fzBqwfPZ7b9ykjndMMLwfkTQofomsLnJ0I200Nq5Sv3dMgBIINyJjNEWhHU84XRvsTbkkM9NVd5vvXvrxRwePB4CiAvL+NlHHFkes4RiziyEx6kFjuMqLg0yjSZIpqZO1nxUBCTiZr/DjQvf1EGDMLE4+bFwP95dtnFwP6dyN2W5CJ9GA7VpPCEYXAW4Ys9CdNnHBj2bKWzfkZfGaHt3pd0RqvOdwUAqzcN5wxotZaADDpYEBYREogRP7JMYLw==",
         "type":"Dilithium2VerificationKey_b64"
      },
      {
         "controller":"did:dyne:controller:7mz5RPAgbgHZtEBiVDy2gFaZMdPDTZsqJjLGuf8YXW1M",
         "id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm#key_eddsa1",
         "publicKeyBase58":"E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm",
         "type":"Ed25519VerificationKey2018"
      },
      {
         "blockchainAccountId":"eip155:1717658228:0xbd1b6a635e6cd9b0a5557566323d72cb9259f5e4",
         "controller":"did:dyne:controller:7mz5RPAgbgHZtEBiVDy2gFaZMdPDTZsqJjLGuf8YXW1M",
         "id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm#fabchainAccountId",
         "type":"EcdsaSecp256k1RecoveryMethod2020"
      }
   ]
}
```

Below is an example of a DID Document resolved using the DID contained in "alsoKnownAs": 

```json
{
   "id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm",
   "txid":"b209e18d074f820c44bbc052c86add6c66beb319cfbc8b2ac1b47b3102e5df40"
}
```

The data stored in the transation represented by the transaction id "txid" can be retrieved by querying the resolve-alsoKnownAs API:

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/W3C-DID-resolve-alsoKnownAs' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {"alsoKnownAs": "b209e18d074f820c44bbc052c86add6c66beb319cfbc8b2ac1b47b3102e5df40"},
  "keys": {}
}'
```
