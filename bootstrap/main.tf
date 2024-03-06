module "github_gcloud_oidc" {
  source = "github.com/FociSolutions/github-foundations-modules//modules/github-gcloud-oidc"

  #Organization
  organization_id = var.org_id
  #Folder
  parent      = "organizations/${var.org_id}"
  folder_name = "fldr-github-foundations"

  #Project
  billing_account = var.billing_account
  project_name    = "github-foundations"
  prefix          = "prj-g"
  services = [
    "storage-api.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "secretmanager.googleapis.com"
  ]

  #Bucket
  bucket_name = "github-tf-state-bucket"
  location    = "northamerica-northeast1"
  versioning  = true
  lifecycle_rules = {
    lr-0 = {
      action = {
        type = "Delete"
      }
      condition = {
        num_newer_versions = "5"
      }
    }
  }
  force_destroy = true

  #OIDC Setup
  github_foundations_organization_name = var.github_foundations_organization_name
}

module "foundations_github_organization" {
  source = "github.com/FociSolutions/github-foundations-modules//modules/foundations-github-organization"
  providers = {
    github.enterprise_scoped     = github.enterprise_scoped
    github.foundation_org_scoped = github.foundation_org_scoped
  }

  admin_logins                         = var.github_organization_admin_logins
  github_foundations_organization_name = var.github_foundations_organization_name
  enterprise_id                        = data.github_enterprise.enterprise_account.id
  billing_email                        = var.github_organization_billing_email

  workload_identity_provider_name   = module.github_gcloud_oidc.provider_name
  bootstrap_workload_identity_sa    = module.github_gcloud_oidc.bootstrap_sa
  organization_workload_identity_sa = module.github_gcloud_oidc.organizations_sa

  gcp_project_id = module.github_gcloud_oidc.project_id

  gcp_tf_state_bucket_project_id = module.github_gcloud_oidc.project_id
  bucket_name                    = module.github_gcloud_oidc.bucket_name
  bucket_location                = module.github_gcloud_oidc.bucket_location

  readme_path = "${path.root}/organizations/projects/README.md"
}

resource "github_enterprise_organization" "organization" {
  for_each = var.github_enterprise_organizations

  enterprise_id = data.github_enterprise.enterprise_account.id

  name          = each.key
  display_name  = each.value.display_name
  description   = each.value.description
  billing_email = each.value.billing_email
  admin_logins  = each.value.admin_logins
}