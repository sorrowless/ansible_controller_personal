.PHONY: help prepare sshconfig docker-services traefik

VENV := .venv
PYTHON ?= 3.12
HOST ?= ${HOST}

help:
	  @echo 'Define $HOST variable before run commands - most playbooks needs it'
		@echo 'Targets:'
		@echo '  make prepare       			  - bootstrap uv, venv, and poetry (macOS / Ubuntu)'
		@echo '  make sshconfig     			  - change ssh config on localhost'
		@echo '  make docker-services       - deploy docker-services'
		@echo '  make traefik               - deploy traefik with its config'

prepare:
		@bash tools/prepare.sh "$(PYTHON)"

sshconfig: prepare
		@. $(VENV)/bin/activate && ./playbooks/utils/run-desktop.yml -c 'localhost,' -t sshconfig

docker-services: prepare
		@. $(VENV)/bin/activate && ./playbooks/services/run-docker-services.yml -l ${HOST}

traefik: prepare
		@. $(VENV)/bin/activate && ./playbooks/services/run-traefik.yml -l ${HOST}
