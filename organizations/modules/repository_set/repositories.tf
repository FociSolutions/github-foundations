module "public_repositories" {
  source = "../public_repository"

  for_each = var.public_repositories

  name                        = each.key
  repository_team_permissions = merge(var.default_repository_team_permissions, each.value.repository_team_permissions_override)
  description                 = each.value.description
  default_branch              = each.value.default_branch
  protected_branches          = each.value.protected_branches
  advance_security            = each.value.advance_security
  topics                      = each.value.topics
  homepage                    = each.value.homepage
  delete_head_on_merge        = each.value.delete_head_on_merge
  allow_auto_merge            = each.value.allow_auto_merge
  dependabot_security_updates = each.value.dependabot_security_updates
}

module "private_repositories" {
  source = "../private_repository"

  for_each = var.private_repositories

  name                        = each.key
  repository_team_permissions = merge(var.default_repository_team_permissions, each.value.repository_team_permissions_override)
  description                 = each.value.description
  default_branch              = each.value.default_branch
  protected_branches          = each.value.protected_branches
  advance_security            = each.value.advance_security
  topics                      = each.value.topics
  homepage                    = each.value.homepage
  delete_head_on_merge        = each.value.delete_head_on_merge
  allow_auto_merge            = each.value.allow_auto_merge
  dependabot_security_updates = each.value.dependabot_security_updates
}
