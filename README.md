# W3C-DID
Dyne.org's W3C-DID implementation

The first focus for the driver was to register [Zenswarm Oracles](https://github.com/dyne/zenswarm) identities, in a way that is both machine and human readable. We haven’t been able to use the standard specs to record public keys, since we found the existing standards incomplete or incompatible. We also have been unable to find a standard to record a Dilithium2 (quantum-proof) and Schnorr public keys, that we created according to the best practices we are aware of.
The DID and the DID Document are produced and resolved by our [Controller](https://did.dyne.org/docs/), who also notarizes the DID Document on Dyne.org's Ethereum based [fabchain](http://test.fabchain.net:5000/).

The content of DID document includes: 
* All the API endpoints of each Oracle, as an array “serviceEndpoint”. 
* The “Country” and the “State”
* Public keys for:
  * Secp256k1 ECDSA, widely used for single signatures
  * BLS381 “Reflow”, for multisignature
  * BLS381 “Schnorr”, currently only for single signatures
  * Dilithium2, for quantum-proof signatures
  * The ethereum address owned by the Oracle, in a string named “blockchainAccountId”, following the eip155 formatting standard 
* The DID whose document contains the txId on our Ethereum-based “Fabchain” where the DID was stored, stored in the string “alsoKnownAs”
* The JWS signature of the DID Document operated by the [Controller](https://did.dyne.org/docs/) inside the "proof"

Below an example Oracle's W3C-DID Document following our specification:


```json
  {
      "@context": [
        "https://www.w3.org/ns/did/v1",
        "https://dyne.github.io/W3C-DID/specs/EcdsaSecp256k1_b64.json",
        "https://dyne.github.io/W3C-DID/specs/ReflowBLS12381_b64.json",
        "https://dyne.github.io/W3C-DID/specs/SchnorrBLS12381_b64.json",
        "https://dyne.github.io/W3C-DID/specs/Dilithium2_b64.json",
        "https://w3id.org/security/suites/secp256k1-2020/v1",
        {
          "Country": "https://schema.org/Country",
          "State": "https://schema.org/State",
          "description": "https://schema.org/description",
          "url": "https://schema.org/url"
        }
      ],
      "Country": "DE",
      "State": "NONE",
      "alsoKnownAs": "did:dyne:fabchain:BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=",
      "description": "restroom-mw",
      "id": "did:dyne:id:BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=",
      "proof": {
        "created": "1656592200368",
        "jws": "eyJhbGciOiJFUzI1NksiLCJiNjQiOnRydWUsImNyaXQiOiJiNjQifQ..eqmJ3CStrY0ePRiwPMGTNwqKavxcduSZvfjIJGHULeNJosIPbI-0mj_43wwN-WcHMmZI6ZWg7Lhj2A7y4np0Cg",
        "proofPurpose": "assertionMethod",
        "type": "EcdsaSecp256k1Signature2019",
        "verificationMethod": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=#key_ecdsa1"
      },
      "service": [
        {
          "id": "did:dyne:zenswarm-api#zenswarm-oracle-announce",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/zenswarm-oracle-announce",
          "type": "LinkedDomains"
        },
        {
          "id": "did:dyne:zenswarm-api#ethereum-to-ethereum-notarization.chain",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/ethereum-to-ethereum-notarization.chain",
          "type": "LinkedDomains"
        },
        {
          "id": "did:dyne:zenswarm-api#zenswarm-oracle-get-identity",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/zenswarm-oracle-get-identity",
          "type": "LinkedDomains"
        },
        {
          "id": "did:dyne:zenswarm-api#zenswarm-oracle-http-post",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/zenswarm-oracle-http-post",
          "type": "LinkedDomains"
        },
        {
          "id": "did:dyne:zenswarm-api#zenswarm-oracle-key-issuance.chain",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/zenswarm-oracle-key-issuance.chain",
          "type": "LinkedDomains"
        },
        {
          "id": "did:dyne:zenswarm-api#zenswarm-oracle-ping.zen",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/zenswarm-oracle-ping.zen",
          "type": "LinkedDomains"
        },
        {
          "id": "did:dyne:zenswarm-api#sawroom-to-ethereum-notarization.chain",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/sawroom-to-ethereum-notarization.chain",
          "type": "LinkedDomains"
        },
        {
          "id": "did:dyne:zenswarm-api#zenswarm-oracle-get-timestamp.zen",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/zenswarm-oracle-get-timestamp.zen",
          "type": "LinkedDomains"
        },
        {
          "id": "did:dyne:zenswarm-api#zenswarm-oracle-update",
          "serviceEndpoint": "https://swarm0.dyne.org:20003/api/zenswarm-oracle-update",
          "type": "LinkedDomains"
        }
      ],
      "url": "https://swarm0.dyne.org",
      "verificationMethod": [
        {
          "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
          "id": "did:dyne:id:BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=#key_ecdsa1",
          "publicKeyBase64": "BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=",
          "type": "EcdsaSecp256k1VerificationKey_b64"
        },
        {
          "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
          "id": "did:dyne:id:BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=#key_reflow1",
          "publicKeyBase64": "DU6n8mU6lP8mpOeQxv4FVhACrRhnsxQoQMkIZPd3YXiLmHM60suxO8GrKZLQRgPQEE9EWsN2x7YIoY34mIsoa5znGiOXy0alCLbRV4g73DpStjsqltVJqAXTLBCxhgHZAqbKILbCvzqUbzK6psEdG/5S8IiI8XvNYczIavAlpss++mLFRYbSKeeT6L+UIMpbA0xeSSyVuscqrKkwC7TRLJB+CCFXMMGMVs5tGZ6Xzena/Lw5WSdI8bL/04NQ++/m",
          "type": "ReflowBLS12381VerificationKey_b64"
        },
        {
          "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
          "id": "did:dyne:id:BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=#key_schnorr1",
          "publicKeyBase64": "DPYbQA/RNB6EvWHFXMkCgELOkcdPsnKcm/jYMCwlAXyp+6THRWuIntfE83urMFpp",
          "type": "SchnorrBLS12381VerificationKey_b64"
        },
        {
          "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
          "id": "did:dyne:id:BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=#key_dilithium1",
          "publicKeyBase64": "5p53NcTIe9JVCsYOR2XteffUcoK5iFMsAKnyQPp6Jr4gwWks/Q8+WlshkDC9uxWSfJxUAq5FACVzLrU6upOzhJHbmGVn6QtIXR47OfJfY5cDraj4Ln5lgGzTvUD0NGwlgJrdfQJ+ePV6D/nJlusB4N96kBp7xn8oa2DbLpQecDKm7R38evlhLh2fNRSsgy6Kia0S/Er7ufRqKfFtxHKr5SC8khktUDfvSZVTKj6EW5ymZq0I8TvdZIdMKn08T1zD14iJlY+pzqttrgX0armkwHMbt0AARsykBecnC1lzsVqIydfslAqsX1ClvhHAQG9ZrPtDJxOE3VDp8UxNHDIegZWVDHu1+wWwgVH7jOxgDDGdUyUi18jXoWjP8aWoa3MpFi924y40x8LQTmkVDNw1ep1DfHVEZVFKTdDdUhK/kmRMYsjIqTg0PJbnbN2VYVsXNvVX783iUOeTmxs79gXqGU8nvRbLspg9aQiwJfUyfRye1F1JnTSIwZWqb1SwfHWyEwjUHCyqwM6ONh13qcG55f1OldMWRRSqt3QMlwqvSK4hCg+it3Htl/iiOochxPhWjVpVwROZHi6QZdoezv0o5iy0hhilITO9S+QMT8GEaAvYryqErMU1++ooBNdOS/2miKcW2H5rTO67dyUeLFR0cxGo5jdjgKcTKONgkj542+KBcyzQBJbcFrEZ3x413797HboNJ7EwdciLm6FZk7fq4qZmDXZZS6TbGlyuMVvsqfVXkwYJ4qM8iOllo1IdlSPq7T3ylwGuKoE3NmjvR1OegiwzOj362nJ4mI892ErtIIoZaCPM5CWfqClcqQmrg/rI+Mu9sFia8HSxxi/8CMyhz5WmllYs6/0oOHy125AkVG8x6fhUyno4dfj9Xy4+PhKrdeKcakH31OwyVBEJdxCnmrtOST6svXpdE731byGxRuzmELFK6f6i/iaIJyxFTCcclX1f13Yx9jn2hIjP1LZ6JlnnQeQSM2STo71n2rbkxiyGQkN1kCKVxuLlqofiEu06NHIjsUB18KyWjBQ0DH6jnJxSwYsEExhlgXC1F9mVxEThtMV2TqkBrrGFsLpkLV6dcrn57vMKr2Ra0bIAyt2mM8JLI+f9TiZgyaG9DYZxfjlc6lKlEz2zsSX6hJUqqiv4/HOvmxSOPgZRseDnvG2gQsrCzU318dDrX6rv1oPhtvgNGK1y46FP/wVo9UNnzOcglJUDr24z2u8rElGkH3K+t0/C5b7QkCSX/Ls0mXIJBwe7EW2SiMBKiD6v+2VRZfR4wqlj0KH7VK6gbeNV52BlX4NyapZO+Nt7ZE4s1faKC2UtPt3yPdnUMcaNbwqOqW8lJuL0NZn0vvMp5/mC1kgN9CKlfkOY7IGZ7jSxroi0eH0BUrmP7YMWzWrNTr1+eEa4yabrB3iJ+F6Ds23UTIvAoo+knJeuNQZyOyNHys/Rai7lT4POY28AgczRVaFaTs/WXDALu0lGC+F7rYgOGQ/iMOaGbJVrez48l5knn6Pk4Pw/iUIwJRKG2RUuZ6JXNn5SxJBG2O/WO/d327BIriIkkOHPJbx8XjMNAo0jGH9uflq33XUYlKUdczB6rrEgMI+ZLAM/WUl84RELS1H8RT60P40IgOnfXYOAaoqzolJX+DI7uCCrrk0+Zrsm1FhkU9sJyjUbM6rVuMn2POTEBiDTJAvWlt4nMcE+1sw5gNb+3Isd0v58ZhGQK04vPvRjENtaNaV7+Z5iBOuvtsO8skQ7Qw==",
          "type": "Dilithium2VerificationKey_b64"
        },
        {
          "blockchainAccountId": "eip155:1717658228:0x67313004fa6e6c609ac1db714ce5945fc47fa2fd",
          "controller": "did:dyne:controller:BLL50JCBTKJZc+Pc5sC9cW7Feyx728h3TAEkWYIcOUZzukbPVPYIfOjDptkYIv/GGSI/XFh778eAFHtnkJppLls=",
          "id": "did:dyne:id:BDvKzXKkafOhOd4WqG5SpSK2YJKo6af6YYqZSFf+IZqfEbph8A4taXvM7oJdKcWdHy+5/XHAUl/jsMTTW/YoLrE=#fabchainAccountId",
          "type": "EcdsaSecp256k1RecoveryMethod2020"
        }
      ]
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
