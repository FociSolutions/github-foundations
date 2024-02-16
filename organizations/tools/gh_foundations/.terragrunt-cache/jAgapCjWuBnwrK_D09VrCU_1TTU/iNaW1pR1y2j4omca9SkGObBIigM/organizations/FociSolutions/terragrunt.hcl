locals {
  organization_billing_email = "dan.mccrady@focisolutions.com"
  organization_email         = "info@focisolutions.com"
  organization_blog          = "http://focisolutions.com"
  organization_location      = "Gatineau Quebec"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "providers" {
  path   = "${get_repo_root()}/providers/${basename(get_terragrunt_dir())}/providers.hcl"
  expose = true
}

terraform {
  source = "${get_repo_root()}//modules/organization_settings"
}

inputs = {
  github_organization_id            = include.providers.locals.organization_name
  github_organization_billing_email = local.organization_billing_email
  github_organization_email         = local.organization_email
  github_organization_blog          = local.organization_blog
  github_organization_location      = local.organization_location

  github_organization_blocked_users                          = []
  github_organization_enable_ghas                            = false
  github_organization_enable_dependabot_alerts               = true
  github_organization_enable_dependabot_updates              = true
  github_organization_enable_dependancy_graph                = true
  github_organization_enable_secret_scanning                 = true
  github_organization_enable_secret_scanning_push_protection = true
  github_organization_requires_web_commit_signing            = true
  github_organization_repository_settings = {
    members_can_create_public   = true,
    members_can_create_internal = true,
    members_can_create_private  = true
  }
}