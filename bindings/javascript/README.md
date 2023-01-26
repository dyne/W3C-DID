# Create and manage Dyne.org's W3C-DID in JavaScript

<p align="center">
 <a href="https://dyne.org">
    <img src="https://files.dyne.org/software_by_dyne.png" height="140" alt="Dyne.org">
  </a>
</p>

<h1 align="center">
  Dyne W3C-DID js bindings 🧰</br>
  <sub>Dyne W3C-DID js bindings provides a javascript wrapper of <a href="https://github.com/dyne/W3C-DID">Dyne.org's W3C-DID</a> client side.</sub>
</h1>

<p align="center">
  <a href="https://dyne.org">
    <img src="https://img.shields.io/badge/%3C%2F%3E%20with%20%E2%9D%A4%20by-Dyne.org-blue.svg" alt="Dyne.org">
  </a>
</p>

<br><br>

## 🚀 Quick start

Start by reading the documentation to understand better how Dyne.org's W3C-DID works

### [https://dyne.org/W3C-DID](https://dyne.org/W3C-DID/)

## 💾 Install

Stable releases are published on https://www.npmjs.com/package/dyne-did that have a slow pace release schedule that you can install with

```bash
yarn add @dyne/yne-did
# or if you use npm
npm install @dyne/did
```

* * *

## 🎮 Usage

The bindings are composed of four main functions:

 - **createKeyring**: takes as input a string that will be used as description inside the did document and return the string under the key **controller** along with your keyring.
 - **createRequest**: takes as input the output of the above function along with a string containg the domain and a string containg the type of request (*create*, *update* or *deactivate*) to perform and return an unsigned request that will be signed by an admin.
 - **signRequest**: takes as input a request, the signer keyring and the signer domain and return the signed request ready to be sent in order to create, update or deactivate a did document.
 - **sendRequest**: takes as input an endpoint and a request and sends the latter to `did.dyne.org/*endpoint*`.

**All input and output are in form of strings.** This means that if you want to pass a JSON you have to `JSON.stringify` it before.

There are other functions related to particular domains as well, but the functioning is almost identical.

All functions return a [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise).

To start using the Dyne.org's W3C-DID you have to create a domain admin request and send it to us. This can be created by using:

```js
import { createKeyring, createRequest } from "@dyne/did";
// or if you don't use >ES6
// const { createKeyring, createRequest } = require('@dyne/did')

// Create a new did document request
const keyring = await createKeyring("new_domain_admin_request");
const request = await createRequest(keyring, "domain_A", "create");
console.log(request);
```

Once your request has been accepted people can create a request for a special context of your domain in the following way:
```js
import { createKeyring, createRequest } from "@dyne/did";
// or if you don't use >ES6
// const { createKeyring, createRequest } = require('@dyne/did')

// Create a new did document request
const keyring = await createKeyring("new_domain_context_admin_request");
const request = await createRequest(keyring, "domain.context_A", "create");
console.log(request);
```

This request will be sent to you and you will have to sign it and you or the participant will send the result to `did.dyne.org` in order to create the new did document.

```js
import { signRequest, sendRequest } from "@dyne/did";
// or if you don't use >ES6
// const { signRequest, sendRequest } = require('@dyne/did')

//Sign did document request, the inputs can be modified
const signedRequest = await signRequest(request, keyring, "domain_A");
const result = await sendRequest("api/v1/domain/pubkeys-accept.chain", signedRequest);
```


## 😍 Acknowledgements

Copyright (C) 2022-2023 by [Dyne.org](https://www.dyne.org) foundation, Amsterdam

Designed, written and maintained by [Denis Jaromil](https://jaromil.dyne.org), [Puria Nafisi Azizi](https://github.com/puria), [Andrea D'Intino](https://github.com/andrea-dintino), [Alberto Lerda](https://github.com/albertolerda) and [Matteo Cristino](https://github.com/matteo-cristino).

* * *

## 👤 Contributing

Please first take a look at the [Dyne.org - Contributor License Agreement](CONTRIBUTING.md) then

1.  🔀 [FORK IT](../../fork)
2.  Create your feature branch `git checkout -b feature/branch`
3.  Commit your changes `git commit -am 'Add some fooBar'`
4.  Push to the branch `git push origin feature/branch`
5.  Create a new Pull Request
6.  Thank you

* * *

## 💼 License

    dyne-did js - a javascript wrapper of Dyne.org's W3C-DID
    Copyright (C) 2022-2023 Dyne.org foundation

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License along with this program. If not, see https://www.gnu.org/licenses/.
