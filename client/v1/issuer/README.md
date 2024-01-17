# Flow

In order to create a unisgned request to send to a sandbox.genericissuer admin do:
1. `echo '{"controller": "<did doc desciption>"}' > controller.json`
2. `zernoom -a controller.json -z create-keyring.zen > keys.json`
3. `zernoom -a keys.json -z create-identity-pubkeys.zen > pks.json` 
4. `zenroom -a pk.json -k request_input.json -z pubkeys-request-unsigned.zen > req.json`


