module "team" {
  source = "../team"

  for_each = var.teams

  team_maintainers = each.value.maintainers
  team_members     = each.value.members
  team_description = each.value.description
  privacy          = each.value.privacy
  team_name        = each.key
}

module "prexisting_team" {
  source   = "../team"
  for_each = var.preexisting_teams

  team_id = data.terraform_remote_state.state[local.team_to_state_index_map[each.key]].outputs["${each.value.output_name}"]

  team_maintainers = each.value.maintainers
  team_members     = each.value.members
  team_name        = each.key
}
