package types

type CheckResult uint16

const (
	Failed        CheckResult = iota
	Passed                    = iota
	Errored                   = iota
	NotApplicable             = iota
)

type CheckError struct {
	Err        error             `json:"-"`
	EntityId   string            `json:"entity_id"`
	Check      CheckType         `json:"check"`
	Violations map[string]string `json:"violations"`
}

type CheckType string

const (
	ITSG33 = "ITSG33"
)

type CheckReport struct {
	Results map[CheckType]CheckResult `json:"results"`
	Errors  []CheckError              `json:"errors"`
}

type ICheckable interface {
	Check(checkTypes []CheckType) CheckReport
}
