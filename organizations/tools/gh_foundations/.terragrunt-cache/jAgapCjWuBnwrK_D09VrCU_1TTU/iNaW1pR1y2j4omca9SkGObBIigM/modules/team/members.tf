resource "github_team_membership" "maintainers" {
  for_each = toset(var.team_maintainers)
  team_id  = github_team.team.id
  username = each.value
  role     = "maintainer"
}

resource "github_team_membership" "members" {
  for_each = toset(var.team_members)
  team_id  = github_team.team.id
  username = each.value
  role     = "member"
}