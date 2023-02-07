# W3C-DID
[Dyne.org](http://dyne.org/) W3C-DID implementation. 

A distributed digital identity gives users control over their personal, verified information and allows them to share it on demand in a safe and secure way.

Our implementation follows the W3C-DID standard and is documented at [https://dyne.org/W3C-DID/](https://dyne.org/W3C-DID/)

One can also peek at the distributed identities we registered using the [explorer.did.dyne.org](https://explorer.did.dyne.org)

The OpenAPI of the W3C-DID controller can be seen at [https://did.dyne.org/docs/](https://did.dyne.org/docs/)

<a href="https://dyne.org">
   <img src="https://files.dyne.org/software_by_dyne.png" width="222">
</a>

This software is meant to be used by developers in need of a federated and reliable environment to distribute identities along with public keys that can allow them to perform several cryptographic actions using end-to-end cryptography.

Our W3C-DID implementation is opinionated:
- free, open source and human readable code
- full coverage: unit and integration tests
- end-to-end crypto (no keys on server!)
- no database: filesystem storage
- record history in git: [dyne/w3c-did-data](https://github.com/dyne/w3c-did-data)
- share DIDs p2p using IPFS
- [Zencode](https://dev.zenroom.org) contract language

# quickstart

Participants need not to run a DID controller, but can use our official instance at https://did.dyne.org/docs

If you need a domain for your application please contact us at [info@dyne.org](mailto:info@dyne.org), do:
```
make keyring
make request
```
and send us your request to become a domain admin.

**Even in case our server we get hacked, your keys will not ne leaked and your DIDs will not be lost**

## test on your own

To run simple tests one needs to install also [Zenroom](https://zenroom.org), the [Zencode tools](https://github.com/dyne/zencode-tools), [GNU parallel](https://www.gnu.org/parallel) and [jq](https://stedolan.github.io/jq/).

A brief command-line overview is given just typing `make`:
```
__／________／__________／
／ ｄｉｄ ／ ｄｙｎｅ ／

Usage:
  make <target>
  help             Display this help.

Admin
  keyring          Generate a new admin keyring [ OUT, CONTROLLER ]
  request          Generate an admin request [ DOMAIN, KEYRING ]
  sign             Sign a request and generate a DID proof [ REQUEST, KEYRING ]

Test
  fill-sandbox     Generate random DIDs in local sandbox  [ NUM ]
  test-units       Run client-api unit tests offline

Service
  build            Install all NodeJS dependencies
  run              Run a service instance on localhost
  service-keyring  Create a keyring for the global service admin
  service-pubkeys  Print the public keys of the global service admin
  accept-admin     Local command to accept an admin [ REQUEST ]
  update           Update all service dependencies
  scrub            Check all signed proofs in data/
  clean            Clean all NodeJS dependencies
```

Using the test command `fill-sandbox` one can generate a fake admin keyring and 100 fake DIDs in `did:dyne:sandbox`
```
make fill-sandbox
```

See what you have created with `ls -l data/dyne/sandbox`.

To test the integrity of dids we have a `scrub` function which will check they are all correctly signed by their admin. Running a scrub requires the installation of GNU parallel:
```
make scrub
```

Each DID is a file containing JSON formatted information about public keys and the chain of authentication granting their integrity.

## did:dyne:domain

We call "domain" any word following the `did:dyne:` namespace. DID domains are governed by specific [contracts subdirectories](/api/v1) carrying the same name. A domain usually corresponds to an application, for which we use standard Zencode contracts or customize them according to use-case needs.

Any "domain" has one or more admins that have the permission to create, update or delete the DID document under their "domain". These admins can be recognized from their DID of the from `did:dyne:domain.A:` and they will govern all the DID documents whose DID starts with `did:dyne:domain:`.

For example `did:dyne:zenflows.A` manages DIDs for the `did:dyne:zenflows:` domain.

The special `did:dyne:admin` spec is the one governing all admin domainsand can create, update and delete admins.

# user flows

## CREATE a did in sandbox

[![](https://mermaid.ink/img/pako:eNp1UcFqwzAM_RXhyzZoF3b1oWCaPwjbKTAUW-3EEjuT7bJQ-u9zmtAOxmwwtt_Tk550VjY4UlpF-srkLdWMR8Gh9VAW2hQEDGAE07Ol5XdESWx5RJ-gmbE6DMgejBvK-ZdTXzmTp-cgx4cIjh1EktNNcE2WU_B56EiWd73d7naNXtXfDbAjnzhNMEo4ceTgyUE33aSXMFOijIa9ECYChE-ahP0_oMyuY4LHffVa1U93Uslr4icciv3IR48py1pss6Bv2LObRa6NKa5WqTup1nB6qSJ614XvasxdqSRu0VoaC-v3Vhs1kBSXrgziPCu0Kn3QQK3S5erogLlPrWr9pVDnPjWTt0onybRReZzrWOem9AH7SJcf1ciaxA?type=png)](https://mermaid.live/edit#pako:eNp1UcFqwzAM_RXhyzZoF3b1oWCaPwjbKTAUW-3EEjuT7bJQ-u9zmtAOxmwwtt_Tk550VjY4UlpF-srkLdWMR8Gh9VAW2hQEDGAE07Ol5XdESWx5RJ-gmbE6DMgejBvK-ZdTXzmTp-cgx4cIjh1EktNNcE2WU_B56EiWd73d7naNXtXfDbAjnzhNMEo4ceTgyUE33aSXMFOijIa9ECYChE-ahP0_oMyuY4LHffVa1U93Uslr4icciv3IR48py1pss6Bv2LObRa6NKa5WqTup1nB6qSJ614XvasxdqSRu0VoaC-v3Vhs1kBSXrgziPCu0Kn3QQK3S5erogLlPrWr9pVDnPjWTt0onybRReZzrWOem9AH7SJcf1ciaxA)

## READ a did in sandbox

[![](https://mermaid.ink/img/pako:eNplUMlqAzEM_RUhCrmkmbsPgQGH0nN69EW1lcQwlqe2HAgh_15PkxZKJBBanp6WK_ocGA1W_mosnm2kY6HkBLqQ11xgBKowTtHzPTtT0ejjTKKwX2o2J4oCY0jdPmPsD-YivMnluKoQYoDK5fxH-BjWNEtLn1zu8fi63VoDb7sPOKnO1QxD79yEB9ES1OHl3Tr5r7jGxKVvFPpZ14XLoZ44sUPT3cAHapM6dHLr0GXq_iIejZbGa2xzIP39ApoDTZVv3-NEYfk?type=png)](https://mermaid.live/edit#pako:eNplUMlqAzEM_RUhCrmkmbsPgQGH0nN69EW1lcQwlqe2HAgh_15PkxZKJBBanp6WK_ocGA1W_mosnm2kY6HkBLqQ11xgBKowTtHzPTtT0ejjTKKwX2o2J4oCY0jdPmPsD-YivMnluKoQYoDK5fxH-BjWNEtLn1zu8fi63VoDb7sPOKnO1QxD79yEB9ES1OHl3Tr5r7jGxKVvFPpZ14XLoZ44sUPT3cAHapM6dHLr0GXq_iIejZbGa2xzIP39ApoDTZVv3-NEYfk)


# secrets

All secret keys are kept client-side and our server has none available, signing is done off-line and interactively to grant full end-to-end encryption.

All client-side secrets created using this repository CLI setup are stored in the `secrets/` folder.

# licensing

Copyright (C) 2022-2023 Dyne.org foundation

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program.  If not, see
<https://www.gnu.org/licenses/>.
