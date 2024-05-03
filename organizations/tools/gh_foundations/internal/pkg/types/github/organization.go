package github

import (
	"errors"
	"fmt"
	"gh_foundations/internal/pkg/types"
)

type Organization struct {
	slug     string
	settings map[string]any
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
	var result types.CheckResult = types.Passed
	violations := make(map[string]string)
	expectedSettings := map[string]any{
		// Vulnerability alerts:  SI-4(5), SI-4(7), SI-10
		"dependabot_alerts_enabled_for_new_repositories":           true,
		"dependabot_security_updates_enabled_for_new_repositories": true,
		"dependency_graph_enabled_for_new_repositories":            true,
		// Secret Scanning: AC-22, IA-5(7), IR-9, SI-4(5), SI-4(7), SI-10
		"secret_scanning_enabled_for_new_repositories":                 true,
		"secret_scanning_push_protection_enabled_for_new_repositories": true,
		// Repository Creation Restrictions: AC-20(3), AC-22
		"members_can_create_public_repositories":   false,
		"members_can_create_private_repositories":  true,
		"members_can_create_internal_repositories": true,
		"members_can_fork_private_repositories":    false,
	}

	for setting, expectedValue := range expectedSettings {
		actualValue, exists := o.settings[setting]
		if !exists || actualValue != expectedValue {
			errMsg := fmt.Sprintf("expected %q to be %q. Got %q instead", setting, fmt.Sprint(expectedValue), fmt.Sprint(actualValue))
			violations[setting] = errMsg
			allErrors = errors.Join(allErrors, errors.New(errMsg))
			result = types.Failed
		}
	}

	// Todo role checks

	// expectedRoles := []map[string]any{
	// }

	if allErrors != nil {
		return result, &types.CheckError{
			Err:        allErrors,
			EntityId:   o.slug,
			Check:      types.ITSG33,
			Violations: violations,
		}
	}
	return result, nil
}
