# W3C DID Dyne Secuirty Vocabolary

## Classes

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
This class represents a linked data signature verification key. See [reflow-BLS12381 paper](https://arxiv.org/pdf/2105.14527.pdf) for more details.

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase64*

**Example**:

```json
{
	"id": "did:example:123#key1",
	"type": "ReflowBLS12381VerificationKey_b64",
	"controller": "did:example:123",
	"publicKeyBase64": "AoD1VmYjfBP0L26CpsYRnzEkaslI91uBIknP/3bqWEq4S6JdjWIomIe3CfypCCe/Cz3Lsodx/rBlxIxXktpKBYYddjNgwUCWJ4jGUryLNSoBA2WcdY360FV2bu/fUABhC3oQHFSlwwpmltWvoSrMBqZ/6R5UvX2iC+lkI3966jcB3zhJ0dBsIrVkftGhvr3EFHgHafua/XL+IaqbmJ+fIhhq60yjnJ/i3riAcO3+aZX3fcFBkGH/de5NPCyunSeD"
}
```

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
