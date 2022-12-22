##@ General
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' Makefile

##@ Docker image management
docker-build:
	docker rm $$(docker ps -aq -f "ancestor=w3cdid") || echo "No container"
	docker rmi w3cdid || echo "No image"
	docker build -t w3cdid .
docker-start:
	docker run -it --name w3cdid w3cdid bash
docker-ip:
	sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" w3cdid
docker-commit:
	$(if ${ID},,$(error Container ID is not defined))
	docker commit --change 'CMD ["/bin/bash","/startup.sh"]' ${ID} dyne/w3c-did-driver:latest

