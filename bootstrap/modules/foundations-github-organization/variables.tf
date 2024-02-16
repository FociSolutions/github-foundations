variable "enterprise_id" {
  type        = string
  description = "The id of the enterprise account to create the organization under."
}

variable "github_foundations_organization_name" {
  type        = string
  description = "The name of the organization to create."
}

variable "billing_email" {
  type        = string
  description = "The email to use for the organizations billing."
}

variable "admin_logins" {
  type        = list(string)
  description = "List of organization owner usernames."
}

variable "workload_identity_provider_name" {
  type        = string
  description = "The name of the workload identity provider to use for the oidc of the github foundation repositories."
}

variable "bootstrap_workload_identity_sa" {
  type        = string
  description = "The service account to use for the bootstrap repository oidc."
}

variable "organization_workload_identity_sa" {
  type        = string
  description = "The service account to use for the organization repository oidc."
}

variable "gcp_project_id" {
  type        = string
  description = "The id of the gcp project where secret manager was setup."

}

variable "gcp_tf_state_bucket_project_id" {
  type        = string
  description = "The id of the gcp project where the tf state bucket was setup."
}

variable "bucket_name" {
  type        = string
  description = "The name of the tf state bucket."
}

variable "bucket_location" {
  type        = string
  description = "The location of the tf state bucket."
}