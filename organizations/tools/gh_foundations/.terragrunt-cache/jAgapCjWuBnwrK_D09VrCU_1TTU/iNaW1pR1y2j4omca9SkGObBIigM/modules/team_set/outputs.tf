output "team_ids" {
  value = {
    for _, team in module.team : team.name => team.id
  }
  description = "Map of team names to their respective ids"
}