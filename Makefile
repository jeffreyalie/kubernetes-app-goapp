# Makefile
# usage make <target>

.PHONY: init tidy fmt check all lint-yaml lint-action lint-helm help
.DEFAULT_GOAL := help

# ----------variables----------------------
HELM_CHART_PATH := ./helm-chart/kubernetes-app-nginx
GO = docker run --rm --user $(shell id -u):$(shell id -g) \
  -e HOME=/tmp -e GOCACHE=/tmp/.cache \
  -v "$(CURDIR)/app":/app -w /app golang:1.26.2-alpine


help:
	@echo "Available targets:"
	@echo "  lint-yaml - Check YAML syntax"
	@echo "  lint-helm - Lint Helm charts"
  @echo "  lintin-action - Lint GHA workflows actions"
  @echo "----------------------------------------------"
  @echo "   init - go init"
  @echo "   tidy - go tidy"
  @echo "   fmt - gofmt -l"
  @echo "   chechk - chech all"
  @echo "   all - go all"

#----------Go linting-----------------------
init:
  $(GO) go mod init grafan-lxd-monitoring

tidy:
  $(GO) go mod tidy

fmt:
  $(GO) gofmt -w .

check:
  $(GO) sh -c "gofmt -l . ; go vet ./... && go build -o /tmp/test ."

all:
  $(GO) sh -c "go mod tidy && gofmt -w . && go vet ./... && go build -o /tmp/main ."

# --------- Files Linting--------------

lint-yaml:
	@echo "Checking YAML syntax..."
	yamllint -s .

	@echo "Workflow linting completed!"

lint-action:
	@echo "Checking workflow syntax..."
	actionlint .gitea/workflows/*.yml

	@echo "Workflow linting completed!"

lint-helm:
	@echo "Linting Helm charts..."
	helm lint $(HELM_CHART_PATH)

	@echo "Helm linting completed!"
