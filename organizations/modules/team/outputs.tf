output "slug" {
  value       = local.create_team ? github_team.team[0].slug : null
  description = "The slug of the created team."
}

output "name" {
  value       = local.create_team ? github_team.team[0].name : null
  description = "Name of the created team."
}