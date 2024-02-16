variable "private_repositories" {
  type = map(object({
    description                          = string
    default_branch                       = string
    repository_team_permissions_override = map(string)
    protected_branches                   = list(string)
    advance_security                     = bool
    has_vulnerability_alerts             = bool
    topics                               = list(string)
    homepage                             = string
    delete_head_on_merge                 = bool
    allow_auto_merge                     = bool
    dependabot_security_updates          = bool
  }))
  description = "A map of private repositories where the key is the repository name and the value is the configuration"
}

variable "public_repositories" {
  type = map(object({
    description                          = string
    default_branch                       = string
    repository_team_permissions_override = map(string)
    protected_branches                   = list(string)
    advance_security                     = bool
    topics                               = list(string)
    homepage                             = string
    delete_head_on_merge                 = bool
    allow_auto_merge                     = bool
    dependabot_security_updates          = bool
  }))
  description = "A map of public repositories where the key is the repository name and the value is the configuration"
}

variable "default_repository_team_permissions" {
  type        = map(string)
  description = "A map where the keys are github team slugs and the value is the permissions the team should have by default for every repository. If an entry exists in `repository_team_permissions_override` for a repository then that will take precedence over this default."

}
