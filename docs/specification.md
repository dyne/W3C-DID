# Specification

## Abstract

The first focus for the Dyne.org's DID method was to register [Zenswarm Oracles](https://github.com/dyne/zenswarm) identities, in a way that is both machine and human readable. We have introduced some new classes and properties to cover all the public keys that we are using inside the DID document, including also a **post quantum** public key. The DID Document and the DID are respectively stored and resolved by our [Controller](https://did.dyne.org/docs/), who also notarizes the DID Document on creation, update and removal on ganache blockchain, which will soon be replaced by planetmint.


### State of the document 

This is a draft document and will be updated.

## DID Method Name

The namestring that shall identify this DID method is: **dyne**.

A DID that uses this method *MUST* begin with the following prefix: **did:dyne**. Per the DID specification, this string *MUST* be in lowercase.

## Method Specific Identifier

Dyne DIDs have the following format:
```
dyne-did   := did:dyne:<idspec>:<idchar>
idspec     := *(ALPHA)
idchar     := 1*44(base58char)
base58char := "1" / "2" / "3" / "4" / "5" / "6" / "7" / "8" / "9" / "A" / "B" / "C"
              / "D" / "E" / "F" / "G" / "H" / "J" / "K" / "L" / "M" / "N" / "P" / "Q"
              / "R" / "S" / "T" / "U" / "V" / "W" / "X" / "Y" / "Z" / "a" / "b" / "c"
              / "d" / "e" / "f" / "g" / "h" / "i" / "j" / "k" / "m" / "n" / "o" / "p"
              / "q" / "r" / "s" / "t" / "u" / "v" / "w" / "x" / "y" / "z"
```

For the moment the main used prefix are:
- <b>did:</b><b>dyne:</b><b>oracle:</b> thawt represent a Zenswarm Oracle and inside each Zenswarm Oracle DID document is present the field "alsoKnownAs" with value <b>did:</b><b>dyne:</b><b>ganache:...</b>, this DID can be resolved and contains the DID of the Oracle and the transaction ids in which the DID document was store on chain during creation, update and removal. 
- <b>did:</b><b>dyne:</b><b>controller:</b> is used only by the Controller to differentiate its DID from the others.

An example of Dyne.org's DID is:
```
did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe
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
   "Country":"IT",
   "State":"NONE",
   "alsoKnownAs":"did:dyne:ganache:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
   "description":"restroom-mw",
   "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
   "proof":{
      "created":"1669312940937",
      "jws":"eyJhbGciOiJFUzI1NksiLCJiNjQiOnRydWUsImNyaXQiOiJiNjQifQ..PLloczDxLJrDplw4_CaLoQAW1mZvH2dIQ3LsxZtF_C5ax5-hPXQ00ytTOUNQyr4HklnrstZPhKNC6SkvdM_SlQ",
      "proofPurpose":"assertionMethod",
      "type":"EcdsaSecp256k1Signature2019",
      "verificationMethod":"did:dyne:controller:6zv2wcKFrki4DzkQTD7CMEakciwomDfwG8Po2BdAwF3P#key_ecdsa1"
   },
   "service":[
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-announce",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-announce",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#ethereum-to-ethereum-notarization.chain",
         "serviceEndpoint":"http://172.104.233.185:28634/api/ethereum-to-ethereum-notarization.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-get-identity",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-get-identity",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-http-post",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-http-post",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-key-issuance.chain",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-key-issuance.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-ping.zen",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-ping.zen",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#sawroom-to-ethereum-notarization.chain",
         "serviceEndpoint":"http://172.104.233.185:28634/api/sawroom-to-ethereum-notarization.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-get-timestamp.zen",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-get-timestamp.zen",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-update",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-update",
         "type":"LinkedDomains"
      }
   ],
   "url":"https://swarm2.dyne.org:20004",
   "verificationMethod":[
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_ecdsa1",
         "publicKeyBase64":"BMBshJCfEXccpJ+KJ830Ro/niwEBvzU2Rt9lZIXn7wpGqARUWn53Z2dlgRR9nJfrtkwhSuybG7i7KYjpeaML9Oc=",
         "type":"EcdsaSecp256k1VerificationKey_b64"
      },
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_reflow1",
         "publicKeyBase64":"DjXU13pWGlSbQdLA91FiSh+GE8VdTqYS/BhglCo5+XpVEVPIaFhgTTrTPJf7WcGFA/zjJU0gDzRFhNIXQ14gdBwIwhl4vVlczhXbiYOoqY9JCcNE84rQ45CO0htuJ5QKFcjUxnDAXARx+9N3NECJuuMHDRsQ5gnRdrrZISzYkzfj4rxTjFW0+oBRVg4IROmMDLBSoMsjRI/nFylMpdWrAL7y1VBNg/m9J/JTWDiDytT7ZCedVTJof1txfrZ1Rlge",
         "type":"ReflowBLS12381VerificationKey_b64"
      },
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_schnorr1",
         "publicKeyBase64":"GDS7kEM8ekwEMMbj2OwjSkZY5qMfyhyHHmHcJA/yiN5tQG2/8JJHffksLo+R3ItA",
         "type":"SchnorrBLS12381VerificationKey_b64"
      },
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_dilithium1",
         "publicKeyBase64":"d+Zxp+osTxJmSzKjYrSivU59O3tbNcEEcDeHPGr3CaZRIwQPnLY8hWUSb3IvK/NWmS8qF1WjITZO/eQGpibmmBzht1C+1XhTXHYX9SZ+Q1By0WpMKuDqoRdFaDEEMXtG2wY8hQYP3yzuiQfLfpmfn04hWzTgdRJdL6juaBfuPeq35RADyDaqtSFRIBtW8IigQndwc6fdk/eqHkEKgTVlsKAVrEfR6GLv7RbJqcTE3Z7s1Qp569EJPzUciBUX4DIJjWGS5z2l4Xef3otEYijdDDwKyEF4U98EJX67wF5TIOBw5hzsTRZRgXhpJhhY94D9DGuGIdspOv8gSI+AQ7pEGRVUtfLtWDqVDzwOSeY2rqGBkiBUUEyFZS6yGZzjRtVaW8YuyEwXlr7uOJfNg2sXBcvE4tZIYI1IT9BZNxCqcD5fnsKhVmpf45SLWDN+qSjtbZLOKKa+1/3lntS9DbU3nSbboXec0wpMiOoQIaAh9A0i80dRrpzGVOqEJ2Ar7q0PV/F3sOaHtdRujZ4eAlGIvXZrRAqTQ02HVmEO0fHIfVp/SvR5dkG4uz8IsmKUvfi73gPT4NdbTUjpDaMOkLAduw4MdoQs/99KKMTMCf9/aiTPW1Vz3frQudvXQ0C65vesowbLSsUNuRMcPI2GbHCn8yi1pEaKqrNP/6MegR0LyHHkgLSXnGZWOnEAAZa73IuZi1iC7nnyg56/N6MSURZeCzNa9E3ofRGUhboBLxa68/Z3dUul5E2pIL51MlMXzdaAUMhFosT4XtQBTuGdgDqHMP+hbyy7c/NXtXDgo6Ze4Csm8R9ABhcr/QsZQrmLKvuaMxDqA48XuWWNXqpLho8zHoR58aZWlQFFxyk7AmiN+hJbKiBkW8WxOe1qO8nJkUvjx4gcXhEqrJmtXlZzMZ8L43J4S5iExXKZ6qVgdsE2UZTpfqRSJEC/xaDJjiF8bt59qFVMhyUUy8Pk5tLN0C3zykC4LtSn5o0bcWRYQWuJkHcHRavaRYWef+XxphZyohkXZwE80IQG41YoCq4DAy/wBrpWLBQ7Z5WU3vqd8efGWXMJjjKI+6zb4ZQ2CTAwxIOcRNcBUplh/AEbGbKyIux0W2k9W7V7nDexWWXAy/DYvbUJxhpZ9msjCVijC+DSzwndPHQbDixXtnO/OPc1iT6/E28aiZGBLd20YaNAraRLJx2V0kofjsMpIsnMQCDu2Lp6WbLIaEk9mM3yJEahAcP2phmtA2ajdXn8XMByU1/Q6IvdxJx6zTybLaht4gnsOxvOnnqD3b1MtxuHeQEYGO4Kt5CqGoYwrY+45PCXc1J/0SRSNcih/WRWyDVwOcd5CP9wsIIAFYtQ6jV9NkZkly32CsNC9XUuwoTdwkJw1eo1U3v006JJI5RIBbqwr/LARPzzs/dh4fHooiAVHOJTsx1TyzmJkl9dMkEJvdC9CfMHUymkXG3SoDaypw9cogUjY4JWn5xxsWkPD2N/cbyYO4OjhI6YTicNB4NTK+slOJMzFtN7xoRtXxIZG/t8ILGcg/N4SfGLJugcybExaGh1dL6qUnNn+afEh6OEx3ZoGdQgmzeUMgDpGn7x3mMp8RqUsGmcyTWTqwKHN523UHk0DhBSCMuD5dd5D1o9KKGZjseBSpaVYpjM7ERGSq5KNjAN0HYJje9Is+HBm6l/dyLeB37KBIDTd9G+n9Ak12MqCMkMhbJb0owOtNFfw6FoILd1GeVb/Br1XV4GO11dc2rkN/iG4w==",
         "type":"Dilithium2VerificationKey_b64"
      },
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_eddsa1",
         "publicKeyBase58":"2eFibJG2GaBxSfL7CUyt18cg14CsNxAD1FtsSMMTC3r7",
         "type":"Ed25519VerificationKey2018"
      },
      {
         "blockchainAccountId":"eip155:1717658228:0xbce1915aac95b986bbf54d05e52e0fe9abc90240",
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#fabchainAccountId",
         "type":"EcdsaSecp256k1RecoveryMethod2020"
      }
   ]
}
```

Below is an example of a DID Document resolved using the DID contained in *alsoKnownAs*: 

```json
{
   "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
   "timestamp-create":"1669312940937",
   "txid-create":"7208d3f1853ec905ef0af5ff1c2556ec00321a6ca788fe6a55f518f14db652ba"
}
```

The data stored in the transation represented by the transaction id *txid-create* can be retrieved by querying the resolve-txid API:

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/did-resolve-txid' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {"txid":"7208d3f1853ec905ef0af5ff1c2556ec00321a6ca788fe6a55f518f14db652ba"},
  "keys": {}
}'
```

## CRUD Operation Definitions

### DID Document Creation

The first step to create a DID document is to retrieve a **token**, that is an eddsa keypair, from the DID controller. In this moment it can be obtained by quering the did-faucet API:

```bash
curl -X 'GET' \ 
  'https://did.dyne.org:443/api/did-faucet.chain' \
  -H 'accept: application/json'
```

The response will look like:

```json
{
  "sent:": "sent:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
  "token": {
    "eddsa": "HShhAKcbNHBAaWoDnXDB1r965sM5VLaemUeefCc79JeE",
    "eddsa_public_key": "6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe"
  }
}
```

At this point the DID document is created from the client, that will use the **eddsa public key** contained in the token as its *\<idchar\>* inside the [id](specification.md?id=Method-Specific-Identifier), and it will look like:

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
   "Country":"IT",
   "State":"NONE",
   "alsoKnownAs":"did:dyne:ganache:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
   "description":"restroom-mw",
   "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
   "service":[
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-announce",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-announce",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#ethereum-to-ethereum-notarization.chain",
         "serviceEndpoint":"http://172.104.233.185:28634/api/ethereum-to-ethereum-notarization.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-get-identity",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-get-identity",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-http-post",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-http-post",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-key-issuance.chain",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-key-issuance.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-ping.zen",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-ping.zen",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#sawroom-to-ethereum-notarization.chain",
         "serviceEndpoint":"http://172.104.233.185:28634/api/sawroom-to-ethereum-notarization.chain",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-get-timestamp.zen",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-get-timestamp.zen",
         "type":"LinkedDomains"
      },
      {
         "id":"did:dyne:zenswarm-api#zenswarm-oracle-update",
         "serviceEndpoint":"http://172.104.233.185:28634/api/zenswarm-oracle-update",
         "type":"LinkedDomains"
      }
   ],
   "url":"https://swarm2.dyne.org:20004",
   "verificationMethod":[
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_ecdsa1",
         "publicKeyBase64":"BMBshJCfEXccpJ+KJ830Ro/niwEBvzU2Rt9lZIXn7wpGqARUWn53Z2dlgRR9nJfrtkwhSuybG7i7KYjpeaML9Oc=",
         "type":"EcdsaSecp256k1VerificationKey_b64"
      },
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_reflow1",
         "publicKeyBase64":"DjXU13pWGlSbQdLA91FiSh+GE8VdTqYS/BhglCo5+XpVEVPIaFhgTTrTPJf7WcGFA/zjJU0gDzRFhNIXQ14gdBwIwhl4vVlczhXbiYOoqY9JCcNE84rQ45CO0htuJ5QKFcjUxnDAXARx+9N3NECJuuMHDRsQ5gnRdrrZISzYkzfj4rxTjFW0+oBRVg4IROmMDLBSoMsjRI/nFylMpdWrAL7y1VBNg/m9J/JTWDiDytT7ZCedVTJof1txfrZ1Rlge",
         "type":"ReflowBLS12381VerificationKey_b64"
      },
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_schnorr1",
         "publicKeyBase64":"GDS7kEM8ekwEMMbj2OwjSkZY5qMfyhyHHmHcJA/yiN5tQG2/8JJHffksLo+R3ItA",
         "type":"SchnorrBLS12381VerificationKey_b64"
      },
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_dilithium1",
         "publicKeyBase64":"d+Zxp+osTxJmSzKjYrSivU59O3tbNcEEcDeHPGr3CaZRIwQPnLY8hWUSb3IvK/NWmS8qF1WjITZO/eQGpibmmBzht1C+1XhTXHYX9SZ+Q1By0WpMKuDqoRdFaDEEMXtG2wY8hQYP3yzuiQfLfpmfn04hWzTgdRJdL6juaBfuPeq35RADyDaqtSFRIBtW8IigQndwc6fdk/eqHkEKgTVlsKAVrEfR6GLv7RbJqcTE3Z7s1Qp569EJPzUciBUX4DIJjWGS5z2l4Xef3otEYijdDDwKyEF4U98EJX67wF5TIOBw5hzsTRZRgXhpJhhY94D9DGuGIdspOv8gSI+AQ7pEGRVUtfLtWDqVDzwOSeY2rqGBkiBUUEyFZS6yGZzjRtVaW8YuyEwXlr7uOJfNg2sXBcvE4tZIYI1IT9BZNxCqcD5fnsKhVmpf45SLWDN+qSjtbZLOKKa+1/3lntS9DbU3nSbboXec0wpMiOoQIaAh9A0i80dRrpzGVOqEJ2Ar7q0PV/F3sOaHtdRujZ4eAlGIvXZrRAqTQ02HVmEO0fHIfVp/SvR5dkG4uz8IsmKUvfi73gPT4NdbTUjpDaMOkLAduw4MdoQs/99KKMTMCf9/aiTPW1Vz3frQudvXQ0C65vesowbLSsUNuRMcPI2GbHCn8yi1pEaKqrNP/6MegR0LyHHkgLSXnGZWOnEAAZa73IuZi1iC7nnyg56/N6MSURZeCzNa9E3ofRGUhboBLxa68/Z3dUul5E2pIL51MlMXzdaAUMhFosT4XtQBTuGdgDqHMP+hbyy7c/NXtXDgo6Ze4Csm8R9ABhcr/QsZQrmLKvuaMxDqA48XuWWNXqpLho8zHoR58aZWlQFFxyk7AmiN+hJbKiBkW8WxOe1qO8nJkUvjx4gcXhEqrJmtXlZzMZ8L43J4S5iExXKZ6qVgdsE2UZTpfqRSJEC/xaDJjiF8bt59qFVMhyUUy8Pk5tLN0C3zykC4LtSn5o0bcWRYQWuJkHcHRavaRYWef+XxphZyohkXZwE80IQG41YoCq4DAy/wBrpWLBQ7Z5WU3vqd8efGWXMJjjKI+6zb4ZQ2CTAwxIOcRNcBUplh/AEbGbKyIux0W2k9W7V7nDexWWXAy/DYvbUJxhpZ9msjCVijC+DSzwndPHQbDixXtnO/OPc1iT6/E28aiZGBLd20YaNAraRLJx2V0kofjsMpIsnMQCDu2Lp6WbLIaEk9mM3yJEahAcP2phmtA2ajdXn8XMByU1/Q6IvdxJx6zTybLaht4gnsOxvOnnqD3b1MtxuHeQEYGO4Kt5CqGoYwrY+45PCXc1J/0SRSNcih/WRWyDVwOcd5CP9wsIIAFYtQ6jV9NkZkly32CsNC9XUuwoTdwkJw1eo1U3v006JJI5RIBbqwr/LARPzzs/dh4fHooiAVHOJTsx1TyzmJkl9dMkEJvdC9CfMHUymkXG3SoDaypw9cogUjY4JWn5xxsWkPD2N/cbyYO4OjhI6YTicNB4NTK+slOJMzFtN7xoRtXxIZG/t8ILGcg/N4SfGLJugcybExaGh1dL6qUnNn+afEh6OEx3ZoGdQgmzeUMgDpGn7x3mMp8RqUsGmcyTWTqwKHN523UHk0DhBSCMuD5dd5D1o9KKGZjseBSpaVYpjM7ERGSq5KNjAN0HYJje9Is+HBm6l/dyLeB37KBIDTd9G+n9Ak12MqCMkMhbJb0owOtNFfw6FoILd1GeVb/Br1XV4GO11dc2rkN/iG4w==",
         "type":"Dilithium2VerificationKey_b64"
      },
      {
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#key_eddsa1",
         "publicKeyBase58":"2eFibJG2GaBxSfL7CUyt18cg14CsNxAD1FtsSMMTC3r7",
         "type":"Ed25519VerificationKey2018"
      },
      {
         "blockchainAccountId":"eip155:1717658228:0xbce1915aac95b986bbf54d05e52e0fe9abc90240",
         "controller":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe",
         "id":"did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe#fabchainAccountId",
         "type":"EcdsaSecp256k1RecoveryMethod2020"
      }
   ]
}
```

The last step is to encode the DID document as a string using json encoding, whituout withespaces, and sign the latter with both the **client eddsa key** and the **token eddsa key**. The DID document and the relative signatures are finally sent to the Controller and the the *HTTP POST* wil be of the form:

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/did-create.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {
	  "did_document": { ... },
	  "eddsa_signature": " ... ",
	  "token_signature": " ... "
  },
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
did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe
```
can be resolved by
```bash
curl -X 'GET' \
  'https://did.dyne.org:443/1.0/identifiers/did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe' \
  -H 'accept: application/json'
```

### DID Document Update

During update the **token** is no more required, only the client eddsa key is needed. In order to update the DID document the clinet will modify its DID document, encoding it has a string using json encoding and finally sign it with the **eddsa key** that matches the **eddsa public key** present in the previous DID document. At the end the new DID document, the DID and the singature will be sent to the DID controller and the *POST* will lok like:

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/did-update.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {
	  "did_document": { ... },
	  "eddsa_signature": " ... ",
	  "id": " ... "
  },
  "keys": {}
}'
```

### DID Document Revocation

To delete/revocate a DID document, it is enough to perform a *HTTP POST* request as follow where the **id** is the DID to be removed and the **eddsa signature** is its signature using the **client eddsa key**:
```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/did-delete.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {
	  "eddsa_signature": "M3So52B9TN7N8pGXywGd62gtWiYz532Z2FJXv1QUf62HSzZ37qUkERsiyB7y2DPFEuzz62jJgSfGdRnJmfeWUAR",
	  "id": "did:dyne:oracle:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe"
  },
  "keys": {}
}'
```

The did document will be removed and it will be not possible to resolve its did anymore, but its *alsoKnownAs* field, in this case *did:dyne:ganache:6hz2jnExz5qSKNAN7XMkcZsHr8HYaHxu6RNuWyG19SVe*, will still be resolvable and it will contains all the history of the DID document:
- timestamp and txid of creation
- timestamps and txids of all the updates, if performed
- timestamp and txid of removal

## Security Considerations

- DID documents are stored from the Controller both on redis and on ganache blockchain, thus the correctness of the DID document can always be verified.
- DID documents use ECDSA signature technology to prevent tampering.

## Privacy Considerations

- No personally identifiable information (PII) is included in a DID document retrieved by Dyne.org's DID resolver.
- DID Document details published on the blockchain ledger are necessary only for authentication by other parties.
- The private key only exists on the user's device and will not be known to any third party.
