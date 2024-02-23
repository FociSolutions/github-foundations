resource "github_membership" "membership_for_user" {
  for_each = toset(var.github_organization_members)

  username = each.value
  role     = "member"
}