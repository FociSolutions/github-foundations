## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 5.42.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_repositories"></a> [private\_repositories](#module\_private\_repositories) | ../private_repository | n/a |
| <a name="module_public_repositories"></a> [public\_repositories](#module\_public\_repositories) | ../public_repository | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_repository_team_permissions"></a> [default\_repository\_team\_permissions](#input\_default\_repository\_team\_permissions) | A map where the keys are github team slugs and the value is the permissions the team should have by default for every repository. If an entry exists in `repository_team_permissions_override` for a repository then that will take precedence over this default. | `map(string)` | n/a | yes |
| <a name="input_private_repositories"></a> [private\_repositories](#input\_private\_repositories) | A map of private repositories where the key is the repository name and the value is the configuration | <pre>map(object({<br>    description                          = string<br>    default_branch                       = string<br>    repository_team_permissions_override = map(string)<br>    protected_branches                   = list(string)<br>    advance_security                     = bool<br>    has_vulnerability_alerts             = bool<br>    topics                               = list(string)<br>    homepage                             = string<br>    delete_head_on_merge                 = bool<br>    allow_auto_merge                     = bool<br>    dependabot_security_updates          = bool<br>  }))</pre> | n/a | yes |
| <a name="input_public_repositories"></a> [public\_repositories](#input\_public\_repositories) | A map of public repositories where the key is the repository name and the value is the configuration | <pre>map(object({<br>    description                          = string<br>    default_branch                       = string<br>    repository_team_permissions_override = map(string)<br>    protected_branches                   = list(string)<br>    advance_security                     = bool<br>    topics                               = list(string)<br>    homepage                             = string<br>    delete_head_on_merge                 = bool<br>    allow_auto_merge                     = bool<br>    dependabot_security_updates          = bool<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
