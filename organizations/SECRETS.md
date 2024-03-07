# Secret Management

The github foundation terraform modules provide several ways to manage secrets in your github organizations and repositories.
1. Through the organization module
2. Through the organization_secrets module
3. Through the repository_set module

The following sections will cover each of these modules and how to effectively use them.

## Usage

### Encryption

Before using any of the modules to create your github secrets it is important to encrypt them first. Github has documentation outlining how to encrypt secrets for their rest API that can be found here: https://docs.github.com/en/rest/guides/encrypting-secrets-for-the-rest-api

### Organization and organization secrets module

The organiztion and organization secrets modules have the following optional fields for organization secret management:
- `actions_secrets`: for creating and managing organization secrets accessible to github actions
- `codespaces_secrets`: for creating and managing organization secrets accessible to github codespaces
- `dependabot_secrets`: for creating and managing organization secrets accessible to dependabot

Each field takes a map where the key is the name of the secret and the value is an object with the following structure:
```hcl
{
    encrypted_value       = string
    visibility            = string
    selected_repositories = optional(list(string))
}
```

`encrypted_value` is the encrypted value of the secret you wish to store. See [encryption](#encryption) for instructions on how to encrypt your secret.

`visibility` configures what repositories can access your secret. It must be one of `all`, `private`, or `selected`.

`selected_repositories` is an optional list of repository id strings for which repositories should have access to the secret. Only set this field if visibility has been set to `selected`. It defaults to an empty list if not set so the secret won't be accessible to any repositories if it's not set.

Either module will work well for organization secret management, but in the event that you want to do something like make the terragrunt configuration managing secrets dependant on the terragrunt configuration you are using to create repositories. But don't want the rest of organization management to wait on repository creation before it can execute. Then you might want to consider creating a `secrets` folder and configuration under the `projects/repositories/<ORG-NAME>` path that uses the organization secrets module to create these secrets. Keep in mind that while spreading organization secret definitions out like this can be helpful to keep context of what the secret is used for and where, it also might lead to naming conflicts which would result in one configuration overwriting the secret created by another configuration.

### Repository set module

The repository set module's `private_repositories` and `public_repositories` fields accepts the following optional fields for repository secret management:
- `action_secrets`: for creating repository secrets accessible to github actions
- `codespace_secrets`: for creating and managing repository secrets accessible to github codespaces
- `dependabot_secrets`: for creating and managing repository secrets accessible to dependabot
- `environments`: for creating and managing environments, including their action secrets.

`action_secrets`, `codespace_secrets`, and `dependabot_secrets` are maps where the keys are the name of the secrets and the values are the encrypted secret values to create and manage as secrets.

`environments` is a map where the keys are the names of the environments to create and manage. The values are objects that contain an `action_secrets` field which is a map where the keys are the name of the secrets and the values are the encrypted secret values to create and manage as environment action secrets