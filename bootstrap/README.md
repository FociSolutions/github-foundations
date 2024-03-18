# Bootstrap

This layer of the toolkit contains all the terraform needed to:
 
 1. Setup a GCP project with secret manager, workfload federated identity for github OIDC and a bucket for terraform state storage.
 2. Setup an organization under a github enterprise account for all the github foundation related repositories.
 3. Perform initial creation of all other organizations under a github enterprise account.

 This layer is meant to be run locally by a user that can authenticate with the `admin:enterprise, admin:org, repo, workflow` scopes.
 
## System Diagram

![System Diagram](../resources/images/system_diagram.png)

## Prerequisites for Running the Bootstrap Layer

Before running the bootstrap layer, please ensure you have the following prerequisites met:

**1. GitHub CLI:**

* Install the GitHub CLI according to your operating system's instructions ([https://cli.github.com/](https://cli.github.com/)).
* Authenticate to GitHub by running the following command: `gh auth login --scopes 'admin:enterprise','admin:org','repo','workflow'`.
  * Choose "GitHub.com" when prompted.
  * Choose your preferred protocol for Git operations.
  * Choose a method to authenticate with GitHub, when prompted.

**2. Google Cloud Platform (GCP) CLI:**

* Install the GCP CLI according to your operating system's instructions ([https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)).
* Authenticate to your GCP instance with the following command `gcloud auth application-default login`.

**3. GCP Service Account and Permissions:**

* Login to the GCP CLI with the command `gcloud auth application-default login` under a service account with the following roles for your organization:
    * `roles/iam.workloadIdentityPoolAdmin`
    * `roles/iam.serviceAccountAdmin`
    * `roles/resourcemanager.projectMover`
    * `roles/resourcemanager.projectDeleter`
    * `roles/resourcemanager.folderEditor`
    * `roles/storage.admin`
    * `roles/storage.objectAdmin`

**Note:** These prerequisites grant extensive permissions within your GCP project and organization. Please ensure you understand the implications of assigning these roles and permissions before proceeding.

**Resources:**

* GitHub CLI: [https://cli.github.com/](https://cli.github.com/)
* GCP CLI: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)
* GCP IAM Roles: [https://cloud.google.com/iam/docs/understanding-roles](https://cloud.google.com/iam/docs/understanding-roles)

## Running the Bootstrap Layer

This section outlines the steps to run the bootstrap layer. Remember to ensure you have met the prerequisites detailed in the previous section before proceeding.

### Single Organization Setup Vs Multi-Organization Setup

The bootstrap layer can be run to setup github foundations in a single organization or in a separate organization under the same enterprise account.

A multi-organization approach allows you to configure separate policies, settings, and requirements for Github Foundations allowing for stricter security measures without affecting your other organizations. However this approach does require Github Enterprise.

The single organization approach can be used with or without Github Enterprise. When using this approach user's should be mindful about who has access to the Github Foundation repositories managing their github resources.

The following sections will describe how to setup variables to run the bootstrap layer for both a single organization and a multi-organization setup.

### Setting Initial Values For Your Environment

Before running the bootstrap layer, you need to set the initial values for your environment. You can do this by copying the `terraform.tfvars.example` file to `terraform.tfvars` and filling in the values.

```bash
$ cp terraform.tfvars.example terraform.tfvars
$ nano terraform.tfvars
```

For both a single organization and  multi organization approach the following variables are required:
- `org_id`: The id of the gcp organization that will have the project that has the terraform state file bucket(s).
- `billing_account`: The billing account to use for the gcp project that has teh terraform state file bucket(s).
- `github_foundations_organization_name`: The name of the organization that will host the github foundation repositories. In the case of the multi-org approach this must be an organization name that doesn't already exist. However for the single org approach this should be the name of an existing organization that you want to use.

To use the toolkit in a multi-organization approach the following variables are required in addition to the previous:
- `github_enterprise_slug`: The slug of the enterprise account that own your organization(s).
- `github_organization_admin_logins`: A list of github users that will be given admin permissions to the github foundation organization.
- `github_organization_billing_email`: A email for billing to set in the github foundation organization.

For the multi-organization approach the following variable is optional:
- `github_enterprise_organizations`: A map of organizations to create under the enterprise account. You can still use the organization layer to manage organizations under your enterprise account that weren't created this way so this is optional.


### Generating a Plan (Without Execution)

To generate a plan that outlines the changes the bootstrap layer will make to your infrastructure, without actually executing them, run the following command:

```
terraform plan
```

This command will analyze your Terraform configuration and display a detailed plan summarizing the planned changes:

* Resources to be created, updated, or destroyed.
* Any potential costs associated with the changes.
* Any potential warnings or errors.

Carefully review the plan to ensure it aligns with your expectations before proceeding to the next step.

### Generating and Executing a Plan

To generate a plan and immediately execute the changes in your infrastructure, run the following command:

```
terraform apply
```

**Warning:** This command will make irreversible changes to your infrastructure. Before running it, ensure you have thoroughly reviewed the plan generated by `terraform plan` and understand the potential impact of the changes.

By default, `terraform apply` will prompt you for confirmation before executing the plan. You can bypass this prompt and proceed directly with execution by using the `-auto-approve` flag, but **strongly advise against** doing so in production environments due to the risk of unintended consequences.

**Additional Options:**

* For more granular control over the plan generation and execution process, you can explore additional options supported by the `terraform plan` and `terraform apply` commands. Refer to the official Terraform documentation for a comprehensive list of options: [https://developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform)

**Important Note:** Remember to exercise caution when working with tools that modify your infrastructure. Always have a backup plan and a clear understanding of the potential consequences before executing any changes.
