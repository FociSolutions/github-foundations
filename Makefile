# Makefile for GitHub Foundations Organizations Layer
# This provides convenient commands for testing, formatting, and validation

.PHONY: help init test format format-check lint validate security clean all

help: ## Show this help message
	@echo "GitHub Foundations Organizations Layer - Development Commands"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Initialize Terraform
	@echo "Initializing Terraform..."
	cd organizations && terraform init

test: init ## Run Terraform tests
	@echo "Running Terraform tests..."
	cd organizations && terraform test -verbose

format: ## Format Terraform and Terragrunt files
	@echo "Formatting Terraform files..."
	cd organizations && terraform fmt -recursive
	@echo "Formatting Terragrunt files..."
	cd organizations && terragrunt hclfmt

format-check: ## Check if Terraform and Terragrunt files are formatted
	@echo "Checking Terraform formatting..."
	cd organizations && terraform fmt -check -diff -recursive
	@echo "Checking Terragrunt formatting..."
	cd organizations && terragrunt hclfmt --terragrunt-check --terragrunt-diff

validate: init ## Validate Terraform configuration
	@echo "Validating Terraform configuration..."
	cd organizations && terraform validate

lint: ## Run TFLint on Terraform files (requires tflint)
	@echo "Running TFLint..."
	@if command -v tflint >/dev/null 2>&1; then \
		cd organizations && tflint --init && tflint --recursive; \
	else \
		echo "TFLint not installed. Install from: https://github.com/terraform-linters/tflint"; \
		exit 1; \
	fi

security: ## Run security scan with Trivy (requires trivy)
	@echo "Running security scan..."
	@if command -v trivy >/dev/null 2>&1; then \
		trivy config organizations/; \
	else \
		echo "Trivy not installed. Install from: https://aquasecurity.github.io/trivy/"; \
		exit 1; \
	fi

clean: ## Clean Terraform artifacts
	@echo "Cleaning Terraform artifacts..."
	find organizations -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	find organizations -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null || true
	find organizations -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true

pre-commit-install: ## Install pre-commit hooks
	@echo "Installing pre-commit hooks..."
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit install; \
		echo "Pre-commit hooks installed successfully!"; \
	else \
		echo "pre-commit not installed. Install with: pip install pre-commit"; \
		exit 1; \
	fi

pre-commit-run: ## Run pre-commit hooks on all files
	@echo "Running pre-commit hooks..."
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit run --all-files; \
	else \
		echo "pre-commit not installed. Install with: pip install pre-commit"; \
		exit 1; \
	fi

all: format validate test ## Run format, validate, and test

check: format-check validate test ## Run format check, validate, and test (for CI)

.DEFAULT_GOAL := help
