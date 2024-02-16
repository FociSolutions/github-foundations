resource "github_organization_block" "blocked_user" {
  for_each = toset(var.github_organization_blocked_users)

  username = each.value
}