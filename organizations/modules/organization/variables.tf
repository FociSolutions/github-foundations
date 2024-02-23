variable "github_organization_id" {
  type        = string
  description = "The ID of the organization to manage."
}

variable "github_organization_billing_email" {
  type        = string
  description = "The billing email to set for the organization."
}

variable "github_organization_members" {
  type        = list(string)
  default     = []
  description = "A list of usernames to invite to the organization. Defaults to `[]`."
}

variable "github_organization_blocked_users" {
  type        = list(string)
  default     = []
  description = "A list of usernames to block from the organization. Defaults to `[]`."
}

variable "github_organization_enable_ghas" {
  type        = bool
  default     = true
  description = "If set github advance security will be enabled for new repositories in the organization. Defaults to `true`."
}

variable "github_organization_enable_dependabot_alerts" {
  type        = bool
  default     = true
  description = "If set dependabot alerts will be enabled for new repositories in the organization. Defaults to `true`."
}

variable "github_organization_enable_dependabot_updates" {
  type        = bool
  default     = true
  description = "If set dependabot security updates will be enabled for new repositories in the organization. Defaults to `true`."
}

variable "github_organization_enable_dependancy_graph" {
  type        = bool
  default     = true
  description = "If set dependancy graph will be enabled for new repositories in the organization. Defaults to `true`."
}

variable "github_organization_enable_secret_scanning" {
  type        = bool
  default     = true
  description = "If set secret scanning will be enabled for new repositories in the organization. Defaults to `true`."
}

variable "github_organization_enable_secret_scanning_push_protection" {
  type        = bool
  default     = true
  description = "If set secret scanning push protection will be enabled for new repositories in the organization. Defaults to `true`."
}

variable "github_organization_pages_settings" {
  type = object({
    members_can_create_public  = bool,
    members_can_create_private = bool
  })
  default = {
    members_can_create_private = false,
    members_can_create_public  = false
  }
  description = "Settings for organization page creation. The default setting does not allow members to create public and private pages."
}

variable "github_organization_repository_settings" {
  type = object({
    members_can_create_public   = bool,
    members_can_create_internal = bool,
    members_can_create_private  = bool
  })
  default = {
    members_can_create_public   = false,
    members_can_create_internal = true,
    members_can_create_private  = true
  }
  description = "Settings for organization repository creation. The default setting allows members to create internal and private repositories but not public."
}

variable "github_organization_requires_web_commit_signing" {
  type        = bool
  default     = false
  description = "If set commit signatures are required for commits to the organization. Defaults to `false`."
}

variable "github_organization_blog" {
  type        = string
  default     = ""
  description = "Url to organization blog. Defaults to `''`."
}

variable "github_organization_email" {
  type        = string
  default     = ""
  description = "Organization email. Defaults to `''`."
}

variable "github_organization_location" {
  type        = string
  default     = ""
  description = "Organization location. Defaults to `''`."
}

variable "enable_security_engineer_role" {
  type        = bool
  default     = false
  description = "If `true` will create a custom repository role for security engineers. Defaults to `false`. If `true` the maximum number of `custom_repository_roles` that can be defined will be reduced by one."
}

variable "enable_contractor_role" {
  type        = bool
  default     = false
  description = "If `true` will create a custom repository role for contractors. Defaults to `false`. If `true` the maximum number of `custom_repository_roles` that can be defined will be reduced by one."
}

variable "enable_community_manager_role" {
  type        = bool
  default     = false
  description = "If `true` will create a custom repository role for community managers. Defaults to `false`. If `true` the maximum number of `custom_repository_roles` that can be defined will be reduced by one."
}

variable "custom_repository_roles" {
  type = map(object({
    description = string
    base_role   = string
    permissions = list(string)
  }))
  description = "A map of custom repository roles to create. The key is the name of the role and the value is the role configurations."
}
