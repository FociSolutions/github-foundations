mock_provider "github" {}
mock_provider "google" {}
mock_provider "google-beta" {}
mock_provider "github-actions-runners" {}
override_module {
  target = module.github_oidc.module.oidc
  outputs = {
    gh-oidc = {
      sa_name   = "this-is-an-sa-name"
      attribute = "attribute.repository/github-foundations/bootstrap"
    }
    provider_name = "this-is-a-provider-name"
  }
}
override_module {
  target = module.github_foundations
  outputs = {
    organization_id = "123"
  }
}
override_module {
  target = module.github_foundations_organization[0]
  outputs = {
    id   = "123"
    name = "github-foundations-organization"
  }
}
override_resource {
  target = module.organizations["github-foundations"].github_enterprise_organization.organization
  values = {
    id = "123"
  }
}
override_resource {
  target = module.github_oidc.google_folder.folder[0]
  values = {
    id   = "organizations/1234567890"
    name = "fldr-github-foundations"
  }
}
override_resource {
  target = module.github_oidc.google_service_account.bootstrap_sa
  values = {
    name  = "bootstrap-sa"
    email = "bootstrap-sa@focisolutions.com"
  }
}
override_resource {
  target = module.github_oidc.google_service_account.organizations_sa
  values = {
    name  = "organizations-sa"
    email = "organizations-sa@focisolutions.com"
  }
}

variables {
  github_account_type               = "Enterprise"
  billing_account                   = "billingAccounts/123456-123456-123456"
  github_enterprise_slug            = "github-enterprise-slug"
  github_organization_admin_logins  = ["admin"]
  github_organization_billing_email = "billingaccount@focisolutions.com"
  org_id                            = 1234567890
  project_parent                    = "organizations/1234567890"
  project_create                    = true
  bucket_name                       = "github-tf-state-bucket-1234567890"
  tf_state_location                 = "us-west4"

  # variables for this test
  github_enterprise_organizations = {
    github-foundations = {
      display_name  = "github-foundations"
      description   = "The organization for the github foundations."
      billing_email = "billingaccount2@focisoulutions.com"
      admin_logins  = ["admin1", "admin2"]
    }
  }
}

run "oidc_module_test" {
  command = apply

  assert {
    condition     = module.github_oidc.folder.name == "fldr-github-foundations"
    error_message = "The folder name is incorrect. Expected 'fldr-github-foundations' but got '${module.github_oidc.folder.name}'"
  }
  assert {
    condition     = module.github_oidc.folder.id == "organizations/1234567890"
    error_message = "The folder id is incorrect. Expected 'organizations/1234567890' but got '${module.github_oidc.folder.id}'"
  }
  assert {
    condition     = startswith(module.github_oidc.project_id, "prj-g-github-foundations")
    error_message = "The project id is incorrect. Expected 'prj-gtf-state-project####' but got '${module.github_oidc.project_id}'"
  }
  assert {
    condition     = module.github_oidc.name == "fldr-github-foundations"
    error_message = "The project name is incorrect. Expected 'fldr-github-foundations' but got '${module.github_oidc.name}'"
  }
  assert {
    condition     = module.github_oidc.provider_name == "this-is-a-provider-name"
    error_message = "The provider name is incorrect. Expected 'this-is-a-provider-name' but got '${module.github_oidc.provider_name}'"
  }
  assert {
    condition     = module.github_oidc.bootstrap_sa == "bootstrap-sa@focisolutions.com"
    error_message = "The bootstrap service account is incorrect. Expected 'bootstrap-sa@focisolutions.com' but got '${module.github_oidc.bootstrap_sa}'"
  }
  assert {
    condition     = module.github_oidc.bootstrap_sa_name == "bootstrap-sa"
    error_message = "The bootstrap service account name is incorrect. Expected 'bootstrap-sa' but got '${module.github_oidc.bootstrap_sa_name}'"
  }
  assert {
    condition     = module.github_oidc.organizations_sa == "organizations-sa@focisolutions.com"
    error_message = "The organizations service account is incorrect. Expected 'organizations-sa@focisolutions.com' but got '${module.github_oidc.organizations_sa}'"
  }
  assert {
    condition     = module.github_oidc.organizations_sa_name == "organizations-sa"
    error_message = "The organizations service account name is incorrect. Expected 'organizations-sa' but got '${module.github_oidc.organizations_sa_name}'"
  }
  assert {
    condition     = module.github_oidc.bucket_name == var.bucket_name
    error_message = "The bucket name is incorrect. Expected '${var.bucket_name}' but got '${module.github_oidc.bucket_name}'"
  }
  assert {
    condition     = module.github_oidc.bucket_location == var.tf_state_location
    error_message = "The bucket location is incorrect. Expected '${var.tf_state_location}' but got '${module.github_oidc.bucket_location}'"
  }
}

run "github_foundations_organization_module_test" {

  assert {
    condition     = module.github_foundations_organization[0].id == "123"
    error_message = "The organization id is incorrect. Expected '123' but got '${module.github_foundations_organization[0].id}'"
  }
  assert {
    condition     = module.github_foundations_organization[0].name == "github-foundations-organization"
    error_message = "The organization name is incorrect. Expected 'github-foundations-organization' but got '${module.github_foundations_organization[0].name}'"
  }
}

run "github_foundations_module_test" {
  assert {
    condition     = module.github_foundations != null
    error_message = "The github foundations module is null."
  }
}

run "organizations_module_test" {
  assert {
    condition     = module.organizations.github-foundations.id == "123"
    error_message = "The organization ID is incorrect. Expected '123' but got '${module.organizations.github-foundations.id}'"
  }
  assert {
    condition     = module.organizations.github-foundations.name == var.github_enterprise_organizations.github-foundations.display_name
    error_message = "The organization name is incorrect. Expected '${var.github_enterprise_organizations.github-foundations.display_name}' but got '${module.organizations.github-foundations.name}'"
  }
}
