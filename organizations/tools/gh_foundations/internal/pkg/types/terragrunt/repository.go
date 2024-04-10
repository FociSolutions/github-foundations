package terragrunt

import "fmt"

type RepositoryImportIdResolver struct {
	Change TerragruntPlanOutputResourceChange
}

func (r *RepositoryImportIdResolver) ResolveImportId() (string, error) {
	if name, exists := r.Change.Change.After["name"]; exists {
		return fmt.Sprint(name), nil
	}
	return "", fmt.Errorf("unable to resolve import id for resource %q", r.Change.Address)
}

type RepositoryBranchDefaultImportIdResolver struct {
	Change TerragruntPlanOutputResourceChange
}

func (r *RepositoryBranchDefaultImportIdResolver) ResolveImportId() (string, error) {
	if repository, exists := r.Change.Change.After["repository"]; exists {
		return fmt.Sprint(repository), nil
	}
	return "", fmt.Errorf("unable to resolve import id for resource %q", r.Change.Address)
}

type RepositoryCollaboratorsImportIdResolver struct {
	Change TerragruntPlanOutputResourceChange
}

func (r *RepositoryCollaboratorsImportIdResolver) ResolveImportId() (string, error) {
	if repository, exists := r.Change.Change.After["repository"]; exists {
		return fmt.Sprint(repository), nil
	}
	return "", fmt.Errorf("unable to resolve import id for resource %q", r.Change.Address)
}
