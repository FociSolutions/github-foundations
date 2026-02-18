# Example repository configuration
# This file demonstrates how to configure repositories for a project using the repository_set module

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "providers" {
  path   = "${get_repo_root()}/organizations/providers/${basename(dirname(dirname(get_terragrunt_dir())))}/providers.hcl"
  expose = true
}

terraform {
  source = "github.com/FociSolutions/github-foundations-modules//modules/repository_set"
}

dependency "teams" {
  config_path = "../teams"
}

inputs = {
  # Public repositories configuration
  public_repositories = {
    "example-public-repo" = {
      description    = "Example public repository"
      default_branch = "main"
      repository_team_permissions_override = {
        # Reference teams from dependency
        # "team-slug" = "permission-level" (pull, push, admin, maintain, triage)
      }
      advanced_security            = false
      has_vulnerability_alerts    = true
      topics                      = ["example", "public", "opensource"]
      homepage                    = "https://example.com"
      delete_head_on_merge        = true
      allow_auto_merge            = true
      dependabot_security_updates = true

      # Template for new repository (optional)
      # template = {
      #   owner      = "template-owner"
      #   repository = "template-repo"
      # }
    }
  }

  # Private repositories configuration
  private_repositories = {
    "example-private-repo" = {
      description    = "Example private repository"
      default_branch = "main"
      repository_team_permissions_override = {
        # Example: Give specific teams custom permissions
        # "developers" = "push"
        # "maintainers" = "admin"
      }
      protected_branches          = [] # Explicitly disable branch protection or configure as needed
      advanced_security            = false
      has_vulnerability_alerts    = true
      topics                      = ["example", "private", "internal"]
      homepage                    = ""
      delete_head_on_merge        = true
      allow_auto_merge            = true
      dependabot_security_updates = true

      # Archive settings (optional)
      # archived = false
    }

    "example-app-repo" = {
      description                          = "Example application repository with advanced features"
      default_branch                       = "main"
      repository_team_permissions_override = {}
      protected_branches = [
        {
          pattern                         = "main"
          enforce_admins                  = true
          require_signed_commits          = true
          required_linear_history         = true
          allow_force_pushes              = false
          allow_deletions                 = false
          require_conversation_resolution = true

          required_pull_request_reviews = {
            dismiss_stale_reviews           = true
            restrict_dismissals             = false
            dismissal_restrictions          = []
            require_code_owner_reviews      = true
            required_approving_review_count = 2
            require_last_push_approval      = true
          }

          required_status_checks = {
            strict   = true
            contexts = ["ci/test", "ci/build"]
          }
        }
      ]
      advanced_security            = true
      has_vulnerability_alerts    = true
      topics                      = ["example", "application", "production"]
      homepage                    = "https://app.example.com"
      delete_head_on_merge        = true
      allow_auto_merge            = false # Disabled for production repos
      dependabot_security_updates = true
    }
  }
}
