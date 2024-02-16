package types

import "os"

type TerragruntPlanArchive struct {
	Name           string
	ModulePath     string
	ModuleDir      string
	OutputFilePath string
}

func (t *TerragruntPlanArchive) Cleanup() error {
	return os.Remove(t.OutputFilePath)
}

type TerragruntPlanOutputRoot struct {
	ResourceChanges []TerragruntPlanOutputResourceChange `json:"resource_changes"`
}

type TerragruntPlanOutputResourceChange struct {
	Address string               `json:"address"`
	Change  TerragruntPlanChange `json:"change"`
}

type TerragruntPlanChange struct {
	Actions []string `json:"actions"`
}

type TerragruntModuleGroups = map[string][]string
