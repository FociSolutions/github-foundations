# Terraform test file for organizations layer
# This file provides comprehensive validation testing for configuration patterns
# Run with: terraform test -verbose
#
# This test file validates:
# - Organization settings best practices
# - Repository configuration standards
# - Team configuration patterns
# - Security settings compliance
# - Naming conventions
# - Input validation

# Mock all external providers to avoid requiring actual credentials
mock_provider "github" {}
mock_provider "google" {}
mock_provider "google-beta" {}

# Test variables for organization settings
variables {
  # Example organization settings
  organization_settings = {
    name                                                         = "test-org"
    billing_email                                                = "billing@example.com"
    company                                                      = "Test Company"
    email                                                        = "contact@example.com"
    location                                                     = "Test Location"
    description                                                  = "Test organization for validation"
    has_organization_projects                                    = true
    has_repository_projects                                      = true
    default_repository_permission                                = "read"
    members_can_create_repositories                              = false
    members_can_create_public_repositories                       = false
    members_can_create_private_repositories                      = false
    members_can_create_pages                                     = false
    members_can_fork_private_repositories                        = false
    web_commit_signoff_required                                  = true
    advance_security_enabled_for_new_repositories               = true
    dependabot_alerts_enabled_for_new_repositories               = true
    dependabot_security_updates_enabled_for_new_repositories     = true
    dependency_graph_enabled_for_new_repositories                = true
    secret_scanning_enabled_for_new_repositories                 = true
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
    condition     = output.organization_name == "test-org"
    error_message = "Organization name should be 'test-org'"
  }

  assert {
    condition     = output.security_settings.advance_security_enabled == true
    error_message = "Advanced security should be enabled"
  }

  assert {
    condition     = output.security_settings.secret_scanning_enabled == true
    error_message = "Secret scanning should be enabled"
  }

  assert {
    condition     = output.security_settings.secret_push_protection_enabled == true
    error_message = "Secret push protection should be enabled"
  }

  assert {
    condition     = output.security_settings.dependabot_alerts_enabled == true
    error_message = "Dependabot alerts should be enabled"
  }

  assert {
    condition     = output.security_settings.dependabot_updates_enabled == true
    error_message = "Dependabot security updates should be enabled"
  }
}

# Test 2: Validate repository counts
run "repository_configuration_validation" {
  command = plan

  assert {
    condition     = output.repository_count == 2
    error_message = "Should have 2 repositories configured (1 public + 1 private)"
  }

  assert {
    condition     = output.validation_passed == true
    error_message = "All validation checks should pass"
  }
}

# Test 3: Validate team counts
run "team_configuration_validation" {
  command = plan

  assert {
    condition     = output.team_count == 2
    error_message = "Should have 2 teams configured"
  }
}

# Test 4: Test invalid organization name
run "invalid_organization_name" {
  command = plan

  variables {
    organization_settings = {
      name                                                         = "Test_Org_Invalid" # Invalid: contains uppercase and underscores
      billing_email                                                = "billing@example.com"
      default_repository_permission                                = "read"
      web_commit_signoff_required                                  = true
      advance_security_enabled_for_new_repositories               = true
      dependabot_alerts_enabled_for_new_repositories               = true
      dependabot_security_updates_enabled_for_new_repositories     = true
      dependency_graph_enabled_for_new_repositories                = true
      secret_scanning_enabled_for_new_repositories                 = true
      secret_scanning_push_protection_enabled_for_new_repositories = true
    }
    public_repositories  = {}
    private_repositories = {}
    teams                = {}
  }

  expect_failures = [
    var.organization_settings,
  ]
}

# Test 5: Test invalid email format
run "invalid_email_format" {
  command = plan

  variables {
    organization_settings = {
      name                                                         = "test-org"
      billing_email                                                = "invalid-email" # Invalid: not a valid email
      default_repository_permission                                = "read"
      web_commit_signoff_required                                  = true
      advance_security_enabled_for_new_repositories               = true
      dependabot_alerts_enabled_for_new_repositories               = true
      dependabot_security_updates_enabled_for_new_repositories     = true
      dependency_graph_enabled_for_new_repositories                = true
      secret_scanning_enabled_for_new_repositories                 = true
      secret_scanning_push_protection_enabled_for_new_repositories = true
    }
    public_repositories  = {}
    private_repositories = {}
    teams                = {}
  }

  expect_failures = [
    var.organization_settings,
  ]
}

# Test 6: Test invalid repository permission
run "invalid_repository_permission" {
  command = plan

  variables {
    organization_settings = {
      name                                                         = "test-org"
      billing_email                                                = "billing@example.com"
      default_repository_permission                                = "super-admin" # Invalid: not a valid permission
      web_commit_signoff_required                                  = true
      advance_security_enabled_for_new_repositories               = true
      dependabot_alerts_enabled_for_new_repositories               = true
      dependabot_security_updates_enabled_for_new_repositories     = true
      dependency_graph_enabled_for_new_repositories                = true
      secret_scanning_enabled_for_new_repositories                 = true
      secret_scanning_push_protection_enabled_for_new_repositories = true
    }
    public_repositories  = {}
    private_repositories = {}
    teams                = {}
  }

  expect_failures = [
    var.organization_settings,
  ]
}

# Test 7: Test invalid team privacy
run "invalid_team_privacy" {
  command = plan

  variables {
    organization_settings = {
      name                                                         = "test-org"
      billing_email                                                = "billing@example.com"
      default_repository_permission                                = "read"
      web_commit_signoff_required                                  = true
      advance_security_enabled_for_new_repositories               = true
      dependabot_alerts_enabled_for_new_repositories               = true
      dependabot_security_updates_enabled_for_new_repositories     = true
      dependency_graph_enabled_for_new_repositories                = true
      secret_scanning_enabled_for_new_repositories                 = true
      secret_scanning_push_protection_enabled_for_new_repositories = true
    }
    public_repositories  = {}
    private_repositories = {}
    teams = {
      "test-team" = {
        name        = "Test Team"
        description = "Test team"
        privacy     = "open" # Invalid: must be closed or secret
        members     = ["user1"]
        maintainers = ["user1"]
      }
    }
  }

  expect_failures = [
    var.teams,
  ]
}

# Test 8: Test team without maintainers
run "team_without_maintainers" {
  command = plan

  variables {
    organization_settings = {
      name                                                         = "test-org"
      billing_email                                                = "billing@example.com"
      default_repository_permission                                = "read"
      web_commit_signoff_required                                  = true
      advance_security_enabled_for_new_repositories               = true
      dependabot_alerts_enabled_for_new_repositories               = true
      dependabot_security_updates_enabled_for_new_repositories     = true
      dependency_graph_enabled_for_new_repositories                = true
      secret_scanning_enabled_for_new_repositories                 = true
      secret_scanning_push_protection_enabled_for_new_repositories = true
    }
    public_repositories  = {}
    private_repositories = {}
    teams = {
      "test-team" = {
        name        = "Test Team"
        description = "Test team"
        privacy     = "closed"
        members     = ["user1", "user2"]
        maintainers = [] # Invalid: must have at least one maintainer
      }
    }
  }

  expect_failures = [
    var.teams,
  ]
}
