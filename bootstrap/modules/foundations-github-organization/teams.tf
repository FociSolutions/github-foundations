resource "github_team" "foundation_devs" {
  name        = "foundation-devs"
  description = "Team members with write access to the foundation repositories"
  privacy     = "closed"
}