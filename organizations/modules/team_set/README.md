## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 5.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_prexisting_team"></a> [prexisting\_team](#module\_prexisting\_team) | ../team | n/a |
| <a name="module_team"></a> [team](#module\_team) | ../team | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_preexisting_teams"></a> [preexisting\_teams](#input\_preexisting\_teams) | A map of existing teams where the key is the team name and the value is the configuration | <pre>map(object({<br>    bucket      = string<br>    prefix      = string<br>    output_name = string<br>    maintainers = list(string)<br>    members     = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | A map of teams to create where the key is the team name and the value is the configuration | <pre>map(object({<br>    description = string<br>    privacy     = string<br>    maintainers = list(string)<br>    members     = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_team_slugs"></a> [team\_slugs](#output\_team\_slugs) | Map of team names to their respective slugs |
