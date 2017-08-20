THIS_FILE := $(lastword $(MAKEFILE_LIST))

.DEFAULT_GOAL := help

build-db: ## Builds the DB
	rm -f db/crud-db.sqlt
	sqlite3 db/crud-db.sqlt < resources/create_db.sql
	sqlite3 db/crud-db.sqlt < resources/add_seed_data.sql

run: ## Run the project
	time stack build && stack exec crud-sqlite-exe

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
