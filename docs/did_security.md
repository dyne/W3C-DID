# Dyne.org's W3C-DID Security Vocabulary

## Classes

### ReflowBLS12381VerificationKey
This class represents a linked data signature verification key. See [reflow-BLS12381 paper](https://arxiv.org/pdf/2105.14527.pdf) for more details.

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase58*

**Example**:

```json
{
	"id": "did:example:123#reflow_public_key",
	"type": "ReflowBLS12381VerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "9kPV92zSUok2Do2RJKx3Zn7ZY9WScvBZoorMQ8FRcoH7m1eo3mAuGJcrSpaw1YrSKeqAhJnpcFdQjLhTBEve3qvwGe7qZsam3kLo85CpTM84TaEnxVyaTZVYxuY4ytmGX2Yz1scayfSdJYASvn9z12VnmC8xM3D1cXMHNDN5zMkLZ29hgq631ssT55UQif6Pj371HUC5g6u2xYQ2mGYiQ6bQt1NWSMJDzzKTr9y7bEMPKq5bDfYEBab6a4fzk6Aqixr1P3"
}
```

### Dilithium2VerificationKey
This class represents a linked data signature verification key. See the [Dilithium paper](https://pq-crystals.org/dilithium/data/dilithium-specification-round3-20210208.pdf) for more details.

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase58*

**Example**:

```json
{
	"id": "did:example:123#dilithium_public_key",
	"type": "Dilithium2VerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "HKJdoS2NDCYGEVVMNDAVwHiEMjcYphbeeqshLtZJ6gqeFQjEKxXzB5X7tKFqXqVjqHRf8vCQoUVRUPifATqN7bosyBPUJsytYi6pwtvpMQJ9cakZzmhZnbeh8yJd2hxZNK3yTMNpQ6Y1rymzPGxyTZ3syDPLVk8HeHeaH399gabYfjnj7knM6cfmfyyZf6Vz5JmbCtPpAGpyaGPBtixHhMc8n1b9zEiXeaY4JpkjPVATM45pYo6di2ZNfhQh72VrhaVPZ8iLiPy2YQzoRRDfWz8byoVNqBDHS48uaEQ3tXbEHxcbbUfyoXfR7hh6s43ZKtBLgR2FuxTYwvJrji2e2BmC6bs8esNMfMNsaNWQxygf9R21iZAo7kvYU318CL7Tm8raDcGsiXzB24r9XWzCs7fFEYfQjWppcVwqGG7jdMr867KaxMBq1TpkSibhtYzJ7X3zLhEZge2hmD16Wa7vBh7hdwoRrq5uS7HRYzD9cXR5WVn7M39NcHqLzio9wub66YETi5pgbdD7EKwxEDN7WPSiVvjLzqGVpMhGwzKPpD7dBQof3bdDywxpzGmzwi2wbpuHDBwRceR7zy8TVdS1oDdGXkvjPQKrLXjwZMpWY3a31CEtxLp56Xqp5m12fx5L3d46ET7GdQDHE18inNPg1qNdjgJkbJc2X6qVFB6NWgQpAng4htiZSrNTLeTbbCik5xLaBUdBWoKiHkm3c12Xh9QvEEZq9xKZNEiDBsC6vnH2jcz55kfeJyKj9872hXhHe3MgfpFTm7aVWLghFj48YMwF7v8twUuEVmvVyLSWTkrRjEgnteELXUCdfbnjRw9H2ykbYK1eB8Q3cM6T6P94W3Qxy8axHMKmzCLVVTozXiED7vQS6vr7fERzrA4QRWbzbYc9utAhJewBaDGiLUuLQze5NLBLmGQEw6jCj9UtLj9sikzc6fSMYKrE9DQ2qXMN7ZGE5vfPd3y24acPGviezmcvTYAK3JnYsDso6UmZh5RH7BERXgX8R978hYYD1AWpjDcnV5rJp59cSTGWV26DCdhr1YrnLWtAAEsooRzYwoeU23dpCrUVJdSSQMp3QDF26hGDJ3ed6tP2jSW7ZvZQYPfjE7LinQfuLhLS282uoRxFopEJ8A5SP7ofpqDEayhPsfvYbHZqv5tzuvAP6nJyKd2Be1FuLzjszBHbms2Hc5Z6JYt48xz9UDawd1UJqkcWbk8YehoEyETr4DXaDErnmmKYk5o216xJK3gdHpvPB2uxQHfGWmBx9Gsrhr7xT82jdLGdpJ1iYA4CU4KcG3PNSwUonsSNpQfb9e9CTwDoGZaDqTs283WGn1ZG1dDsPzdTMkUYRc9TJPSgeoatmjad7mM1o2wsYCvZbEbU1ZGP21rayoWif7SZSRRUrtSRtWj75buTESf5C5rr7xFQkepuuEdmm2E4FwypQpQHxGVNJxAeaFTRtTu7LK6conHmQawaXM76zE2YqiVadpfBwqpQAcq8jSTRHSsoawon2ESaRd4yvcNKfu3HkJ4MJjfySQzwrFf2Ugyt2dfat62AcVF2RN1YukKSgWgaD7VmZvkM4iQg5pEtJyEsf3D6K4rqKH1UJBvYdCSvCbeYvS91JNNR9y37X35famBXkA6XLndLRMUqYd31CXbBmaPRnHnDmoQ2Q6NcXtAKUt2DSf2U9tVv4tCBqCbD8wAxwjAMXLbSeDWvcDjnLxGDPyroNFeKP3YZfZierDpEMbgdxpfoiWd6dhYRvy6mekDSLQftb45n3CK951oJjDrdi1V4if9FkwuH"
}
```
### Mldsa44VerificationKey

ML-DSA-44 is an update of the Dilithium algorithm suggested by NIST.
This class represents a linked data signature verification key. See the specification in [FIPS 204](https://csrc.nist.gov/pubs/fips/204/ipd) for more details.


**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase58*

**Example**:

```json
{
	"id": "did:example:123#mldsa44_public_key",
	"type": "Mldsa44VerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "8cvh2985w2mdFnQH6nz7HMVeSxKMetizH5piuYoMpv86Mo4ibKujLBitSjT1MdSuJ1sR1zxsKXe6NjcQwac1ohUtGGf8swFgBi9cNVqfJw9r8WLfZ8uBoe2ehKS5DCjtNEQqF7sDvb7DJLnHPtDnhZQi32Hm6sAPgH2BCLPE7B56kMPvwFUDmrf1bLcYKdfn7mnkw8Q5rDXQRHSTPWisDACDxporJPK33CMPggz3DuWKv783vpx8fTmXKZgQXakiyBHYf2Bv88f4D9K8fdd2NvjQYM1hk5nG9BVixhKVAdgf1hzrEKkccnUFuaa2mna5iUkFEZjGCgWGzY8S62pyNwhR1dEMpMGmRzGqm9gtHEFKbFJ8GA3mAE53mLTDZahMmAjMXn4CAEaBQ6iw2saCQoMHNGzBNWY69r9uCQohv4B2x3EX7ZWEmKnWNCnZDggqAajDV5doqaJxXSeFSq7wfoUZxsewMdUtXeQheYPCJx89RoUr7aerv3gszUvkhH6QtNMUjit8f484YZHLzMxu6PoHwtkbuxC4SRXaWo27FvoqZQCXHRNKQ5b3mGkTfyG5YxFHrhvekrE9TV8UwWnTKhE69k8SbjwTH2AA9BmnAgXt1BmjbPF4zxFBwFeSQfMXS2S69X8zob5xhefQpgzcjNXdzSygiCRTyLqFVzFPdYaewEBXHgjb73XHy5pXPYzsS1XjJbHwYKD899gQjqAMRmWyyduaPEMk7ziaA92QGF6xMqLSATqq1P6KFL3yWXWXXiqRcjnDy8crGmCi3jX23iLjzJebCweY2GHGLBss7dXnDw4oTWNt1TY57x4ioucC7ARk5Zm5MvZHXesWbqPVudyCpPgj7g7RGgE7ozGj1ADcDMfyNzGmAUyW5ycStoJrMUJWM76ourGhdXMNjpiwCpNJhmVJTddhXgQsKLeBKS89bzj23YTKJdhhFKBAxsfQZpCRLn7XbUrNPtqNBGeSZG3ksjMDzAsobG1RyC4S8AyaWt1BThiY2eVxUp6LVNhwSQeQGJ7TeQ4YCbAd8CupVqA14cdCPFUEAfYCnbqYUHRC7nrdTmHRRZzCmeiPZC86bAq6PauWqE3s9wgRPR8huGbMYiSzkM1AX6ZCM9zrVwsk1ZBAHR1jkfrMWhetkoixNxMqCKBbJkszNMQNhjj5P5Tn6gY8cT8dCTuwKuQ5z4176YhdxNktMZZ6uv3A4JkU8oHqyEtbPXaH9CJmM8fPYiFwUYjASREZpfEJkkYMDHTDt7L3WwWyixZqHTzh62FYbMyHUPrEoq596qAnNvGdt4m6kRX92wq7hE5rBq8peH4kXG5yHQqxadMrn3Wt4gj1oSQ7BY43Fsgmdzzjv7twk8422GkDVeigzXDbwoPRdoRMw6hpqQY1n9vrXST9sq5SSSe4QNXA533d9YTEYv6Qwc5jUFrag4AiNdgtAyJ2wAnAzFjXW4WWWKfdYyzs5yKD6ypWWEBG4tepLAnoZ91zG5VtnaJCG9vMxnaSCDb68SLx1rH9rCrfB72udugpnNN5ALaHdhLBJZR9VUHyJaJeVGwfxAEtjJz5nu1ZzPks1YuwpJCKZWKhgkQCyrLABypoCD7EJi4GCB2RBNEzEsE4wVDi4dUNKoasHp8BcrZjx2gKYB3J4W55yuYZdJKhR7jSDFrrcFBJJqtUUW1xnjfHhYA5wG3LxsE9Hkz9aZexvRUH8xxs2zccPcoqW4e2hy7662FBWhdteE8QfccqGcBwk4CSJ5cY28A8SXHVd6B7gWwRkDWTwWgWNuShqoWMkcke"
}
```

### BbsVerificationKey
This class represents a linked data signature verification key. See the [BBS paper](https://identity.foundation/bbs-signature/draft-irtf-cfrg-bbs-signatures.html) for more details.

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase58*

**Example**:

```json
{
	"id": "did:example:123#bbs_public_key",
	"type": "BbsVerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "rqGGNqCnuL1xWXGZZ2NYedvHVeAyG3wJUq451TE8q3MrQQFjcbgUPXtXiG87MAtBG4d4oyjiGGQNjPufGuo1t4AptCxGNTGvoGfWqLLwX1ozaJUAAwooTp5CCcWQZrkT1Sv"
}
```

### EcdsaSecp256r1VerificationKey
This class represents a linked data signature verification key. This key represent a ecdsa key over the Secp256r1 curve, known also as P-256 curve. 

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase58*

**Example**:

```json
{
	"id": "did:example:123#es256_public_key",
	"type": "EcdsaSecp256r1VerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "5a1vFrHHfCULezmUm3mAsd6G9qtyHVvMH9aMLj7QGBkEg3nkqSjgVo4Pk64nMrm8z2ZmJ6whqzp1nPdqaQX5j6Hr"
}
```

### IssuerBLS12381VerificationKey
This class represents a linked data signature verification key. This key represent a compressed issuer key in the (Coconut)[https://arxiv.org/pdf/1802.07344.pdf] selective disclosure credential
scheme. The compression scheme transform a pair of two BLS12381 points (the original issuer public key) in one base58 string by first applying the (zcash compression)[https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-pairing-friendly-curves-08#name-zcash-serialization-format-] to both of them followed by a simple concatenation.

**Status**:  
*Stable*  
**Expected properties**:  
*id, type, controller, publicKeyBase58*

**Example**:

```json
{
	"id": "did:example:123#issuer_public_key",
	"type": "IssuerBLS12381VerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "2eeoyWMdUh1KxbLNydhZxpbNDqh1aGiJaCMwMWP4PpqyD1oEBW9rmBaET5ZugQvocw3w5NzL1znB2SmSJLmd5J13QNnP4xGtmT8itf3j7jyakGBLmy3zg2sXJvkqZLsDySoHEfjJLGP8c5CbZvQCSydphNo4NWoi6s2RXBLotSXMQ2NsrcL6HoYsnJxTFcEDcFMuYiDGyyzpATPLBBNEVQ4VypdKtwrzgqwkMk1SDjiEqhwy61hYHknCJM6bDhirnjptpxL"
}
```
