# Specification

## Abstract

The first focus for the Dyne.org's DID method was to register [Zenswarm Oracles](https://github.com/dyne/zenswarm) identities, in a way that is both machine and human readable. We have introduced some new classes and properties to cover all the public keys that we are using inside the DID document, including also a **post quantum** public key. The DID Document and the DID are respectively stored and resolved by our [Controller](https://did.dyne.org/docs/).

<!-- To be added as soon as notarization is back
 who also notarizes the DID Document on creation, update and removal on [planetmint blockchain]().
-->



### State of the document 

This is a draft document and will be updated.

## DID Method Name

The namestring that shall identify this DID method is: **dyne**.

A DID that uses this method *MUST* begin with the following prefix: **did:dyne**. Per the DID specification, this string *MUST* be in lowercase.

## Method Specific Identifier

Dyne DIDs is a URI conformant with [[RFC3986]] specification. The ABNF definition of our DIDs can be found in the following specification which uses the syntax provided in both [[RFC5234]] and [[RFC3986]] specifications:
```
dyne-did   := did:dyne:<idspec>:<idchar>
idspec     := *(ALPHA) *1("." *(ALPHA)) *1("_" 1*1(permission))
permission := "A" / "C" / "U" / "D" / "T"
idchar     := 1*44(base58char)
base58char := "1" / "2" / "3" / "4" / "5" / "6" / "7" / "8" / "9" / "A" / "B" / "C"
              / "D" / "E" / "F" / "G" / "H" / "J" / "K" / "L" / "M" / "N" / "P" / "Q"
              / "R" / "S" / "T" / "U" / "V" / "W" / "X" / "Y" / "Z" / "a" / "b" / "c"
              / "d" / "e" / "f" / "g" / "h" / "i" / "j" / "k" / "m" / "n" / "o" / "p"
              / "q" / "r" / "s" / "t" / "u" / "v" / "w" / "x" / "y" / "z"
```

The permission characters are used to define the power of a did document on other did documents with the same did domain:
- **A** identifies domain admins that have all the admin power listed below.
- **C** identifies domain admins that have the power only to create.
- **U** identifies domain admins that have the power only to update.
- **D** identifies domain admins that have the power only to deactivate.
- **T** identifies domain admins that have the power only to make transactions.

For the moment the main used prefix are:
- <b>did:</b><b>dyne:</b><b>sandbox:</b> that is used for testing purposes.
- <b>did:</b><b>dyne:</b><b>ifacer.main:</b> that is used in our [zenflows project](https://github.com/interfacerproject/zenflows) to create the user identity.
- <b>did:</b><b>dyne:</b><b>ifacer.main_A:</b> that is used in our [zenflows project](https://github.com/interfacerproject/zenflows) to create the admin identity.

An example of Dyne.org's DID is:
```
did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ
```
that is associated to the following DID document:
```json
{
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
  "description":"matteo",
  "id":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g",
  "proof":{
    "created":"1677163739984",
    "jws":"eyJhbGciOiJFUzI1NksiLCJiNjQiOnRydWUsImNyaXQiOiJiNjQifQ..7ePFQRqvnUX29PzkQYsIvL3u3UsG6ld2nJXLEDLaRDqRqitSbPy2Xm-LNJmXtE20-iJEzkX_EV93q3Pyy7FUew",
    "proofPurpose":"assertionMethod",
    "type":"EcdsaSecp256k1Signature2019",
    "verificationMethod":"did:dyne:sandbox.test_A:CoQ5W5wxi4SCMJK8Rjxfy52TyVRCECb7JiYXCemcZGBH#ecdh_public_key"
  },
  "verificationMethod":[
    {
      "controller":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g",
      "id":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g#ecdh_public_key","publicKeyBase58":"NgctHrSPYRuYgbmfYqa9cBqwdjbVMkbyDuf21XKqP7uzNx3wsCNupWTSeuPnaBxpEZ6QRXQ9EPzBiMc2ei6wT4Jr",
      "type":"EcdsaSecp256k1VerificationKey2019"
    },
    {
      "controller":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g",
      "id":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g#reflow_public_key",
      "publicKeyBase58":"C78nKxqaYSEf1BxyZyysTT75QySD4yAjAUAJQoRdgmHmndBNgpvso5p8VJqm8j3L7RRPqDoYNrCQGd3umkAUQddsMn8xL3hqwh2Z7uzdwo2f422edhUmnv5pECyNBzNjyBPKHr9pVHAvjzH9AxRJCBHALdwG7tXBLkp9p8kxU8A1YYebrXZabdN62FLLyPiQaqGjTJnPDjGcAe26JH2SLSqXn6tAfbGppH2NpdRfYSCW3xWo7k2YWkVn4ACGHqkjG8WoQR","type":"ReflowBLS12381VerificationKey"
    },
    {
      "controller":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g",
      "id":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g#bitcoin_public_key",
      "publicKeyBase58":"pWLhCz4CaxNrSQWnywHsDhbAkXtNkdD8HqX5a9DyAxiK",
      "type":"EcdsaSecp256k1VerificationKey2019"
    },
    {
      "controller":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g",
      "id":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g#eddsa_public_key",
      "publicKeyBase58":"HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g",
      "type":"Ed25519VerificationKey2018"
    },
    {
      "blockchainAccountId":"eip155:1:0xd7614a1afd45343a2542e5beb7df6d88f001663d",
      "controller":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g",
      "id":"did:dyne:sandbox.test:HtD277sgEGRPeqv2FYE6mrdwePtvxJ9jq4dZe1UTE48g#ethereum_address",
      "type":"EcdsaSecp256k1RecoveryMethod2020"
    }
  ]
}
```
## Method Supported Metadata

The informations about the DID document are store in the DidDocumentMetadata field outstide of the DID document, for example the above did document is associated with the following metadata:
```json
{
  "created":"1677163739984",
  "deactivated":"false",
  "planetmint":[
    "a8f9bceba0962b0e7e3db7d3196e9db97ec2e5d75e1b0cbcd3fdf6a6eab44844"
  ]
}
```
### Operation Timestamp
Metadata includes information such as the timestamp (unix time) the document was created, the timestamp (unix time) it was last modified.

### Deactivated
If a DID document has been deactivated, *i.e.* **deactivated** field is set to true, it means that it is no longer active or available for use. This mean that the DID associated to the DID document can not be used anymore to prove the user identity under any circumstance.

### Transaction ids
Moreover the metadata contains an array of transaction ids over planetmint, named **planetmint**, where each transaction store the hash of the did document along with its metadata. These transactions are performed at creation, update and deactivation.
The transaction ids are sorted by time, *i.e.* the first one will represent the creation, while the last one, if the deactivated filed is set to true, will be the deactivation.
#### How to use the transaction ids
Since the transaction id is known only after the transaction is performed, then in order to verify the correctness of the did document through the use of planetmint the following steps have to be executed:
- resolve the DID document through the resolver.
- use the last transaction id, found in the **planetmint** array in the metdata, to retrieve the hash from the planetmint blockhain.
- remove the transaction id used in the previous step from the **planetmint** array in the metadata and compute the hash of the result.
- compare the two hases, they must match.

Pay attention, if only a transaction id is found then remove only the value, but not the list, *i.e.* it should look like this:
```json
{
  "created":"1677163739984",
  "deactivated":"false",
  "planetmint":[]
}
```

## CRUD Operation Definitions

CRUD operations refer to the four basic functions that are commonly used to manipulate data in a database or system. These operations are:
- **Create**: This operation is used to create new data, such as adding a new document or record to a database.
- **Read**: This operation is used to read or retrieve data from a database or system. Reading data does not modify or change the data in any way.
- **Update**: This operation is used to update or modify existing data in a database or system.
- **Delete**: This operation is used to delete or remove data from a database or system.

In this moment all the CRUD operations, execpt for the Reading operation, are permissioned. This means that Create, Update and Delete operations are restricted to certain users or groups of users. In other words, only users who have been granted permission can perform these operations.

This permissioned system is set up following a linear hierarchy and the level of each user in this hierarchy is defined inside their own DID. There are mainly four levels:
- **admin**: its DID starts with <b>did:</b><b>dyne:</b><b>admin:</b>. It posses the master key needed to create all the other DID documents.
- **second-level admins**: its DID starts with <b>did:</b><b>dyne:</b><b>domain_A:</b> where *domain* can be any alphabetic string. They can create, update and delete any did document whose DID starts with <b>did:</b><b>dyne:</b><b>domain.ctx_A:</b>, <b>did:</b><b>dyne:</b><b>domain.ctx:</b> and <b>did:</b><b>dyne:</b><b>domain:</b>, where *ctx* can be any alphabetical string and represent the context. The power of these second-level admins can also be reduced to a single operation using the following notation:
   - <b>did:</b><b>dyne:</b><b>idspec_C:</b> can only create DID documents
   - <b>did:</b><b>dyne:</b><b>idspec_U:</b> can only update DID documents
   - <b>did:</b><b>dyne:</b><b>idspec_D:</b> can only delete DID documents
- **second-level context specific admins**: its DID starts with <b>did:</b><b>dyne:</b><b>domain.ctx_A:</b> where *domain* and *ctx* can be any alphabetic string. These admin are *context specific admin* and they can only create, update and delete only DID document under the same context, *i.e.* DID documents whose DID starts with <b>did:</b><b>dyne:</b><b>domain.ctx:</b>. Also in this case their power can be reduced to a single operation as for the second-level admins.
- **participants**: their DID starts with <b>did:</b><b>dyne:</b><b>domain.ctx:</b> or <b>did:</b><b>dyne:</b><b>domain:</b> and they can not perform any operation on DID documents, excpet for reading.

### DID Document Creation

As stated before, this operation is permissioned, thus in order to create a DID document a secret keyring is needed. In order to create a second-level (or a second-level context specific) admin DID document the admin keyring is needed, while in order to create a participant DID document a second-level (or a second-level context specific) admin keyring is needed. Once the user creates the DID document the latter has to be encoded into a string removing all new lines and withespaces (outside of the values of DID document) and escaping double quotes and backslashes. Finally an eddsa signature of this string is computed to certify that on receipt the DID document has not been tumpered with.

In order to avoid reply attack a second signature is needed. This time the DID document along with a timestamp are inserted into a dictionary, also in this case the dictionary is encoded into a string and finally ecdh signed.

Thus at the end of the clinet side creation of the DID document, the client will end up with a DID document, a ecdh signature, a timestamp, a eddsa signature and the DID of the signer. This should look like this:

```json
{
  "did_document": {
    "@context": [
      "https://www.w3.org/ns/did/v1",
      "https://w3id.org/security/suites/ed25519-2018/v1",
      "https://w3id.org/security/suites/secp256k1-2019/v1",
      "https://w3id.org/security/suites/secp256k1-2020/v1",
      "https://dyne.github.io/W3C-DID/specs/ReflowBLS12381.json",
      {
        "description": "https://schema.org/description"
      }
    ],
    "description": "Alice",
    "id": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV",
    "verificationMethod": [
      {
        "controller": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV",
        "id": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV#ecdh_public_key",
        "publicKeyBase58": "PFJZ6vu7p1bDMaAE28Shkgydd2NwPy8n1KZdH3yTSYYtyXVc8jSVoXZqu7GFK7UTozUvkGyZkDPcroKEVAThrFPF",
        "type": "EcdsaSecp256k1VerificationKey2019"
      },
      {
        "controller": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV",
        "id": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV#reflow_public_key",
        "publicKeyBase58": "DxNbADPkQnsJuTsu7E4orFYT175sios3Kuh3L5ssECgJeotUBaRtWqZuqk52QT97YTfNo4a5FZ5ibv3pX3BR4Ci5FPeXWV5J9U8Y4AnZHkP6iVRgfw2swnf6gtVBfFjoboKcn2UokDqq2wLE3cgzxU7zdAzV7rurPxpbeuQH7tXQbNSc7bwzJq8vjwP8bADtUQyfpqCGMNeP1VnacP2AHojBXfhRazAwWv7xcuthLpyp2q5Jh1pHZL4qSRKGPf6qNXyX8D",
        "type": "ReflowBLS12381VerificationKey"
      },
      {
        "controller": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV",
        "id": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV#bitcoin_public_key",
        "publicKeyBase58": "dQz3xoUpQWkqVutfKyY1U1VwyACWUyBXaYExh7DZNv3p",
        "type": "EcdsaSecp256k1VerificationKey2019"
      },
      {
        "controller": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV",
        "id": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV#eddsa_public_key",
        "publicKeyBase58": "CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV",
        "type": "Ed25519VerificationKey2018"
      },
      {
        "blockchainAccountId": "eip155:1:0xdb26948a4d17061c0d8242822423738bf16ee1ce",
        "controller": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV",
        "id": "did:dyne:sandbox:CmR8HZwNaV3Xw7ZVdvaa4oQDmsiVmoiULEiWJABe7EHV#ethereum_address",
        "type": "EcdsaSecp256k1RecoveryMethod2020"
      }
    ]
  },
  "ecdh_signature": {
    "r": "5w8hD5GYbQUr7ytBrmTY1GhAZryKuyxQK1fLbady15Ev",
    "s": "AjCmqMXUXBD1Wc66nFabcnTxRodpHTcFepcyHLwRGoiS"
  },
  "eddsa_signature": "54jSisfb17KqjYuDsUn4rdGkmAoJFUAA4aRVHW75sa7chAWoBTpJiGSdUxegfTKQpVi7UoNFuteVEtCndKwBKaMp",
  "id": "did:dyne:sandbox_A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ",
  "timestamp": "1672319885685"
}
```

All these informations are now sent to the Dyne's DID server that will verify the signatures and the timestamp and create a new DID document. Moreover the ecdh signature will be converted into a jws signature and inserted inside the DID document proof in order to matain its integrity.
Thus the last step from a Client prospective is an *HTTP POST* that will be of the form:

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/v1/sandbox/pubkeys-accept.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {
     "did_document": { ... },
     "ecdh_siganture": "...",
     "timestamp": "...",
     "eddsa_signature": " ... ",
     "id": " ... "
  },
  "keys": {}
}'
```

### DID Document Read

To read the DID document associated with a DID, you simply have to perform an *HTTP GET*:
```bash
curl -X 'GET' \
 'https://did.dyne.org:443/dids/<DID>' \
  -H 'accept: application/json'
```
It resolve the DID into a DID document, if it is found. For example the DID 
```
did:dyne:sandbox_A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ
```
can be resolved with:
```bash
curl -X 'GET' \
  'https://did.dyne.org:443/dids/did:dyne:sandbox_A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ' \
  -H 'accept: application/json'
```

### DID Document Update

As stated at the beginning also this operation is permissioned. The procedure is almost identical to the creation one: a new updated DID document is created by the client, that encodes it as a string and sign the latter with an admin or second-level admin ecdh key, creating an ecdsa siganture. As before we also sign it along with a timestamp to avoid reply attacks creating an eddsa signature. Then an *HTTP POST*, of the following form, is performed:

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/v1/sandbox/pubkeys-update.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {
     "did_document": { ... },
     "ecdh_siganture": "...",
     "timestamp": "...",
     "eddsa_signature": " ... ",
     "id": " ... "
  },
  "keys": {}
}'
```

### DID Document Revocation

To revocate/deactivate a DID document, it is enough to perform a *HTTP POST* request as follow where the **deactivate_id** is the DID to be deactivated, the **ecdh signature** is its ecdh signature using the admin or second-level admin ecdh key and the **id** is te signer DID:

```bash
curl -X 'POST' \
  'https://did.dyne.org:443/api/did-deactivate.chain' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "data": {
     "deactivate_id": "...",
     "ecdh_signature": "...",
     "id": "..."
  },
  "keys": {}
}'
```

The did document will not be removed, but inside its metadata the field **deactivated** will be set to **true** and it will not be possible for this DID document to perform any operations.

## Security Considerations

- DID documents are stored from the Server on filesystem and any change is tracked using git and logifles, thus any change can be track and controlled.
- DID documents use ECDSA signature technology to prevent tampering.

## Privacy Considerations

- No personally identifiable information (PII) is included in a DID document retrieved by Dyne.org's DID resolver.
- The private key only exists on the user's device and will not be known to any third party.

<!-- To be added as soon as notarization is back
- DID Document details published on the blockchain ledger are necessary only for authentication by other parties
-->
