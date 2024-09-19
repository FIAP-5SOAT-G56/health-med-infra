#!/bin/bash

NETWORK_NAME=local-network
NETWORK_ID=$(shell docker network ls -qf "name=${NETWORK_NAME}")

.PHONY: add-network
add-network:
	@if [ -n '${NETWORK_ID}' ]; then \
		echo 'The ${NETWORK_NAME} network already exists. Skipping...'; \
	else \
		docker network create -d bridge ${NETWORK_NAME}; \
	fi

NETWORK_NAME=local-network
NETWORK_ID=$(shell docker network ls -qf "name=${NETWORK_NAME}")

.PHONY: up
up: add-network
	docker compose up --remove-orphans -d

.PHONY: down
down:
	docker compose down

.PHONY: logs
logs:
	docker compose logs -f

# Containers CLI
localstack:
	docker compose run localstack bash

redis:
	docker compose run local-redis redis-cli

# Terraform
tf-init:
	terraform -chdir=terraform init

tf-plan:
	terraform -chdir=terraform plan

tf-apply:
	terraform -chdir=terraform apply -auto-approve

tf-destroy:
	terraform -chdir=terraform destroy -auto-approve