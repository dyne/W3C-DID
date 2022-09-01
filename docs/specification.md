# Specification

## Abstract

The first focus for the Dyne.org's DID method was to register [Zenswarm Oracles](https://github.com/dyne/zenswarm) identities, in a way that is both machine and human readable. We have introduced some new classes and properties to cover all the public keys that we are using inside the DID document, including also a **post quantum** public key. The DID and the DID Document are produced and resolved by our [Controller](https://did.dyne.org/docs/), who also notarizes the DID Document on [fabchain.net](https://www.fabchain.net/).

For the moment only Zenswarm Oracles, through a dedicated procedure, can posses a Dyne.org's DID. This will change in the following months, and this document will be updated with the changes.


### State of the document 

This is a draft document and will be updated.

## DID Method Name

The namestring that shall identify this DID method is: **dyne**.

A DID that uses this method *MUST* begin with the following prefix: **did:dyne**. Per the DID specification, this string *MUST* be in lowercase.

## Method Specific Identifier

Dyne DIDs have the following format:
```
dyne-did   := did:dyne:<idspec>:<idchar>
idspec     := "id" / "controller" / "fabchain"
idchar     := 1*44(base58char)
base58char := "1" / "2" / "3" / "4" / "5" / "6" / "7" / "8" / "9" / "A" / "B" / "C"
              / "D" / "E" / "F" / "G" / "H" / "J" / "K" / "L" / "M" / "N" / "P" / "Q"
              / "R" / "S" / "T" / "U" / "V" / "W" / "X" / "Y" / "Z" / "a" / "b" / "c"
              / "d" / "e" / "f" / "g" / "h" / "i" / "j" / "k" / "m" / "n" / "o" / "p"
              / "q" / "r" / "s" / "t" / "u" / "v" / "w" / "x" / "y" / "z"
```

The prefix **did:dyne:id:** represent a Zenswarm Oracle and inside each Zenswarm Oracle DID document is present the field "alsoKnownAs" with value **did:dyne:fabchain:...**, this DID can be resolved and contains the DID of the Oracle and the transaction id in which the DID document is store on the chain. The prefix **did:dyne:controller:** is used by the Controller to differentiate its DID from the others.

An example of Dyne.org's DID is:
```
did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm
```
that is associated to the following DID document:
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

## CRUD Operation Definitions

### DID Document Creation

As stated in the [abstract](specification.md?id=abstract) the DID document can be created only for Zenswarm Oracles. It is created by send an *HTTP POST* request containing the identity of the Zenswarm Oracles, containing the public keys, the service endpoints and some more useful stuff describing the Oracle, to the Controller, and it look like:

```json
{
  "identity": {
    "API": [
      "/api/zenswarm-oracle-announce",
      "/api/ethereum-to-ethereum-notarization.chain",
      "/api/zenswarm-oracle-get-identity",
      "/api/zenswarm-oracle-http-post",
      "/api/zenswarm-oracle-key-issuance.chain",
      "/api/zenswarm-oracle-ping",
      "/api/sawroom-to-ethereum-notarization.chain",
      "/api/zenswarm-oracle-get-timestamp",
      "/api/zenswarm-oracle-update",
      "/api/zenswarm-oracle-get-signed-timestamp",
      "/api/zenswarm-oracle-sign-dilithium",
      "/api/zenswarm-oracle-sign-ecdsa",
      "/api/zenswarm-oracle-sign-eddsa",
      "/api/zenswarm-oracle-sign-schnorr",
      "/api/zenswarm-dilithium-signature-verification-on-planetmint.chain",
      "/api/zenswarm-oracle-execute-zencode-planetmint.chain",
      "/api/zenswarm-post-6-rand-oracles.chain",
      "/api/zenswarm-read-from-fabric",
      "/api/zenswarm-write-on-fabric",
      "/api/zenswarm-read-from-ethereum",
      "/api/zenswarm-write-on-ethereum.chain",
      "/api/zenswarm-read-from-planetmint",
      "/api/zenswarm-write-on-planetmint",
      "/api/zenswarm-oracle-verify-dilithium",
      "/api/zenswarm-oracle-verify-ecdsa",
      "/api/zenswarm-oracle-verify-eddsa",
      "/api/zenswarm-oracle-verify-schnorr"
    ],
    "Country": "IE",
    "L0": "ethereum",
    "State": "NONE",
    "baseUrl": "https://swarm4.dyne.org",
    "description": "restroom-mw",
    "dilithium_public_key": "eoBUN9iZOOo11Ux4ZK/y5C7rWpgHB7cV86IDuJWClUqIqeXulPViP+PNWdjfijmLA0mKc9ybXbLtPUTwC/WjQDtn81coLMPgamtJnG2iM+GFKQ/MownoHRfvEX2trhNESSgvdqIqvAdD/99ZRg1kaS8QdjacZBll00N9urMfD9u9PqZO3rbGZ0noVqY0rJyVDGDVfJDWhrfAnm7tnKehaKOaxtot3niVoQEGpntdHj7TR4yoR+5kfPN+4o61GhPJxhVjnbVnzQnzYyMrDzd/DI6GtQ0sj9TrIMzIxpsuoz+NSmk3GDAb5NKCl4GfsnY6nQA6hZ4JjAMbSAzSwQC+NmPGlGvSnLZd00bo9wMRG1pSTxT01YJfIfq3B2g8RG58OayAfhKtWag83RtpLsMTgoeo8mkGOww2xBqlyVerzbkfjTBCvRgjzjpLl5AGNPQHfCeB6s+rDugUWWbraR9KzVIQBXFWvHwAmBaGVoGU9SETifhT8+HRBwj/NmdMPTZQsrfxNj2SwZ4eDM5JNzlC8UPiZu5BIHVCS9lV5CUKVgPx3253setQzBXF3kug3JuLpsBfS8oXDxzWomadTH1B1tyj3U9G67tzjvI6zkqsxNzc38tQ/1ZAgsbbHbCyEnSfD4b5rjTnXhDYM0A2auFuJ7FlMzE4D4IDYEuvVNYUDLXLnkfdKzVVJFox999Irr33gZgZ29Gjgmzz5vC/FdcaymfJsSm1kztSczLx1rGAppN1fbngMVNQSl21QoIj/F8ilFwhC+iqlTwWvpUoPmPbg5i2P6lmjbGvOrpMm9Dyy0HknOjn4iKCpb49MZ5H667RVIhl3qmO6VTUUFT/xWU/Tbtvy9+hRxUdYS1eMbhQliWQRhc3mC3OEYPaRXH1ONuPiTTKZhzR6AkukouxLVp+Gq+d7AQ/XGtJ/DbDTLh1B8lyEj+KfIRXX7XxCSC4Sk5m+4pKfKGT1HMiw9s9z96V+Or8RECtXQZdG9DhlRDFC+TjzDB2wbJU8y2SEQ/EResE95SvCZrB+kY56OMaLU5I+qT6I41q1ywNVKxEuw90VXuEhmuCmSB0NQAJZhRoxMKcTz7AvmoBXtH5pJuB2kSLYTkfkoeLCDp0yx/Dp+aSSEU0Ql3OPHkEmJZKVrnGqZVCO3i2VoKDl8Pzj3FS/ZzK/qBgFFF5rMsr5FLC8TZFkDVmEY+CcHjEI8HJBRH/CGCt2G707bZOPLhzsowTiR0bU3N5g1yc2aWo0LMSzr0eRsF9aiQ6gKbnpMJU2nTj/XKlFjJk6OncZSKj1yU5Ov5GsSyksCT1hepg0tzdzWVGm6y/3Un4X+8SEmW7vUtjZYgkG6IedHbEtJoxAvW29kpK340KHixpK3CNtvfDslB8vTHizcGcyTOmj/XzF07zfWaa9WtK8a2ugk+iSKG0iBDP78vnHpAtbTN1H36/GdRfs9yGAmGXgOIPE0a5zy3lLgrcKhy5v874y6PP5Q4pB9EX30K1PnYmyy/eXz5MrUoUWfYpEwVSmBITRrZdjapgQiDj/dMt0Bk2xw93Qs9GxHqNdryUJVu/5p08oVvA9NClHKHwQ0bWHYp8YrqpSG8JZXXZ7URkETUMZuBydTadCJwAk3hfhcVRN2rsLQcQ/i0XODrJ+mn21y+t7+osZ+w6QAF3EbreLjuLxJULLwWY9ojRH6+XyGi2TLfMpcdWMXyNCFDZZAwQa5bSFxwhGKPu09C/4htxphiEO2XtjRtTmsnEVg==",
    "ecdh_public_key": "BIQRO1nxawUbHCHhs0GPLb/Q2bWFTp+kS1yE+fv/ynjNYoHv4p5OfyNWjmtM3L4ZjKfNdcBoVHMCeNboJsPVzPo=",
    "eddsa_public_key": "BHzxLnKLa16xN23ZbLqUHvoVaf66FCvKNJNai77pxWXb",
    "ethereum_address": "833e4c52263a644889bc43f34154ae298e09831c",
    "ip": "swarm4.dyne.org",
    "port_https": "20003",
    "reflow_public_key": "Gdv8ug5aMsFjJokErPe4P+R7LBB0JL6T+cYsZakq7AlOSQcFV4vhi4+vkoFIpwjyGf1sof3FkEMfJ7rmgUWuuhLAcJwP3rbmpKz3OpYQ0w7FD7ONst23Xr3FJBk+xiMuD7ueAFm/G4GCzmMVF9I9XKA7vGMNIDCnXEj6veLhDyWqYUKQv029WBlv55j8PXOqDSrJGxNu/G3LL74cwcxfqFJZ7TpseYHvElz5N7XGgzSPeY0O40t5OK71aA9+L9k/",
    "schnorr_public_key": "AgqoUfc6gjDpM97Wav+7mT51E7Ycte4MDzBSnad7rsl3SRpnqiIDsMCOd/58Rmyk",
    "tracker": "https://apiroom.net/",
    "uid": "swarm4.dyne.org:20003",
    "version": "3"
  }
}
```

and the *POST* wil look like:

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/W3C-DID-controller-create-oracle-DID.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {"identity":{ ... }},
  "keys": {}
}'
```

### DID Document Read

To read the DID document for some DID, you simply have to perform an *HTTP GET*:
```bash
curl -X 'GET' \
  'https://did.dyne.org:443/1.0/identifiers/<DID>' \
  -H 'accept: application/json'
```
It returns a did document for that DID, if it is found. For example the DID 
```
did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm 
```
can be resolved by
```bash
curl -X 'GET' \
  'https://did.dyne.org:443/1.0/identifiers/did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm' \
  -H 'accept: application/json'
```

### DID Document Update

In the current implementation, DID Documents are immutable, and cannot be updated. Future enhancements will enable support for key rotations, revocations, and service changes.

### DID Document Revocation

To delete/revocate a DID document is enough to perform a *HTTP POST* request as follow:
```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/W3C-DID-oracle-deannounce.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {"id":"did:dyne:id:E3H6tgCWZwXMXc8qbFAw22KBCjNxHnhKhG31tqreg3wm"},
  "keys": {}
}'
```
passing the DID to delete/revoke inside the "data" field.

## Security Considerations

- DID documents are stored from the Controller both on redis and on [fabchain.net](https://www.fabchain.net/), thus the correctness of the DID document can always be verified.
- DID documents use ECDSA signature technology to prevent tampering.

## Privacy Considerations

- The private key only exists on the user's device and will not be known to any third party.
