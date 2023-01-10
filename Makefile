PWD ?= $(shell pwd)
RR_PORT := 443
RR_HOST := did.dyne.org
RR_SCHEMA := https
HOSTNAME := $(shell hostname)
DOMAIN ?= sandbox
REQUEST ?= did_doc.json

$(info __／________／__________／)
$(info ／ ｄｉｄ ／ ｄｙｎｅ ／)

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' Makefile

.PHONY: test


##@ Admin

keyring: tmp := $(shell mktemp)
keyring: OUT ?= secrets/keyring.json
keyring: CONTROLLER ?= ${USER}@${HOSTNAME}
keyring: ## Generate a new admin keyring [ OUT, CONTROLLER ]
	$(if $(wildcard ${OUT}),$(error Local authority ${OUT} found, cannot overwrite))
	@echo "{\"controller\": \"${CONTROLLER}\"}" > ${tmp}
	@zenroom -z -k ${tmp} client/v1/create-keyring.zen > ${OUT}
	@rm -f ${tmp}

request: KEYRING ?= secrets/keyring.json
request: OUT ?= did_doc.json
request: DOMAIN ?= sandbox
request: ## Generate an admin request [ DOMAIN, KEYRING ]
	@sh ./scripts/req.sh ${DOMAIN} ${KEYRING} > ${OUT}

sign: tmp := $(shell mktemp)
sign: REQUEST ?= did_doc.json
sign: SIGNER_DOMAIN ?= admin
sign: KEYRING ?= secrets/keyring.json
sign: OUT ?= signed_did_doc.json
sign: ## Sign a request and generate a DID proof [ REQUEST, KEYRING ]
	$(if ${REQUEST}, $(info Signing request: ${REQUEST}), $(error Missing argument: REQUEST))
	$(if $(wildcard ${KEYRING}),,$(error Local authority ${KEYRING} not found, cannot sign))
	@cat ${REQUEST} | jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' > ${REQUEST}
	@jq '.signer_did_spec = "${SIGNER_DOMAIN}"' ${REQUEST} > ${tmp} && mv ${tmp} ${REQUEST}
	@zenroom -z -k ${KEYRING} -a ${REQUEST} \
				client/v1/pubkeys-sign.zen > ${OUT}

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
	@cp -v restroom/.env.example restroom/.env
	cd restroom && node restroom.mjs

service-keyring: tmp := $(shell mktemp)
service-keyring: tmp2 := $(shell mktemp)
service-keyring: KEYRING ?= secrets/service-keyring.json
service-keyring: CONTROLLER ?= ${USER}@${HOSTNAME}
service-keyring: ## Create a keyring for the global service admin
	$(if $(wildcard ${KEYRING}),$(error Service keyring found, cannot overwrite))
	@echo "{\"controller\": \"${CONTROLLER}\"}" > ${tmp}
	@umask 0067 && zenroom -z -k ${tmp} client/v1/create-keyring.zen 2>/dev/null > ${KEYRING}
	@rm -f ${tmp} ## secret keyring created
	@zenroom -z -k ${KEYRING} -a client/v1/did-settings.json client/v1/create-identity-pubkeys.zen 2>/dev/null > ${tmp}
	@jq --arg value $$(($$(date +%s%N)/1000000)) '.timestamp = $$value' ${tmp} > ${tmp2} && mv ${tmp2} ${tmp}
	@zenroom -z -a ${tmp} -k ${KEYRING} client/v1/admin/didgen.zen 2>/dev/null > service-admin-did.json
	@rm -f ${tmp} ## self-signed DID created
	make accept-admin REQUEST=service-admin-did.json

service-pubkeys: ## Print the public keys of the global service admin
	$(if $(wildcard secrets/service-keyring.json),,$(error Service keyring not found))
	@zenroom -z -k secrets/service-keyring.json -a client/v1/did-settings.json client/v1/create-identity-pubkeys.zen 2>/dev/null | jq .

accept-admin:
accept-admin: ## Local command to accept an admin [ REQUEST ]
	$(if ${REQUEST},\
		$(info Accepting request: ${REQUEST}),\
		$(error Missing argument: REQUEST))
	$(if $(wildcard ${REQUEST}),,$(error Request not found: ${REQUEST}))
	@sh ./scripts/accept-admin-request.sh ${REQUEST}

update: ## Update all service dependencies
	$(info Updating to latest packages)
	@cd restroom && rm -f package-lock.json && npm i zenroom@latest @restroom-mw/files@next && npm list

scrub: DATA ?= ${PWD}/data/dyne
scrub: ## Check all signed proofs in data/
	@bash scripts/scrub.sh "${DATA}"

clean: ## Clean all NodeJS dependencies
	$(info Cleaning all dependencies - need a new install-deps)
	@rm -rf node_modules package-lock.json
	@rm -rf restroom/node_modules restroom/package-lock.json
