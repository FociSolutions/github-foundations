package types

import (
	"fmt"
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

type TeamImportIdResolver struct {
	Change TerragruntPlanOutputResourceChange
}

func (t *TeamImportIdResolver) ResolveImportId() (string, error) {
	if name, exists := t.Change.Change.After["name"]; exists {
		return fmt.Sprint(name), nil
	}
	return "", fmt.Errorf("unable to resolve import id for resource %q", t.Change.Address)
}

type TeamMemberImportIdResolver struct {
	Change TerragruntPlanOutputResourceChange
}

func (t *TeamMemberImportIdResolver) ResolveImportId() (string, error) {
	var teamId, username any
	var exists bool
	if teamId, exists = t.Change.Change.After["team_id"]; !exists {
		return "", fmt.Errorf("unable to resolve import id for resource %q", t.Change.Address)

	}
	if username, exists = t.Change.Change.After["username"]; !exists {
		return "", fmt.Errorf("unable to resolve import id for resource %q", t.Change.Address)

	}
	return fmt.Sprintf("%s:%s", teamId, username), nil
}

type RepositoryImportIdResolver struct {
	Change TerragruntPlanOutputResourceChange
}

func (r *RepositoryImportIdResolver) ResolveImportId() (string, error) {
	if name, exists := r.Change.Change.After["name"]; exists {
		return fmt.Sprint(name), nil
	}
	return "", fmt.Errorf("unable to resolve import id for resource %q", r.Change.Address)
}
