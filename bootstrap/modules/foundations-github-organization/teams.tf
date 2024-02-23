resource "github_team" "foundation_devs" {
  provider = github.foundation_org_scoped

  name        = "foundation-devs"
  description = "Team members with write access to the foundation repositories"
  privacy     = "closed"
}
