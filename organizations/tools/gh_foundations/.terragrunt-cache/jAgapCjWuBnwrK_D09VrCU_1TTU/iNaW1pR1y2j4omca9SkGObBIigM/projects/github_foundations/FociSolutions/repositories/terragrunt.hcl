include "root" {
  path   = "${find_in_parent_folders()}"
  expose = true
}

include "providers" {
  path   = "${get_repo_root()}/providers/${basename(dirname(get_terragrunt_dir()))}/providers.hcl"
  expose = true
}

inputs = {
  public_repositories = {
    "github-foundations" = {
      description                          = "A framework for managing your GitHub Enterprise account infrastructure."
      default_branch                       = "main"
      repository_team_permissions_override = {}
      protected_branches                   = ["main"]
      advance_security                     = false
      has_vulnerability_alerts             = true
      topics                               = []
      homepage                             = ""
      delete_head_on_merge                 = true
      allow_auto_merge                     = true
      dependabot_security_updates          = true
  } }

  private_repositories = {
  }

  default_repository_team_permissions = {
    "GhFoundationsAdmins" = "admin"
  }
}

terraform {
  source = "${get_repo_root()}//modules/repository_set"
}

dependency "teams" {
  config_path = "../teams"

  mock_outputs = {
    team_ids = {
      team1 = "team1_id"
      team2 = "team2_id"
    }
  }
}
