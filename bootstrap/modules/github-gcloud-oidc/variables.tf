#Organization Variables
variable "organization_id" {
  description = "The organization id."
  type        = string
}

#Folder Variables
variable "folder_create" {
  description = "Create folder. When set to false, uses id to reference an existing folder."
  type        = bool
  default     = true
}


variable "id" {
  description = "Folder ID in case you use folder_create=false."
  type        = string
  default     = null
}

variable "folder_name" {
  description = "Folder name."
  type        = string
  default     = null
}

variable "parent" {
  description = "Parent in folders/folder_id or organizations/org_id format."
  type        = string
  default     = null
  validation {
    condition     = var.parent == null || can(regex("(organizations|folders)/[0-9]+", var.parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}

#Project Variables

variable "project_name" {
  description = "Project name and id suffix."
  type        = string
}

variable "descriptive_name" {
  description = "Name of the project name. Used for project name instead of `project_name` variable."
  type        = string
  default     = null
}


variable "prefix" {
  description = "Optional prefix used to generate project id and name."
  type        = string
  default     = null
  validation {
    condition     = var.prefix != ""
    error_message = "Prefix cannot be empty, please use null instead."
  }
}

variable "project_create" {
  description = "Create project. When set to false, uses a data source to reference existing project."
  type        = bool
  default     = true
}

variable "billing_account" {
  description = "Billing account id."
  type        = string
  default     = null
}

variable "auto_create_network" {
  description = "Whether to create the default network for the project."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Resource labels."
  type        = map(string)
  default     = {}
}

variable "skip_delete" {
  description = "Allows the underlying resources to be destroyed without destroying the project itself."
  type        = bool
  default     = false
}

variable "services" {
  description = "Service APIs to enable."
  type        = list(string)
  default     = []
}

variable "project_parent" {
  description = "Parent folder or organization in 'folders/folder_id' or 'organizations/org_id' format."
  type        = string
  default     = null
  validation {
    condition     = var.project_parent == null || can(regex("(organizations|folders)/[0-9]+", var.project_parent))
    error_message = "Parent must be of the form folders/folder_id or organizations/organization_id."
  }
}

variable "service_config" {
  description = "Configure service API activation."
  type = object({
    disable_on_destroy         = bool
    disable_dependent_services = bool
  })
  default = {
    disable_on_destroy         = false
    disable_dependent_services = false
  }
}

#Storage Bucket Variables

variable "bucket_name" {
  description = "Bucket name "
  type        = string
}

variable "location" {
  description = "Bucket location."
  type        = string
}

variable "storage_class" {
  description = "Bucket storage class."
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "MULTI_REGIONAL", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be one of STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "force_destroy" {
  description = "Optional map to set force destroy keyed by name, defaults to false."
  type        = bool
  default     = false
}

variable "uniform_bucket_level_access" {
  description = "Allow using object ACLs (false) or not (true, this is the recommended behavior) , defaults to true (which is the recommended practice, but not the behavior of storage API)."
  type        = bool
  default     = true
}

variable "default_event_based_hold" {
  description = "Enable event based hold to new objects added to specific bucket, defaults to false."
  type        = bool
  default     = null
}

variable "requester_pays" {
  description = "Enables Requester Pays on a storage bucket."
  type        = bool
  default     = null
}

variable "versioning" {
  description = "Enable versioning, defaults to false."
  type        = bool
  default     = false
}

variable "autoclass" {
  description = "Enable autoclass to automatically transition objects to appropriate storage classes based on their access pattern. If set to true, storage_class must be set to STANDARD. Defaults to false."
  type        = bool
  default     = false
}

variable "website" {
  description = "Bucket website."
  type = object({
    main_page_suffix = optional(string)
    not_found_page   = optional(string)
  })
  default = null
}

variable "encryption_key" {
  description = "KMS key that will be used for encryption."
  type        = string
  default     = null
}

variable "retention_policy" {
  description = "Bucket retention policy."
  type = object({
    retention_period = number
    is_locked        = optional(bool)
  })
  default = null
}

variable "logging_config" {
  description = "Bucket logging configuration."
  type = object({
    log_bucket        = string
    log_object_prefix = optional(string)
  })
  default = null
}

variable "cors" {
  description = "CORS configuration for the bucket. Defaults to null."
  type = object({
    origin          = optional(list(string))
    method          = optional(list(string))
    response_header = optional(list(string))
    max_age_seconds = optional(number)
  })
  default = null
}

variable "lifecycle_rules" {
  description = "Bucket lifecycle rule."
  type = map(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                        = optional(number)
      created_before             = optional(string)
      custom_time_before         = optional(string)
      days_since_custom_time     = optional(number)
      days_since_noncurrent_time = optional(number)
      matches_prefix             = optional(list(string))
      matches_storage_class      = optional(list(string)) # STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE, DURABLE_REDUCED_AVAILABILITY
      matches_suffix             = optional(list(string))
      noncurrent_time_before     = optional(string)
      num_newer_versions         = optional(number)
      with_state                 = optional(string) # "LIVE", "ARCHIVED", "ANY"
    })
  }))
  default = {}
  validation {
    condition = alltrue([
      for k, v in var.lifecycle_rules : v.action != null && v.condition != null
    ])
    error_message = "Lifecycle rules action and condition cannot be null."
  }
  validation {
    condition = alltrue([
      for k, v in var.lifecycle_rules : contains(
        ["Delete", "SetStorageClass", "AbortIncompleteMultipartUpload"],
        v.action.type
      )
    ])
    error_message = "Lifecycle rules action type has unsupported value."
  }
  validation {
    condition = alltrue([
      for k, v in var.lifecycle_rules :
      v.action.type != "SetStorageClass"
      ||
      v.action.storage_class != null
    ])
    error_message = "Lifecycle rules with action type SetStorageClass require a storage class."
  }
}

variable "custom_placement_config" {
  type        = list(string)
  default     = null
  description = "The bucket's custom location configuration, which specifies the individual regions that comprise a dual-region bucket. If the bucket is designated as REGIONAL or MULTI_REGIONAL, the parameters are empty."
}

#OIDC variables

variable "github_foundations_organization_name" {
  type        = string
  description = "The name of the organization that the github foundation repos will be under."
}