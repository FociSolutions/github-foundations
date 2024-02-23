output "ghas_enabled" {
  value       = github_organization_settings.organization_settings.advanced_security_enabled_for_new_repositories
  description = "A boolean value indicating if GitHub Advanced Security is enabled for new repositories in the organization."
}

output "custom_role_ids" {
  value = {
    for role in github_organization_custom_role.custom_repository_role : role.name => role.id
  }
  description = "A map of custom role names to custom role ids."
}

output "security_engineer_role_id" {
  value       = length(github_organization_custom_role.security_engineer_role) > 0 ? github_organization_custom_role.security_engineer_role[0].id : null
  description = "The id of the security engineer custom role."
}

output "contractor_role_id" {
  value       = length(github_organization_custom_role.contractor_role) > 0 ? github_organization_custom_role.contractor_role[0].id : null
  description = "The id of the contractor custom role."
}

output "community_manager_role_id" {
  value       = length(github_organization_custom_role.community_manager_role) > 0 ? github_organization_custom_role.community_manager_role[0].id : null
  description = "The id of the community manager custom role."
}