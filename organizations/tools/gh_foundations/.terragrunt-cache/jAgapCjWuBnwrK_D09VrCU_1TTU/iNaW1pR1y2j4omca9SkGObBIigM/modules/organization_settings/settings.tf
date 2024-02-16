locals {
  members_can_create_pages        = var.github_organization_pages_settings.members_can_create_public || var.github_organization_pages_settings.members_can_create_private
  members_can_create_repositories = var.github_organization_repository_settings.members_can_create_public || var.github_organization_repository_settings.members_can_create_internal || var.github_organization_repository_settings.members_can_create_private
}

import {
  to = github_organization_settings.organization_settings
  id = var.github_organization_id
}

resource "github_organization_settings" "organization_settings" {
  billing_email               = var.github_organization_billing_email
  email                       = var.github_organization_email
  blog                        = var.github_organization_blog
  location                    = var.github_organization_location
  web_commit_signoff_required = var.github_organization_requires_web_commit_signing
  has_organization_projects   = true
  has_repository_projects     = true

  # Github advance security, dependabot, and secret scanning
  advanced_security_enabled_for_new_repositories               = var.github_organization_enable_ghas
  dependabot_alerts_enabled_for_new_repositories               = var.github_organization_enable_dependabot_alerts
  dependabot_security_updates_enabled_for_new_repositories     = var.github_organization_enable_dependabot_updates
  dependency_graph_enabled_for_new_repositories                = var.github_organization_enable_dependancy_graph
  secret_scanning_enabled_for_new_repositories                 = var.github_organization_enable_secret_scanning
  secret_scanning_push_protection_enabled_for_new_repositories = var.github_organization_enable_secret_scanning_push_protection

  #Organization pages
  members_can_create_pages         = local.members_can_create_pages
  members_can_create_public_pages  = var.github_organization_pages_settings.members_can_create_public
  members_can_create_private_pages = var.github_organization_pages_settings.members_can_create_private

  #Oranization Repository settings
  members_can_create_repositories          = local.members_can_create_repositories
  members_can_create_public_repositories   = var.github_organization_repository_settings.members_can_create_public
  members_can_create_internal_repositories = var.github_organization_repository_settings.members_can_create_internal
  members_can_create_private_repositories  = var.github_organization_repository_settings.members_can_create_private
  default_repository_permission            = "none"
  members_can_fork_private_repositories    = false

  lifecycle {
    ignore_changes = [
      name,
      description,
      billing_email
    ]
  }
}
