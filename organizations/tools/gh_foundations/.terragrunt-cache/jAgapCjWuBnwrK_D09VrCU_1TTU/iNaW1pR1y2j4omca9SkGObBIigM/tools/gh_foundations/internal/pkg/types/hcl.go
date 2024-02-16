package types

type TGProviderBlock struct {
	Name   string `hcl:"omit,key"`
	Path   string `hcl:"path"`
	Expose bool   `hcl:"expose"`
}

type TGTerraformBlock struct {
	Source string `hcl:"source"`
}

type TGDependencyBlock struct {
	Name        string         `hcl:"omit,key"`
	ConfigPath  string         `hcl:"config_path"`
	MockOutputs map[string]any `hcl:"mock_outputs ="`
}

// Teams Module Specific Types

type TeamsModuleConfiguration struct {
	Providers []TGProviderBlock `hcl:"include"`
	Inputs    TeamsModuleInputs `hcl:"inputs ="`
	Terraform TGTerraformBlock  `hcl:"terraform"`
}

type TeamsModuleInputs struct {
	Teams map[string]TeamConfigurationVariables `hcl:"teams ="`
}

type TeamConfigurationVariables struct {
	Description string   `hcl:"description"`
	Privacy     string   `hcl:"privacy"`
	Maintainers []string `hcl:"maintainers"`
	Members     []string `hcl:"members"`
}

// Repositories Module Specific Types

type RepositoriesModuleConfiguration struct {
	Providers    []TGProviderBlock        `hcl:"include"`
	Inputs       RepositoriesModuleInputs `hcl:"inputs ="`
	Terraform    TGTerraformBlock         `hcl:"terraform"`
	Dependencies []TGDependencyBlock      `hcl:"dependency"`
}

type RepositoriesModuleInputs struct {
	PublicRepositories               map[string]PublicRepositoryConfigurationVariables  `hcl:"public_repositories ="`
	PrivateRepositories              map[string]PrivateRepositoryConfigurationVariables `hcl:"private_repositories ="`
	DefaultRepositoryTeamPermissions map[string]string                                  `hcl:"default_repository_team_permissions ="`
}

type PrivateRepositoryConfigurationVariables struct {
	Description                       string            `hcl:"description"`
	DefaultBranch                     string            `hcl:"default_branch"`
	RepositoryTeamPermissionsOverride map[string]string `hcl:"repository_team_permissions_override"`
	ProtectedBranches                 []string          `hcl:"protected_branches"`
	AdvanceSecurity                   bool              `hcl:"advance_security"`
	HasVulnerabilityAlerts            bool              `hcl:"has_vulnerability_alerts"`
	Topics                            []string          `hcl:"topics"`
	Homepage                          string            `hcl:"homepage"`
	DeleteHeadOnMerge                 bool              `hcl:"delete_head_on_merge"`
	AllowAutoMerge                    bool              `hcl:"allow_auto_merge"`
	DependabotSecurityUpdates         bool              `hcl:"dependabot_security_updates"`
}

type PublicRepositoryConfigurationVariables struct {
	Description                       string            `hcl:"description"`
	DefaultBranch                     string            `hcl:"default_branch"`
	RepositoryTeamPermissionsOverride map[string]string `hcl:"repository_team_permissions_override"`
	ProtectedBranches                 []string          `hcl:"protected_branches"`
	AdvanceSecurity                   bool              `hcl:"advance_security"`
	HasVulnerabilityAlerts            bool              `hcl:"has_vulnerability_alerts"`
	Topics                            []string          `hcl:"topics"`
	Homepage                          string            `hcl:"homepage"`
	DeleteHeadOnMerge                 bool              `hcl:"delete_head_on_merge"`
	AllowAutoMerge                    bool              `hcl:"allow_auto_merge"`
	DependabotSecurityUpdates         bool              `hcl:"dependabot_security_updates"`
}
