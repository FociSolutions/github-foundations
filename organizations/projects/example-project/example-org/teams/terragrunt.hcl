# Example team configuration
# This file demonstrates how to configure teams for a project using the team_set module

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "providers" {
  path   = "${get_repo_root()}/organizations/providers/${basename(dirname(dirname(get_terragrunt_dir())))}/providers.hcl"
  expose = true
}

terraform {
  source = "github.com/FociSolutions/github-foundations-modules//modules/team_set"
}

inputs = {
  teams = {
    # Administrative team
    "example-admins" = {
      name        = "Example Admins"
      description = "Administrative team for the example project"
      privacy     = "closed" # Options: closed, secret
      members     = [
        "admin1",
        "admin2"
      ]
      maintainers = [
        "admin1"
      ]
    }
    
    # Developer team
    "example-developers" = {
      name        = "Example Developers"
      description = "Developer team for the example project"
      privacy     = "closed"
      members     = [
        "developer1",
        "developer2",
        "developer3",
        "developer4"
      ]
      maintainers = [
        "developer1",
        "developer2"
      ]
    }
    
    # Read-only team
    "example-viewers" = {
      name        = "Example Viewers"
      description = "Read-only access team for the example project"
      privacy     = "closed"
      members     = [
        "viewer1",
        "viewer2"
      ]
      maintainers = [
        "viewer1"
      ]
    }
    
    # Security team
    "example-security" = {
      name        = "Example Security"
      description = "Security team responsible for code reviews and security updates"
      privacy     = "secret" # Secret teams are only visible to organization owners and team members
      members     = [
        "security1",
        "security2"
      ]
      maintainers = [
        "security1"
      ]
    }
  }
}
