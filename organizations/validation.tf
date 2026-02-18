# Validation module for organizations layer
# This module provides input validation and type checking for configurations
# It doesn't create any real resources, just validates inputs

variable "organization_settings" {
  description = "Organization settings configuration"
  type = object({
    name                                                         = string
    billing_email                                                = string
    company                                                      = optional(string, "")
    email                                                        = optional(string, "")
    location                                                     = optional(string, "")
    description                                                  = optional(string, "")
    has_organization_projects                                    = optional(bool, true)
    has_repository_projects                                      = optional(bool, true)
    default_repository_permission                                = optional(string, "read")
    members_can_create_repositories                              = optional(bool, false)
    members_can_create_public_repositories                       = optional(bool, false)
    members_can_create_private_repositories                      = optional(bool, false)
    members_can_create_pages                                     = optional(bool, false)
    members_can_fork_private_repositories                        = optional(bool, false)
    web_commit_signoff_required                                  = optional(bool, true)
    advanced_security_enabled_for_new_repositories               = optional(bool, true)
    dependabot_alerts_enabled_for_new_repositories               = optional(bool, true)
    dependabot_security_updates_enabled_for_new_repositories     = optional(bool, true)
    dependency_graph_enabled_for_new_repositories                = optional(bool, true)
    secret_scanning_enabled_for_new_repositories                 = optional(bool, true)
    secret_scanning_push_protection_enabled_for_new_repositories = optional(bool, true)
  })

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.organization_settings.name))
    error_message = "Organization name must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.organization_settings.billing_email))
    error_message = "Billing email must be a valid email address."
  }

  validation {
    condition     = contains(["read", "write", "admin", "none"], var.organization_settings.default_repository_permission)
    error_message = "Default repository permission must be one of: read, write, admin, none."
  }
}

variable "public_repositories" {
  description = "Public repository configurations"
  type = map(object({
    description                          = string
    default_branch                       = optional(string, "main")
    repository_team_permissions_override = optional(map(string), {})
    advance_security                     = optional(bool, false)
    has_vulnerability_alerts             = optional(bool, true)
    topics                               = optional(list(string), [])
    homepage                             = optional(string, "")
    delete_head_on_merge                 = optional(bool, true)
    allow_auto_merge                     = optional(bool, true)
    dependabot_security_updates          = optional(bool, true)
  }))
  default = {}

  validation {
    condition = alltrue([
      for name, repo in var.public_repositories :
      can(regex("^[a-z0-9._-]+$", name))
    ])
    error_message = "Repository names must contain only lowercase letters, numbers, dots, underscores, and hyphens."
  }
}

variable "private_repositories" {
  description = "Private repository configurations"
  type = map(object({
    description                          = string
    default_branch                       = optional(string, "main")
    repository_team_permissions_override = optional(map(string), {})
    protected_branches                   = optional(list(any), [])
    advance_security                     = optional(bool, false)
    has_vulnerability_alerts             = optional(bool, true)
    topics                               = optional(list(string), [])
    homepage                             = optional(string, "")
    delete_head_on_merge                 = optional(bool, true)
    allow_auto_merge                     = optional(bool, true)
    dependabot_security_updates          = optional(bool, true)
  }))
  default = {}

  validation {
    condition = alltrue([
      for name, repo in var.private_repositories :
      can(regex("^[a-z0-9._-]+$", name))
    ])
    error_message = "Repository names must contain only lowercase letters, numbers, dots, underscores, and hyphens."
  }
}

variable "teams" {
  description = "Team configurations"
  type = map(object({
    name        = string
    description = string
    privacy     = optional(string, "closed")
    members     = list(string)
    maintainers = list(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for team_slug, team in var.teams :
      can(regex("^[a-z0-9-]+$", team_slug))
    ])
    error_message = "Team slugs must contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition = alltrue([
      for team_slug, team in var.teams :
      contains(["closed", "secret"], team.privacy)
    ])
    error_message = "Team privacy must be either 'closed' or 'secret'."
  }

  validation {
    condition = alltrue([
      for team_slug, team in var.teams :
      length(team.maintainers) > 0
    ])
    error_message = "Each team must have at least one maintainer."
  }

  validation {
    condition = alltrue([
      for team_slug, team in var.teams :
      alltrue([for maintainer in team.maintainers : contains(team.members, maintainer)])
    ])
    error_message = "All team maintainers must also be team members."
  }
}

# Output validation results
output "validation_passed" {
  description = "Indicates if all validations passed"
  value       = true
}

output "organization_name" {
  description = "Validated organization name"
  value       = var.organization_settings.name
}

output "repository_count" {
  description = "Total number of repositories configured"
  value       = length(var.public_repositories) + length(var.private_repositories)
}

output "team_count" {
  description = "Total number of teams configured"
  value       = length(var.teams)
}

output "security_settings" {
  description = "Organization security settings summary"
  value = {
    advanced_security_enabled      = var.organization_settings.advanced_security_enabled_for_new_repositories
    secret_scanning_enabled        = var.organization_settings.secret_scanning_enabled_for_new_repositories
    secret_push_protection_enabled = var.organization_settings.secret_scanning_push_protection_enabled_for_new_repositories
    dependabot_alerts_enabled      = var.organization_settings.dependabot_alerts_enabled_for_new_repositories
    dependabot_updates_enabled     = var.organization_settings.dependabot_security_updates_enabled_for_new_repositories
  }
}
