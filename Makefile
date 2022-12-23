RR_PORT := 443
RR_HOST := did.dyne.org
RR_SCHEMA := https
##@ General
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' Makefile

.PHONY: test

test-units: ## Run client-api unit tests offline
	-if [ ! -f test/zenroom ]; then cp /usr/local/bin/zenroom test/; fi
	./test/bats/bin/bats test/zencode_units

.PHONY: geneate-sandbox-did
generate-sandbox-did:
	zenroom -z client/v1/sandbox/sandbox-keygen.zen \
			-a client/v1/did-settings.json \
			> /tmp/controller-keyring.json 2>/dev/null
	zenroom -z client/v1/sandbox/create-identity-pubkeys.zen \
			> /tmp/new-id-pubkeys.json 2>/dev/null
	@jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' /tmp/new-id-pubkeys.json > /tmp/new-id-pubkeys-tmp.json && mv /tmp/new-id-pubkeys-tmp.json /tmp/new-id-pubkeys.json
	zenroom -z client/v1/sandbox/pubkeys-request.zen \
			-a /tmp/new-id-pubkeys.json -k /tmp/controller-keyring.json \
			> /tmp/pubkeys-request.json 2>/dev/null
	./restroom-test -s ${RR_SCHEMA} -h ${RR_HOST} -p ${RR_PORT} -u v1/sandbox/pubkeys-accept.chain -a /tmp/pubkeys-request.json | jq .

test-local: generate-sandbox-did ## Test a local DID document creation
	zenroom -z client/v1/sandbox/pubkeys-update.zen \
			-a /tmp/new-id-pubkeys.json -k /tmp/controller-keyring.json \
			| tee /tmp/pubkeys-update.json | jq .
	./restroom-test -p 12001 -u v1/sandbox/pubkeys-update.chain -a /tmp/pubkeys-update.json
	@rm -f /tmp/controller-keyring.json /tmp/new-id-pubkeys.json /tmp/pubkeys-request.json /tmp/pubkeys-update.json

run-local: ## Run an instance on localhost
	cp restroom/local-config.site .env
	@if ! [ -r restroom/node_modules ]; then echo "Deps missing, first run: make install-deps"; return 1; fi
	node restroom/restroom.mjs

update-npm:
	$(info Updating to latest packages)
	@cd restroom && rm -f package-lock.json && npm i zenroom@latest @restroom-mw/files@next && npm list

install-deps: ## Install all NodeJS dependencies
	$(info Installing NodeJS dependencies - need npm installed)
	@test -d restroom/node_modules || (cd restroom && npm i)

clean: ## Clean all NodeJS dependencies
	$(info Cleaning all dependencies - need a new install-deps)
	@rm -rf node_modules package-lock.json
	@rm -rf restroom/node_modules restroom/package-lock.json
