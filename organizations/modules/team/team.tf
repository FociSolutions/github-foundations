locals {
  create_team = length(var.team_id) > 0 ? false : true
}

resource "github_team" "team" {
  count       = local.create_team ? 1 : 0
  name        = var.team_name
  description = var.team_description
  privacy     = var.privacy
}