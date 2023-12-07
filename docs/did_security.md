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
	"id": "did:example:123#key1",
	"type": "Dilithium2VerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "HKJdoS2NDCYGEVVMNDAVwHiEMjcYphbeeqshLtZJ6gqeFQjEKxXzB5X7tKFqXqVjqHRf8vCQoUVRUPifATqN7bosyBPUJsytYi6pwtvpMQJ9cakZzmhZnbeh8yJd2hxZNK3yTMNpQ6Y1rymzPGxyTZ3syDPLVk8HeHeaH399gabYfjnj7knM6cfmfyyZf6Vz5JmbCtPpAGpyaGPBtixHhMc8n1b9zEiXeaY4JpkjPVATM45pYo6di2ZNfhQh72VrhaVPZ8iLiPy2YQzoRRDfWz8byoVNqBDHS48uaEQ3tXbEHxcbbUfyoXfR7hh6s43ZKtBLgR2FuxTYwvJrji2e2BmC6bs8esNMfMNsaNWQxygf9R21iZAo7kvYU318CL7Tm8raDcGsiXzB24r9XWzCs7fFEYfQjWppcVwqGG7jdMr867KaxMBq1TpkSibhtYzJ7X3zLhEZge2hmD16Wa7vBh7hdwoRrq5uS7HRYzD9cXR5WVn7M39NcHqLzio9wub66YETi5pgbdD7EKwxEDN7WPSiVvjLzqGVpMhGwzKPpD7dBQof3bdDywxpzGmzwi2wbpuHDBwRceR7zy8TVdS1oDdGXkvjPQKrLXjwZMpWY3a31CEtxLp56Xqp5m12fx5L3d46ET7GdQDHE18inNPg1qNdjgJkbJc2X6qVFB6NWgQpAng4htiZSrNTLeTbbCik5xLaBUdBWoKiHkm3c12Xh9QvEEZq9xKZNEiDBsC6vnH2jcz55kfeJyKj9872hXhHe3MgfpFTm7aVWLghFj48YMwF7v8twUuEVmvVyLSWTkrRjEgnteELXUCdfbnjRw9H2ykbYK1eB8Q3cM6T6P94W3Qxy8axHMKmzCLVVTozXiED7vQS6vr7fERzrA4QRWbzbYc9utAhJewBaDGiLUuLQze5NLBLmGQEw6jCj9UtLj9sikzc6fSMYKrE9DQ2qXMN7ZGE5vfPd3y24acPGviezmcvTYAK3JnYsDso6UmZh5RH7BERXgX8R978hYYD1AWpjDcnV5rJp59cSTGWV26DCdhr1YrnLWtAAEsooRzYwoeU23dpCrUVJdSSQMp3QDF26hGDJ3ed6tP2jSW7ZvZQYPfjE7LinQfuLhLS282uoRxFopEJ8A5SP7ofpqDEayhPsfvYbHZqv5tzuvAP6nJyKd2Be1FuLzjszBHbms2Hc5Z6JYt48xz9UDawd1UJqkcWbk8YehoEyETr4DXaDErnmmKYk5o216xJK3gdHpvPB2uxQHfGWmBx9Gsrhr7xT82jdLGdpJ1iYA4CU4KcG3PNSwUonsSNpQfb9e9CTwDoGZaDqTs283WGn1ZG1dDsPzdTMkUYRc9TJPSgeoatmjad7mM1o2wsYCvZbEbU1ZGP21rayoWif7SZSRRUrtSRtWj75buTESf5C5rr7xFQkepuuEdmm2E4FwypQpQHxGVNJxAeaFTRtTu7LK6conHmQawaXM76zE2YqiVadpfBwqpQAcq8jSTRHSsoawon2ESaRd4yvcNKfu3HkJ4MJjfySQzwrFf2Ugyt2dfat62AcVF2RN1YukKSgWgaD7VmZvkM4iQg5pEtJyEsf3D6K4rqKH1UJBvYdCSvCbeYvS91JNNR9y37X35famBXkA6XLndLRMUqYd31CXbBmaPRnHnDmoQ2Q6NcXtAKUt2DSf2U9tVv4tCBqCbD8wAxwjAMXLbSeDWvcDjnLxGDPyroNFeKP3YZfZierDpEMbgdxpfoiWd6dhYRvy6mekDSLQftb45n3CK951oJjDrdi1V4if9FkwuH"
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
	"id": "did:example:123#key1",
	"type": "BbsVerificationKey",
	"controller": "did:example:123",
	"publicKeyBase58": "rqGGNqCnuL1xWXGZZ2NYedvHVeAyG3wJUq451TE8q3MrQQFjcbgUPXtXiG87MAtBG4d4oyjiGGQNjPufGuo1t4AptCxGNTGvoGfWqLLwX1ozaJUAAwooTp5CCcWQZrkT1Sv"
}
```
