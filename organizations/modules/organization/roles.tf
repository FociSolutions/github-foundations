resource "github_organization_custom_role" "custom_repository_role" {
  for_each    = var.custom_repository_roles
  name        = each.key
  description = each.value.description
  base_role   = each.value.base_role
  permissions = each.value.permissions

  lifecycle {
    precondition {
      condition     = length(var.custom_repository_roles) <= 5 - (var.enable_security_engineer_role ? 1 : 0) - (var.enable_contractor_role ? 1 : 0) - (var.enable_community_manager_role ? 1 : 0)
      error_message = "To many custom repository roles defined, an orrganization's maximum is 5. This limit is reduced by one for each of the following variables that are set to true: `enable_security_engineer_role`, `enable_contractor_role`, `enable_community_manager_role`."
    }
  }
}

resource "github_organization_custom_role" "security_engineer_role" {
  count       = var.enable_security_engineer_role ? 1 : 0
  name        = "Security Engineer"
  description = "Security Engineers have maintainer permissions and are able to contribute code and maintain the security pipeline."
  base_role   = "maintain"
  permissions = [
    "delete_alerts_code_scanning",
    "write_code_scanning"
  ]
}

resource "github_organization_custom_role" "contractor_role" {
  count       = var.enable_contractor_role ? 1 : 0
  name        = "Contractor"
  description = "Contractors have write permissions and are able to develop webhooks integrations."
  base_role   = "write"
  permissions = [
    "manage_webhooks"
  ]
}

resource "github_organization_custom_role" "community_manager_role" {
  count       = var.enable_community_manager_role ? 1 : 0
  name        = "Community Manager"
  description = "Community Managers have read permissions and are able to handle all the community interactions without being able to contribute code."
  base_role   = "read"
  permissions = [
    "mark_as_duplicate",
    "manage_settings_pages",
    "manage_settings_wiki",
    "set_social_preview",
    "edit_repo_metadata",
    "edit_discussion_category",
    "create_discussion_category",
    "edit_category_on_discussion",
    "toggle_discussion_answer",
    "convert_issues_to_discussions",
    "close_discussion",
    "reopen_discussion",
    "delete_discussion_comment"
  ]
}
