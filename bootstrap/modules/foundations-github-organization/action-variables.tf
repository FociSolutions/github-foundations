resource "github_actions_variable" "organization_workload_identity_sa" {
  provider = github.foundation_org_scoped

  repository    = github_repository.organizations_repo.name
  variable_name = "GCP_SERVICE_ACCOUNT"
  value         = var.organization_workload_identity_sa
}

resource "github_actions_variable" "bootstrap_workload_identity_sa" {
  provider = github.foundation_org_scoped

  repository    = github_repository.bootstrap_repo.name
  variable_name = "GCP_SERVICE_ACCOUNT"
  value         = var.bootstrap_workload_identity_sa
}

resource "github_actions_variable" "gcp_secret_manager_project_id" {
  provider = github.foundation_org_scoped

  repository    = github_repository.organizations_repo.name
  variable_name = "GCP_SECRET_MANAGER_PROJECT"
  value         = var.gcp_project_id
}

resource "github_actions_organization_variable" "workload_identity_provider" {
  provider = github.foundation_org_scoped

  variable_name = "WORKLOAD_IDENTITY_PROVIDER"
  value         = var.workload_identity_provider_name
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "tf_state_bucket_project_id" {
  provider = github.foundation_org_scoped

  variable_name = "TF_STATE_BUCKET_PROJECT_ID"
  value         = var.gcp_tf_state_bucket_project_id
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "tf_state_bucket_name" {
  provider = github.foundation_org_scoped

  variable_name = "TF_STATE_BUCKET_NAME"
  value         = var.bucket_name
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}

resource "github_actions_organization_variable" "tf_state_bucket_location" {
  provider = github.foundation_org_scoped

  variable_name = "TF_STATE_BUCKET_LOCATION"
  value         = var.bucket_location
  visibility    = "selected"
  selected_repository_ids = [
    github_repository.bootstrap_repo.repo_id,
    github_repository.organizations_repo.repo_id
  ]
}