# Dyne.org's DID Method

The first focus for the Dyne.org's DID method [[DID-PRIMER]] was to register [Zenswarm Oracles](https://github.com/dyne/zenswarm) identities, in a way that is both machine and human readable. We haven’t been able to use the standard specs to record public keys, since we found the existing standards incomplete or incompatible. We also have been unable to find a standard to record a Dilithium2 (quantum-proof) and Schnorr public keys, that we created according to the best practices we are aware of.
The DID Document and the DID are respectively stored and resolved by our [Controller](https://did.dyne.org/docs/), who also notarizes the DID Document on creation, update and removal on ganache blockchain, which will soon be replaced by planetmint.

The content of the Dyne.org's DID document includes: 
* A list of API endpoints, as an array “serviceEndpoint”. 
* The “Country” and the “State”
* Public keys for:
  * Secp256k1 ECDSA, widely used for single signatures
  * ED25519 EDDSA widely used for single signatures
  * BLS381 “Reflow”, for multisignature
  * BLS381 “Schnorr”, currently only for single signatures
  * Dilithium2, for quantum-proof signatures
  * The ethereum address owned by the Oracle, in a string named “blockchainAccountId”, following the eip155 formatting standard 
* The DID whose document contains the txId on Ethereum-based blockchain ganache where the DID document was stored, stored in the string “alsoKnownAs”
* The JWS signature of the DID Document operated by the [Controller](https://did.dyne.org/docs/) inside the "proof"

To have more information about the specification of our DID method you can jump to the [Specification Section](specification.md?id=specification). 

If you are more interested in understanding what type of keys we have used inside the DID document you can visit our [Security Vocabulary](security.md).
