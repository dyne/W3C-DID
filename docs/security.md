# Dyne.org's W3C-DID Security Vocabulary

## Classes

### ReflowBLS12381VerificationKey
This class represents a linked data signature verification key. See [reflow-BLS12381 paper](https://arxiv.org/pdf/2105.14527.pdf) for more details.

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase64*

**Example**:

```json
{
	"id": "did:example:123#reflow_public_key",
	"type": "ReflowBLS12381VerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "9kPV92zSUok2Do2RJKx3Zn7ZY9WScvBZoorMQ8FRcoH7m1eo3mAuGJcrSpaw1YrSKeqAhJnpcFdQjLhTBEve3qvwGe7qZsam3kLo85CpTM84TaEnxVyaTZVYxuY4ytmGX2Yz1scayfSdJYASvn9z12VnmC8xM3D1cXMHNDN5zMkLZ29hgq631ssT55UQif6Pj371HUC5g6u2xYQ2mGYiQ6bQt1NWSMJDzzKTr9y7bEMPKq5bDfYEBab6a4fzk6Aqixr1P3"
}
```

<!-- Old base64 public keys
### EcdsaSecp256k1VerificationKey_b64
This class represents a linked data signature verification key. It is implemented as stated [here](https://w3c-ccg.github.io/lds-ecdsa-secp256k1-2019/) with the only difference that accepts base 64 encoded public key with the proprerty [**publicKeyBase64**](#publickeybase64).

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase64*

**Example**:

```json
{
	"id": "did:example:123#key1",
	"type": "EcdsaSecp256k1VerificationKey_b64",
	"controller": "did:example:123",
	"publicKeyBase64": "BMryTzTcMC42F4dOWdXM5mVAZr0dvS0jV84oBt/SQBePhxH2p3/NilU9siTfdNWv7iPcViIPDtz3JxFiQY/Gu5s="
}
```

### ReflowBLS12381VerificationKey_b64


### SchnorrBLS12381VerificationKey_b64
This class represents a linked data signature verification key. It has been implemented following the [bitcoin-specification](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki) with the only difference that it is implemented over BLS12381 instead of Secp256k1.

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase64*

**Example**:

```json
{
	"id": "did:example:123#key1",
	"type": "SchnorrBLS12381VerificationKey_b64",
	"controller": "did:example:123",
	"publicKeyBase64": "GCz+aD+oqmm/aA9GM0mauJjEL3a2sJuTcuOGgmkqMD7869PpTHsh8VmfNvfY20p1"
}
```

### Dilithium2VerificationKey_b64
This class represents a linked data signature verification key. See the [Dilithium paper](https://pq-crystals.org/dilithium/data/dilithium-specification-round3-20210208.pdf) for more details.

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase64*

**Example**:

```json
{
	"id": "did:example:123#key1",
	"type": "Dilithium2VerificationKey_b64",
	"controller": "did:example:123",
	"publicKeyBase64": "xJ27Sc28WRK7VuDInQbb+YwtiS++tycCYGKMVmoXMmnuHO4JAFWJd+t4EwCndchQCXRlY4dh3e2Y97LfcOYC4vxYYzMx6btyhkwOeLZduKqyRco3V5M6QfnxPGdJeSOmbxoCq+Akkwg1wnOCUOhQ7KB/106w1Na+UWYuqLXtKWjrqJWyKdZx8alTn7nYDGWzr5sjnBXnTFGEpfjbiJvYcIstBd24KropNIndVxKuFvG97Kg8w4XrEknPDK1ELTJydeN9mEw7DXrMLPnmf1rILh3Fr4dVfN7ac+ujT87eqs5vRlgnBdJNuV7I/lpuoR2MX0SeqfSGtXB0ksuYPTylmYTmDg0OOzQ86Pm27Fq9VWu9QSX/7feESlY0tVFPYi0N8n+RudAFKjDyC9jy9lUOmJ5uSUCL7PAT4hsgtAhNyXdBlwEkeTwBdQPpzgyC+wYKLe8bKKRaUOrJzmRVBaZBngqKIX8olMy1R09EkcSOs/OlORQ00Mzb1lRGvAbZ7BO4N+Dd8UVlwK3W6cDp9EWrWZ1QhRktNyaUwW0bgMjiak65c9Rl3ZY8wUye/COsit1vrHkS1635wAeFFyHKPoa9pGSenhzp2weAEIWhlXJcziGMc0gfZs8UdIUxk62jhby9wDfPwz6Jn0cmeQvOWRYbYKBg/OKFAIXN4jIENZFh8fIZ3o2zli6POlifbWnTqvAa+FB/W86p+ndAhTwoSXmp1A8LYn2kUkCRGaiZAm2hUBcoa/7QVAhOoJ/zqw+zv1v789kBGG8Mww/T2gc8ZvOLS6ZBhRbnEcgOFNyXttnNzEkWXAdbO69JN3jSPBSwRxYxgeO+uGrL6UukDpjgjEvHd59jAo30zPLfX+d3qzQypikzKRZyLqBvn2LTS991JRtHWBXSQC2fGT23MlfyLnW7l0391Iz6Qcs+zxQkaroPZRc2RZTAgPpH9VxCp5CSx91hKYT4HzUuBA0+is1g5yG1k7p2qQTYPvzf292Gj6301B7+lvji9LKb1029VHS227C+rtZwlO/nauLlMUvSWgsyyw8nhnmVP0jNCDwILIUg+XQ/gUCM63N024Wooa79+52nJo2rnrq9qQzTMkHTbS+V0eajpg2HD8TfOtjJH0FNqIsinq7m4Ntrny56t+JtWkrJumVMUBd8O9c0LhuD9iYPFEhWYEUfPyO0ocnw6BLb2ehigh0cLBfAMOSIrtrZhC/PHzQM1L/zyY+WRtnBucMRWMevOS/SkxwF7coTqh8c72yimdQqHbF7clF9c6pIpL5QnobBCNj1kgBv+9M7gztyoLUZUlb1FgonS1HHEU1804BkFWZpGxalTVbpk8H5/ZXs2JT0A2FkBX1OdsgavsrxryBg3sbWrWbIDqVabrku1tH58WDZau+YY0cWEDIccoKx04I+s5fJKaxvm32SsCK9/bWzmQGQmM9LQl4P6Q3fNDQ7mVtAYbYzkYJUFtP5TV/ErTQIlJhZAHm87f6lZXllg/kWwCPB37C3W+p7OIjNFNAbfIJASQhga/1BIFBqWnViToysVCU0l4y7y1V2qhkcHAdNlsC61DyVRdbbdlF/DwpT+0mVfDmX1UUgXlqkoYDDEg03GCTrweN/7GLJAfUB3p+YRddjUK13wfy/4hd7KneEMB571pqxGH6cSUkULreVQiLhr0YzV+gwQl8IZ60pwLTZs4wBFg6U/kJY1pyQ1oCfqjGaJLYD4KjVeaoUDPDGcZsrPeP34QNpw05k+mrIwQ=="
}
```

## Properties

### publicKeyBase64
A public key Base64 property is used to specify the base64-encoded version of the public key.

**Status**:   
*stable*  
**Domain**:  
*Key*  
**Range**:  
*xsd:string*

The following example demonstrates the expression of a public key in base64 format.

**Example**:

```json
{
	"id": "did:example:123#key1",
	"type": "EcdsaSecp256k1VerificationKey_b64",
	"controller": "did:example:123",
	"publicKeyBase64": "BMryTzTcMC42F4dOWdXM5mVAZr0dvS0jV84oBt/SQBePhxH2p3/NilU9siTfdNWv7iPcViIPDtz3JxFiQY/Gu5s="
}
```
-->