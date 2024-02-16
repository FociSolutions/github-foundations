resource "github_enterprise_organization" "github-foundations" {
  provider = github.enterprise_scoped

  enterprise_id = var.enterprise_id
  name          = var.github_foundations_organization_name
  display_name  = "Github Foundations"
  description   = "Organization created to host github foundation toolkit repositories"
  billing_email = var.billing_email
  admin_logins  = var.admin_logins
}

