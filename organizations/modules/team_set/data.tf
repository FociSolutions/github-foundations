locals {
  distinct_states = distinct([
    for team in var.preexisting_teams : {
      bucket = team.bucket
      prefix = team.prefix
    }
  ])

  team_to_state_index_map = {
    for team_name, team_config in var.preexisting_teams : team_name => index(local.distinct_states, {
      bucket = team_config.bucket
      prefix = team_config.prefix
    })
  }
}

data "terraform_remote_state" "state" {
  for_each = {
    for i, state in local.distinct_states : "${i}" => state
  }
  backend = "gcs"
  config = {
    bucket = each.value.bucket
    prefix = each.value.prefix
  }
}