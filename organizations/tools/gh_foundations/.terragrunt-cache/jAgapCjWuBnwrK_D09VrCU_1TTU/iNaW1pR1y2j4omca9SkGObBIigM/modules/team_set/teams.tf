module "team" {
  source = "../team"

  for_each = var.teams

  team_maintainers = each.value.maintainers
  team_members     = each.value.members
  team_description = each.value.description
  privacy          = each.value.privacy
  team_name        = each.key
}
