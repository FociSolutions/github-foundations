package terragrunt

import (
	"bytes"
	"fmt"
	"gh_foundations/internal/pkg/types"
	"gh_foundations/internal/pkg/types/terraform_state"
	v1_2 "gh_foundations/internal/pkg/types/terraform_state/v1.2"
	"io"
	"os/exec"
	"path"

	"github.com/spf13/afero"
	"github.com/tidwall/gjson"
)

var fs = afero.NewOsFs()

// command creation function for mocking
var newCommandExecutor = func(name string, args ...string) types.ICommandExecutor {
	return &types.CommandExecutor{
		Cmd: exec.Command(name, args...),
	}
}

type IPlanFile interface {
	Cleanup() error
	RunPlan(target *string) error
	GetStateExplorer() (terraform_state.IStateExplorer, error)
	GetPlanFilePath() string
}

type PlanFile struct {
	Name           string
	ModulePath     string
	ModuleDir      string
	OutputFilePath string
}

func NewTerragruntPlanFile(name string, modulePath string, moduleDir string, outputFilePath string) (*PlanFile, error) {
	// If there is a file conflict with the output file, create a new file with a "copy_" prefix
	if _, err := fs.Stat(outputFilePath); err == nil {
		dir := path.Dir(outputFilePath)
		filename := path.Base(outputFilePath)
		outputFilePath = path.Join(dir, "copy_"+filename)
	}

	return &PlanFile{
		Name:           name,
		ModuleDir:      moduleDir,
		ModulePath:     modulePath,
		OutputFilePath: outputFilePath,
	}, nil
}

func (t *PlanFile) Cleanup() error {
	return fs.Remove(t.OutputFilePath)
}

func (t *PlanFile) GetPlanFilePath() string {
	return t.OutputFilePath
}

func (t *PlanFile) RunPlan(target *string) error {
	if _, errBytes, err := runPlan(t.ModuleDir, &t.Name, target); err != nil {
		return fmt.Errorf("error running plan: %s", errBytes.String())
	}

	planFile, err := fs.Create(t.OutputFilePath)
	if err != nil {
		return err
	}
	defer planFile.Close()

	if errBytes, err := outputPlan(t.Name, planFile, t.ModuleDir); err != nil {
		return fmt.Errorf("error outputting plan: %s", errBytes.String())
	}

	return nil
}

func (t *PlanFile) GetStateExplorer() (terraform_state.IStateExplorer, error) {
	planBytes, err := afero.ReadFile(fs, t.OutputFilePath)
	if err != nil {
		return nil, err
	}

	var explorer terraform_state.IStateExplorer
	versionQuery := "format_version"
	gjsonResult := gjson.GetBytes(planBytes, versionQuery)
	if !gjsonResult.Exists() {
		return nil, fmt.Errorf("unable to determine plan version")
	} else if gjsonResult.Type != gjson.String {
		return nil, fmt.Errorf("unexpected type for %q: %s", versionQuery, gjsonResult.Type)
	}
	version := gjsonResult.String()

	switch version {
	case "1.2":
		explorer = &v1_2.StateExplorer{}
	default:
		return nil, fmt.Errorf("unsupported version %q", version)
	}

	explorer.SetPlan(planBytes)
	return explorer, nil
}

type ImportIdResolver interface {
	ResolveImportId(resourceAddress string) (string, error)
}

func outputPlan(planName string, planFile io.Writer, dir string) (bytes.Buffer, error) {
	errBuffer := &bytes.Buffer{}
	cmdExecutor := newCommandExecutor("terragrunt", "show", "-json", planName)
	cmdExecutor.SetOutput(planFile)
	cmdExecutor.SetErrorOutput(errBuffer)
	cmdExecutor.SetDir(dir)
	if err := cmdExecutor.Run(); err != nil {
		return *errBuffer, err
	}
	return *errBuffer, nil
}

func runPlan(dir string, output *string, target *string) (bytes.Buffer, bytes.Buffer, error) {
	errBuffer := &bytes.Buffer{}
	logBuffer := &bytes.Buffer{}
	args := []string{"plan", "-lock=false"}
	if output != nil {
		args = append(args, fmt.Sprintf("-out=%s", *output))
	}
	if target != nil {
		args = append(args, fmt.Sprintf("-target=%s", *target))
	}

	cmdExecutor := newCommandExecutor("terragrunt", args...)
	cmdExecutor.SetErrorOutput(errBuffer)
	cmdExecutor.SetDir(dir)
	if err := cmdExecutor.Run(); err != nil {
		return *logBuffer, *errBuffer, err
	} else {
		logBuffer.WriteString(fmt.Sprintf("Command %q complete", cmdExecutor.String()))
	}
	return *logBuffer, *errBuffer, nil
}
