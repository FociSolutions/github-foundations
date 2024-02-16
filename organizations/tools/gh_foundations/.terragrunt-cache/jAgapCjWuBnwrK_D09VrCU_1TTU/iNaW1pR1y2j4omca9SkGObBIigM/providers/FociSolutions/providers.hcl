locals {
  organization_name      = "FociSolutions"
  secret_manager_project = get_env("GCP_SECRET_MANAGER_PROJECT")
}

generate "github_provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF


provider "google" {
}

data "google_secret_manager_secret_version_access" "pem_file" {
  project = "${local.secret_manager_project}"
  secret = "${local.organization_name}Pem"
}

data "google_secret_manager_secret" "pem_file_metadata" {
  project = "${local.secret_manager_project}"
  secret_id = "${local.organization_name}Pem"
}

provider "github" {
    owner = "${local.organization_name}"
    app_auth {
      id              = data.google_secret_manager_secret.pem_file_metadata.annotations.appId        
      installation_id = data.google_secret_manager_secret.pem_file_metadata.annotations.installationId 
      pem_file        = data.google_secret_manager_secret_version_access.pem_file.secret_data
    }
    }
EOF
}