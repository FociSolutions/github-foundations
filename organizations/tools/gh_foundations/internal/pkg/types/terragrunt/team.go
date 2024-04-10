package terragrunt

import (
	"fmt"
	"gh_foundations/internal/pkg/types/terraform_state"
)

type TeamImportIdResolver struct {
	StateExplorer terraform_state.IStateExplorer
}

func (t *TeamImportIdResolver) ResolveImportId(resourceAddress string) (string, error) {
	name, err := t.StateExplorer.GetResourceChangeAfterAttribute(resourceAddress, "name")
	if err != nil {
		return "", err
	} else if !name.Exists() {
		return "", fmt.Errorf("unable to resolve import id: unexpected error occurred")
	}

	return name.String(), nil
}

type TeamMemberImportIdResolver struct {
	StateExplorer terraform_state.IStateExplorer
}

func (t *TeamMemberImportIdResolver) ResolveImportId(resourceAddress string) (string, error) {
	// var teamId, username any
	// var exists bool
	teamId, err := t.StateExplorer.GetResourceChangeAfterAttribute(resourceAddress, "team_id")
	if err != nil {
		return "", err
	} else if !teamId.Exists() {
		return "", fmt.Errorf("unable to resolve import id: unexpected error occurred")
	}

	username, err := t.StateExplorer.GetResourceChangeAfterAttribute(resourceAddress, "username")
	if err != nil {
		return "", err
	} else if !username.Exists() {
		return "", fmt.Errorf("unable to resolve import id: unexpected error occurred")
	}

	return fmt.Sprintf("%s:%s", teamId.String(), username.String()), nil
}
