## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.1 |
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
| [github_branch_default.default_branch](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/branch_default) | resource |
| [github_repository.repository](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/repository) | resource |
| [github_repository_collaborators.collaborators](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/repository_collaborators) | resource |
| [github_repository_dependabot_security_updates.automated_security_fixes](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/repository_dependabot_security_updates) | resource |
| [github_repository_ruleset.protected_branch_base_rules](https://registry.terraform.io/providers/integrations/github/5.42.0/docs/resources/repository_ruleset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advance_security"></a> [advance\_security](#input\_advance\_security) | Enables advance security for the repository. If repository is public `advance_security` is enabled by default and cannot be changed. | `bool` | `true` | no |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Allow auto-merging pull requests on the repository | `bool` | `true` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The branch to set as the default branch for this repository. Defaults to "main" | `string` | `"main"` | no |
| <a name="input_delete_head_on_merge"></a> [delete\_head\_on\_merge](#input\_delete\_head\_on\_merge) | Sets the delete head on merge option for the repository. If true it will delete pull request branches automatically on merge. Defaults to true | `bool` | `true` | no |
| <a name="input_dependabot_security_updates"></a> [dependabot\_security\_updates](#input\_dependabot\_security\_updates) | Enables dependabot security updates. Only works when `has_vulnerability_alerts` is set because that is required to enable dependabot for the repository. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | The description to give to the repository. Defaults to `""` | `string` | `""` | no |
| <a name="input_has_discussions"></a> [has\_discussions](#input\_has\_discussions) | Enables Github Discussions. | `bool` | `true` | no |
| <a name="input_has_downloads"></a> [has\_downloads](#input\_has\_downloads) | Enables downloads for the repository | `bool` | `false` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Enables Github Issues for the repository | `bool` | `true` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Enables Github Projects for the repository | `bool` | `true` | no |
| <a name="input_has_vulnerability_alerts"></a> [has\_vulnerability\_alerts](#input\_has\_vulnerability\_alerts) | Enables security alerts for vulnerable dependencies for the repository | `bool` | `true` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | Enables Github Wiki for the repository | `bool` | `true` | no |
| <a name="input_homepage"></a> [homepage](#input\_homepage) | The homepage for the repository | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the repository to create/import. | `string` | n/a | yes |
| <a name="input_protected_branches"></a> [protected\_branches](#input\_protected\_branches) | A list of ref names or patterns that should be protected. Defaults `["main"]` | `list(string)` | <pre>[<br>  "main"<br>]</pre> | no |
| <a name="input_repository_team_permissions"></a> [repository\_team\_permissions](#input\_repository\_team\_permissions) | A map where the keys are github team ids and the value is the permissions the team should have in the repository | `map(string)` | n/a | yes |
| <a name="input_secret_scanning"></a> [secret\_scanning](#input\_secret\_scanning) | Enables secret scanning for the repository. If repository is private `advance_security` must also be enabled. | `bool` | `true` | no |
| <a name="input_secret_scanning_on_push"></a> [secret\_scanning\_on\_push](#input\_secret\_scanning\_on\_push) | Enables secret scanning push protection for the repository. If repository is private `advance_security` must also be enabled. | `bool` | `true` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | The topics to apply to the repository | `list(string)` | `[]` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Sets the visibility property of a repository. Defaults to "private" | `string` | `"private"` | no |

## Outputs

No outputs.
