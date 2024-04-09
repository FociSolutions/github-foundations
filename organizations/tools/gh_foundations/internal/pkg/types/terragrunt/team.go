package terragrunt

import "fmt"

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
