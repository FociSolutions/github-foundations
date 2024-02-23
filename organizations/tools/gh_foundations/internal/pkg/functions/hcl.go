package functions

import (
	"gh_foundations/internal/pkg/types"
	"log"

	"github.com/rodaine/hclencoder"
)

func CreateTeamsModuleHCLContent(teams []string) string {
	module := &types.TeamsModuleConfiguration{
		Providers: []types.TGProviderBlock{
			{
				Name:   "root",
				Path:   "${find_in_parent_folders()}",
				Expose: true,
			}, {
				Name:   "providers",
				Path:   "${get_repo_root()}/providers/${basename(dirname(get_terragrunt_dir()))}/providers.hcl",
				Expose: true,
			},
		},
		Terraform: types.TGTerraformBlock{
			Source: "${get_repo_root()}//modules/team_set",
		},
		Inputs: types.TeamsModuleInputs{
			Teams: map[string]types.TeamConfigurationVariables{},
		},
	}

	for _, t := range teams {
		module.Inputs.Teams[t] = types.TeamConfigurationVariables{
			Description: "This is the description for the " + t + " team",
			Privacy:     "closed",
			Maintainers: []string{},
			Members:     []string{},
		}
	}

	hcl, err := hclencoder.Encode(module)
	if err != nil {
		log.Fatal(err)
	}

	return string(hcl)
}

func CreateRepositoriesModuleHCLContent() string {
	module := &types.RepositoriesModuleConfiguration{
		Providers: []types.TGProviderBlock{
			{
				Name:   "root",
				Path:   "${find_in_parent_folders()}",
				Expose: true,
			}, {
				Name:   "providers",
				Path:   "${get_repo_root()}/providers/${basename(dirname(get_terragrunt_dir()))}/providers.hcl",
				Expose: true,
			},
		},
		Terraform: types.TGTerraformBlock{
			Source: "${get_repo_root()}//modules/repository_set",
		},
		Inputs: types.RepositoriesModuleInputs{
			PublicRepositories:               map[string]types.PublicRepositoryConfigurationVariables{},
			PrivateRepositories:              map[string]types.PrivateRepositoryConfigurationVariables{},
			DefaultRepositoryTeamPermissions: map[string]string{},
		},
		Dependencies: []types.TGDependencyBlock{
			{
				Name:       "teams",
				ConfigPath: "../teams",
				MockOutputs: map[string]interface{}{
					"team_slugs=": map[string]interface{}{
						"team1": "team1",
						"team2": "team2",
					},
				},
			},
		},
	}

	hcl, err := hclencoder.Encode(module)
	if err != nil {
		log.Fatal(err)
	}

	return string(hcl)
}
