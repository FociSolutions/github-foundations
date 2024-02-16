include "root" {
  path   = "${find_in_parent_folders()}"
  expose = true
}

include "providers" {
  path   = "${get_repo_root()}/providers/${basename(dirname(get_terragrunt_dir()))}/providers.hcl"
  expose = true
}

inputs = {
  teams = {
    "GhFoundationsAdmins" = {
      description = "The development team for the GitHub Foundations"
      privacy     = "closed"
      members     = ["TylerMizuyabu", "bzarboni1", "blastdan"]
      maintainers = ["blastdan"]
    }
  }
}

terraform {
  source = "${get_repo_root()}//modules/team_set"
}
