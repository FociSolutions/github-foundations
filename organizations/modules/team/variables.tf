variable "team_name" {
  type        = string
  description = "The name to give to the github team that will be created."
}

variable "privacy" {
  type        = string
  description = "The privacy setting for the github team. Must be one of `closed` or `secret`."
  default     = "closed"
}

variable "team_description" {
  type        = string
  description = "Description of the github team to be created."
  default     = ""
}

variable "team_maintainers" {
  type        = list(string)
  description = "A list of team maintainers for the github team. These user's will have permissions to manage the team."
  validation {
    condition     = length(var.team_maintainers) > 0
    error_message = "The team_maintainers value must be a list of atleast length 1."
  }
}

variable "team_members" {
  type        = list(string)
  description = "A list of team members for the github team. These user's will not have permissions to manage the team."
  default     = []
}

variable "team_id" {
  type        = string
  description = "The ID of the team if it exists (optional)."
  default     = ""
}