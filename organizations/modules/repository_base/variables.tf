variable "name" {
  type        = string
  description = "The name of the repository to create/import."
}

variable "description" {
  type        = string
  description = "The description to give to the repository. Defaults to `\"\"`"
  default     = ""
}

variable "default_branch" {
  type        = string
  description = "The branch to set as the default branch for this repository. Defaults to \"main\""
  default     = "main"
}

variable "repository_team_permissions" {
  type        = map(string)
  description = "A map where the keys are github team ids and the value is the permissions the team should have in the repository"
}

variable "protected_branches" {
  type        = list(string)
  description = "A list of ref names or patterns that should be protected. Defaults `[\"main\"]`"
  default     = ["main"]
}

variable "has_downloads" {
  description = "Enables downloads for the repository"
  type        = bool
  default     = false
}

variable "has_discussions" {
  description = "Enables Github Discussions."
  type        = bool
  default     = true
}

variable "has_issues" {
  description = "Enables Github Issues for the repository"
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Enables Github Projects for the repository"
  type        = bool
  default     = true
}

variable "has_wiki" {
  description = "Enables Github Wiki for the repository"
  type        = bool
  default     = true
}

variable "has_vulnerability_alerts" {
  description = "Enables security alerts for vulnerable dependencies for the repository"
  type        = bool
  default     = true
}

variable "topics" {
  description = "The topics to apply to the repository"
  type        = list(string)
  default     = []
}

variable "homepage" {
  description = "The homepage for the repository"
  type        = string
  default     = ""
}

variable "delete_head_on_merge" {
  description = "Sets the delete head on merge option for the repository. If true it will delete pull request branches automatically on merge. Defaults to true"
  type        = bool
  default     = true
}

variable "allow_auto_merge" {
  description = "Allow auto-merging pull requests on the repository"
  type        = bool
  default     = true
}

variable "visibility" {
  description = "Sets the visibility property of a repository. Defaults to \"private\""
  type        = string
  default     = "private"
}

variable "secret_scanning" {
  description = "Enables secret scanning for the repository. If repository is private `advance_security` must also be enabled."
  type        = bool
  default     = true
}

variable "secret_scanning_on_push" {
  description = "Enables secret scanning push protection for the repository. If repository is private `advance_security` must also be enabled."
  type        = bool
  default     = true
}

variable "advance_security" {
  description = "Enables advance security for the repository. If repository is public `advance_security` is enabled by default and cannot be changed."
  type        = bool
  default     = true
}

variable "dependabot_security_updates" {
  description = "Enables dependabot security updates. Only works when `has_vulnerability_alerts` is set because that is required to enable dependabot for the repository."
  type        = bool
  default     = true
}