.PHONY: help prepare daemon sshconfig docker-services traefik

VENV := .venv
PYTHON ?= 3.12
HOST ?= ${HOST}

define run_with_host
	@export HOST="$${HOST:-$$(bash tools/select-hosts.sh)}"; \
	. $(VENV)/bin/activate && $(1) -l $$HOST
endef

help:
		@echo 'Targets:'
		@echo '  make prepare               - bootstrap uv, venv, and poetry (macOS / Ubuntu)'
		@echo '  make sshconfig             - change ssh config on localhost'
		@echo '  make docker-services       - deploy docker-services (HOST or fzf)'
		@echo '  make traefik               - deploy traefik with its config (HOST or fzf)'
		@echo ''
		@echo 'HOST can be one host or comma-separated: HOST=ru01.sbog.org,us03.sbog.org'
		@echo 'Without HOST, fzf prompts for host(s) from host_vars/'

prepare:
		@bash tools/prepare.sh "$(PYTHON)"

sshconfig: prepare
		@. $(VENV)/bin/activate && ./playbooks/utils/run-desktop.yml -c 'localhost,' -t sshconfig

docker-services: prepare
		$(call run_with_host,./playbooks/services/run-docker-services.yml)

traefik: prepare
		$(call run_with_host,./playbooks/services/run-traefik.yml)
