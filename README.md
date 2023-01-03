# W3C-DID
[Dyne.org](http://dyne.org/) W3C-DID implementation. 

The documentation of the W3C-DID Document specs is at [https://dyne.github.io/W3C-DID/](https://dyne.github.io/W3C-DID/)

The OpenAPI of the W3C-DID controller can be seen at [https://did.dyne.org/docs/](https://did.dyne.org/docs/)


<a href="https://dyne.org">
   <img src="https://files.dyne.org/software_by_dyne.png" width="222">
</a>


# Quickstart

Users need not to run a DID, but can use our official instance at https://did.dyne.org/docs

To run a local instance however, make sure npm is installed and use:
```
make install-deps
make run-local
```

To generate DID documents one needs registered ECDH and EDDSA public keys to be listed inside an admin DID document, i.e: `did:dyne:DID-spec.A` or `did:dyne:admin`.

To run simple tests one can generate a fake keyring:
```
zenroom -k client/v1/did-setting.json -z client/v1/sandbox/sandbox-keygen.zen > sandbox-admin-keyring.json`
```
that is associated to the DID document whose DID id [did:dyne:sandbox.A:8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ](/data/sandbox/A/8REPQXUsFmaN6avGN6aozQtkhLNC9xUmZZNRM7u2UqEZ).

This fake keyring is able to write inside `did:dyne:sandbox` for testing purposes (saved data will be lost once in a while!)

To test the creation of a DID document on the local running instance:
```
make generate-sandbox-did-local
```

## DID document specs

We call "DID spec" any word following the `did:dyne:` namespace. DID specs are governed by specific [contracts subdirectories](/api/v1) carrying the same name.

Any "DID spec" has one or more admins that have the permission to create, update or delete the DID document under their "DID spec". These admins can be recognized from their DID, indeed it will be of the from `did:dyne:DID-spec.A:` and they will govern all the DID documents whose DID starts with `did:dyne:DID-spec:`.

For example `did:dyne:zenflows.A` manages DIDs for the `did:dyne:zenflows:` namespace.

The special `did:dyne:admin` spec is the one governing all admin specs and can create, update and delete admins.

<!-- Controller has no more a keyring! can be eliminated or it will be usefull when notarization will be back?
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
-->

