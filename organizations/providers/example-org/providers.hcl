# Example provider configuration for an organization
# This file demonstrates how to configure the GitHub provider for a specific organization

locals {
  organization_name      = "example-org"
  secret_manager_project = get_env("GCP_SECRET_MANAGER_PROJECT")
}

generate "github_provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF

provider "google" {
}

data "google_secret_manager_secret_version_access" "pem_file" {
  project = "${local.secret_manager_project}"
  secret  = "github-app-${local.organization_name}-pem"
}

data "google_secret_manager_secret" "pem_file_metadata" {
  project   = "${local.secret_manager_project}"
  secret_id = "github-app-${local.organization_name}-pem"
}

provider "github" {
  owner = "${local.organization_name}"
  app_auth {
    id              = data.google_secret_manager_secret.pem_file_metadata.annotations.appId
    installation_id = data.google_secret_manager_secret.pem_file_metadata.annotations.installationId
    pem_file        = data.google_secret_manager_secret_version_access.pem_file.secret_data
  }
}
EOF
}
