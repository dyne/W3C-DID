ANSIPLAY = ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory staging.toml --ssh-common-args '-o StrictHostKeyChecking=accept-new -o IdentitiesOnly=yes' --private-key ./sshkey $(1)

##@ General
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' Makefile

##@ Server management
install: ## Install controller
	$(call ANSIPLAY, setup-controller.yaml)

tls: ## Install SSL/TLS certificate
	$(call ANSIPLAY, acme-certificate.yaml)

