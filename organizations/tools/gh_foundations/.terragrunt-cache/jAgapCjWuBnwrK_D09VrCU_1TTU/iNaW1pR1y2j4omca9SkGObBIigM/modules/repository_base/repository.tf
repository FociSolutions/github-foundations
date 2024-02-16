locals {
  enable_dependabot_automated_security_fixes = var.has_vulnerability_alerts && var.dependabot_security_updates ? 1 : 0
}

resource "github_repository" "repository" {
  name        = var.name
  description = var.description
  visibility  = var.visibility

  auto_init              = true
  archive_on_destroy     = true
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

  security_and_analysis {
    # I MIGHT HAVE TO MAKE A SECOND GITHUB_REPOSITORY FOR IF AN ORG DOESN'T HAVE ACCESS TO ADVANCED SECURITY
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
    creation = true
    deletion = true
    update   = true
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
      include = toset(concat([var.default_branch], var.protected_branches))
    }
  }
}
