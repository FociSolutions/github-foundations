package terragrunt

import (
	"bytes"
	"fmt"
	"gh_foundations/internal/pkg/types/terraform_state"
	v1_2 "gh_foundations/internal/pkg/types/terraform_state/v1.2"
	"io"
	"os"
	"os/exec"

	"github.com/tidwall/gjson"
)

type TerragruntPlanArchive struct {
	Name           string
	ModulePath     string
	ModuleDir      string
	OutputFilePath string
}

func NewTerragruntPlanArchive(name string, modulePath string, moduleDir string, outputFilePath string) (*TerragruntPlanArchive, error) {
	if err, errBytes := runPlan(moduleDir, &name, nil); err != nil {
		return nil, fmt.Errorf("error running plan: %s", errBytes.String())
	}

	planFile, err := os.Create(outputFilePath)
	if err != nil {
		return nil, err
	}
	defer planFile.Close()

	if err, errBytes := outputPlan(name, planFile, moduleDir); err != nil {
		return nil, fmt.Errorf("error outputing plan: %s", errBytes.String())
	}

	return &TerragruntPlanArchive{
		Name:           name,
		ModuleDir:      moduleDir,
		ModulePath:     modulePath,
		OutputFilePath: outputFilePath,
	}, nil
}

func (t *TerragruntPlanArchive) Cleanup() error {
	return os.Remove(t.OutputFilePath)
}

func (t *TerragruntPlanArchive) RefreshPlan(target *string) error {
	if err, errBytes := runPlan(t.ModuleDir, &t.Name, target); err != nil {
		return fmt.Errorf("error running plan: %s", errBytes.String())
	}

	os.Remove(t.OutputFilePath)
	planFile, err := os.Create(t.OutputFilePath)
	if err != nil {
		return err
	}
	defer planFile.Close()

	if err, errBytes := outputPlan(t.Name, planFile, t.ModuleDir); err != nil {
		return fmt.Errorf("error outputing plan: %s", errBytes.String())
	}

	return nil
}

func (t *TerragruntPlanArchive) GetStateExplorer() (terraform_state.IStateExplorer, error) {
	planBytes, err := os.ReadFile(t.OutputFilePath)
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

func outputPlan(planName string, planFile io.Writer, moduleDir string) (error, bytes.Buffer) {
	errBuffer := bytes.Buffer{}
	showCmd := exec.Command("terragrunt", "show", "-json", planName)
	showCmd.Stdout = planFile
	showCmd.Stderr = os.Stderr
	showCmd.Dir = moduleDir
	if err := showCmd.Run(); err != nil {
		debugBytes := bytes.Buffer{}
		debugBytes.WriteString(fmt.Sprintf("Error running command %q: %s\nPlan file: %+v\n", showCmd.String(), errBuffer.String(), planFile))
		return err, debugBytes
	}
	return nil, errBuffer
}

func runPlan(dir string, output *string, target *string) (error, bytes.Buffer) {
	logsBuffer := bytes.Buffer{}
	args := []string{"plan", "-lock=false"}
	if output != nil {
		args = append(args, fmt.Sprintf("-out=%s", *output))
	}
	if target != nil {
		args = append(args, fmt.Sprintf("-target=%s", *target))
	}

	planCmd := exec.Command("terragrunt", args...)
	planCmd.Stderr = &logsBuffer
	planCmd.Dir = dir
	if err := planCmd.Run(); err != nil {
		return err, logsBuffer
	} else {
		logsBuffer.WriteString(fmt.Sprintf("Command %q complete", planCmd.String()))
	}
	return nil, logsBuffer
}
