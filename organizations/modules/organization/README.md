## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 5.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 5.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_membership.membership_for_user](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/membership) | resource |
| [github_organization_block.blocked_user](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/organization_block) | resource |
| [github_organization_custom_role.community_manager_role](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/organization_custom_role) | resource |
| [github_organization_custom_role.contractor_role](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/organization_custom_role) | resource |
| [github_organization_custom_role.custom_repository_role](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/organization_custom_role) | resource |
| [github_organization_custom_role.security_engineer_role](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/organization_custom_role) | resource |
| [github_organization_settings.organization_settings](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/organization_settings) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_repository_roles"></a> [custom\_repository\_roles](#input\_custom\_repository\_roles) | A map of custom repository roles to create. The key is the name of the role and the value is the role configurations. | <pre>map(object({<br>    description = string<br>    base_role   = string<br>    permissions = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_enable_community_manager_role"></a> [enable\_community\_manager\_role](#input\_enable\_community\_manager\_role) | If `true` will create a custom repository role for community managers. Defaults to `false`. If `true` the maximum number of `custom_repository_roles` that can be defined will be reduced by one. | `bool` | `false` | no |
| <a name="input_enable_contractor_role"></a> [enable\_contractor\_role](#input\_enable\_contractor\_role) | If `true` will create a custom repository role for contractors. Defaults to `false`. If `true` the maximum number of `custom_repository_roles` that can be defined will be reduced by one. | `bool` | `false` | no |
| <a name="input_enable_security_engineer_role"></a> [enable\_security\_engineer\_role](#input\_enable\_security\_engineer\_role) | If `true` will create a custom repository role for security engineers. Defaults to `false`. If `true` the maximum number of `custom_repository_roles` that can be defined will be reduced by one. | `bool` | `false` | no |
| <a name="input_github_organization_billing_email"></a> [github\_organization\_billing\_email](#input\_github\_organization\_billing\_email) | The billing email to set for the organization. | `string` | n/a | yes |
| <a name="input_github_organization_blocked_users"></a> [github\_organization\_blocked\_users](#input\_github\_organization\_blocked\_users) | A list of usernames to block from the organization. Defaults to `[]`. | `list(string)` | `[]` | no |
| <a name="input_github_organization_blog"></a> [github\_organization\_blog](#input\_github\_organization\_blog) | Url to organization blog. Defaults to `''`. | `string` | `""` | no |
| <a name="input_github_organization_email"></a> [github\_organization\_email](#input\_github\_organization\_email) | Organization email. Defaults to `''`. | `string` | `""` | no |
| <a name="input_github_organization_enable_dependabot_alerts"></a> [github\_organization\_enable\_dependabot\_alerts](#input\_github\_organization\_enable\_dependabot\_alerts) | If set dependabot alerts will be enabled for new repositories in the organization. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_github_organization_enable_dependabot_updates"></a> [github\_organization\_enable\_dependabot\_updates](#input\_github\_organization\_enable\_dependabot\_updates) | If set dependabot security updates will be enabled for new repositories in the organization. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_github_organization_enable_dependancy_graph"></a> [github\_organization\_enable\_dependancy\_graph](#input\_github\_organization\_enable\_dependancy\_graph) | If set dependancy graph will be enabled for new repositories in the organization. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_github_organization_enable_ghas"></a> [github\_organization\_enable\_ghas](#input\_github\_organization\_enable\_ghas) | If set github advance security will be enabled for new repositories in the organization. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_github_organization_enable_secret_scanning"></a> [github\_organization\_enable\_secret\_scanning](#input\_github\_organization\_enable\_secret\_scanning) | If set secret scanning will be enabled for new repositories in the organization. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_github_organization_enable_secret_scanning_push_protection"></a> [github\_organization\_enable\_secret\_scanning\_push\_protection](#input\_github\_organization\_enable\_secret\_scanning\_push\_protection) | If set secret scanning push protection will be enabled for new repositories in the organization. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_github_organization_id"></a> [github\_organization\_id](#input\_github\_organization\_id) | The ID of the organization to manage. | `string` | n/a | yes |
| <a name="input_github_organization_location"></a> [github\_organization\_location](#input\_github\_organization\_location) | Organization location. Defaults to `''`. | `string` | `""` | no |
| <a name="input_github_organization_members"></a> [github\_organization\_members](#input\_github\_organization\_members) | A list of usernames to invite to the organization. Defaults to `[]`. | `list(string)` | `[]` | no |
| <a name="input_github_organization_pages_settings"></a> [github\_organization\_pages\_settings](#input\_github\_organization\_pages\_settings) | Settings for organization page creation. The default setting does not allow members to create public and private pages. | <pre>object({<br>    members_can_create_public  = bool,<br>    members_can_create_private = bool<br>  })</pre> | <pre>{<br>  "members_can_create_private": false,<br>  "members_can_create_public": false<br>}</pre> | no |
| <a name="input_github_organization_repository_settings"></a> [github\_organization\_repository\_settings](#input\_github\_organization\_repository\_settings) | Settings for organization repository creation. The default setting allows members to create internal and private repositories but not public. | <pre>object({<br>    members_can_create_public   = bool,<br>    members_can_create_internal = bool,<br>    members_can_create_private  = bool<br>  })</pre> | <pre>{<br>  "members_can_create_internal": true,<br>  "members_can_create_private": true,<br>  "members_can_create_public": false<br>}</pre> | no |
| <a name="input_github_organization_requires_web_commit_signing"></a> [github\_organization\_requires\_web\_commit\_signing](#input\_github\_organization\_requires\_web\_commit\_signing) | If set commit signatures are required for commits to the organization. Defaults to `false`. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_community_manager_role_id"></a> [community\_manager\_role\_id](#output\_community\_manager\_role\_id) | The id of the community manager custom role. |
| <a name="output_contractor_role_id"></a> [contractor\_role\_id](#output\_contractor\_role\_id) | The id of the contractor custom role. |
| <a name="output_custom_role_ids"></a> [custom\_role\_ids](#output\_custom\_role\_ids) | A map of custom role names to custom role ids. |
| <a name="output_ghas_enabled"></a> [ghas\_enabled](#output\_ghas\_enabled) | A boolean value indicating if GitHub Advanced Security is enabled for new repositories in the organization. |
| <a name="output_security_engineer_role_id"></a> [security\_engineer\_role\_id](#output\_security\_engineer\_role\_id) | The id of the security engineer custom role. |
