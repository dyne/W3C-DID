# W3C-DID
[Dyne.org](http://dyne.org/) W3C-DID implementation. 

The documentation of the W3C-DID Document specs is at [https://dyne.github.io/W3C-DID/](https://dyne.github.io/W3C-DID/)

The OpenAPI of the W3C-DID controller can be seen at [https://did.dyne.org/docs/](https://did.dyne.org/docs/)

[![software by Dyne.org](https://files.dyne.org/software_by_dyne.png)](http://www.dyne.org)

# Quickstart

Users need not to run a DID, but can use our official instance at https://did.dyne.org/docs

To generate DID documents one needs a keyring and its registered EDDSA public key to be listed in an admin did, i.e: `did:dyne:operator`

To run simple tests one can generate a fake key: `zenroom -z private_contracts/fake_keygen.zen > client_keyring.json`

The public key of this fake key is able to write inside `did:dyne:sandbox` for testing purposes (saved data will be lost once in a while!)

> TODO: example of curl to use client_keyring.json for CRUD operations on did:dyne:sandbox DIDs

## DID document specs

We call "DID spec" any word following the `did:dyne:` namespace. DID specs are governed by specific [contracts subdirectories](/contracts) carrying the same name.

Our DID implementation makes available some base DID specs to enable authenticated operators (`did:dyne:operator`) to register generic DID documents (`did:dyne:generic`).

We have also project specific implementations that introduce ad-hoc schemas like `did:dyne:zenflows`) manages DIDs for the `did:dyne:ifacer` namespace.

So far we have:

| did spec | admin spec |
|:--------:|:----------:|
| generic  | operator   |
| ifacer   | zenflows   |
| sandbox  | (fake)     |

The special `did:dyne:elohim` spec is the one governing all admin specs and can create, update and delete admins.

## Controller Keyring (setup once)

Inside the [private_contracts](private_contracts) are the scripts to generate the primary controller keyring whose ECDH key will be used to sign all DID documents and whose ECDH public key can be used to verify their integrity.

These keys will help govern further generation of DIDs: the secret keys will be needed to sign any DID creation on a system that has just started.

You can optionally create a keyring manually: `zenroom -z private_contracts/create_keys.zen`

The Controller keyring should look like this: 

```json
{
   "Issuer": {
      "keyring": {
         "ecdh": "k3amvcaPJNSbVbK0eNh83c7k8OZqSklaPCfbnUGMDvc=",
         "eddsa": "349aphSypm5b6YgC8M8hd7zT9mKhJg1tJxxuGscyN9TR",
         "ethereum": "0f06a1a546612a53380c7e47755de9b7a6b2fdd55e382fd39d48d2b862a55bfd"
      }
   }
}
```

The keyring has to be stored into: `contracts/keyring.json`

The public keys should be generated with: `zenroom -z private_contracts/create_pub_keys.zen`
and stored in `contracts/public_keys.json`


