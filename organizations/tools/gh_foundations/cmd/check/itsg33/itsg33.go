package itsg33

import "github.com/spf13/cobra"

var Itsg33Cmd = &cobra.Command{
	Use:   "gen",
	Short: "Run the ITSG33 checks against a GitHub configuration.",
	Long:  `Run the ITSG33 checks against a GitHub configuration and generate reports.`,
}
