## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.77 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 3.77 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.77 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oidc"></a> [oidc](#module\_oidc) | terraform-google-modules/github-actions-runners/google//modules/gh-oidc | n/a |

## Resources

| Name | Type |
|------|------|
| [google_folder.folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder) | resource |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_iam_member.bootstrap_project_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.organizations_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.project_services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.bootstrap_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.organizations_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [random_id.unique_project_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_folder.folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/folder) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_network"></a> [auto\_create\_network](#input\_auto\_create\_network) | Whether to create the default network for the project. | `bool` | `false` | no |
| <a name="input_autoclass"></a> [autoclass](#input\_autoclass) | Enable autoclass to automatically transition objects to appropriate storage classes based on their access pattern. If set to true, storage\_class must be set to STANDARD. Defaults to false. | `bool` | `false` | no |
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing account id. | `string` | `null` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket name | `string` | n/a | yes |
| <a name="input_cors"></a> [cors](#input\_cors) | CORS configuration for the bucket. Defaults to null. | <pre>object({<br>    origin          = optional(list(string))<br>    method          = optional(list(string))<br>    response_header = optional(list(string))<br>    max_age_seconds = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_custom_placement_config"></a> [custom\_placement\_config](#input\_custom\_placement\_config) | The bucket's custom location configuration, which specifies the individual regions that comprise a dual-region bucket. If the bucket is designated as REGIONAL or MULTI\_REGIONAL, the parameters are empty. | `list(string)` | `null` | no |
| <a name="input_default_event_based_hold"></a> [default\_event\_based\_hold](#input\_default\_event\_based\_hold) | Enable event based hold to new objects added to specific bucket, defaults to false. | `bool` | `null` | no |
| <a name="input_descriptive_name"></a> [descriptive\_name](#input\_descriptive\_name) | Name of the project name. Used for project name instead of `project_name` variable. | `string` | `null` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | KMS key that will be used for encryption. | `string` | `null` | no |
| <a name="input_folder_create"></a> [folder\_create](#input\_folder\_create) | Create folder. When set to false, uses id to reference an existing folder. | `bool` | `true` | no |
| <a name="input_folder_name"></a> [folder\_name](#input\_folder\_name) | Folder name. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Optional map to set force destroy keyed by name, defaults to false. | `bool` | `false` | no |
| <a name="input_github_foundations_organization_name"></a> [github\_foundations\_organization\_name](#input\_github\_foundations\_organization\_name) | The name of the organization that the github foundation repos will be under. | `string` | n/a | yes |
| <a name="input_id"></a> [id](#input\_id) | Folder ID in case you use folder\_create=false. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Resource labels. | `map(string)` | `{}` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Bucket lifecycle rule. | <pre>map(object({<br>    action = object({<br>      type          = string<br>      storage_class = optional(string)<br>    })<br>    condition = object({<br>      age                        = optional(number)<br>      created_before             = optional(string)<br>      custom_time_before         = optional(string)<br>      days_since_custom_time     = optional(number)<br>      days_since_noncurrent_time = optional(number)<br>      matches_prefix             = optional(list(string))<br>      matches_storage_class      = optional(list(string)) # STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE, DURABLE_REDUCED_AVAILABILITY<br>      matches_suffix             = optional(list(string))<br>      noncurrent_time_before     = optional(string)<br>      num_newer_versions         = optional(number)<br>      with_state                 = optional(string) # "LIVE", "ARCHIVED", "ANY"<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Bucket location. | `string` | n/a | yes |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | Bucket logging configuration. | <pre>object({<br>    log_bucket        = string<br>    log_object_prefix = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | The organization id. | `string` | n/a | yes |
| <a name="input_parent"></a> [parent](#input\_parent) | Parent in folders/folder\_id or organizations/org\_id format. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Optional prefix used to generate project id and name. | `string` | `null` | no |
| <a name="input_project_create"></a> [project\_create](#input\_project\_create) | Create project. When set to false, uses a data source to reference existing project. | `bool` | `true` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name and id suffix. | `string` | n/a | yes |
| <a name="input_project_parent"></a> [project\_parent](#input\_project\_parent) | Parent folder or organization in 'folders/folder\_id' or 'organizations/org\_id' format. | `string` | `null` | no |
| <a name="input_requester_pays"></a> [requester\_pays](#input\_requester\_pays) | Enables Requester Pays on a storage bucket. | `bool` | `null` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | Bucket retention policy. | <pre>object({<br>    retention_period = number<br>    is_locked        = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_service_config"></a> [service\_config](#input\_service\_config) | Configure service API activation. | <pre>object({<br>    disable_on_destroy         = bool<br>    disable_dependent_services = bool<br>  })</pre> | <pre>{<br>  "disable_dependent_services": false,<br>  "disable_on_destroy": false<br>}</pre> | no |
| <a name="input_services"></a> [services](#input\_services) | Service APIs to enable. | `list(string)` | `[]` | no |
| <a name="input_skip_delete"></a> [skip\_delete](#input\_skip\_delete) | Allows the underlying resources to be destroyed without destroying the project itself. | `bool` | `false` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Bucket storage class. | `string` | `"STANDARD"` | no |
| <a name="input_uniform_bucket_level_access"></a> [uniform\_bucket\_level\_access](#input\_uniform\_bucket\_level\_access) | Allow using object ACLs (false) or not (true, this is the recommended behavior) , defaults to true (which is the recommended practice, but not the behavior of storage API). | `bool` | `true` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Enable versioning, defaults to false. | `bool` | `false` | no |
| <a name="input_website"></a> [website](#input\_website) | Bucket website. | <pre>object({<br>    main_page_suffix = optional(string)<br>    not_found_page   = optional(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap_sa"></a> [bootstrap\_sa](#output\_bootstrap\_sa) | Bootstrap repository service account email. |
| <a name="output_bootstrap_sa_name"></a> [bootstrap\_sa\_name](#output\_bootstrap\_sa\_name) | Bootstrap repository service account name. |
| <a name="output_bucket_location"></a> [bucket\_location](#output\_bucket\_location) | Terraform state bucket location. |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Terraform state bucket name. |
| <a name="output_folder"></a> [folder](#output\_folder) | Folder resource. |
| <a name="output_id"></a> [id](#output\_id) | Fully qualified folder id. |
| <a name="output_name"></a> [name](#output\_name) | Folder name. |
| <a name="output_organizations_sa"></a> [organizations\_sa](#output\_organizations\_sa) | Organizations repository service account email. |
| <a name="output_organizations_sa_name"></a> [organizations\_sa\_name](#output\_organizations\_sa\_name) | Organizations repository service account name. |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Project id. |
| <a name="output_provider_name"></a> [provider\_name](#output\_provider\_name) | Workload identity provider name. |
