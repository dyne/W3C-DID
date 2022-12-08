## Setup 

- **git clone https://github.com/dyne/W3C-DID.git**
- **cd W3C-DID**
- In order to You need to generate an ED25519 keypair, using the command **ssh-keygen -t ed25519**, then:
- Copy the private key in ./devops/sshkey and set the privileges:

```bash
echo "-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAACmFlczI1Ni1jdHIAAAAGYmNyeXB0AAAAGAAAABC2APqVI+
sQsoxakCzy5PTuAAAAEAAAAAEAAAGzAAAAB3NzaC1kc3MAAACBAOquyMT+8c+HE5cl+zxk
wv0tDWtK3u5KXTWioagnTX8BkzZLoM4EvWR1N12hufo3WQbdtFnBD3IvPt52HX5K0IogKw
cA0W/bUNrhuuLSJqG46/ud5POGRHrq/+qET3hpsTP0ig1JLczwdaNR73HYNhcA93ajAX8o
DqjEWYf3ZB0UAzjUE6P4AAAADGFsYnlAcGMtYXN1cwE=
-----END OPENSSH PRIVATE KEY-----" > ./devops/sshkey; chmod 600 ./devops/sshkey
```

- Copy the ED25519 pubkey in **~/.ssh/authorized_keys** of the server where the Controller will be running


## Ansible setup

Before you start the process, you have to configure: 
* the **ip** that Ansible will connect to (it can be a domain name)
* the **domain_name** to match the domain name of the controller machine (default is did.dyne.org), 

This can be done in the file **./devops/hosts.toml**, which will look like:

```
194.233.163.193 domain_name=mydomain.com ansible_port=22
```

## Provisioning

In order to install a Controller, you use the **make** command:

* make start (will start the controller)
* make install (import restroom, resolver, contracts, ngnix, ...). 
* make announce (create a keyring if not present, create the public keys, announce himself (save did on redis and produce tx that is the mpack of its did and a timestamp) and download the public keys). If no keyring is provided, one will be generated during the announce part.
* make stop (stop the controller)
