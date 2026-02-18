# Example organization settings configuration
# This file demonstrates how to configure organization settings using the organization_settings module
# Copy this file and modify for your own organization

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "providers" {
  path   = "${get_repo_root()}/organizations/providers/${basename(get_terragrunt_dir())}/providers.hcl"
  expose = true
}

terraform {
  source = "github.com/FociSolutions/github-foundations-modules//modules/organization_settings"
}

inputs = {
  # Organization basic information
  name          = "example-org"
  billing_email = "billing@example.com"
  company       = "Example Company"
  email         = "contact@example.com"
  location      = "Example Location"
  description   = "Example organization managed by GitHub Foundations"

  # Project settings
  has_organization_projects = true
  has_repository_projects   = true

  # Repository creation permissions
  default_repository_permission           = "read"
  members_can_create_repositories         = false
  members_can_create_public_repositories  = false
  members_can_create_private_repositories = false
  members_can_create_pages                = false
  members_can_fork_private_repositories   = false

  # Commit signoff requirement
  web_commit_signoff_required = true

  # Security settings for new repositories
  advanced_security_enabled_for_new_repositories               = true
  dependabot_alerts_enabled_for_new_repositories               = true
  dependabot_security_updates_enabled_for_new_repositories     = true
  dependency_graph_enabled_for_new_repositories                = true
  secret_scanning_enabled_for_new_repositories                 = true
  secret_scanning_push_protection_enabled_for_new_repositories = true
}
