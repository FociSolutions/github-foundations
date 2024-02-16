resource "github_team_repository" "team" {
  for_each   = var.repository_team_permissions
  depends_on = [github_repository.repository]
  team_id    = each.key
  repository = var.name
  permission = each.value
}