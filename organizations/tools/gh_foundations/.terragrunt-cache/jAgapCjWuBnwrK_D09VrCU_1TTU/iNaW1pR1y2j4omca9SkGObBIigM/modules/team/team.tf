resource "github_team" "team" {
  name        = var.team_name
  description = var.team_description
  privacy     = var.privacy
}