# Zenflows W3C-DID

To create a Zenflows admin or a Zenflows users you should be in posses of, respectively, the Admin keyring or a Zenflows Admin keyring and its name, in the following format:
```json
{
    "controller": "some_sort_of_admin",
    "some_sort_of_admin": {
        "keyring":{
            "....": "...."
        }
    }
}
```
Other than this you will need a json file containing:
- **did_spec**: the did spec of the document that will be created
- **signer_did_spec**: the did spec of the signer
- **identity**: the description that will end inside the did document
- **zenflows_id**: a string dictionary containing the zenflows **identifier** if it exits, otherwise an empty dictionary
- **eddsa_public_key**: a base58 eddsa public key
- **ethereum_address**: a hexadecimal ethereum address
- **ecdh_public_key**: a base58 ecdh public key
- **reflow_public_key**: a base58 reflow public key
- **bitcoin public key**: a base58 bitcoin public key


Moreover if you run this script locally without the help of restroom, then you will also need a **timestamp**. An example of such a file is:
```json
{
    "did_spec": "zenflows",
    "signer_did_spec": "zenflows.A",
    "identity": "zenflows back-end test",
    "zenflows_id": {"identifier": "062HBVPRYQZRJE2PEN21V8HB3C"},
    "bitcoin_public_key": "24FWY6sMx2MvH1EEoncuWr4dh4NJ7Pmo5WDNst4oztg7s",
    "ecdh_public_key": "SJ3uY8Y5cKYsMqqvW3rZaX7h4s1ms5NpAYeHUi16A7jHMVtwSF3Gdzafh9XmvGz6uNksBnaU5fvarDw1mZF2Nkjz",
    "eddsa_public_key": "2s5wmQjZeYtpckyHakLiP5ujWKDL1M2b8CiP6vwajNrK",
    "ethereum_address": "747846c15dfc79803265f953d003ac4251867cd7",
    "reflow_public_key": "3LfL2v8qz2cmgy8LRqLPL4H12mt2rW3p7hrwJ6q1gqpHKyXWovkCutsJRsLxkrgHwQ233gouwWFmzshS5EnK9dah92855jzaqV4fD53svqLBrxdV2nt44aEMuWoXYSwA4dmTwHXpgsyQuCsn6uNewbF5VLcesqJubzHf4XvVF9249F1HVLmMR7oCKVBnCw3pTB2HrcmSJaSdKu88rJbzELTvdMLbXXyEcCvYDT3HhzGXNv9BBTo9ZXQGw1CSCCyDrCNMYe",
    "timestamp": "1233456789"
}
```

Once you have all this infromation you will need to merge the latter json with the [did-settings.json](./did-settings.json) and finally run:
zenroom -z -a your_json.json -k keyring.json pubkeys-request.zen 