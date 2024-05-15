package check

import (
	"gh_foundations/cmd/check/itsg33"

	"github.com/spf13/cobra"
)

var CheckCmd = &cobra.Command{
	Use:   "check",
	Short: "Perform checks against a Github configuration.",
	Long:  `Perform checks against a Github configuration and generate reports.`,
}

func init() {
	CheckCmd.AddCommand(itsg33.Itsg33Cmd)
}
