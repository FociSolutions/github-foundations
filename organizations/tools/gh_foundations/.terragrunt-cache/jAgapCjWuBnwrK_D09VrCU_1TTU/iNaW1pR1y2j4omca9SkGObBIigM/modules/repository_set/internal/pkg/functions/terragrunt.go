package functions

import (
	"encoding/json"
	"fmt"
	"gh_foundations/internal/pkg/types"
	"io"
	"os"
	"os/exec"
	"path/filepath"
)

func ArchivePlan(modulePath string, planName string) (*types.TerragruntPlanArchive, error) {
	moduleDir := filepath.Dir(modulePath)
	outputFilePath := modulePath + string(os.PathSeparator) + planName
	if _, err := os.Stat(outputFilePath); err == nil {
		return nil, fmt.Errorf("file %q already exists", outputFilePath)
	}

	initCmd := exec.Command("terragrunt", "init", "--terragrunt-config", modulePath, "--terragrunt-working-dir %s", moduleDir)
	initCmd.Stderr = os.Stderr
	initCmd.Stdout = os.Stdout
	if err := initCmd.Run(); err != nil {
		fmt.Println(err)
		return nil, err
	}

	planCmd := exec.Command("terragrunt", "plan", "--terragrunt-config %s", modulePath, "--terragrunt-working-dir %s", moduleDir, fmt.Sprintf("-out=%s", planName))
	if err := planCmd.Run(); err != nil {
		return nil, err
	}

	return &types.TerragruntPlanArchive{
		Name:           planName,
		ModulePath:     modulePath,
		OutputFilePath: outputFilePath,
	}, nil
}

func GetAddressesForPlannedResourceCreates(planArchive *types.TerragruntPlanArchive) ([]string, error) {
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

	addresses := make([]string, 0)
	for _, resourceChange := range planOutput.ResourceChanges {
		if len(resourceChange.Change.Actions) == 1 && resourceChange.Change.Actions[0] == "create" {
			addresses = append(addresses, resourceChange.Address)
		}
	}

	return addresses, nil
}
