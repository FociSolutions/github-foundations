package github

import (
	"errors"
	"fmt"
	"gh_foundations/internal/pkg/types"
	"reflect"

	"github.com/jeremywohl/flatten"
)

type Repository struct {
	slug     string
	settings map[string]any
	rulesets []map[string]any
}

func (r *Repository) Check(checkTypes []types.CheckType) types.CheckReport {
	report := types.CheckReport{
		Results: make(map[types.CheckType]types.CheckResult),
		Errors:  []types.CheckError{},
	}
	for _, t := range checkTypes {
		switch t {
		case types.ITSG33:
			r, err := r.ITSG33Compliant()
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

func (r *Repository) ITSG33Compliant() (types.CheckResult, *types.CheckError) {
	var allErrors error
	var result types.CheckResult = types.Passed
	violations := make(map[string]string)
	expectedSettings := map[string]any{
		// Vulnerability alerts:  SI-4(5), SI-4(7), SI-10
		"security_and_analysis.dependabot_security_updates.status": "enabled",
		"dependabot_security_updates_enabled":                      true,
		"dependency_graph_enabled":                                 true,
		// Secret Scanning: AC-22, IA-5(7), IR-9, SI-4(5), SI-4(7), SI-10
		"security_and_analysis.secret_scanning.status":                 "enabled",
		"security_and_analysis.secret_scanning_push_protection.status": "enabled",
		// Delete branches on merge: SI-12
		"delete_branch_on_merge": true,
	}
	expectedRulesets := []map[string]any{
		// Protected Branches Ruleset - Pull Requests CM-3, CM-4, CM-5, SC-28, SI-10, SI-12
		{
			"type": "pull_request",
			"parameters": map[string]any{
				"required_approving_review_count":   1,
				"dismiss_stale_reviews_on_push":     true,
				"require_code_owner_review":         false,
				"require_last_push_approval":        true,
				"required_review_thread_resolution": false,
			},
			"ruleset_source_type": "Repository",
		},
	}

	flattenedSettings, err := flatten.Flatten(r.settings, "", flatten.DotStyle)
	if err != nil {
		return types.Errored, &types.CheckError{
			Err:      err,
			EntityId: r.slug,
			Check:    types.ITSG33,
		}
	}

	for setting, expectedValue := range expectedSettings {
		actualValue, exists := flattenedSettings[setting]
		if !exists || actualValue != expectedValue {
			errMsg := fmt.Sprintf("expected %q to be %q. Got %q instead", setting, fmt.Sprint(expectedValue), fmt.Sprint(actualValue))
			violations[setting] = errMsg
			allErrors = errors.Join(allErrors, errors.New(errMsg))
			result = types.Failed
		}
	}

	for _, ruleset := range expectedRulesets {
		eq := reflect.DeepEqual(ruleset, r.rulesets)
		if !eq {
			errMsg := fmt.Sprintf("expected ruleset %q to be %q. Got %q instead", ruleset, fmt.Sprint(ruleset), fmt.Sprint(r.rulesets))
			violations["rulesets"] = errMsg
			allErrors = errors.Join(allErrors, errors.New(errMsg))
			result = types.Failed
		}
	}

	if allErrors != nil {
		return result, &types.CheckError{
			Err:        allErrors,
			EntityId:   r.slug,
			Check:      types.ITSG33,
			Violations: violations,
		}
	}
	return result, nil
}
