output "folder" {
  description = "Folder resource."
  value       = local.folder
}

output "id" {
  description = "Fully qualified folder id."
  value       = local.folder.name
}

output "project_id" {
  description = "Project id."
  value       = google_project.project[0].project_id
}

output "name" {
  description = "Folder name."
  value       = local.folder.display_name
}

output "provider_name" {
  description = "Workload identity provider name."
  value       = module.oidc.provider_name
}

output "bootstrap_sa" {
  description = "Bootstrap repository service account email."
  value       = google_service_account.bootstrap_sa.email
}

output "bootstrap_sa_name" {
  description = "Bootstrap repository service account name."
  value       = google_service_account.bootstrap_sa.name
}

output "organizations_sa" {
  description = "Organizations repository service account email."
  value       = google_service_account.organizations_sa.email
}

output "organizations_sa_name" {
  description = "Organizations repository service account name."
  value       = google_service_account.organizations_sa.name
}

output "bucket_name" {
  description = "Terraform state bucket name."
  value       = google_storage_bucket.bucket.name
}

output "bucket_location" {
  description = "Terraform state bucket location."
  value       = google_storage_bucket.bucket.location
}