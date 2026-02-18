# Testing Guide for Organizations Layer

This guide explains how to test your Terraform and Terragrunt configurations in the organizations layer before committing changes.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Running Tests](#running-tests)
- [Format Checking](#format-checking)
- [Pre-commit Hooks](#pre-commit-hooks)
- [Validation](#validation)
- [Security Scanning](#security-scanning)
- [Example Configurations](#example-configurations)

## Prerequisites

Before running tests, ensure you have the following installed:

- **Terraform** (v1.7.5 or later): [Installation Guide](https://developer.hashicorp.com/terraform/downloads)
- **Terragrunt** (v0.55.18 or later): [Installation Guide](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- **TFLint** (optional but recommended): [Installation Guide](https://github.com/terraform-linters/tflint)
- **pre-commit** (optional but recommended): [Installation Guide](https://pre-commit.com/#install)

## Running Tests

### Terraform Native Tests

The organizations layer includes a comprehensive test file (`main.tftest.hcl`) that validates:
- Organization settings configuration
- Repository configuration
- Team configuration
- Security settings
- Naming conventions
- Email format validation

To run the tests:

```bash
cd organizations/
terraform init
terraform test -verbose
```

The test output will show:
- ✅ Passed tests (all assertions successful)
- ❌ Failed tests (with specific error messages)

### Example Test Output

```
main.tftest.hcl... in progress
  run "organization_settings_validation"... pass
  run "repository_configuration_validation"... pass
  run "team_configuration_validation"... pass
  run "security_settings_validation"... pass
  run "naming_conventions_validation"... pass
  run "email_format_validation"... pass
main.tftest.hcl... tearing down
main.tftest.hcl... pass
```

## Format Checking

### Check Terraform Formatting

Check if your Terraform files are properly formatted:

```bash
cd organizations/
terraform fmt -check -diff -recursive
```

To automatically format files:

```bash
terraform fmt -recursive
```

### Check Terragrunt Formatting

Check Terragrunt HCL files:

```bash
cd organizations/
terragrunt hclfmt --terragrunt-check --terragrunt-diff
```

To automatically format Terragrunt files:

```bash
terragrunt hclfmt
```

## Pre-commit Hooks

This repository includes pre-commit hooks that automatically run checks before each commit.

### Setup Pre-commit Hooks

1. Install pre-commit:
   ```bash
   pip install pre-commit
   # or
   brew install pre-commit
   ```

2. Install the hooks:
   ```bash
   cd /home/runner/work/github-foundations/github-foundations
   pre-commit install
   ```

3. (Optional) Run hooks manually:
   ```bash
   pre-commit run --all-files
   ```

### Included Hooks

The pre-commit configuration includes:
- **terraform_fmt**: Checks Terraform formatting
- **terragrunt_fmt**: Checks Terragrunt HCL formatting
- **terraform_tflint**: Runs TFLint on Terraform files
- **terraform_validate**: Validates Terraform syntax
- **terraform_trivy**: Security scanning of Terraform code
- **gitleaks**: Detects secrets in code
- **trailing-whitespace**: Removes trailing whitespace
- **end-of-file-fixer**: Ensures files end with a newline
- **check-added-large-files**: Prevents committing large files
- **detect-private-key**: Detects private keys

## Validation

### Validate Terraform Configuration

Validate that your Terraform configuration is syntactically valid:

```bash
cd organizations/
terraform init
terraform validate
```

### Validate Terragrunt Configuration

Validate your Terragrunt configuration:

```bash
cd organizations/
terragrunt validate-inputs
```

## Security Scanning

### TFLint

Run TFLint to check for potential issues:

```bash
cd organizations/
tflint --init
tflint --recursive
```

### Trivy

Run Trivy for security scanning:

```bash
cd organizations/
trivy config .
```

## Example Configurations

The `organizations/` folder includes example configurations to help you get started:

### Organization Settings
- **Location**: `organizations/example-org/terragrunt.hcl`
- **Purpose**: Example organization-level settings

### Project Structure
- **Location**: `projects/example-project/example-org/`
- **Purpose**: Example project with repositories and teams

#### Repositories
- **Location**: `projects/example-project/example-org/repositories/terragrunt.hcl`
- **Includes**:
  - Public repository example
  - Private repository example
  - Application repository with branch protection

#### Teams
- **Location**: `projects/example-project/example-org/teams/terragrunt.hcl`
- **Includes**:
  - Admin team
  - Developer team
  - Viewer team
  - Security team (secret)

### Provider Configuration
- **Location**: `providers/example-org/providers.hcl`
- **Purpose**: GitHub provider setup with GCP Secret Manager integration

## Testing Workflow

Follow this workflow before committing changes:

1. **Make your changes** to Terraform/Terragrunt files

2. **Format your code**:
   ```bash
   terraform fmt -recursive
   terragrunt hclfmt
   ```

3. **Validate syntax**:
   ```bash
   terraform validate
   ```

4. **Run tests**:
   ```bash
   terraform test -verbose
   ```

5. **Run security scans**:
   ```bash
   tflint --recursive
   trivy config .
   ```

6. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: your commit message"
   ```
   
   Pre-commit hooks will automatically run and validate your changes.

## Continuous Integration

When you push your changes or create a pull request, GitHub Actions will automatically:
- Check Terraform formatting
- Check Terragrunt formatting
- Run Terraform plan
- Validate configurations
- Scan for security issues

The CI pipeline uses the same tools and configurations as local development, ensuring consistency.

## Troubleshooting

### Common Issues

**Issue**: `terraform test` fails with module not found
- **Solution**: Run `terraform init` first to download required modules

**Issue**: Pre-commit hooks fail
- **Solution**: Run `pre-commit run --all-files` to see detailed errors

**Issue**: Format check fails
- **Solution**: Run `terraform fmt -recursive` and `terragrunt hclfmt` to auto-format

**Issue**: TFLint fails
- **Solution**: Run `tflint --init` to download required plugins

## Additional Resources

- [Terraform Testing Documentation](https://developer.hashicorp.com/terraform/language/tests)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [TFLint Rules](https://github.com/terraform-linters/tflint/tree/master/docs/rules)
- [Pre-commit Terraform Hooks](https://github.com/antonbabenko/pre-commit-terraform)
