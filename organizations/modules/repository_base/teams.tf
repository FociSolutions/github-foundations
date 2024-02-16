resource "github_repository_collaborators" "collaborators" {
  repository = github_repository.repository.name

  dynamic "team" {
    for_each = var.repository_team_permissions
    content {
      permission = team.value
      team_id    = team.key
    }
  }
}
