# Dyne.org Decentralized Identifiers

Welcome to our free and open source implementation of the decentralized identifier standard [[DID-PRIMER]] by the World Wide Web Consortium (W3C), a global community that works on the development of web standards. Our implementation features the use of [Zenroom](https://zenroom.org) a portable virtual machine for smart-contract language execution that can process simple human-like language (Zencode) making it easy to manage data transformations and cryptographic operations.

Decentralized identity is a new way of managing identity and personal data that **empowers individuals and gives them control over their own information**. With our software you can create and manage your own decentralized identity, and use it to interact with a variety of online services and applications.

Zencode is a key part of our implementation, as it allows to easily express complex data transformation and cryptographic operations in a way that is easy to understand and write. This makes it possible for you to customize and **manage your decentralized identity without needing to have advanced technical knowledge**.

In this documentation, we will provide an overview of the decentralized identity standard and how our implementation works, as well as a detailed guide to using Zencode to manage your decentralized identity. We will also provide examples and best practices for using our implementation to its full potential.

Thank you for choosing our decentralized identity solution. We hope that it empowers you to take control of your own identity and personal data.

## Our W3C DID implementation supports: 
* A list of API endpoints, as an array “serviceEndpoint”.
* Geolocation fiels as “Country” and “State”
* Public keys for:
  * Secp256k1 ECDSA, widely used for single signatures
  * ED25519 EDDSA widely used for single signatures
  * BLS381 [“Reflow”](https://medium.com/think-do-tank/reflow-crypto-material-passports-for-the-circular-economy-d75b3aa63678), for multisignature and advanced zero-knowledge proof operations
  * Dilithium2, for [quantum-proof signatures](https://medium.com/think-do-tank/quantum-proof-cryptography-e23b165b3bbd)
  * Ethereum public addresses (“blockchainAccountId”), following the eip155 standard 
* The DID whose document contains the txId on Ethereum-based blockchain ganache where the DID document was stored, stored in the string “alsoKnownAs”
* The JWS signature of the DID Document operated by the [Controller](https://did.dyne.org/docs/) inside the "proof"

To have more information about the specification of our DID method you can jump to the [Specification Section](specification.md?id=specification). 

If you are more interested in understanding what type of keys we have used inside the DID document you can visit our [Security Vocabulary](security.md).
