locals {
  team_id = local.create_team ? github_team.team[0].id : var.team_id
}

resource "github_team_membership" "maintainers" {
  for_each = toset(var.team_maintainers)
  team_id  = local.team_id
  username = each.value
  role     = "maintainer"
}

resource "github_team_membership" "members" {
  for_each = toset(var.team_members)
  team_id  = local.team_id
  username = each.value
  role     = "member"
} 