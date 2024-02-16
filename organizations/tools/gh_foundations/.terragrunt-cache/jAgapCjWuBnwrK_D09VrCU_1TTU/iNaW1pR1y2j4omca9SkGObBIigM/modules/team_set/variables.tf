variable "teams" {
  type = map(object({
    description = string
    privacy     = string
    maintainers = list(string)
    members     = list(string)
  }))
  description = "A map of teams to create where the key is the team name and the value is the configuration"
}
