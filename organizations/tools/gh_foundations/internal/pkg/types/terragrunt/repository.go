package terragrunt

import (
	"fmt"
	"gh_foundations/internal/pkg/types/terraform_state"
)

type RepositoryImportIdResolver struct {
	StateExplorer terraform_state.IStateExplorer
}

func (r *RepositoryImportIdResolver) ResolveImportId(resourceAddress string) (string, error) {
	name, err := r.StateExplorer.GetResourceChangeAfterAttribute(resourceAddress, "name")
	if err != nil {
		return "", err
	} else if !name.Exists() {
		return "", fmt.Errorf("unable to resolve import id: unexpected error occurred")
	}

	return name.String(), nil
}

type RepositoryBranchDefaultImportIdResolver struct {
	StateExplorer terraform_state.IStateExplorer
}

func (r *RepositoryBranchDefaultImportIdResolver) ResolveImportId(resourceAddress string) (string, error) {
	repository, err := r.StateExplorer.GetResourceChangeAfterAttribute(resourceAddress, "repository")
	if err != nil {
		return "", err
	} else if !repository.Exists() {
		return "", fmt.Errorf("unable to resolve import id: unexpected error occurred")
	}

	return repository.String(), nil
}

type RepositoryCollaboratorsImportIdResolver struct {
	StateExplorer terraform_state.IStateExplorer
}

func (r *RepositoryCollaboratorsImportIdResolver) ResolveImportId(resourceAddress string) (string, error) {
	repository, err := r.StateExplorer.GetResourceChangeAfterAttribute(resourceAddress, "repository")
	if err != nil {
		return "", err
	} else if !repository.Exists() {
		return "", fmt.Errorf("unable to resolve import id: unexpected error occurred")
	}

	return repository.String(), nil
}
