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
| [github_team.team](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/team) | resource |
| [github_team_membership.maintainers](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/team_membership) | resource |
| [github_team_membership.members](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/team_membership) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_privacy"></a> [privacy](#input\_privacy) | The privacy setting for the github team. Must be one of `closed` or `secret`. | `string` | `"closed"` | no |
| <a name="input_team_description"></a> [team\_description](#input\_team\_description) | Description of the github team to be created. | `string` | `""` | no |
| <a name="input_team_id"></a> [team\_id](#input\_team\_id) | The ID of the team if it exists (optional). | `string` | `""` | no |
| <a name="input_team_maintainers"></a> [team\_maintainers](#input\_team\_maintainers) | A list of team maintainers for the github team. These user's will have permissions to manage the team. | `list(string)` | n/a | yes |
| <a name="input_team_members"></a> [team\_members](#input\_team\_members) | A list of team members for the github team. These user's will not have permissions to manage the team. | `list(string)` | `[]` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | The name to give to the github team that will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | Name of the created team. |
| <a name="output_slug"></a> [slug](#output\_slug) | The slug of the created team. |
