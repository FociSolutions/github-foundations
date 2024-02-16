package types

type TerragruntPlanArchive struct {
	Name           string
	ModulePath     string
	OutputFilePath string
}

type TerragruntPlanOutputRoot struct {
	ResourceChanges []TerragruntPlanOutputResourceChange `json:"resource_changes"`
}

type TerragruntPlanOutputResourceChange struct {
	Address string               `json:"address"`
	Change  TerragruntPlanChange `json:"change"`
}

type TerragruntPlanChange struct {
	Actions []string `json:"actions"`
}
