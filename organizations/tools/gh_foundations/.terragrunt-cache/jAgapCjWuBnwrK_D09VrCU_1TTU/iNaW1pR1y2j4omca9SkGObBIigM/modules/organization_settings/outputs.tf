output "ghas_enabled" {
  value = github_organization_settings.organization_settings.advanced_security_enabled_for_new_repositories
}