RR_PORT := 443
RR_HOST := did.dyne.org
RR_SCHEMA := https
HOSTNAME := $(shell hostname)
DATA := $(shell pwd)/data

$(info __／________／__________／)
$(info ／ ｄｉｄ ／ ｄｙｎｅ ／)

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' Makefile

.PHONY: test


##@ Admin

keyring: tmp := $(shell mktemp)
keyring: ## Generate a new admin keyring
	$(if $(wildcard keyring.json),$(error Local authority keyring.json found, cannot overwrite))
	@echo "{\"controller\": \"${USER}@${HOSTNAME}\"}" > ${tmp}
	@zenroom -z client/v1/admin/keygen.zen -k ${tmp} > keyring.json
	@rm -f ${tmp}

self-DID: tmppk := $(shell mktemp)
self-DID: ## Generate a self-signed admin DID
	@zenroom -z client/v1/admin/pubgen.zen -k keyring.json -a client/v1/did-settings.json > ${tmppk}
	@cat ${tmppk} | jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' > ${tmppk}
	@zenroom -z client/v1/admin/didgen.zen -a ${tmppk} -k keyring.json > admin_did_doc.json
	@rm -f ${tmppk}

##@ Test
populate-remote-sandbox: ## Generate random DIDs in remote sandbox (RR_SCHEMA, RR_HOST, RR_PORT)
	zenroom -z client/v1/sandbox/sandbox-keygen.zen \
			-a client/v1/did-settings.json \
			> /tmp/controller-keyring.json 2>/dev/null
	zenroom -z client/v1/sandbox/create-identity-pubkeys.zen \
			> /tmp/new-id-pubkeys.json 2>/dev/null
	@jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' /tmp/new-id-pubkeys.json > /tmp/new-id-pubkeys-tmp.json && mv /tmp/new-id-pubkeys-tmp.json /tmp/new-id-pubkeys.json
	zenroom -a /tmp/new-id-pubkeys.json -k /tmp/controller-keyring.json \
			-z client/v1/sandbox/pubkeys-request.zen \
			> /tmp/pubkeys-request.json 2>/dev/null
	./restroom-test -s ${RR_SCHEMA} -h ${RR_HOST} -p ${RR_PORT} -u v1/sandbox/pubkeys-accept.chain -a /tmp/pubkeys-request.json | jq .

populate-sandbox: NUM ?= 100
populate-sandbox: ## Generate random DIDs in local sandbox (TODO)
	bash scripts/fakedid.sh ${NUM}

test-units: ## Run client-api unit tests offline
	-if [ ! -f test/zenroom ]; then cp /usr/local/bin/zenroom test/; fi
	./test/bats/bin/bats test/zencode_units

test-local: ## Test a local DID document creation
	zenroom -z client/v1/sandbox/pubkeys-update.zen \
			-a /tmp/new-id-pubkeys.json -k /tmp/controller-keyring.json \
			| tee /tmp/pubkeys-update.json | jq .
	./restroom-test -p 12001 -u v1/sandbox/pubkeys-update.chain -a /tmp/pubkeys-update.json
	@rm -f /tmp/controller-keyring.json /tmp/new-id-pubkeys.json /tmp/pubkeys-request.json /tmp/pubkeys-update.json

##@ Service

build: ## Install all NodeJS dependencies
	$(info Installing NodeJS dependencies - need npm installed)
	@test -d restroom/node_modules || (cd restroom && npm i)

run: ## Run a service instance on localhost
	$(if $(wildcard restroom/node_modules),,$(error Deps missing, first run: make build))
	@cp -v restroom/local-config.site .env
	node restroom/restroom.mjs

service-keyring: tmp := $(shell mktemp)
service-keyring: UMASK := $(shell umask)
service-keyring: ## Create a keyring for the global service admin
	$(if $(wildcard secrets/service-keyring.json),$(error Service keyring found, cannot overwrite))
	@echo "{\"controller\": \"${USER}@${HOSTNAME}\"}" > ${tmp}
	@umask 0067
	@zenroom -z client/v1/admin/keygen.zen -k ${tmp} > secrets/service-keyring.json
	@umask ${UMASK}
	@rm -f ${tmp}

accept-admin-request: ## Local command to accept an admin request [ FORCE ]
	$(if $(wildcard ${DATA}/admin),$(error Local authority did document found, cannot overwrite))
	@mv admin_did_doc.json $$(jq -r '.didDocument.id' admin_did_doc.json | sed -e 's/:/\//g' -e 's/\./\//g' -e "s|^did/dyne|${DATA}|g")

update: ## Update all service dependencies
	$(info Updating to latest packages)
	@cd restroom && rm -f package-lock.json && npm i zenroom@latest @restroom-mw/files@next && npm list

scrub: ## Check all signed proofs in data/
	@bash scripts/scrub.sh "${DATA}"

clean: ## Clean all NodeJS dependencies
	$(info Cleaning all dependencies - need a new install-deps)
	@rm -rf node_modules package-lock.json
	@rm -rf restroom/node_modules restroom/package-lock.json
