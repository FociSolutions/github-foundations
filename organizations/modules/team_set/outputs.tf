output "team_slugs" {
  value = {
    for _, team in module.team : team.name => team.slug
  }
  description = "Map of team names to their respective slugs"
}