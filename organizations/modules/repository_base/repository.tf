locals {
  enable_dependabot_automated_security_fixes = var.has_vulnerability_alerts && var.dependabot_security_updates ? 1 : 0
  is_public                                  = var.visibility == "public"
  can_configure_security_and_analysis        = !local.is_public && var.advance_security

  protected_branches_refs = [
    for branch in var.protected_branches : "refs/heads/${branch}"
  ]
}

resource "github_repository" "repository" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  auto_init              = true
  archive_on_destroy     = false
  has_downloads          = var.has_downloads
  has_issues             = var.has_issues
  has_projects           = var.has_projects
  has_wiki               = var.has_wiki
  has_discussions        = var.has_discussions
  vulnerability_alerts   = var.has_vulnerability_alerts
  topics                 = var.topics
  homepage_url           = var.homepage
  delete_branch_on_merge = var.delete_head_on_merge
  allow_auto_merge       = var.allow_auto_merge

  # A hacky way of getting around the 422 errors received from github api
  dynamic "security_and_analysis" {
    for_each = local.can_configure_security_and_analysis ? [1] : []
    content {
      advanced_security {
        status = var.advance_security ? "enabled" : "disabled"
      }
      secret_scanning {
        status = var.secret_scanning ? "enabled" : "disabled"
      }
      secret_scanning_push_protection {
        status = var.secret_scanning_on_push ? "enabled" : "disabled"
      }
    }
  }
}

resource "github_repository_dependabot_security_updates" "automated_security_fixes" {
  count      = local.enable_dependabot_automated_security_fixes
  repository = github_repository.repository.name
  enabled    = true
}

resource "github_branch_default" "default_branch" {
  repository = github_repository.repository.name
  branch     = var.default_branch
}

resource "github_repository_ruleset" "protected_branch_base_rules" {
  name        = "protected_branch_base_ruleset"
  repository  = github_repository.repository.name
  target      = "branch"
  enforcement = "active"
  rules {
    deletion = true
    creation = false
    update   = false
    pull_request {
      dismiss_stale_reviews_on_push   = true
      require_last_push_approval      = true
      required_approving_review_count = 1
    }
    non_fast_forward = true
  }

  conditions {
    ref_name {
      exclude = []
      include = toset(concat(["~DEFAULT_BRANCH"], local.protected_branches_refs))
    }
  }
}
