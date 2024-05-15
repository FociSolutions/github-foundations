package github

import (
	"errors"
	"fmt"
	"gh_foundations/internal/pkg/types"

	"github.com/google/go-github/v61/github"
)

type Organization struct {
	*github.Organization
	// customRepositoryRoles []map[string]any
}

func (o *Organization) Check(checkTypes []types.CheckType) types.CheckReport {
	report := types.CheckReport{
		Results: make(map[types.CheckType]types.CheckResult),
		Errors:  []types.CheckError{},
	}
	for _, t := range checkTypes {
		switch t {
		case types.ITSG33:
			r, err := o.ITSG33Compliant()
			if err != nil {
				report.Errors = append(report.Errors, *err)
			}
			report.Results[t] = r
		default:
			report.Results[t] = types.NotApplicable
		}
	}
	return report
}

// Custom repository roles for an organization need to be accessed separately from settings

func (o *Organization) ITSG33Compliant() (types.CheckResult, *types.CheckError) {
	var allErrors error
	violations := make(map[string]string)
	checks := []func(org *Organization) (string, error){
		func(org *Organization) (string, error) {
			key := "dependabot_alerts_enabled_for_new_repositories"
			if !org.GetDependabotAlertsEnabledForNewRepos() {
				return key, errors.New("dependabot_alerts_enabled_for_new_repositories is not enabled. Expected it to be enabled")
			}
			return key, nil
		},
		func(org *Organization) (string, error) {
			key := "dependabot_security_updates_enabled_for_new_repositories"
			if !org.GetDependabotSecurityUpdatesEnabledForNewRepos() {
				return key, errors.New("dependabot_security_updates_enabled_for_new_repositories is not enabled. Expected it to be enabled")
			}
			return key, nil
		},
		func(org *Organization) (string, error) {
			key := "dependency_graph_enabled_for_new_repositories"
			if !org.GetDependencyGraphEnabledForNewRepos() {
				return key, errors.New("dependency_graph_enabled_for_new_repositories is not enabled. Expected it to be enabled")
			}
			return key, nil
		},
		func(org *Organization) (string, error) {
			key := "security_and_analysis_enabled_for_new_repositories"
			fmt.Println(org.GetSecretScanningEnabledForNewRepos())
			if !org.GetSecretScanningEnabledForNewRepos() {
				return key, errors.New("secret_scanning_enabled_for_new_repositories is not enabled. Expected it to be enabled")
			}
			return key, nil
		},
		func(org *Organization) (string, error) {
			key := "secret_scanning_push_protection_enabled_for_new_repositories"
			if !org.GetSecretScanningPushProtectionEnabledForNewRepos() {
				return key, errors.New("secret_scanning_push_protection_enabled_for_new_repositories is not enabled. Expected it to be enabled")
			}
			return key, nil
		},
		func(org *Organization) (string, error) {
			key := "delete_branch_on_merge"
			if org.GetMembersCanCreatePublicRepos() {
				return key, errors.New("members_can_create_public_repositories is enabled. Expected it to be disabled")
			}
			return key, nil
		},
		func(org *Organization) (string, error) {
			key := "members_can_create_private_repositories"
			if !org.GetMembersCanCreatePrivateRepos() {
				return key, errors.New("members_can_create_private_repositories is not enabled. Expected it to be enabled")
			}
			return key, nil
		},
		func(org *Organization) (string, error) {
			key := "members_can_create_internal_repositories"
			if !org.GetMembersCanCreateInternalRepos() {
				return key, errors.New("members_can_create_internal_repositories is not enabled. Expected it to be enabled")
			}
			return key, nil
		},
		func(org *Organization) (string, error) {
			key := "members_can_fork_private_repositories"
			if org.GetMembersCanForkPrivateRepos() {
				return key, errors.New("members_can_fork_private_repositories is enabled. Expected it to be disabled")
			}
			return key, nil
		},
	}

	for _, check := range checks {
		violationKey, err := check(o)
		if err != nil {
			violations[violationKey] = err.Error()
		}
		allErrors = errors.Join(allErrors, err)
	}

	// Todo role checks

	// expectedRoles := []map[string]any{
	// }

	if allErrors != nil {
		return types.Failed, &types.CheckError{
			Err:        allErrors,
			EntityId:   o.GetName(),
			Check:      types.ITSG33,
			Violations: violations,
		}
	}
	return types.Passed, nil
}
