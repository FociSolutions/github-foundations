locals {
  repos_with_drift_detection = [github_repository.organizations_repo]
}

#Creates the repository for the bootstrap layer
resource "github_repository" "bootstrap_repo" {
  provider = github.foundation_org_scoped
  #TODO: figure out what seems to be a race condition between repository creation and organization creation
  depends_on = [github_enterprise_organization.github-foundations]

  name        = "bootstrap"
  description = "The repository for the bootstrap layer of the foundations. This repository contains the Terraform code to setup the github organization for the foundation repositories, create the GCP project, the GCP service account, the GCP secret manager secrets, and the GCP storage bucket for the state files."

  visibility = "private"

  auto_init              = true
  delete_branch_on_merge = true
  vulnerability_alerts   = true
}

resource "github_repository_collaborators" "bootstrap_repo_collaborators" {
  provider = github.foundation_org_scoped
  repository = github_repository.bootstrap_repo.name

  team {
    permission = "push"
    team_id    = github_team.foundation_devs.id
  }
}

resource "github_branch_protection" "protect_bootstrap_main" {
  provider = github.foundation_org_scoped

  repository_id = github_repository.bootstrap_repo.id

  pattern          = "main"
  enforce_admins   = true
  allows_deletions = false

  # TODO: Add a required check for the terrafom apply workflow
  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    required_approving_review_count = 1
    require_last_push_approval      = true
  }
}

#Creates the repository for the organizations layer
resource "github_repository" "organizations_repo" {
  provider   = github.foundation_org_scoped
  depends_on = [github_enterprise_organization.github-foundations]

  name        = "organizations"
  description = "The repository for the organizations layer of the foundations. This repository contains the Terraform code to manage github organizations under the enterprise account and their repositories, teams, and members."

  visibility = "private"

  auto_init              = true
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  has_issues             = true
}

resource "github_repository_collaborators" "organization_repo_collaborators" {
  provider = github.foundation_org_scoped
  repository = github_repository.organizations_repo.name
  
  team {
    permission = "push"
    team_id    = github_team.foundation_devs.id
  }
}


resource "github_branch_protection" "protect_organization_main" {
  provider = github.foundation_org_scoped

  repository_id = github_repository.organizations_repo.id

  pattern          = "main"
  enforce_admins   = true
  allows_deletions = false

  required_status_checks {
    strict = true
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    required_approving_review_count = 1
    require_last_push_approval      = true
  }
}

resource "github_issue_labels" "drift_labels" {
  for_each = { for idx, val in local.repos_with_drift_detection : idx => val }
  provider = github.foundation_org_scoped

  repository = each.value.name

  label {
    name  = "Action Required"
    color = "FF0000"
  }

  label {
    name  = "Re-Apply"
    color = "0800FF"
  }
}
