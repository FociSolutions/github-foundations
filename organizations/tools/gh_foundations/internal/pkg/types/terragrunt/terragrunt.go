package terragrunt

import (
	"os"
)

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
	Type    string               `json:"type"`
	Address string               `json:"address"`
	Change  TerragruntPlanChange `json:"change"`
}

type TerragruntPlanChange struct {
	Actions []string       `json:"actions"`
	After   map[string]any `json:"after"`
}

type TerragruntModuleGroups = map[string][]string

type ImportIdResolver interface {
	ResolveImportId() (string, error)
}