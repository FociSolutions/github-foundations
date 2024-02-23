package functions

import (
	"bytes"
	"encoding/json"
	"fmt"
	"gh_foundations/internal/pkg/types"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func ArchivePlan(modulePath string, planName string) (*types.TerragruntPlanArchive, error) {
	moduleDir := filepath.Dir(modulePath)
	outputFilePath := moduleDir + string(os.PathSeparator) + planName + ".json"

	if _, err := os.Stat(outputFilePath); err == nil {
		return nil, fmt.Errorf("file %q already exists", outputFilePath)
	}

	planFile, err := os.Create(outputFilePath)
	if err != nil {
		return nil, err
	}

	planCmd := exec.Command("terragrunt", "plan", fmt.Sprintf("-out=%s", planName))
	planCmd.Stderr = os.Stderr
	planCmd.Dir = moduleDir
	if err := planCmd.Run(); err != nil {
		return nil, err
	}

	showCmd := exec.Command("terragrunt", "show", "-json", planName)
	showCmd.Stdout = planFile
	showCmd.Stderr = os.Stderr
	showCmd.Dir = moduleDir
	if err := showCmd.Run(); err != nil {
		return nil, err
	}

	return &types.TerragruntPlanArchive{
		Name:           planName,
		ModuleDir:      moduleDir,
		ModulePath:     modulePath,
		OutputFilePath: outputFilePath,
	}, nil
}

func GetPlannedResourceCreations(planArchive *types.TerragruntPlanArchive) ([]types.TerragruntPlanOutputResourceChange, error) {
	// Parse the plan file
	planFile, err := os.Open(planArchive.OutputFilePath)
	if err != nil {
		return nil, err
	}
	defer planFile.Close()

	data, err := io.ReadAll(planFile)
	if err != nil {
		return nil, err
	}

	planOutput := &types.TerragruntPlanOutputRoot{}
	if err := json.Unmarshal(data, planOutput); err != nil {
		return nil, err
	}

	changes := make([]types.TerragruntPlanOutputResourceChange, 0)
	for _, resourceChange := range planOutput.ResourceChanges {
		if len(resourceChange.Change.Actions) == 1 && resourceChange.Change.Actions[0] == "create" {
			changes = append(changes, resourceChange)
		}
	}

	return changes, nil
}

func CreateImportIdResolver(change types.TerragruntPlanOutputResourceChange) types.ImportIdResolver {
	switch change.Type {
	case "github_team_membership":
		return &types.TeamMemberImportIdResolver{Change: change}
	case "github_team":
		return &types.TeamImportIdResolver{Change: change}
	case "github_repository":
		return &types.RepositoryImportIdResolver{Change: change}
	default:
		return nil
	}
}

func RunImportCommand(archive types.TerragruntPlanArchive, address string, id string) error {
	importCmd := exec.Command("terragrunt", "import", address, id)
	importCmd.Stderr = nil
	importCmd.Stdout = nil
	importCmd.Dir = archive.ModuleDir
	return importCmd.Run()
}

func GetModuleGroups() (types.TerragruntModuleGroups, error) {
	b := bytes.Buffer{}
	outputModuleGroupsCmd := exec.Command("terragrunt", "output-module-groups")
	outputModuleGroupsCmd.Stdout = &b
	outputModuleGroupsCmd.Stderr = os.Stderr

	if err := outputModuleGroupsCmd.Run(); err != nil {
		return nil, err
	}

	groups := types.TerragruntModuleGroups{}

	if err := json.Unmarshal(b.Bytes(), &groups); err != nil {
		return nil, err
	}

	// Appends the terragrunt.hcl path.
	for key, group := range groups {
		full_paths := []string{}
		for _, path := range group {
			full_paths = append(full_paths, strings.Join([]string{path, "terragrunt.hcl"}, string(os.PathSeparator)))
		}
		groups[key] = full_paths
	}

	return groups, nil
}
