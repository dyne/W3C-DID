
run-local:
	node_modules/.bin/pm2 start ecosystem.config.js

setup-local:
	$(info Generating the DID-DYNE-Controller keyring)
	@test -r contracts/keyring.json || zenroom -z private_contracts/create_keys.zen > contracts/keyring.json
	@chmod go-rwx contracts/keyring.json
	@test -r contracts/public_keys.json || zenroom -z private_contracts/create_pub_keys.zen -k contracts/keyring.json > contracts/public_keys.json
	@ls -l contracts/keyring.json contracts/public_keys.json
	cp restroom/local-config.site .env

restart:
	node_modules/.bin/pm2 restart all
stop:
	node_modules/.bin/pm2 stop all

deps:
	npm install yarn pm2
