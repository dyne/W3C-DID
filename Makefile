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
	@zenroom -z -k ${tmp} client/v1/create-keyring.zen > keyring.json
	@rm -f ${tmp}

request: ## Generate an admin request [ DOMAIN ]
	@sh ./scripts/req.sh ${DOMAIN}

sign: ## Sign a request and generate a DID proof [ REQUEST ]
	$(if ${REQUEST}, $(info Signing request: ${REQUEST}), $(error Missing argument: REQUEST))
	$(if $(wildcard secrets/service-keyring.json),,$(error Local authority keyring.json not found, cannot sign))
	@cat ${REQUEST} | jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' > ${REQUEST}
	@zenroom -z -k secrets/service-keyring.json -a ${REQUEST} \
				client/v1/pubkeys-sign.zen > signed_did_doc.json
	@rm -f did_doc.json

##@ Test
populate-remote-sandbox:
	zenroom -z -a client/v1/did-settings.json \
			client/v1/sandbox/sandbox-keygen.zen
			> /tmp/controller-keyring.json 2>/dev/null
	zenroom -z client/v1/sandbox/create-identity-pubkeys.zen \
			> /tmp/new-id-pubkeys.json 2>/dev/null
	@jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' /tmp/new-id-pubkeys.json > /tmp/new-id-pubkeys-tmp.json && mv /tmp/new-id-pubkeys-tmp.json /tmp/new-id-pubkeys.json
	zenroom -z -a /tmp/new-id-pubkeys.json -k /tmp/controller-keyring.json \
				client/v1/sandbox/pubkeys-request.zen \
			> /tmp/pubkeys-request.json 2>/dev/null
	./restroom-test -s ${RR_SCHEMA} -h ${RR_HOST} -p ${RR_PORT} -u v1/sandbox/pubkeys-accept.chain -a /tmp/pubkeys-request.json | jq .

fill-sandbox: NUM ?= 100
fill-sandbox: ## Generate random DIDs in local sandbox  [ NUM ]
	bash scripts/fakedid.sh ${NUM}

test-units: ## Run client-api unit tests offline
	-if [ ! -f test/zenroom ]; then cp /usr/local/bin/zenroom test/; fi
	./test/bats/bin/bats test/zencode_units

##@ Service

build: ## Install all NodeJS dependencies
	$(info Installing NodeJS dependencies - need npm installed)
	@test -d restroom/node_modules || (cd restroom && npm i)

run: ## Run a service instance on localhost
	$(if $(wildcard restroom/node_modules),,$(error Deps missing, first run: make build))
	@cp -v restroom/local-config.site .env
	node restroom/restroom.mjs

service-keyring: tmp := $(shell mktemp)
service-keyring: ## Create a keyring for the global service admin
	$(if $(wildcard secrets/service-keyring.json),$(error Service keyring found, cannot overwrite))
	@echo "{\"controller\": \"${USER}@${HOSTNAME}\"}" > ${tmp}
	@umask 0067 && zenroom -z -k ${tmp} client/v1/create-keyring.zen 2>/dev/null > secrets/service-keyring.json
	@rm -f ${tmp} ## secret keyring created
	@zenroom -z -k secrets/service-keyring.json -a client/v1/did-settings.json client/v1/create-identity-pubkeys.zen 2>/dev/null > ${tmp}
	@cat ${tmp} | jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' > ${tmp}
	@zenroom -z -a ${tmp} -k keyring.json client/v1/admin/didgen.zen 2>/dev/null > service-admin-did.json
	@rm -f ${tmp} ## self-signed DID created
	make accept-admin FORCE=1 REQUEST=service-admin-did.json

service-pubkeys: ## Print the public keys of the global service admin
	$(if $(wildcard secrets/service-keyring.json),,$(error Service keyring not found))
	@zenroom -z -k secrets/service-keyring.json -a client/v1/did-settings.json client/v1/create-identity-pubkeys.zen 2>/dev/null | jq .

accept-admin:
accept-admin: ## Local command to accept an admin [ REQUEST ]
	$(if ${REQUEST},\
		$(info Accepting request: ${REQUEST}),\
		$(error Missing argument: REQUEST))
	@sh ./scripts/accept-admin-request.sh ${REQUEST}

update: ## Update all service dependencies
	$(info Updating to latest packages)
	@cd restroom && rm -f package-lock.json && npm i zenroom@latest @restroom-mw/files@next && npm list

scrub: ## Check all signed proofs in data/
	@bash scripts/scrub.sh "${DATA}"

clean: ## Clean all NodeJS dependencies
	$(info Cleaning all dependencies - need a new install-deps)
	@rm -rf node_modules package-lock.json
	@rm -rf restroom/node_modules restroom/package-lock.json
