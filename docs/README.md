# W3C-DID
Dyne.org's W3C-DID implementation

The first focus for the driver was to register [Zenswarm Oracles](https://github.com/dyne/zenswarm) identities, in a way that is both machine and human readable. We haven’t been able to use the standard specs to record public keys, since we found the existing standards incomplete or incompatible. We also have been unable to find a standard to record a Dilithium2 (quantum-proof) and Schnorr public keys, that we created according to the best practices we are aware of.
The DID and the DID Document are produced and resolved by our [Controller](https://did.dyne.org/docs/), who also notarizes the DID Document on Dyne.org's Ethereum based [fabchain](http://test.fabchain.net:5000/).

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
  "W3C-DID": {
    "@context": [
      "https://www.w3.org/ns/did/v1",
      "https://dyne.github.io/W3C-DID/specs/EcdsaSecp256k1_b64.json",
      "https://dyne.github.io/W3C-DID/specs/ReflowBLS12381_b64.json",
      "https://dyne.github.io/W3C-DID/specs/SchnorrBLS12381_b64.json",
      "https://dyne.github.io/W3C-DID/specs/Dilithium2_b64.json",
      "https://w3id.org/security/suites/secp256k1-2020/v1",
      "https://w3id.org/security/suites/ed25519-2018/v1",
      {
        "Country": "https://schema.org/Country",
        "State": "https://schema.org/State",
        "description": "https://schema.org/description",
        "url": "https://schema.org/url"
      }
    ],
    "Country": "FR",
    "State": "NONE",
    "alsoKnownAs": "did:dyne:fabchain:BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=",
    "description": "restroom-mw",
    "id": "did:dyne:id:BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=",
    "proof": {
      "created": "1656940750354",
      "jws": "eyJhbGciOiJFUzI1NksiLCJiNjQiOnRydWUsImNyaXQiOiJiNjQifQ..qAcwEbtzjd4RwC3fTlUDkMx0uoM2SUOXBhv-spAZ8NRaMmRFXKQsez8eHGdIMKQMGJhNAn8V7KDhHA8zaxVmAg",
      "proofPurpose": "assertionMethod",
      "type": "EcdsaSecp256k1Signature2019",
      "verificationMethod": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=#key_ecdsa1"
    },
    "service": [
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-announce",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-announce",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#ethereum-to-ethereum-notarization.chain",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/ethereum-to-ethereum-notarization.chain",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-get-identity",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-get-identity",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-http-post",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-http-post",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-key-issuance.chain",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-key-issuance.chain",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-ping",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-ping",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#sawroom-to-ethereum-notarization.chain",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/sawroom-to-ethereum-notarization.chain",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-get-timestamp",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-get-timestamp",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-update",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-update",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-get-signed-timestamp",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-get-signed-timestamp",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-sign-dilithium",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-sign-dilithium",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-sign-ecdsa",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-sign-ecdsa",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-sign-eddsa",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-sign-eddsa",
        "type": "LinkedDomains"
      },
      {
        "id": "did:dyne:zenswarm-api#zenswarm-oracle-sign-schnorr",
        "serviceEndpoint": "https://swarm1.dyne.org:20003/api/zenswarm-oracle-sign-schnorr",
        "type": "LinkedDomains"
      }
    ],
    "url": "https://swarm1.dyne.org",
    "verificationMethod": [
      {
        "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
        "id": "did:dyne:id:BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=#key_ecdsa1",
        "publicKeyBase64": "BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=",
        "type": "EcdsaSecp256k1VerificationKey_b64"
      },
      {
        "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
        "id": "did:dyne:id:BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=#key_reflow1",
        "publicKeyBase64": "E+QVn6d+mrTDPl8g/a98CL9K+CVG1LRG1mdFvYb1nhAFHtMOVw+t3Y6gc+zzTKO7AFRwHyaYI9moXCKanHdcLS37+ebRuxoxB9qOwZhPM6IWJj9opQPdql8xdMz7T1yKBHnq7uy4rkywwUkSgG32nQXA7zPJKwHq+ieLaD65ePzi1n21L1vjIlNBVVDTjGmHD3/xTmgxSVcM8eYswOBSxv+EsU6YhAj9EAgp+OoTW2h7bSIPTXgI8i1COtcw2emA",
        "type": "ReflowBLS12381VerificationKey_b64"
      },
      {
        "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
        "id": "did:dyne:id:BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=#key_schnorr1",
        "publicKeyBase64": "D54MEEyah5gC76dQscft9ggFt29tENpcp4Ms+6z5ZBaChQeu3iZee5/81Mq9MJEg",
        "type": "SchnorrBLS12381VerificationKey_b64"
      },
      {
        "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
        "id": "did:dyne:id:BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=#key_dilithium1",
        "publicKeyBase64": "WR6I8Y2/D7pN9wUypkNqoG1ivSozcezyLTovGDBpJYxn3PIO7m2sDJYHx8cr9tJVpCcpdSdregQEWG7iHdgyMwXic60JajTQfifyZCHOStJRYwEXKBA36fMnu/0rK6kjGjImXCGIfGO8gDdvVtWe1x2HmN4XBoLsE+J7Qbwqir+qub3AssQKg+xyq/4DYRGyrqG0kiablY5RaUR66eaVVORgTR2eHza58nf/iCDUkol3Y//yM8CS7BS4bPh+ARd+3Dk2P++XLXzi8kV4Vrj5S4nIVv7D5AbPBUYQc6uTKyw7ybhON2x21MHGWfF0s83J4P1h/yMtObnYg9DxJQAHGZrpc6RvH2fND2hUB0PobdrzRQLz79jm+Pn1oFbhq7LsQep6CFsO2iqQquab3Qes41W16V3gVd2aNtzhbTqaTRr+hU7/T8bYf0dv1r0jZuZvaMnfpbiPpesQ0izSh7lO1l7TrMHNZbVPU/vB9P53stGuqcEXrsmz6W/ExoVCusj2L6DCMo3q2y42XRT2tA3JXsjMrFJKzc2DI1UdOkOuP7jzuc9WxlwFSTHvIdZDrG8SuWiRZYGda6ZzQBvCPgkqpaDRmsZvrC4IGNFeuAcedNZWMI6W+fvw+csOToLOwRUqUmJqhrjjc8dZ0EfyKM34PMp1z8TKcPh/wUWeXOZ6HJCfbEcyNZHNpBXtabhA/bMS3dhVnUR2hDgF5/Ch3wgevXB22VlpQECkRIFkZ6C3q8MD5mVIVQ9hSsHp9hy/mqzCkuRiIrVNfDEglgpMJCtimX5l0prnQPyB5I1B2zWNNJDxuzFGhRn7Nuj5l7Xq0rJN+wa5JlPQmOrTR55YKWi5HrP/r3Z6VAanf23fsWuaNayIDhsDv21Jgg3x+vo2aCx5kuYPnx67ci/3CDOK8YRfAHKuZm2LojEs0GB+FW4H71wQW/46p7LKlvHbU4/XjZFaW3gbrErKIlSVj4eL3kxi9/eCXEoRSueLBips/RWnS+Nrttf6jFLogOyJERFmLYMq+RpC2oViPgRDc3AGfsMlkJUrDY71LkrxbfMCAJXC94OE6A4egUzZTOkch/6dVWSLvOEX4z8ojSEyS5EwlOuVLoa9p+k+VqNRniqGXgto7083RKFu+6HGfQ5HG4CBurpzm7FJ3POM5h246urjyXB6CYVb7qgIa0MhjdNqAZSX+Uhwl0z/Q329vqbM4OZfO3tPO2M6TCPKDb/fcao22bYoNx4P0WfGGtHlzw8TpSQLPnsLpGX7da7LLKsBty2EDCElSlyGDWpoALNui02SGsAiSSF7MDg/ili/GJrYUPlV336X/hg/qqmd+gTVWK88qSyF6NEf7+jMxyHw4a7O7wrRi+PuzH1OJYSTINYGFIwc22MwDZ01gN38s/9i72FQQnI+7Jybt06JZtu/l9cnJp+17qmnZYGskswF1FM6YFGiIxS2++NmW9Vj1iIb1atpcfc9nU7P3RzgOy39Pcc3LH/32eN38Gc4oGB6t2uGqK0UeYAm+hj17+rGrOQGAd4FnJTWmk2euRuGtzU3Xps4YNIxU5kVEe1zMGyb+ueZGLRfu8CsLXqKv8jDWd19Ek1cSceUgUUhdJFXdu4gpiSw4w+QkSrok3A/4dYa30/W/SSyBbDRZ1U2p2ANYhz04oTJe1fEvasf9P9EQsArxQQMPMSdozhHiR3DJ8eks927/eT6YHUzUyL3PgvnOBlmsNxjJQEWARG9eC2NdD+Nvw/L/xZBdg==",
        "type": "Dilithium2VerificationKey_b64"
      },
      {
        "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
        "id": "did:dyne:id:BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=#key_eddsa1",
        "publicKeyBase58": "FFB2sQifRQNRLmetRroJ8PvcudBxBuRoYQpMSYdQhg6L",
        "type": "Ed25519VerificationKey2018"
      },
      {
        "blockchainAccountId": "eip155:1717658228:0xe785f9e188f8137ec13ecea52ed753d4c7c7c064",
        "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
        "id": "did:dyne:id:BKQKsKZsau62MJAk3nsEK/NoKdS80+a0j7TezfbwrWdAEPJzWk5/yAPldkVL3eiQkz3x2z6FDcIex7cu9W5aYf8=#fabchainAccountId",
        "type": "EcdsaSecp256k1RecoveryMethod2020"
      }
    ]
  }
}
```

Below is an exampled of a DID Document resolved using the DID contained in "alsoKnownAs": 


```json
{
	"id": "did:dyne:id:BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=",
	"txid": "94d5a744e8a4d8153cda90a900fdeba5b763a945411f3f7ebe33c7d54b91bbf0"
}
```


The "alsoKnownAs" can be resolved by querying the resolve API: 

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/W3C-DID-resolve-alsoKnownAs' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {"alsoKnownAs": "94d5a744e8a4d8153cda90a900fdeba5b763a945411f3f7ebe33c7d54b91bbf0"},
  "keys": {}
}'
```
