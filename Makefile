.PHONY: help build build-local up down logs ps test
.DEFAULT_GOAL := help


DOCKER_TAG := latest
build: ## Build docker image to deploy
		docker build -t Kyosu-K/gotodo:${DOCKER_TAG} \
				--target deploy ./

build-local: ## Build docker image to local development
		docker compose build --no-cache

up: ## Do docker compose up with hot reload
		docker compose up -d

down: ## Do docker compose down
		docker compose down

logs: ## Tail docker compose logs
		docker compose logs -f

ps: ## Check container status
		docker compomse ps

test: ## Execute tests
		go test -race -shuffle=on ./...

dry-migrate: ## Try migration
	mysqldef -u ${TODO_DB_USER} -p ${TODO_DB_PASSWORD} -h ${TODO_DB_HOST} -P ${TODO_DB_PORT} ${TODO_DB_NAME} --dry-run < ./_tools/mysql/schema.sql

migrate:  ## Execute migration
	mysqldef -u ${TODO_DB_USER} -p ${TODO_DB_PASSWORD} -h ${TODO_DB_HOST} -P ${TODO_DB_PORT} ${TODO_DB_NAME} < ./_tools/mysql/schema.sql

generate: ## Generate codes
	go generate ./...

help: ## Show options
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
			awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' 