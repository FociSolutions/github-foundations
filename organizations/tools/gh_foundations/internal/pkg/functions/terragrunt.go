package functions

import (
	"bytes"
	"fmt"
	"gh_foundations/internal/pkg/types/terraform_state"
	types "gh_foundations/internal/pkg/types/terragrunt"
	"os"
	"os/exec"
	"path/filepath"
)

func ArchivePlan(modulePath string, planName string) (*types.TerragruntPlanArchive, error) {
	moduleDir := filepath.Dir(modulePath)
	outputFilePath := moduleDir + string(os.PathSeparator) + planName + ".json"

	if _, err := os.Stat(outputFilePath); err == nil {
		return nil, fmt.Errorf("file %q already exists", outputFilePath)
	}

	planArchive, err := types.NewTerragruntPlanArchive(planName, modulePath, moduleDir, outputFilePath)
	if err != nil {
		return nil, err
	}

	return planArchive, nil
}

func RunImportCommand(archive types.TerragruntPlanArchive, address string, id string) (bytes.Buffer, error) {
	errorBytes := bytes.Buffer{}
	importCmd := exec.Command("terragrunt", "import", address, id)
	importCmd.Stderr = &errorBytes
	importCmd.Stdout = nil
	importCmd.Dir = archive.ModuleDir
	return errorBytes, importCmd.Run()
}

func CreateImportIdResolver(resourceAddress string, stateExplorer terraform_state.IStateExplorer) types.ImportIdResolver {
	resourceType, err := stateExplorer.GetResourceChangeResourceType(resourceAddress)
	if err != nil {
		return nil
	}
	switch resourceType {
	case "github_team_membership":
		return &types.TeamMemberImportIdResolver{StateExplorer: stateExplorer}
	case "github_team":
		return &types.TeamImportIdResolver{StateExplorer: stateExplorer}
	case "github_repository":
		return &types.RepositoryImportIdResolver{StateExplorer: stateExplorer}
	case "github_branch_default":
		return &types.RepositoryBranchDefaultImportIdResolver{StateExplorer: stateExplorer}
	case "github_repository_collaborators":
		return &types.RepositoryCollaboratorsImportIdResolver{StateExplorer: stateExplorer}
	case "github_actions_secret", "github_codespaces_secret", "dependabot_secret":
		return &types.RepositorySecretsImportIdResolver{StateExplorer: stateExplorer}
	case "github_repository_dependabot_security_updates":
		return &types.RepositoryDependabotSecurityUpdatesImportIdResolver{StateExplorer: stateExplorer}
	case "github_repository_environment":
		return &types.RepositoryEnvironmentImportIdResolver{StateExplorer: stateExplorer}
	case "github_repository_ruleset":
		return &types.RepositoryRulesetImportIdResolver{StateExplorer: stateExplorer}
	default:
		return nil
	}
}
