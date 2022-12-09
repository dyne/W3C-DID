##@ General
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' Makefile

test-local: ## Test a local DID document creation
	zenroom -z contracts/sandbox/pubkeys-create.zen > /tmp/pubkeys.json
	zenroom -z contracts/sandbox/pubkeys-request.zen \
			-k contracts/sandbox/did-document-create.keys -a /tmp/pubkeys.json \
			| tee /tmp/pubkeys-request.json | jq .
	./restroom-test -p 12001 -u sandbox/pubkeys-accept -a /tmp/pubkeys-request.json
	@rm -f /tmp/pubkeys.json /tmp/pubkeys-request.json

#	curl -s -X 'POST' 'http://localhost:12001/api/sandbox/did-create' \
		 -H 'accept: application/json' -H 'Content-Type: application/json' \
		 -d "{ \"data\": `cat /tmp/did-request.json`, \"keys\": {} }"

run-local: ## Run an instance on localhost
	@if ! [ -r restroom/node_modules ]; then echo "Deps missing, first run: make install-deps"; return 1; fi
	@if ! [ -r .env ]; then echo "Setup missing, first run: make setup-local"; return 1; fi
	node restroom/restroom.mjs

setup-local: ## Setup to run on localhost
	$(info Generating the DID-DYNE-Controller keyring)
	@test -r contracts/keyring.json || zenroom -z private_contracts/create_keys.zen > contracts/keyring.json
	@chmod go-rwx contracts/keyring.json
	@test -r contracts/public_keys.json || zenroom -z private_contracts/create_pub_keys.zen -k contracts/keyring.json > contracts/public_keys.json
	@ls -l contracts/keyring.json contracts/public_keys.json
	@cp restroom/local-config.site .env

update-npm:
	$(info Updating to latest packages)
	@rm -rf restroom && npx -y create-restroom@next -a --no-@restroom-mw/sawroom --no-@restroom-mw/fabric restroom

install-deps: ## Install all NodeJS dependencies
	$(info Installing NodeJS dependencies - need npm installed)
	@test -d restroom/node_modules || (cd restroom && npm i)

clean: ## Clean all NodeJS dependencies
	$(info Cleaning all dependencies - need a new install-deps)
	@rm -rf node_modules package-lock.json
	@rm -rf restroom/node_modules restroom/package-lock.json
