# Makefile for Go Library Release

PROJECT_NAME ?= $(shell basename "$(PWD)")
VERSION_FILE = VERSION
CHANGELOG_FILE = CHANGELOG.md
BUMP_SCRIPT = bump_version.sh

# Default target: Show help
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  help         Show this help message"
	@echo "  init         Initialize version file if it doesn't exist (v0.1.0)"
	@echo "  version      Show current version"
	@echo "  bump-major   Bump major version (e.g., v1.0.0)"
	@echo "  bump-minor   Bump minor version (e.g., v0.2.0)"
	@echo "  bump-patch   Bump patch version (e.g., v0.1.1)"
	@echo "  tag          Create a new Git tag with the current version and update CHANGELOG"
	@echo "  push         Push tags and commits to the remote repository"
	@echo "  update-repo    Pull latest changes from the remote repository"

.PHONY: init
init:
ifeq ($(wildcard $(VERSION_FILE)),)
	echo "v0.1.0" > $(VERSION_FILE)
	@echo "Initialized $(VERSION_FILE) with v0.1.0"
endif

.PHONY: version
version:
	@cat $(VERSION_FILE)

.PHONY: bump-major
bump-major:
	$(BUMP_SCRIPT) major

.PHONY: bump-minor
bump-minor:
	$(BUMP_SCRIPT) minor

.PHONY: bump-patch
bump-patch:
	$(BUMP_SCRIPT) patch

.PHONY: tag
tag: version
	current_version := $(shell cat $(VERSION_FILE))
	git tag -a "$(current_version)" -m "Release $(current_version)"
	git log --pretty=format:"- %ad: %s" --date=short $(shell git describe --tags --abbrev=0 HEAD^)..HEAD >> $(CHANGELOG_FILE)
	@echo "Tagged version $(current_version) and updated $(CHANGELOG_FILE)"

.PHONY: push
push:
	git push origin --tags
	git push origin HEAD

.PHONY: update-repo
update-repo:
	git pull origin $(shell git rev-parse --abbrev-ref HEAD)

# Default action is to show help
default: help
