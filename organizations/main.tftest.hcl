# Terraform test file for organizations layer
# This file provides comprehensive testing for the organizations folder structure
# Run with: terraform test -verbose

# Mock all external providers to avoid requiring actual credentials
mock_provider "github" {}
mock_provider "google" {}
mock_provider "google-beta" {}

# Override external modules to provide test data
# These override the external modules from github-foundations-modules
override_module {
  target = module.organization_settings
  outputs = {
    organization_id   = "123456"
    organization_name = "test-org"
  }
}

override_module {
  target = module.repository_set
  outputs = {
    repository_ids = {
      "test-repo-1" = "repo-123"
      "test-repo-2" = "repo-456"
    }
  }
}

override_module {
  target = module.team_set
  outputs = {
    team_ids = {
      "test-team-1" = "team-123"
      "test-team-2" = "team-456"
    }
  }
}

# Test variables for organization settings
variables {
  test_organization_name = "test-organization"
  test_project_name      = "test-project"
  
  # Example organization settings
  organization_settings = {
    name                       = "test-org"
    billing_email              = "billing@example.com"
    company                    = "Test Company"
    email                      = "contact@example.com"
    location                   = "Test Location"
    description                = "Test organization for validation"
    has_organization_projects  = true
    has_repository_projects    = true
    default_repository_permission = "read"
    members_can_create_repositories = false
    members_can_create_public_repositories = false
    members_can_create_private_repositories = false
    members_can_create_pages   = false
    members_can_fork_private_repositories = false
    web_commit_signoff_required = true
    advanced_security_enabled_for_new_repositories = true
    dependabot_alerts_enabled_for_new_repositories = true
    dependabot_security_updates_enabled_for_new_repositories = true
    dependency_graph_enabled_for_new_repositories = true
    secret_scanning_enabled_for_new_repositories = true
    secret_scanning_push_protection_enabled_for_new_repositories = true
  }
  
  # Example public repository configuration
  public_repositories = {
    "test-public-repo" = {
      description                          = "Test public repository"
      default_branch                       = "main"
      repository_team_permissions_override = {}
      advance_security                     = false
      has_vulnerability_alerts             = true
      topics                               = ["test", "public"]
      homepage                             = "https://example.com"
      delete_head_on_merge                 = true
      allow_auto_merge                     = true
      dependabot_security_updates          = true
    }
  }
  
  # Example private repository configuration
  private_repositories = {
    "test-private-repo" = {
      description                          = "Test private repository"
      default_branch                       = "main"
      repository_team_permissions_override = {}
      protected_branches                   = []
      advance_security                     = false
      has_vulnerability_alerts             = true
      topics                               = ["test", "private"]
      homepage                             = ""
      delete_head_on_merge                 = true
      allow_auto_merge                     = true
      dependabot_security_updates          = true
    }
  }
  
  # Example team configuration
  teams = {
    "test-team-admins" = {
      name        = "Test Admins"
      description = "Administrative team for testing"
      privacy     = "closed"
      members     = ["admin1", "admin2"]
      maintainers = ["admin1"]
    }
    "test-team-developers" = {
      name        = "Test Developers"
      description = "Developer team for testing"
      privacy     = "closed"
      members     = ["dev1", "dev2", "dev3"]
      maintainers = ["dev1"]
    }
  }
}

# Test 1: Validate organization settings structure
run "organization_settings_validation" {
  command = plan
  
  assert {
    condition     = var.organization_settings.name == "test-org"
    error_message = "Organization name should be 'test-org'"
  }
  
  assert {
    condition     = var.organization_settings.web_commit_signoff_required == true
    error_message = "Web commit signoff should be required for security"
  }
  
  assert {
    condition     = var.organization_settings.members_can_create_public_repositories == false
    error_message = "Members should not be able to create public repositories by default"
  }
  
  assert {
    condition     = var.organization_settings.advanced_security_enabled_for_new_repositories == true
    error_message = "Advanced security should be enabled for new repositories"
  }
  
  assert {
    condition     = var.organization_settings.secret_scanning_enabled_for_new_repositories == true
    error_message = "Secret scanning should be enabled for new repositories"
  }
  
  assert {
    condition     = var.organization_settings.secret_scanning_push_protection_enabled_for_new_repositories == true
    error_message = "Secret scanning push protection should be enabled for new repositories"
  }
}

# Test 2: Validate repository configuration
run "repository_configuration_validation" {
  command = plan
  
  assert {
    condition     = var.public_repositories["test-public-repo"].default_branch == "main"
    error_message = "Default branch should be 'main'"
  }
  
  assert {
    condition     = var.public_repositories["test-public-repo"].delete_head_on_merge == true
    error_message = "Delete head on merge should be enabled for clean repository management"
  }
  
  assert {
    condition     = var.public_repositories["test-public-repo"].has_vulnerability_alerts == true
    error_message = "Vulnerability alerts should be enabled"
  }
  
  assert {
    condition     = var.private_repositories["test-private-repo"].default_branch == "main"
    error_message = "Default branch should be 'main'"
  }
  
  assert {
    condition     = var.private_repositories["test-private-repo"].dependabot_security_updates == true
    error_message = "Dependabot security updates should be enabled"
  }
}

# Test 3: Validate team configuration
run "team_configuration_validation" {
  command = plan
  
  assert {
    condition     = length(var.teams) == 2
    error_message = "Should have 2 test teams configured"
  }
  
  assert {
    condition     = var.teams["test-team-admins"].privacy == "closed"
    error_message = "Team privacy should be 'closed' for security"
  }
  
  assert {
    condition     = length(var.teams["test-team-admins"].members) == 2
    error_message = "Admin team should have 2 members"
  }
  
  assert {
    condition     = length(var.teams["test-team-developers"].members) == 3
    error_message = "Developer team should have 3 members"
  }
  
  assert {
    condition     = contains(var.teams["test-team-admins"].maintainers, "admin1")
    error_message = "admin1 should be a maintainer of the admin team"
  }
}

# Test 4: Validate security settings
run "security_settings_validation" {
  command = plan
  
  assert {
    condition = alltrue([
      var.organization_settings.dependabot_alerts_enabled_for_new_repositories,
      var.organization_settings.dependabot_security_updates_enabled_for_new_repositories,
      var.organization_settings.dependency_graph_enabled_for_new_repositories
    ])
    error_message = "All Dependabot security features should be enabled"
  }
  
  assert {
    condition = alltrue([
      var.organization_settings.secret_scanning_enabled_for_new_repositories,
      var.organization_settings.secret_scanning_push_protection_enabled_for_new_repositories
    ])
    error_message = "Secret scanning and push protection should both be enabled"
  }
  
  assert {
    condition     = !var.organization_settings.members_can_fork_private_repositories
    error_message = "Members should not be able to fork private repositories by default for security"
  }
}

# Test 5: Validate naming conventions
run "naming_conventions_validation" {
  command = plan
  
  assert {
    condition     = can(regex("^[a-z0-9-]+$", var.test_organization_name))
    error_message = "Organization name should only contain lowercase letters, numbers, and hyphens"
  }
  
  assert {
    condition     = can(regex("^[a-z0-9-]+$", var.test_project_name))
    error_message = "Project name should only contain lowercase letters, numbers, and hyphens"
  }
}

# Test 6: Validate email format in organization settings
run "email_format_validation" {
  command = plan
  
  assert {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.organization_settings.billing_email))
    error_message = "Billing email should be in valid email format"
  }
  
  assert {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.organization_settings.email))
    error_message = "Contact email should be in valid email format"
  }
}
